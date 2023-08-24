
obj/user/tst_freeRAM:     file format elf32-i386


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
  800031:	e8 85 14 00 00       	call   8014bb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

char arr[PAGE_SIZE*12];
uint32 WSEntries_before[1000];

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	vcprintf("\n\n===============================================================\n", NULL);
  800044:	83 ec 08             	sub    $0x8,%esp
  800047:	6a 00                	push   $0x0
  800049:	68 c0 2f 80 00       	push   $0x802fc0
  80004e:	e8 00 18 00 00       	call   801853 <vcprintf>
  800053:	83 c4 10             	add    $0x10,%esp
	vcprintf("MAKE SURE to have a FRESH RUN for EACH SCENARIO of this test\n(i.e. don't run any program/test/multiple scenarios before it)\n", NULL);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	6a 00                	push   $0x0
  80005b:	68 04 30 80 00       	push   $0x803004
  800060:	e8 ee 17 00 00       	call   801853 <vcprintf>
  800065:	83 c4 10             	add    $0x10,%esp
	vcprintf("===============================================================\n\n\n", NULL);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 84 30 80 00       	push   $0x803084
  800072:	e8 dc 17 00 00       	call   801853 <vcprintf>
  800077:	83 c4 10             	add    $0x10,%esp

	uint32 testCase;
	if (myEnv->page_WS_max_size == 1000)
  80007a:	a1 20 40 80 00       	mov    0x804020,%eax
  80007f:	8b 40 74             	mov    0x74(%eax),%eax
  800082:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  800087:	75 09                	jne    800092 <_main+0x5a>
	{
		//EVALUATION [40%]
		testCase = 1 ;
  800089:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800090:	eb 2a                	jmp    8000bc <_main+0x84>
	}
	else if (myEnv->page_WS_max_size == 10)
  800092:	a1 20 40 80 00       	mov    0x804020,%eax
  800097:	8b 40 74             	mov    0x74(%eax),%eax
  80009a:	83 f8 0a             	cmp    $0xa,%eax
  80009d:	75 09                	jne    8000a8 <_main+0x70>
	{
		//EVALUATION [30%]
		testCase = 2 ;
  80009f:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8000a6:	eb 14                	jmp    8000bc <_main+0x84>
	}
	else if (myEnv->page_WS_max_size == 26)
  8000a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ad:	8b 40 74             	mov    0x74(%eax),%eax
  8000b0:	83 f8 1a             	cmp    $0x1a,%eax
  8000b3:	75 07                	jne    8000bc <_main+0x84>
	{
		//EVALUATION [30%]
		testCase = 3 ;
  8000b5:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	}
	int32 envIdFib, envIdHelloWorld, helloWorldFrames;
	{
		//CASE1: free the exited env only
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
  8000bc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8000c0:	74 0a                	je     8000cc <_main+0x94>
  8000c2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8000c6:	0f 85 66 01 00 00    	jne    800232 <_main+0x1fa>
		{
			//Load "fib" & "fos_helloWorld" programs into RAM
			cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 c8 30 80 00       	push   $0x8030c8
  8000d4:	e8 e5 17 00 00       	call   8018be <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
			envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e1:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  8000e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ec:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8000f2:	89 c1                	mov    %eax,%ecx
  8000f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000f9:	8b 40 74             	mov    0x74(%eax),%eax
  8000fc:	52                   	push   %edx
  8000fd:	51                   	push   %ecx
  8000fe:	50                   	push   %eax
  8000ff:	68 fa 30 80 00       	push   $0x8030fa
  800104:	e8 9d 28 00 00       	call   8029a6 <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int freeFrames = sys_calculate_free_frames() ;
  80010f:	e8 20 26 00 00       	call   802734 <sys_calculate_free_frames>
  800114:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80011a:	a1 20 40 80 00       	mov    0x804020,%eax
  80011f:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  800125:	a1 20 40 80 00       	mov    0x804020,%eax
  80012a:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  800130:	89 c1                	mov    %eax,%ecx
  800132:	a1 20 40 80 00       	mov    0x804020,%eax
  800137:	8b 40 74             	mov    0x74(%eax),%eax
  80013a:	52                   	push   %edx
  80013b:	51                   	push   %ecx
  80013c:	50                   	push   %eax
  80013d:	68 fe 30 80 00       	push   $0x8030fe
  800142:	e8 5f 28 00 00       	call   8029a6 <sys_create_env>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 45 dc             	mov    %eax,-0x24(%ebp)
			helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  80014d:	8b 9d 7c ff ff ff    	mov    -0x84(%ebp),%ebx
  800153:	e8 dc 25 00 00       	call   802734 <sys_calculate_free_frames>
  800158:	29 c3                	sub    %eax,%ebx
  80015a:	89 d8                	mov    %ebx,%eax
  80015c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			env_sleep(2000);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 d0 07 00 00       	push   $0x7d0
  80016a:	e8 37 2b 00 00       	call   802ca6 <env_sleep>
  80016f:	83 c4 10             	add    $0x10,%esp
			vcprintf("[DONE]\n\n", NULL);
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	6a 00                	push   $0x0
  800177:	68 0d 31 80 00       	push   $0x80310d
  80017c:	e8 d2 16 00 00       	call   801853 <vcprintf>
  800181:	83 c4 10             	add    $0x10,%esp

			//Load and run "fos_add"
			cprintf("Loading fos_add program into RAM...");
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	68 18 31 80 00       	push   $0x803118
  80018c:	e8 2d 17 00 00       	call   8018be <cprintf>
  800191:	83 c4 10             	add    $0x10,%esp
			int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800194:	a1 20 40 80 00       	mov    0x804020,%eax
  800199:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  80019f:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a4:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8001aa:	89 c1                	mov    %eax,%ecx
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8b 40 74             	mov    0x74(%eax),%eax
  8001b4:	52                   	push   %edx
  8001b5:	51                   	push   %ecx
  8001b6:	50                   	push   %eax
  8001b7:	68 3c 31 80 00       	push   $0x80313c
  8001bc:	e8 e5 27 00 00       	call   8029a6 <sys_create_env>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			env_sleep(2000);
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 d0 07 00 00       	push   $0x7d0
  8001d2:	e8 cf 2a 00 00       	call   802ca6 <env_sleep>
  8001d7:	83 c4 10             	add    $0x10,%esp
			vcprintf("[DONE]\n\n", NULL);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	6a 00                	push   $0x0
  8001df:	68 0d 31 80 00       	push   $0x80310d
  8001e4:	e8 6a 16 00 00       	call   801853 <vcprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp

			cprintf("running fos_add program...\n\n");
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	68 44 31 80 00       	push   $0x803144
  8001f4:	e8 c5 16 00 00       	call   8018be <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
			sys_run_env(envIdFOSAdd);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	ff b5 74 ff ff ff    	pushl  -0x8c(%ebp)
  800205:	e8 ba 27 00 00       	call   8029c4 <sys_run_env>
  80020a:	83 c4 10             	add    $0x10,%esp

			cprintf("please be patient ...\n");
  80020d:	83 ec 0c             	sub    $0xc,%esp
  800210:	68 61 31 80 00       	push   $0x803161
  800215:	e8 a4 16 00 00       	call   8018be <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp
			env_sleep(5000);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	68 88 13 00 00       	push   $0x1388
  800225:	e8 7c 2a 00 00       	call   802ca6 <env_sleep>
  80022a:	83 c4 10             	add    $0x10,%esp
	int32 envIdFib, envIdHelloWorld, helloWorldFrames;
	{
		//CASE1: free the exited env only
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
		{
  80022d:	e9 4f 02 00 00       	jmp    800481 <_main+0x449>
				if( myEnv->page_last_WS_index !=  0)  										panic("InitialWSError2: INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
			}
		}
		 */
		//CASE2: free the WS ONLY using FIFO algorithm
		else if (testCase == 2)
  800232:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  800236:	0f 85 45 02 00 00    	jne    800481 <_main+0x449>
		{
			//("STEP 0: checking InitialWSError2: INITIAL WS entries ...\n");
			{
				if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x804000)  	panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80023c:	a1 20 40 80 00       	mov    0x804020,%eax
  800241:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800247:	8b 00                	mov    (%eax),%eax
  800249:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80024c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80024f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800254:	3d 00 40 80 00       	cmp    $0x804000,%eax
  800259:	74 14                	je     80026f <_main+0x237>
  80025b:	83 ec 04             	sub    $0x4,%esp
  80025e:	68 78 31 80 00       	push   $0x803178
  800263:	6a 57                	push   $0x57
  800265:	68 ca 31 80 00       	push   $0x8031ca
  80026a:	e8 9b 13 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80027a:	83 c0 18             	add    $0x18,%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80028a:	3d 00 10 20 00       	cmp    $0x201000,%eax
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 78 31 80 00       	push   $0x803178
  800299:	6a 58                	push   $0x58
  80029b:	68 ca 31 80 00       	push   $0x8031ca
  8002a0:	e8 65 13 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002aa:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8002b0:	83 c0 30             	add    $0x30,%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8002b8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c0:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 78 31 80 00       	push   $0x803178
  8002cf:	6a 59                	push   $0x59
  8002d1:	68 ca 31 80 00       	push   $0x8031ca
  8002d6:	e8 2f 13 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8002e6:	83 c0 48             	add    $0x48,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 45 98             	mov    %eax,-0x68(%ebp)
  8002ee:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002f6:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8002fb:	74 14                	je     800311 <_main+0x2d9>
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	68 78 31 80 00       	push   $0x803178
  800305:	6a 5a                	push   $0x5a
  800307:	68 ca 31 80 00       	push   $0x8031ca
  80030c:	e8 f9 12 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800311:	a1 20 40 80 00       	mov    0x804020,%eax
  800316:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80031c:	83 c0 60             	add    $0x60,%eax
  80031f:	8b 00                	mov    (%eax),%eax
  800321:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800324:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800327:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80032c:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 78 31 80 00       	push   $0x803178
  80033b:	6a 5b                	push   $0x5b
  80033d:	68 ca 31 80 00       	push   $0x8031ca
  800342:	e8 c3 12 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800347:	a1 20 40 80 00       	mov    0x804020,%eax
  80034c:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800352:	83 c0 78             	add    $0x78,%eax
  800355:	8b 00                	mov    (%eax),%eax
  800357:	89 45 90             	mov    %eax,-0x70(%ebp)
  80035a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80035d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800362:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800367:	74 14                	je     80037d <_main+0x345>
  800369:	83 ec 04             	sub    $0x4,%esp
  80036c:	68 78 31 80 00       	push   $0x803178
  800371:	6a 5c                	push   $0x5c
  800373:	68 ca 31 80 00       	push   $0x8031ca
  800378:	e8 8d 12 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800388:	05 90 00 00 00       	add    $0x90,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800392:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800395:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039a:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80039f:	74 14                	je     8003b5 <_main+0x37d>
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	68 78 31 80 00       	push   $0x803178
  8003a9:	6a 5d                	push   $0x5d
  8003ab:	68 ca 31 80 00       	push   $0x8031ca
  8003b0:	e8 55 12 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003c0:	05 a8 00 00 00       	add    $0xa8,%eax
  8003c5:	8b 00                	mov    (%eax),%eax
  8003c7:	89 45 88             	mov    %eax,-0x78(%ebp)
  8003ca:	8b 45 88             	mov    -0x78(%ebp),%eax
  8003cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d2:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8003d7:	74 14                	je     8003ed <_main+0x3b5>
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 78 31 80 00       	push   $0x803178
  8003e1:	6a 5e                	push   $0x5e
  8003e3:	68 ca 31 80 00       	push   $0x8031ca
  8003e8:	e8 1d 12 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8003ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f2:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8003f8:	05 c0 00 00 00       	add    $0xc0,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800402:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 78 31 80 00       	push   $0x803178
  800419:	6a 5f                	push   $0x5f
  80041b:	68 ca 31 80 00       	push   $0x8031ca
  800420:	e8 e5 11 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800425:	a1 20 40 80 00       	mov    0x804020,%eax
  80042a:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800430:	05 d8 00 00 00       	add    $0xd8,%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	89 45 80             	mov    %eax,-0x80(%ebp)
  80043a:	8b 45 80             	mov    -0x80(%ebp),%eax
  80043d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800442:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800447:	74 14                	je     80045d <_main+0x425>
  800449:	83 ec 04             	sub    $0x4,%esp
  80044c:	68 78 31 80 00       	push   $0x803178
  800451:	6a 60                	push   $0x60
  800453:	68 ca 31 80 00       	push   $0x8031ca
  800458:	e8 ad 11 00 00       	call   80160a <_panic>
				if( myEnv->page_last_WS_index !=  1)  										panic("InitialWSError2: INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  80045d:	a1 20 40 80 00       	mov    0x804020,%eax
  800462:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  800468:	83 f8 01             	cmp    $0x1,%eax
  80046b:	74 14                	je     800481 <_main+0x449>
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	68 e0 31 80 00       	push   $0x8031e0
  800475:	6a 61                	push   $0x61
  800477:	68 ca 31 80 00       	push   $0x8031ca
  80047c:	e8 89 11 00 00       	call   80160a <_panic>
			}
		}

		//Reading (Not Modified)
		char garbage1 = arr[PAGE_SIZE*10-1] ;
  800481:	a0 5f 51 83 00       	mov    0x83515f,%al
  800486:	88 85 73 ff ff ff    	mov    %al,-0x8d(%ebp)
		char garbage2 = arr[PAGE_SIZE*11-1] ;
  80048c:	a0 5f 61 83 00       	mov    0x83615f,%al
  800491:	88 85 72 ff ff ff    	mov    %al,-0x8e(%ebp)
		char garbage3 = arr[PAGE_SIZE*12-1] ;
  800497:	a0 5f 71 83 00       	mov    0x83715f,%al
  80049c:	88 85 71 ff ff ff    	mov    %al,-0x8f(%ebp)

		char garbage4, garbage5 ;
		//Writing (Modified)
		int i ;
		for (i = 0 ; i < PAGE_SIZE*4 ; i+=PAGE_SIZE/2)
  8004a2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  8004a9:	eb 26                	jmp    8004d1 <_main+0x499>
		{
			arr[i] = -1 ;
  8004ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ae:	05 60 b1 82 00       	add    $0x82b160,%eax
  8004b3:	c6 00 ff             	movb   $0xff,(%eax)
			//always use pages at 0x801000 and 0x804000
			garbage4 = *ptr ;
  8004b6:	a1 00 40 80 00       	mov    0x804000,%eax
  8004bb:	8a 00                	mov    (%eax),%al
  8004bd:	88 45 db             	mov    %al,-0x25(%ebp)
			garbage5 = *ptr2 ;
  8004c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8004c5:	8a 00                	mov    (%eax),%al
  8004c7:	88 45 da             	mov    %al,-0x26(%ebp)
		char garbage3 = arr[PAGE_SIZE*12-1] ;

		char garbage4, garbage5 ;
		//Writing (Modified)
		int i ;
		for (i = 0 ; i < PAGE_SIZE*4 ; i+=PAGE_SIZE/2)
  8004ca:	81 45 d4 00 08 00 00 	addl   $0x800,-0x2c(%ebp)
  8004d1:	81 7d d4 ff 3f 00 00 	cmpl   $0x3fff,-0x2c(%ebp)
  8004d8:	7e d1                	jle    8004ab <_main+0x473>

		//===================

		//CASE1: free the exited env only
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
  8004da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8004de:	74 0a                	je     8004ea <_main+0x4b2>
  8004e0:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8004e4:	0f 85 92 00 00 00    	jne    80057c <_main+0x544>
		{
			int i = 0;
  8004ea:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
			numOfExistPages = 0;
  8004f1:	c7 05 20 72 83 00 00 	movl   $0x0,0x837220
  8004f8:	00 00 00 
			for (i = 0; i < myEnv->page_WS_max_size; ++i)
  8004fb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800502:	eb 64                	jmp    800568 <_main+0x530>
			{
				if (!myEnv->__uptr_pws[i].empty)
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80050f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	c1 e0 03             	shl    $0x3,%eax
  80051b:	01 c8                	add    %ecx,%eax
  80051d:	8a 40 04             	mov    0x4(%eax),%al
  800520:	84 c0                	test   %al,%al
  800522:	75 41                	jne    800565 <_main+0x52d>
				{
					WSEntries_before[numOfExistPages++] = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address, PAGE_SIZE);
  800524:	8b 15 20 72 83 00    	mov    0x837220,%edx
  80052a:	8d 42 01             	lea    0x1(%edx),%eax
  80052d:	a3 20 72 83 00       	mov    %eax,0x837220
  800532:	a1 20 40 80 00       	mov    0x804020,%eax
  800537:	8b 98 58 da 01 00    	mov    0x1da58(%eax),%ebx
  80053d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800540:	89 c8                	mov    %ecx,%eax
  800542:	01 c0                	add    %eax,%eax
  800544:	01 c8                	add    %ecx,%eax
  800546:	c1 e0 03             	shl    $0x3,%eax
  800549:	01 d8                	add    %ebx,%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800553:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800559:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80055e:	89 04 95 60 72 83 00 	mov    %eax,0x837260(,%edx,4)
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
		{
			int i = 0;
			numOfExistPages = 0;
			for (i = 0; i < myEnv->page_WS_max_size; ++i)
  800565:	ff 45 d0             	incl   -0x30(%ebp)
  800568:	a1 20 40 80 00       	mov    0x804020,%eax
  80056d:	8b 50 74             	mov    0x74(%eax),%edx
  800570:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800573:	39 c2                	cmp    %eax,%edx
  800575:	77 8d                	ja     800504 <_main+0x4cc>
		//===================

		//CASE1: free the exited env only
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
		{
  800577:	e9 ac 02 00 00       	jmp    800828 <_main+0x7f0>
				if(myEnv->page_last_WS_index != 9) panic("wrong PAGE WS pointer location");
			}
		}
		 */
		//CASE2: free the WS ONLY using FIFO algorithm
		else if (testCase == 2)
  80057c:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  800580:	0f 85 a2 02 00 00    	jne    800828 <_main+0x7f0>
		{
			//cprintf("Checking PAGE FIFO algorithm... \n");
			{
				if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800586:	a1 20 40 80 00       	mov    0x804020,%eax
  80058b:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800599:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80059f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a4:	3d 00 40 80 00       	cmp    $0x804000,%eax
  8005a9:	74 17                	je     8005c2 <_main+0x58a>
  8005ab:	83 ec 04             	sub    $0x4,%esp
  8005ae:	68 38 32 80 00       	push   $0x803238
  8005b3:	68 9e 00 00 00       	push   $0x9e
  8005b8:	68 ca 31 80 00       	push   $0x8031ca
  8005bd:	e8 48 10 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80e000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8005c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c7:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8005cd:	83 c0 18             	add    $0x18,%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  8005d8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8005de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e3:	3d 00 e0 80 00       	cmp    $0x80e000,%eax
  8005e8:	74 17                	je     800601 <_main+0x5c9>
  8005ea:	83 ec 04             	sub    $0x4,%esp
  8005ed:	68 38 32 80 00       	push   $0x803238
  8005f2:	68 9f 00 00 00       	push   $0x9f
  8005f7:	68 ca 31 80 00       	push   $0x8031ca
  8005fc:	e8 09 10 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x80f000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800601:	a1 20 40 80 00       	mov    0x804020,%eax
  800606:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80060c:	83 c0 30             	add    $0x30,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800617:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80061d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800622:	3d 00 f0 80 00       	cmp    $0x80f000,%eax
  800627:	74 17                	je     800640 <_main+0x608>
  800629:	83 ec 04             	sub    $0x4,%esp
  80062c:	68 38 32 80 00       	push   $0x803238
  800631:	68 a0 00 00 00       	push   $0xa0
  800636:	68 ca 31 80 00       	push   $0x8031ca
  80063b:	e8 ca 0f 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x810000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800640:	a1 20 40 80 00       	mov    0x804020,%eax
  800645:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80064b:	83 c0 48             	add    $0x48,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800656:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80065c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800661:	3d 00 00 81 00       	cmp    $0x810000,%eax
  800666:	74 17                	je     80067f <_main+0x647>
  800668:	83 ec 04             	sub    $0x4,%esp
  80066b:	68 38 32 80 00       	push   $0x803238
  800670:	68 a1 00 00 00       	push   $0xa1
  800675:	68 ca 31 80 00       	push   $0x8031ca
  80067a:	e8 8b 0f 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x805000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80067f:	a1 20 40 80 00       	mov    0x804020,%eax
  800684:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80068a:	83 c0 60             	add    $0x60,%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800695:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80069b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a0:	3d 00 50 80 00       	cmp    $0x805000,%eax
  8006a5:	74 17                	je     8006be <_main+0x686>
  8006a7:	83 ec 04             	sub    $0x4,%esp
  8006aa:	68 38 32 80 00       	push   $0x803238
  8006af:	68 a2 00 00 00       	push   $0xa2
  8006b4:	68 ca 31 80 00       	push   $0x8031ca
  8006b9:	e8 4c 0f 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x806000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8006be:	a1 20 40 80 00       	mov    0x804020,%eax
  8006c3:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8006c9:	83 c0 78             	add    $0x78,%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8006d4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8006da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006df:	3d 00 60 80 00       	cmp    $0x806000,%eax
  8006e4:	74 17                	je     8006fd <_main+0x6c5>
  8006e6:	83 ec 04             	sub    $0x4,%esp
  8006e9:	68 38 32 80 00       	push   $0x803238
  8006ee:	68 a3 00 00 00       	push   $0xa3
  8006f3:	68 ca 31 80 00       	push   $0x8031ca
  8006f8:	e8 0d 0f 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x807000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8006fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800702:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800708:	05 90 00 00 00       	add    $0x90,%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800715:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80071b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800720:	3d 00 70 80 00       	cmp    $0x807000,%eax
  800725:	74 17                	je     80073e <_main+0x706>
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	68 38 32 80 00       	push   $0x803238
  80072f:	68 a4 00 00 00       	push   $0xa4
  800734:	68 ca 31 80 00       	push   $0x8031ca
  800739:	e8 cc 0e 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80073e:	a1 20 40 80 00       	mov    0x804020,%eax
  800743:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800749:	05 a8 00 00 00       	add    $0xa8,%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800756:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80075c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800761:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 38 32 80 00       	push   $0x803238
  800770:	68 a5 00 00 00       	push   $0xa5
  800775:	68 ca 31 80 00       	push   $0x8031ca
  80077a:	e8 8b 0e 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80077f:	a1 20 40 80 00       	mov    0x804020,%eax
  800784:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80078a:	05 c0 00 00 00       	add    $0xc0,%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800797:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80079d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007a2:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8007a7:	74 17                	je     8007c0 <_main+0x788>
  8007a9:	83 ec 04             	sub    $0x4,%esp
  8007ac:	68 38 32 80 00       	push   $0x803238
  8007b1:	68 a6 00 00 00       	push   $0xa6
  8007b6:	68 ca 31 80 00       	push   $0x8031ca
  8007bb:	e8 4a 0e 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8007c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c5:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8007cb:	05 d8 00 00 00       	add    $0xd8,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  8007d8:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8007de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e3:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8007e8:	74 17                	je     800801 <_main+0x7c9>
  8007ea:	83 ec 04             	sub    $0x4,%esp
  8007ed:	68 38 32 80 00       	push   $0x803238
  8007f2:	68 a7 00 00 00       	push   $0xa7
  8007f7:	68 ca 31 80 00       	push   $0x8031ca
  8007fc:	e8 09 0e 00 00       	call   80160a <_panic>

				if(myEnv->page_last_WS_index != 9) panic("wrong PAGE WS pointer location");
  800801:	a1 20 40 80 00       	mov    0x804020,%eax
  800806:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  80080c:	83 f8 09             	cmp    $0x9,%eax
  80080f:	74 17                	je     800828 <_main+0x7f0>
  800811:	83 ec 04             	sub    $0x4,%esp
  800814:	68 84 32 80 00       	push   $0x803284
  800819:	68 a9 00 00 00       	push   $0xa9
  80081e:	68 ca 31 80 00       	push   $0x8031ca
  800823:	e8 e2 0d 00 00       	call   80160a <_panic>
			}
		}

		//=========================================================//
		//Clear the FFL
		sys_clear_ffl();
  800828:	e8 4e 20 00 00       	call   80287b <sys_clear_ffl>
		//=========================================================//

		//Writing (Modified) after freeing the entire FFL:
		//	3 frames should be allocated (stack page, mem table, page file table)
		*ptr3 = garbage1 ;
  80082d:	a1 08 40 80 00       	mov    0x804008,%eax
  800832:	8a 95 73 ff ff ff    	mov    -0x8d(%ebp),%dl
  800838:	88 10                	mov    %dl,(%eax)
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  80083a:	a1 00 40 80 00       	mov    0x804000,%eax
  80083f:	8a 00                	mov    (%eax),%al
  800841:	88 45 db             	mov    %al,-0x25(%ebp)
		garbage5 = *ptr2 ;
  800844:	a1 04 40 80 00       	mov    0x804004,%eax
  800849:	8a 00                	mov    (%eax),%al
  80084b:	88 45 da             	mov    %al,-0x26(%ebp)

		//CASE1: free the exited env's ONLY
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
  80084e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800852:	74 0a                	je     80085e <_main+0x826>
  800854:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  800858:	0f 85 99 00 00 00    	jne    8008f7 <_main+0x8bf>
		{
			//Add the last reference to our WS
			WSEntries_before[numOfExistPages++] = ROUNDDOWN((uint32)(ptr3), PAGE_SIZE);
  80085e:	a1 20 72 83 00       	mov    0x837220,%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 15 20 72 83 00    	mov    %edx,0x837220
  80086c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800872:	89 95 3c ff ff ff    	mov    %edx,-0xc4(%ebp)
  800878:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  80087e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  800884:	89 14 85 60 72 83 00 	mov    %edx,0x837260(,%eax,4)

			//Make sure that WS is not affected
			for (i = 0; i < numOfExistPages; ++i)
  80088b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800892:	eb 54                	jmp    8008e8 <_main+0x8b0>
			{
				if (WSEntries_before[i] != ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address, PAGE_SIZE))
  800894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800897:	8b 0c 85 60 72 83 00 	mov    0x837260(,%eax,4),%ecx
  80089e:	a1 20 40 80 00       	mov    0x804020,%eax
  8008a3:	8b 98 58 da 01 00    	mov    0x1da58(%eax),%ebx
  8008a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008ac:	89 d0                	mov    %edx,%eax
  8008ae:	01 c0                	add    %eax,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	c1 e0 03             	shl    $0x3,%eax
  8008b5:	01 d8                	add    %ebx,%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  8008bf:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8008c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ca:	39 c1                	cmp    %eax,%ecx
  8008cc:	74 17                	je     8008e5 <_main+0x8ad>
					panic("FreeRAM.Scenario1 or 3: WS is changed while not expected to!");
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	68 a4 32 80 00       	push   $0x8032a4
  8008d6:	68 c4 00 00 00       	push   $0xc4
  8008db:	68 ca 31 80 00       	push   $0x8031ca
  8008e0:	e8 25 0d 00 00       	call   80160a <_panic>
		{
			//Add the last reference to our WS
			WSEntries_before[numOfExistPages++] = ROUNDDOWN((uint32)(ptr3), PAGE_SIZE);

			//Make sure that WS is not affected
			for (i = 0; i < numOfExistPages; ++i)
  8008e5:	ff 45 d4             	incl   -0x2c(%ebp)
  8008e8:	a1 20 72 83 00       	mov    0x837220,%eax
  8008ed:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8008f0:	7c a2                	jl     800894 <_main+0x85c>
		garbage4 = *ptr ;
		garbage5 = *ptr2 ;

		//CASE1: free the exited env's ONLY
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
  8008f2:	e9 45 01 00 00       	jmp    800a3c <_main+0xa04>
				if (WSEntries_before[i] != ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address, PAGE_SIZE))
					panic("FreeRAM.Scenario1 or 3: WS is changed while not expected to!");
			}
		}
		//Case2: free the WS ONLY by clock algorithm
		else if (testCase == 2)
  8008f7:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8008fb:	0f 85 3b 01 00 00    	jne    800a3c <_main+0xa04>
			}
			 */

			//Check the WS after FIFO algorithm

			if (garbage4 != *ptr || garbage5 != *ptr2) panic("test failed!");
  800901:	a1 00 40 80 00       	mov    0x804000,%eax
  800906:	8a 00                	mov    (%eax),%al
  800908:	3a 45 db             	cmp    -0x25(%ebp),%al
  80090b:	75 0c                	jne    800919 <_main+0x8e1>
  80090d:	a1 04 40 80 00       	mov    0x804004,%eax
  800912:	8a 00                	mov    (%eax),%al
  800914:	3a 45 da             	cmp    -0x26(%ebp),%al
  800917:	74 17                	je     800930 <_main+0x8f8>
  800919:	83 ec 04             	sub    $0x4,%esp
  80091c:	68 e1 32 80 00       	push   $0x8032e1
  800921:	68 d7 00 00 00       	push   $0xd7
  800926:	68 ca 31 80 00       	push   $0x8031ca
  80092b:	e8 da 0c 00 00       	call   80160a <_panic>

			//There should be two empty locations that are freed for the two tables (mem table and page file table)
			int numOfEmptyLocs = 0 ;
  800930:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
			for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  800937:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80093e:	eb 26                	jmp    800966 <_main+0x92e>
			{
				if (myEnv->__uptr_pws[i].empty)
  800940:	a1 20 40 80 00       	mov    0x804020,%eax
  800945:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80094b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80094e:	89 d0                	mov    %edx,%eax
  800950:	01 c0                	add    %eax,%eax
  800952:	01 d0                	add    %edx,%eax
  800954:	c1 e0 03             	shl    $0x3,%eax
  800957:	01 c8                	add    %ecx,%eax
  800959:	8a 40 04             	mov    0x4(%eax),%al
  80095c:	84 c0                	test   %al,%al
  80095e:	74 03                	je     800963 <_main+0x92b>
					numOfEmptyLocs++ ;
  800960:	ff 45 cc             	incl   -0x34(%ebp)

			if (garbage4 != *ptr || garbage5 != *ptr2) panic("test failed!");

			//There should be two empty locations that are freed for the two tables (mem table and page file table)
			int numOfEmptyLocs = 0 ;
			for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  800963:	ff 45 c8             	incl   -0x38(%ebp)
  800966:	a1 20 40 80 00       	mov    0x804020,%eax
  80096b:	8b 50 74             	mov    0x74(%eax),%edx
  80096e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800971:	39 c2                	cmp    %eax,%edx
  800973:	77 cb                	ja     800940 <_main+0x908>
			{
				if (myEnv->__uptr_pws[i].empty)
					numOfEmptyLocs++ ;
			}
			if (numOfEmptyLocs != 2) panic("test failed! either wrong victim or victim is not removed from WS");
  800975:	83 7d cc 02          	cmpl   $0x2,-0x34(%ebp)
  800979:	74 17                	je     800992 <_main+0x95a>
  80097b:	83 ec 04             	sub    $0x4,%esp
  80097e:	68 f0 32 80 00       	push   $0x8032f0
  800983:	68 e0 00 00 00       	push   $0xe0
  800988:	68 ca 31 80 00       	push   $0x8031ca
  80098d:	e8 78 0c 00 00       	call   80160a <_panic>

			uint32 expectedAddresses[8] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x807000,0xee7fe000,0xeebfd000} ;
  800992:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  800998:	bb 00 34 80 00       	mov    $0x803400,%ebx
  80099d:	ba 08 00 00 00       	mov    $0x8,%edx
  8009a2:	89 c7                	mov    %eax,%edi
  8009a4:	89 de                	mov    %ebx,%esi
  8009a6:	89 d1                	mov    %edx,%ecx
  8009a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			int numOfFoundedAddresses = 0;
  8009aa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for (int j = 0; j < 8; j++)
  8009b1:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8009b8:	eb 5f                	jmp    800a19 <_main+0x9e1>
			{
				for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  8009ba:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  8009c1:	eb 44                	jmp    800a07 <_main+0x9cf>
				{
					if (ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == expectedAddresses[j])
  8009c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8009c8:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8009ce:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8009d1:	89 d0                	mov    %edx,%eax
  8009d3:	01 c0                	add    %eax,%eax
  8009d5:	01 d0                	add    %edx,%eax
  8009d7:	c1 e0 03             	shl    $0x3,%eax
  8009da:	01 c8                	add    %ecx,%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  8009e4:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8009ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009ef:	89 c2                	mov    %eax,%edx
  8009f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8009f4:	8b 84 85 6c fe ff ff 	mov    -0x194(%ebp,%eax,4),%eax
  8009fb:	39 c2                	cmp    %eax,%edx
  8009fd:	75 05                	jne    800a04 <_main+0x9cc>
					{
						numOfFoundedAddresses++;
  8009ff:	ff 45 c4             	incl   -0x3c(%ebp)
						break;
  800a02:	eb 12                	jmp    800a16 <_main+0x9de>

			uint32 expectedAddresses[8] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x807000,0xee7fe000,0xeebfd000} ;
			int numOfFoundedAddresses = 0;
			for (int j = 0; j < 8; j++)
			{
				for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  800a04:	ff 45 bc             	incl   -0x44(%ebp)
  800a07:	a1 20 40 80 00       	mov    0x804020,%eax
  800a0c:	8b 50 74             	mov    0x74(%eax),%edx
  800a0f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800a12:	39 c2                	cmp    %eax,%edx
  800a14:	77 ad                	ja     8009c3 <_main+0x98b>
			}
			if (numOfEmptyLocs != 2) panic("test failed! either wrong victim or victim is not removed from WS");

			uint32 expectedAddresses[8] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x807000,0xee7fe000,0xeebfd000} ;
			int numOfFoundedAddresses = 0;
			for (int j = 0; j < 8; j++)
  800a16:	ff 45 c0             	incl   -0x40(%ebp)
  800a19:	83 7d c0 07          	cmpl   $0x7,-0x40(%ebp)
  800a1d:	7e 9b                	jle    8009ba <_main+0x982>
						numOfFoundedAddresses++;
						break;
					}
				}
			}
			if (numOfFoundedAddresses != 8) panic("test failed! either wrong victim or victim is not removed from WS");
  800a1f:	83 7d c4 08          	cmpl   $0x8,-0x3c(%ebp)
  800a23:	74 17                	je     800a3c <_main+0xa04>
  800a25:	83 ec 04             	sub    $0x4,%esp
  800a28:	68 f0 32 80 00       	push   $0x8032f0
  800a2d:	68 ef 00 00 00       	push   $0xef
  800a32:	68 ca 31 80 00       	push   $0x8031ca
  800a37:	e8 ce 0b 00 00       	call   80160a <_panic>

		}


		//Case1: free the exited env's ONLY
		if (testCase ==1)
  800a3c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800a40:	0f 85 81 00 00 00    	jne    800ac7 <_main+0xa8f>
		{
			cprintf("running fos_helloWorld program...\n\n");
  800a46:	83 ec 0c             	sub    $0xc,%esp
  800a49:	68 34 33 80 00       	push   $0x803334
  800a4e:	e8 6b 0e 00 00       	call   8018be <cprintf>
  800a53:	83 c4 10             	add    $0x10,%esp
			sys_run_env(envIdHelloWorld);
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	ff 75 dc             	pushl  -0x24(%ebp)
  800a5c:	e8 63 1f 00 00       	call   8029c4 <sys_run_env>
  800a61:	83 c4 10             	add    $0x10,%esp
			cprintf("please be patient ...\n");
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	68 61 31 80 00       	push   $0x803161
  800a6c:	e8 4d 0e 00 00       	call   8018be <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
			env_sleep(3000);
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 b8 0b 00 00       	push   $0xbb8
  800a7c:	e8 25 22 00 00       	call   802ca6 <env_sleep>
  800a81:	83 c4 10             	add    $0x10,%esp

			cprintf("running fos_fib program...\n\n");
  800a84:	83 ec 0c             	sub    $0xc,%esp
  800a87:	68 58 33 80 00       	push   $0x803358
  800a8c:	e8 2d 0e 00 00       	call   8018be <cprintf>
  800a91:	83 c4 10             	add    $0x10,%esp
			sys_run_env(envIdFib);
  800a94:	83 ec 0c             	sub    $0xc,%esp
  800a97:	ff 75 e0             	pushl  -0x20(%ebp)
  800a9a:	e8 25 1f 00 00       	call   8029c4 <sys_run_env>
  800a9f:	83 c4 10             	add    $0x10,%esp
			cprintf("please be patient ...\n");
  800aa2:	83 ec 0c             	sub    $0xc,%esp
  800aa5:	68 61 31 80 00       	push   $0x803161
  800aaa:	e8 0f 0e 00 00       	call   8018be <cprintf>
  800aaf:	83 c4 10             	add    $0x10,%esp
			env_sleep(5000);
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	68 88 13 00 00       	push   $0x1388
  800aba:	e8 e7 21 00 00       	call   802ca6 <env_sleep>
  800abf:	83 c4 10             	add    $0x10,%esp
  800ac2:	e9 60 08 00 00       	jmp    801327 <_main+0x12ef>
		}
		//CASE3: free BOTH exited env's and WS
		else if (testCase ==3)
  800ac7:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  800acb:	0f 85 56 08 00 00    	jne    801327 <_main+0x12ef>
				if( ROUNDDOWN(myEnv->__uptr_pws[24].virtual_address,PAGE_SIZE) !=   0xee7fe000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
				if( myEnv->page_last_WS_index !=  0)  										panic("InitialWSError2: INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
			}
			 */

			cprintf("Checking PAGE FIFO algorithm... \n");
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	68 78 33 80 00       	push   $0x803378
  800ad9:	e8 e0 0d 00 00       	call   8018be <cprintf>
  800ade:	83 c4 10             	add    $0x10,%esp
			{
				if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800ae1:	a1 20 40 80 00       	mov    0x804020,%eax
  800ae6:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800af4:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800afa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800aff:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800b04:	74 17                	je     800b1d <_main+0xae5>
  800b06:	83 ec 04             	sub    $0x4,%esp
  800b09:	68 78 31 80 00       	push   $0x803178
  800b0e:	68 25 01 00 00       	push   $0x125
  800b13:	68 ca 31 80 00       	push   $0x8031ca
  800b18:	e8 ed 0a 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800b1d:	a1 20 40 80 00       	mov    0x804020,%eax
  800b22:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800b28:	83 c0 18             	add    $0x18,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800b33:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3e:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800b43:	74 17                	je     800b5c <_main+0xb24>
  800b45:	83 ec 04             	sub    $0x4,%esp
  800b48:	68 78 31 80 00       	push   $0x803178
  800b4d:	68 26 01 00 00       	push   $0x126
  800b52:	68 ca 31 80 00       	push   $0x8031ca
  800b57:	e8 ae 0a 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800b5c:	a1 20 40 80 00       	mov    0x804020,%eax
  800b61:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800b67:	83 c0 30             	add    $0x30,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800b72:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800b78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b7d:	3d 00 20 20 00       	cmp    $0x202000,%eax
  800b82:	74 17                	je     800b9b <_main+0xb63>
  800b84:	83 ec 04             	sub    $0x4,%esp
  800b87:	68 78 31 80 00       	push   $0x803178
  800b8c:	68 27 01 00 00       	push   $0x127
  800b91:	68 ca 31 80 00       	push   $0x8031ca
  800b96:	e8 6f 0a 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800b9b:	a1 20 40 80 00       	mov    0x804020,%eax
  800ba0:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800ba6:	83 c0 48             	add    $0x48,%eax
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800bb1:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800bb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bbc:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800bc1:	74 17                	je     800bda <_main+0xba2>
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	68 78 31 80 00       	push   $0x803178
  800bcb:	68 28 01 00 00       	push   $0x128
  800bd0:	68 ca 31 80 00       	push   $0x8031ca
  800bd5:	e8 30 0a 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800bda:	a1 20 40 80 00       	mov    0x804020,%eax
  800bdf:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800be5:	83 c0 60             	add    $0x60,%eax
  800be8:	8b 00                	mov    (%eax),%eax
  800bea:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  800bf0:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800bf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bfb:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800c00:	74 17                	je     800c19 <_main+0xbe1>
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	68 78 31 80 00       	push   $0x803178
  800c0a:	68 29 01 00 00       	push   $0x129
  800c0f:	68 ca 31 80 00       	push   $0x8031ca
  800c14:	e8 f1 09 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800c19:	a1 20 40 80 00       	mov    0x804020,%eax
  800c1e:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800c24:	83 c0 78             	add    $0x78,%eax
  800c27:	8b 00                	mov    (%eax),%eax
  800c29:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  800c2f:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800c35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c3a:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800c3f:	74 17                	je     800c58 <_main+0xc20>
  800c41:	83 ec 04             	sub    $0x4,%esp
  800c44:	68 78 31 80 00       	push   $0x803178
  800c49:	68 2a 01 00 00       	push   $0x12a
  800c4e:	68 ca 31 80 00       	push   $0x8031ca
  800c53:	e8 b2 09 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800c58:	a1 20 40 80 00       	mov    0x804020,%eax
  800c5d:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800c63:	05 90 00 00 00       	add    $0x90,%eax
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800c70:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c7b:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800c80:	74 17                	je     800c99 <_main+0xc61>
  800c82:	83 ec 04             	sub    $0x4,%esp
  800c85:	68 78 31 80 00       	push   $0x803178
  800c8a:	68 2b 01 00 00       	push   $0x12b
  800c8f:	68 ca 31 80 00       	push   $0x8031ca
  800c94:	e8 71 09 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800c99:	a1 20 40 80 00       	mov    0x804020,%eax
  800c9e:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800ca4:	05 a8 00 00 00       	add    $0xa8,%eax
  800ca9:	8b 00                	mov    (%eax),%eax
  800cab:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800cb1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800cb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cbc:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800cc1:	74 17                	je     800cda <_main+0xca2>
  800cc3:	83 ec 04             	sub    $0x4,%esp
  800cc6:	68 78 31 80 00       	push   $0x803178
  800ccb:	68 2c 01 00 00       	push   $0x12c
  800cd0:	68 ca 31 80 00       	push   $0x8031ca
  800cd5:	e8 30 09 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800cda:	a1 20 40 80 00       	mov    0x804020,%eax
  800cdf:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800ce5:	05 c0 00 00 00       	add    $0xc0,%eax
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800cf2:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800cf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cfd:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800d02:	74 17                	je     800d1b <_main+0xce3>
  800d04:	83 ec 04             	sub    $0x4,%esp
  800d07:	68 78 31 80 00       	push   $0x803178
  800d0c:	68 2d 01 00 00       	push   $0x12d
  800d11:	68 ca 31 80 00       	push   $0x8031ca
  800d16:	e8 ef 08 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800d1b:	a1 20 40 80 00       	mov    0x804020,%eax
  800d20:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800d26:	05 d8 00 00 00       	add    $0xd8,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800d33:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800d39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d3e:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800d43:	74 17                	je     800d5c <_main+0xd24>
  800d45:	83 ec 04             	sub    $0x4,%esp
  800d48:	68 78 31 80 00       	push   $0x803178
  800d4d:	68 2e 01 00 00       	push   $0x12e
  800d52:	68 ca 31 80 00       	push   $0x8031ca
  800d57:	e8 ae 08 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800d5c:	a1 20 40 80 00       	mov    0x804020,%eax
  800d61:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800d67:	05 f0 00 00 00       	add    $0xf0,%eax
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  800d74:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  800d7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d7f:	3d 00 40 80 00       	cmp    $0x804000,%eax
  800d84:	74 17                	je     800d9d <_main+0xd65>
  800d86:	83 ec 04             	sub    $0x4,%esp
  800d89:	68 78 31 80 00       	push   $0x803178
  800d8e:	68 2f 01 00 00       	push   $0x12f
  800d93:	68 ca 31 80 00       	push   $0x8031ca
  800d98:	e8 6d 08 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0x805000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800d9d:	a1 20 40 80 00       	mov    0x804020,%eax
  800da2:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800da8:	05 08 01 00 00       	add    $0x108,%eax
  800dad:	8b 00                	mov    (%eax),%eax
  800daf:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  800db5:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  800dbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dc0:	3d 00 50 80 00       	cmp    $0x805000,%eax
  800dc5:	74 17                	je     800dde <_main+0xda6>
  800dc7:	83 ec 04             	sub    $0x4,%esp
  800dca:	68 78 31 80 00       	push   $0x803178
  800dcf:	68 30 01 00 00       	push   $0x130
  800dd4:	68 ca 31 80 00       	push   $0x8031ca
  800dd9:	e8 2c 08 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=   0x806000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800dde:	a1 20 40 80 00       	mov    0x804020,%eax
  800de3:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800de9:	05 20 01 00 00       	add    $0x120,%eax
  800dee:	8b 00                	mov    (%eax),%eax
  800df0:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  800df6:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  800dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e01:	3d 00 60 80 00       	cmp    $0x806000,%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 78 31 80 00       	push   $0x803178
  800e10:	68 31 01 00 00       	push   $0x131
  800e15:	68 ca 31 80 00       	push   $0x8031ca
  800e1a:	e8 eb 07 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[13].virtual_address,PAGE_SIZE) !=   0x807000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800e1f:	a1 20 40 80 00       	mov    0x804020,%eax
  800e24:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800e2a:	05 38 01 00 00       	add    $0x138,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  800e37:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  800e3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e42:	3d 00 70 80 00       	cmp    $0x807000,%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 78 31 80 00       	push   $0x803178
  800e51:	68 32 01 00 00       	push   $0x132
  800e56:	68 ca 31 80 00       	push   $0x8031ca
  800e5b:	e8 aa 07 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[14].virtual_address,PAGE_SIZE) !=   0x808000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800e60:	a1 20 40 80 00       	mov    0x804020,%eax
  800e65:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800e6b:	05 50 01 00 00       	add    $0x150,%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  800e78:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  800e7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e83:	3d 00 80 80 00       	cmp    $0x808000,%eax
  800e88:	74 17                	je     800ea1 <_main+0xe69>
  800e8a:	83 ec 04             	sub    $0x4,%esp
  800e8d:	68 78 31 80 00       	push   $0x803178
  800e92:	68 33 01 00 00       	push   $0x133
  800e97:	68 ca 31 80 00       	push   $0x8031ca
  800e9c:	e8 69 07 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[15].virtual_address,PAGE_SIZE) !=   0x809000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800ea1:	a1 20 40 80 00       	mov    0x804020,%eax
  800ea6:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800eac:	05 68 01 00 00       	add    $0x168,%eax
  800eb1:	8b 00                	mov    (%eax),%eax
  800eb3:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  800eb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800ebf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec4:	3d 00 90 80 00       	cmp    $0x809000,%eax
  800ec9:	74 17                	je     800ee2 <_main+0xeaa>
  800ecb:	83 ec 04             	sub    $0x4,%esp
  800ece:	68 78 31 80 00       	push   $0x803178
  800ed3:	68 34 01 00 00       	push   $0x134
  800ed8:	68 ca 31 80 00       	push   $0x8031ca
  800edd:	e8 28 07 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[16].virtual_address,PAGE_SIZE) !=   0x80A000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800ee2:	a1 20 40 80 00       	mov    0x804020,%eax
  800ee7:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800eed:	05 80 01 00 00       	add    $0x180,%eax
  800ef2:	8b 00                	mov    (%eax),%eax
  800ef4:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  800efa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800f00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f05:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  800f0a:	74 17                	je     800f23 <_main+0xeeb>
  800f0c:	83 ec 04             	sub    $0x4,%esp
  800f0f:	68 78 31 80 00       	push   $0x803178
  800f14:	68 35 01 00 00       	push   $0x135
  800f19:	68 ca 31 80 00       	push   $0x8031ca
  800f1e:	e8 e7 06 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[17].virtual_address,PAGE_SIZE) !=   0x80B000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800f23:	a1 20 40 80 00       	mov    0x804020,%eax
  800f28:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800f2e:	05 98 01 00 00       	add    $0x198,%eax
  800f33:	8b 00                	mov    (%eax),%eax
  800f35:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  800f3b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800f41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f46:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 78 31 80 00       	push   $0x803178
  800f55:	68 36 01 00 00       	push   $0x136
  800f5a:	68 ca 31 80 00       	push   $0x8031ca
  800f5f:	e8 a6 06 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[18].virtual_address,PAGE_SIZE) !=   0x80C000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800f64:	a1 20 40 80 00       	mov    0x804020,%eax
  800f69:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800f6f:	05 b0 01 00 00       	add    $0x1b0,%eax
  800f74:	8b 00                	mov    (%eax),%eax
  800f76:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  800f7c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800f82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f87:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800f8c:	74 17                	je     800fa5 <_main+0xf6d>
  800f8e:	83 ec 04             	sub    $0x4,%esp
  800f91:	68 78 31 80 00       	push   $0x803178
  800f96:	68 37 01 00 00       	push   $0x137
  800f9b:	68 ca 31 80 00       	push   $0x8031ca
  800fa0:	e8 65 06 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[19].virtual_address,PAGE_SIZE) !=   0x80D000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800fa5:	a1 20 40 80 00       	mov    0x804020,%eax
  800faa:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800fb0:	05 c8 01 00 00       	add    $0x1c8,%eax
  800fb5:	8b 00                	mov    (%eax),%eax
  800fb7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  800fbd:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800fc3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fc8:	3d 00 d0 80 00       	cmp    $0x80d000,%eax
  800fcd:	74 17                	je     800fe6 <_main+0xfae>
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	68 78 31 80 00       	push   $0x803178
  800fd7:	68 38 01 00 00       	push   $0x138
  800fdc:	68 ca 31 80 00       	push   $0x8031ca
  800fe1:	e8 24 06 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[20].virtual_address,PAGE_SIZE) !=   0x80E000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800fe6:	a1 20 40 80 00       	mov    0x804020,%eax
  800feb:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800ff1:	05 e0 01 00 00       	add    $0x1e0,%eax
  800ff6:	8b 00                	mov    (%eax),%eax
  800ff8:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  800ffe:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  801004:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801009:	3d 00 e0 80 00       	cmp    $0x80e000,%eax
  80100e:	74 17                	je     801027 <_main+0xfef>
  801010:	83 ec 04             	sub    $0x4,%esp
  801013:	68 78 31 80 00       	push   $0x803178
  801018:	68 39 01 00 00       	push   $0x139
  80101d:	68 ca 31 80 00       	push   $0x8031ca
  801022:	e8 e3 05 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[21].virtual_address,PAGE_SIZE) !=   0x80F000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  801027:	a1 20 40 80 00       	mov    0x804020,%eax
  80102c:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  801032:	05 f8 01 00 00       	add    $0x1f8,%eax
  801037:	8b 00                	mov    (%eax),%eax
  801039:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  80103f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  801045:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80104a:	3d 00 f0 80 00       	cmp    $0x80f000,%eax
  80104f:	74 17                	je     801068 <_main+0x1030>
  801051:	83 ec 04             	sub    $0x4,%esp
  801054:	68 78 31 80 00       	push   $0x803178
  801059:	68 3a 01 00 00       	push   $0x13a
  80105e:	68 ca 31 80 00       	push   $0x8031ca
  801063:	e8 a2 05 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[22].virtual_address,PAGE_SIZE) !=   0x810000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  801068:	a1 20 40 80 00       	mov    0x804020,%eax
  80106d:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  801073:	05 10 02 00 00       	add    $0x210,%eax
  801078:	8b 00                	mov    (%eax),%eax
  80107a:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  801080:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  801086:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80108b:	3d 00 00 81 00       	cmp    $0x810000,%eax
  801090:	74 17                	je     8010a9 <_main+0x1071>
  801092:	83 ec 04             	sub    $0x4,%esp
  801095:	68 78 31 80 00       	push   $0x803178
  80109a:	68 3b 01 00 00       	push   $0x13b
  80109f:	68 ca 31 80 00       	push   $0x8031ca
  8010a4:	e8 61 05 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[23].virtual_address,PAGE_SIZE) !=   0x811000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8010a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8010ae:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8010b4:	05 28 02 00 00       	add    $0x228,%eax
  8010b9:	8b 00                	mov    (%eax),%eax
  8010bb:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8010c1:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8010c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010cc:	3d 00 10 81 00       	cmp    $0x811000,%eax
  8010d1:	74 17                	je     8010ea <_main+0x10b2>
  8010d3:	83 ec 04             	sub    $0x4,%esp
  8010d6:	68 78 31 80 00       	push   $0x803178
  8010db:	68 3c 01 00 00       	push   $0x13c
  8010e0:	68 ca 31 80 00       	push   $0x8031ca
  8010e5:	e8 20 05 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[24].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8010ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8010ef:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8010f5:	05 40 02 00 00       	add    $0x240,%eax
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801102:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801108:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80110d:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  801112:	74 17                	je     80112b <_main+0x10f3>
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	68 78 31 80 00       	push   $0x803178
  80111c:	68 3d 01 00 00       	push   $0x13d
  801121:	68 ca 31 80 00       	push   $0x8031ca
  801126:	e8 df 04 00 00       	call   80160a <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[25].virtual_address,PAGE_SIZE) !=   0xee7fe000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80112b:	a1 20 40 80 00       	mov    0x804020,%eax
  801130:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  801136:	05 58 02 00 00       	add    $0x258,%eax
  80113b:	8b 00                	mov    (%eax),%eax
  80113d:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  801143:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  801149:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80114e:	3d 00 e0 7f ee       	cmp    $0xee7fe000,%eax
  801153:	74 17                	je     80116c <_main+0x1134>
  801155:	83 ec 04             	sub    $0x4,%esp
  801158:	68 78 31 80 00       	push   $0x803178
  80115d:	68 3e 01 00 00       	push   $0x13e
  801162:	68 ca 31 80 00       	push   $0x8031ca
  801167:	e8 9e 04 00 00       	call   80160a <_panic>
				if( myEnv->page_last_WS_index !=  0)  										panic("InitialWSError2: INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  80116c:	a1 20 40 80 00       	mov    0x804020,%eax
  801171:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  801177:	85 c0                	test   %eax,%eax
  801179:	74 17                	je     801192 <_main+0x115a>
  80117b:	83 ec 04             	sub    $0x4,%esp
  80117e:	68 e0 31 80 00       	push   $0x8031e0
  801183:	68 3f 01 00 00       	push   $0x13f
  801188:	68 ca 31 80 00       	push   $0x8031ca
  80118d:	e8 78 04 00 00       	call   80160a <_panic>
			}

			//=========================================================//
			//Clear the FFL
			sys_clear_ffl();
  801192:	e8 e4 16 00 00       	call   80287b <sys_clear_ffl>

			//NOW: it should take from WS

			//Writing (Modified) after freeing the entire FFL:
			//	3 frames should be allocated (stack page, mem table, page file table)
			*ptr4 = garbage2 ;
  801197:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80119c:	8a 95 72 ff ff ff    	mov    -0x8e(%ebp),%dl
  8011a2:	88 10                	mov    %dl,(%eax)
			//always use pages at 0x801000 and 0x804000
			//			if (garbage4 != *ptr) panic("test failed!");
			//			if (garbage5 != *ptr2) panic("test failed!");

			garbage4 = *ptr ;
  8011a4:	a1 00 40 80 00       	mov    0x804000,%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	88 45 db             	mov    %al,-0x25(%ebp)
			garbage5 = *ptr2 ;
  8011ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	88 45 da             	mov    %al,-0x26(%ebp)

			//Writing (Modified) after freeing the entire FFL:
			//	4 frames should be allocated (4 stack pages)
			*(ptr4+1*PAGE_SIZE) = 'A';
  8011b8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011bd:	05 00 10 00 00       	add    $0x1000,%eax
  8011c2:	c6 00 41             	movb   $0x41,(%eax)
			*(ptr4+2*PAGE_SIZE) = 'B';
  8011c5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011ca:	05 00 20 00 00       	add    $0x2000,%eax
  8011cf:	c6 00 42             	movb   $0x42,(%eax)
			*(ptr4+3*PAGE_SIZE) = 'C';
  8011d2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011d7:	05 00 30 00 00       	add    $0x3000,%eax
  8011dc:	c6 00 43             	movb   $0x43,(%eax)
			*(ptr4+4*PAGE_SIZE) = 'D';
  8011df:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011e4:	05 00 40 00 00       	add    $0x4000,%eax
  8011e9:	c6 00 44             	movb   $0x44,(%eax)
						ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ==  0x802000)
					panic("test failed! either wrong victim or victim is not removed from WS");
			}
			 */
			//Check the WS after FIFO algorithm
			if (garbage4 != *ptr || garbage5 != *ptr2) panic("test failed!");
  8011ec:	a1 00 40 80 00       	mov    0x804000,%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	3a 45 db             	cmp    -0x25(%ebp),%al
  8011f6:	75 0c                	jne    801204 <_main+0x11cc>
  8011f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3a 45 da             	cmp    -0x26(%ebp),%al
  801202:	74 17                	je     80121b <_main+0x11e3>
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	68 e1 32 80 00       	push   $0x8032e1
  80120c:	68 69 01 00 00       	push   $0x169
  801211:	68 ca 31 80 00       	push   $0x8031ca
  801216:	e8 ef 03 00 00       	call   80160a <_panic>

			//There should be two empty locations that are freed for the two tables (mem table and page file table)
			int numOfEmptyLocs = 0 ;
  80121b:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  801222:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801229:	eb 26                	jmp    801251 <_main+0x1219>
			{
				if (myEnv->__uptr_pws[i].empty)
  80122b:	a1 20 40 80 00       	mov    0x804020,%eax
  801230:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801236:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801239:	89 d0                	mov    %edx,%eax
  80123b:	01 c0                	add    %eax,%eax
  80123d:	01 d0                	add    %edx,%eax
  80123f:	c1 e0 03             	shl    $0x3,%eax
  801242:	01 c8                	add    %ecx,%eax
  801244:	8a 40 04             	mov    0x4(%eax),%al
  801247:	84 c0                	test   %al,%al
  801249:	74 03                	je     80124e <_main+0x1216>
					numOfEmptyLocs++ ;
  80124b:	ff 45 b8             	incl   -0x48(%ebp)
			//Check the WS after FIFO algorithm
			if (garbage4 != *ptr || garbage5 != *ptr2) panic("test failed!");

			//There should be two empty locations that are freed for the two tables (mem table and page file table)
			int numOfEmptyLocs = 0 ;
			for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  80124e:	ff 45 b4             	incl   -0x4c(%ebp)
  801251:	a1 20 40 80 00       	mov    0x804020,%eax
  801256:	8b 50 74             	mov    0x74(%eax),%edx
  801259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80125c:	39 c2                	cmp    %eax,%edx
  80125e:	77 cb                	ja     80122b <_main+0x11f3>
			{
				if (myEnv->__uptr_pws[i].empty)
					numOfEmptyLocs++ ;
			}
			if (numOfEmptyLocs != 2) panic("test failed! either wrong victim or victim is not removed from WS");
  801260:	83 7d b8 02          	cmpl   $0x2,-0x48(%ebp)
  801264:	74 17                	je     80127d <_main+0x1245>
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	68 f0 32 80 00       	push   $0x8032f0
  80126e:	68 72 01 00 00       	push   $0x172
  801273:	68 ca 31 80 00       	push   $0x8031ca
  801278:	e8 8d 03 00 00       	call   80160a <_panic>

			uint32 expectedAddresses[24] = {0x801000,0x802000,0x803000,0x804000,0x805000,0x806000,0x807000,0x808000,0x809000,0x80a000,0x80b000,0x80c000,0x80d000,0x80e000,0x80f000,0x810000,0x811000,
  80127d:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  801283:	bb 20 34 80 00       	mov    $0x803420,%ebx
  801288:	ba 18 00 00 00       	mov    $0x18,%edx
  80128d:	89 c7                	mov    %eax,%edi
  80128f:	89 de                	mov    %ebx,%esi
  801291:	89 d1                	mov    %edx,%ecx
  801293:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
					0xee3f9000,0xee3fa000,0xee3fb000,0xee3fc000,0xee3fd000,0xee7fe000,0xeebfd000} ;

			int numOfFoundedAddresses = 0;
  801295:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
			for (int j = 0; j < 24; j++)
  80129c:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  8012a3:	eb 5f                	jmp    801304 <_main+0x12cc>
			{
				for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  8012a5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
  8012ac:	eb 44                	jmp    8012f2 <_main+0x12ba>
				{
					if (ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == expectedAddresses[j])
  8012ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8012b3:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8012b9:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8012bc:	89 d0                	mov    %edx,%eax
  8012be:	01 c0                	add    %eax,%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c1 e0 03             	shl    $0x3,%eax
  8012c5:	01 c8                	add    %ecx,%eax
  8012c7:	8b 00                	mov    (%eax),%eax
  8012c9:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  8012cf:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8012d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012da:	89 c2                	mov    %eax,%edx
  8012dc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8012df:	8b 84 85 6c fe ff ff 	mov    -0x194(%ebp,%eax,4),%eax
  8012e6:	39 c2                	cmp    %eax,%edx
  8012e8:	75 05                	jne    8012ef <_main+0x12b7>
					{
						numOfFoundedAddresses++;
  8012ea:	ff 45 b0             	incl   -0x50(%ebp)
						break;
  8012ed:	eb 12                	jmp    801301 <_main+0x12c9>
					0xee3f9000,0xee3fa000,0xee3fb000,0xee3fc000,0xee3fd000,0xee7fe000,0xeebfd000} ;

			int numOfFoundedAddresses = 0;
			for (int j = 0; j < 24; j++)
			{
				for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  8012ef:	ff 45 a8             	incl   -0x58(%ebp)
  8012f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8012f7:	8b 50 74             	mov    0x74(%eax),%edx
  8012fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012fd:	39 c2                	cmp    %eax,%edx
  8012ff:	77 ad                	ja     8012ae <_main+0x1276>

			uint32 expectedAddresses[24] = {0x801000,0x802000,0x803000,0x804000,0x805000,0x806000,0x807000,0x808000,0x809000,0x80a000,0x80b000,0x80c000,0x80d000,0x80e000,0x80f000,0x810000,0x811000,
					0xee3f9000,0xee3fa000,0xee3fb000,0xee3fc000,0xee3fd000,0xee7fe000,0xeebfd000} ;

			int numOfFoundedAddresses = 0;
			for (int j = 0; j < 24; j++)
  801301:	ff 45 ac             	incl   -0x54(%ebp)
  801304:	83 7d ac 17          	cmpl   $0x17,-0x54(%ebp)
  801308:	7e 9b                	jle    8012a5 <_main+0x126d>
						numOfFoundedAddresses++;
						break;
					}
				}
			}
			if (numOfFoundedAddresses != 24) panic("test failed! either wrong victim or victim is not removed from WS");
  80130a:	83 7d b0 18          	cmpl   $0x18,-0x50(%ebp)
  80130e:	74 17                	je     801327 <_main+0x12ef>
  801310:	83 ec 04             	sub    $0x4,%esp
  801313:	68 f0 32 80 00       	push   $0x8032f0
  801318:	68 83 01 00 00       	push   $0x183
  80131d:	68 ca 31 80 00       	push   $0x8031ca
  801322:	e8 e3 02 00 00       	call   80160a <_panic>

		}


		//Check that the values are successfully stored
		for (i = 0 ; i < PAGE_SIZE*4 ; i+=PAGE_SIZE/2)
  801327:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80132e:	eb 2c                	jmp    80135c <_main+0x1324>
		{
			//cprintf("i = %x, address = %x, arr[i] = %d\n", i, &(arr[i]), arr[i]);
			if (arr[i] != -1) panic("test failed!");
  801330:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801333:	05 60 b1 82 00       	add    $0x82b160,%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	3c ff                	cmp    $0xff,%al
  80133c:	74 17                	je     801355 <_main+0x131d>
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	68 e1 32 80 00       	push   $0x8032e1
  801346:	68 8d 01 00 00       	push   $0x18d
  80134b:	68 ca 31 80 00       	push   $0x8031ca
  801350:	e8 b5 02 00 00       	call   80160a <_panic>

		}


		//Check that the values are successfully stored
		for (i = 0 ; i < PAGE_SIZE*4 ; i+=PAGE_SIZE/2)
  801355:	81 45 d4 00 08 00 00 	addl   $0x800,-0x2c(%ebp)
  80135c:	81 7d d4 ff 3f 00 00 	cmpl   $0x3fff,-0x2c(%ebp)
  801363:	7e cb                	jle    801330 <_main+0x12f8>
		{
			//cprintf("i = %x, address = %x, arr[i] = %d\n", i, &(arr[i]), arr[i]);
			if (arr[i] != -1) panic("test failed!");
		}
		if (*ptr3 != arr[PAGE_SIZE*10-1]) panic("test failed!");
  801365:	a1 08 40 80 00       	mov    0x804008,%eax
  80136a:	8a 10                	mov    (%eax),%dl
  80136c:	a0 5f 51 83 00       	mov    0x83515f,%al
  801371:	38 c2                	cmp    %al,%dl
  801373:	74 17                	je     80138c <_main+0x1354>
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	68 e1 32 80 00       	push   $0x8032e1
  80137d:	68 8f 01 00 00       	push   $0x18f
  801382:	68 ca 31 80 00       	push   $0x8031ca
  801387:	e8 7e 02 00 00       	call   80160a <_panic>


		if (testCase ==3)
  80138c:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  801390:	0f 85 09 01 00 00    	jne    80149f <_main+0x1467>
		{
			//			cprintf("garbage4 = %d, *ptr = %d\n",garbage4, *ptr);
			if (garbage4 != *ptr) panic("test failed!");
  801396:	a1 00 40 80 00       	mov    0x804000,%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	3a 45 db             	cmp    -0x25(%ebp),%al
  8013a0:	74 17                	je     8013b9 <_main+0x1381>
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	68 e1 32 80 00       	push   $0x8032e1
  8013aa:	68 95 01 00 00       	push   $0x195
  8013af:	68 ca 31 80 00       	push   $0x8031ca
  8013b4:	e8 51 02 00 00       	call   80160a <_panic>
			if (garbage5 != *ptr2) panic("test failed!");
  8013b9:	a1 04 40 80 00       	mov    0x804004,%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	3a 45 da             	cmp    -0x26(%ebp),%al
  8013c3:	74 17                	je     8013dc <_main+0x13a4>
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	68 e1 32 80 00       	push   $0x8032e1
  8013cd:	68 96 01 00 00       	push   $0x196
  8013d2:	68 ca 31 80 00       	push   $0x8031ca
  8013d7:	e8 2e 02 00 00       	call   80160a <_panic>

			if (*ptr4 != arr[PAGE_SIZE*11-1]) panic("test failed!");
  8013dc:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8013e1:	8a 10                	mov    (%eax),%dl
  8013e3:	a0 5f 61 83 00       	mov    0x83615f,%al
  8013e8:	38 c2                	cmp    %al,%dl
  8013ea:	74 17                	je     801403 <_main+0x13cb>
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	68 e1 32 80 00       	push   $0x8032e1
  8013f4:	68 98 01 00 00       	push   $0x198
  8013f9:	68 ca 31 80 00       	push   $0x8031ca
  8013fe:	e8 07 02 00 00       	call   80160a <_panic>
			if (*(ptr4+1*PAGE_SIZE) != 'A') panic("test failed!");
  801403:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801408:	05 00 10 00 00       	add    $0x1000,%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 41                	cmp    $0x41,%al
  801411:	74 17                	je     80142a <_main+0x13f2>
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	68 e1 32 80 00       	push   $0x8032e1
  80141b:	68 99 01 00 00       	push   $0x199
  801420:	68 ca 31 80 00       	push   $0x8031ca
  801425:	e8 e0 01 00 00       	call   80160a <_panic>
			if (*(ptr4+2*PAGE_SIZE) != 'B') panic("test failed!");
  80142a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80142f:	05 00 20 00 00       	add    $0x2000,%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	3c 42                	cmp    $0x42,%al
  801438:	74 17                	je     801451 <_main+0x1419>
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	68 e1 32 80 00       	push   $0x8032e1
  801442:	68 9a 01 00 00       	push   $0x19a
  801447:	68 ca 31 80 00       	push   $0x8031ca
  80144c:	e8 b9 01 00 00       	call   80160a <_panic>
			if (*(ptr4+3*PAGE_SIZE) != 'C') panic("test failed!");
  801451:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801456:	05 00 30 00 00       	add    $0x3000,%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	3c 43                	cmp    $0x43,%al
  80145f:	74 17                	je     801478 <_main+0x1440>
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 e1 32 80 00       	push   $0x8032e1
  801469:	68 9b 01 00 00       	push   $0x19b
  80146e:	68 ca 31 80 00       	push   $0x8031ca
  801473:	e8 92 01 00 00       	call   80160a <_panic>
			if (*(ptr4+4*PAGE_SIZE) != 'D') panic("test failed!");
  801478:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80147d:	05 00 40 00 00       	add    $0x4000,%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 44                	cmp    $0x44,%al
  801486:	74 17                	je     80149f <_main+0x1467>
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	68 e1 32 80 00       	push   $0x8032e1
  801490:	68 9c 01 00 00       	push   $0x19c
  801495:	68 ca 31 80 00       	push   $0x8031ca
  80149a:	e8 6b 01 00 00       	call   80160a <_panic>
		}
	}

	cprintf("Congratulations!! test freeRAM (Scenario# %d) completed successfully.\n", testCase);
  80149f:	83 ec 08             	sub    $0x8,%esp
  8014a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a5:	68 9c 33 80 00       	push   $0x80339c
  8014aa:	e8 0f 04 00 00       	call   8018be <cprintf>
  8014af:	83 c4 10             	add    $0x10,%esp

	return;
  8014b2:	90                   	nop
}
  8014b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b6:	5b                   	pop    %ebx
  8014b7:	5e                   	pop    %esi
  8014b8:	5f                   	pop    %edi
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8014c1:	e8 4e 15 00 00       	call   802a14 <sys_getenvindex>
  8014c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8014c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cc:	89 d0                	mov    %edx,%eax
  8014ce:	01 c0                	add    %eax,%eax
  8014d0:	01 d0                	add    %edx,%eax
  8014d2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8014d9:	01 c8                	add    %ecx,%eax
  8014db:	c1 e0 02             	shl    $0x2,%eax
  8014de:	01 d0                	add    %edx,%eax
  8014e0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8014e7:	01 c8                	add    %ecx,%eax
  8014e9:	c1 e0 02             	shl    $0x2,%eax
  8014ec:	01 d0                	add    %edx,%eax
  8014ee:	c1 e0 02             	shl    $0x2,%eax
  8014f1:	01 d0                	add    %edx,%eax
  8014f3:	c1 e0 03             	shl    $0x3,%eax
  8014f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014fb:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801500:	a1 20 40 80 00       	mov    0x804020,%eax
  801505:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 0f                	je     80151e <libmain+0x63>
		binaryname = myEnv->prog_name;
  80150f:	a1 20 40 80 00       	mov    0x804020,%eax
  801514:	05 18 da 01 00       	add    $0x1da18,%eax
  801519:	a3 10 40 80 00       	mov    %eax,0x804010

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80151e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801522:	7e 0a                	jle    80152e <libmain+0x73>
		binaryname = argv[0];
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	8b 00                	mov    (%eax),%eax
  801529:	a3 10 40 80 00       	mov    %eax,0x804010

	// call user main routine
	_main(argc, argv);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	ff 75 0c             	pushl  0xc(%ebp)
  801534:	ff 75 08             	pushl  0x8(%ebp)
  801537:	e8 fc ea ff ff       	call   800038 <_main>
  80153c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80153f:	e8 dd 12 00 00       	call   802821 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 98 34 80 00       	push   $0x803498
  80154c:	e8 6d 03 00 00       	call   8018be <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801554:	a1 20 40 80 00       	mov    0x804020,%eax
  801559:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80155f:	a1 20 40 80 00       	mov    0x804020,%eax
  801564:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	52                   	push   %edx
  80156e:	50                   	push   %eax
  80156f:	68 c0 34 80 00       	push   $0x8034c0
  801574:	e8 45 03 00 00       	call   8018be <cprintf>
  801579:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80157c:	a1 20 40 80 00       	mov    0x804020,%eax
  801581:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  801587:	a1 20 40 80 00       	mov    0x804020,%eax
  80158c:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  801592:	a1 20 40 80 00       	mov    0x804020,%eax
  801597:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80159d:	51                   	push   %ecx
  80159e:	52                   	push   %edx
  80159f:	50                   	push   %eax
  8015a0:	68 e8 34 80 00       	push   $0x8034e8
  8015a5:	e8 14 03 00 00       	call   8018be <cprintf>
  8015aa:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8015ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8015b2:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8015b8:	83 ec 08             	sub    $0x8,%esp
  8015bb:	50                   	push   %eax
  8015bc:	68 40 35 80 00       	push   $0x803540
  8015c1:	e8 f8 02 00 00       	call   8018be <cprintf>
  8015c6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8015c9:	83 ec 0c             	sub    $0xc,%esp
  8015cc:	68 98 34 80 00       	push   $0x803498
  8015d1:	e8 e8 02 00 00       	call   8018be <cprintf>
  8015d6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8015d9:	e8 5d 12 00 00       	call   80283b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8015de:	e8 19 00 00 00       	call   8015fc <exit>
}
  8015e3:	90                   	nop
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8015ec:	83 ec 0c             	sub    $0xc,%esp
  8015ef:	6a 00                	push   $0x0
  8015f1:	e8 ea 13 00 00       	call   8029e0 <sys_destroy_env>
  8015f6:	83 c4 10             	add    $0x10,%esp
}
  8015f9:	90                   	nop
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <exit>:

void
exit(void)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801602:	e8 3f 14 00 00       	call   802a46 <sys_exit_env>
}
  801607:	90                   	nop
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801610:	8d 45 10             	lea    0x10(%ebp),%eax
  801613:	83 c0 04             	add    $0x4,%eax
  801616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801619:	a1 14 82 83 00       	mov    0x838214,%eax
  80161e:	85 c0                	test   %eax,%eax
  801620:	74 16                	je     801638 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801622:	a1 14 82 83 00       	mov    0x838214,%eax
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	50                   	push   %eax
  80162b:	68 54 35 80 00       	push   $0x803554
  801630:	e8 89 02 00 00       	call   8018be <cprintf>
  801635:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801638:	a1 10 40 80 00       	mov    0x804010,%eax
  80163d:	ff 75 0c             	pushl  0xc(%ebp)
  801640:	ff 75 08             	pushl  0x8(%ebp)
  801643:	50                   	push   %eax
  801644:	68 59 35 80 00       	push   $0x803559
  801649:	e8 70 02 00 00       	call   8018be <cprintf>
  80164e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	ff 75 f4             	pushl  -0xc(%ebp)
  80165a:	50                   	push   %eax
  80165b:	e8 f3 01 00 00       	call   801853 <vcprintf>
  801660:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	6a 00                	push   $0x0
  801668:	68 75 35 80 00       	push   $0x803575
  80166d:	e8 e1 01 00 00       	call   801853 <vcprintf>
  801672:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801675:	e8 82 ff ff ff       	call   8015fc <exit>

	// should not return here
	while (1) ;
  80167a:	eb fe                	jmp    80167a <_panic+0x70>

0080167c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801682:	a1 20 40 80 00       	mov    0x804020,%eax
  801687:	8b 50 74             	mov    0x74(%eax),%edx
  80168a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168d:	39 c2                	cmp    %eax,%edx
  80168f:	74 14                	je     8016a5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	68 78 35 80 00       	push   $0x803578
  801699:	6a 26                	push   $0x26
  80169b:	68 c4 35 80 00       	push   $0x8035c4
  8016a0:	e8 65 ff ff ff       	call   80160a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8016a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8016ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016b3:	e9 c2 00 00 00       	jmp    80177a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8016b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	01 d0                	add    %edx,%eax
  8016c7:	8b 00                	mov    (%eax),%eax
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	75 08                	jne    8016d5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8016cd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016d0:	e9 a2 00 00 00       	jmp    801777 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8016d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016e3:	eb 69                	jmp    80174e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8016e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8016ea:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8016f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016f3:	89 d0                	mov    %edx,%eax
  8016f5:	01 c0                	add    %eax,%eax
  8016f7:	01 d0                	add    %edx,%eax
  8016f9:	c1 e0 03             	shl    $0x3,%eax
  8016fc:	01 c8                	add    %ecx,%eax
  8016fe:	8a 40 04             	mov    0x4(%eax),%al
  801701:	84 c0                	test   %al,%al
  801703:	75 46                	jne    80174b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801705:	a1 20 40 80 00       	mov    0x804020,%eax
  80170a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  801710:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801713:	89 d0                	mov    %edx,%eax
  801715:	01 c0                	add    %eax,%eax
  801717:	01 d0                	add    %edx,%eax
  801719:	c1 e0 03             	shl    $0x3,%eax
  80171c:	01 c8                	add    %ecx,%eax
  80171e:	8b 00                	mov    (%eax),%eax
  801720:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801723:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801726:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80172b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80172d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801730:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	01 c8                	add    %ecx,%eax
  80173c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80173e:	39 c2                	cmp    %eax,%edx
  801740:	75 09                	jne    80174b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801742:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801749:	eb 12                	jmp    80175d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80174b:	ff 45 e8             	incl   -0x18(%ebp)
  80174e:	a1 20 40 80 00       	mov    0x804020,%eax
  801753:	8b 50 74             	mov    0x74(%eax),%edx
  801756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801759:	39 c2                	cmp    %eax,%edx
  80175b:	77 88                	ja     8016e5 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80175d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801761:	75 14                	jne    801777 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	68 d0 35 80 00       	push   $0x8035d0
  80176b:	6a 3a                	push   $0x3a
  80176d:	68 c4 35 80 00       	push   $0x8035c4
  801772:	e8 93 fe ff ff       	call   80160a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801777:	ff 45 f0             	incl   -0x10(%ebp)
  80177a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801780:	0f 8c 32 ff ff ff    	jl     8016b8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801786:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80178d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801794:	eb 26                	jmp    8017bc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801796:	a1 20 40 80 00       	mov    0x804020,%eax
  80179b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8017a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017a4:	89 d0                	mov    %edx,%eax
  8017a6:	01 c0                	add    %eax,%eax
  8017a8:	01 d0                	add    %edx,%eax
  8017aa:	c1 e0 03             	shl    $0x3,%eax
  8017ad:	01 c8                	add    %ecx,%eax
  8017af:	8a 40 04             	mov    0x4(%eax),%al
  8017b2:	3c 01                	cmp    $0x1,%al
  8017b4:	75 03                	jne    8017b9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8017b6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017b9:	ff 45 e0             	incl   -0x20(%ebp)
  8017bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8017c1:	8b 50 74             	mov    0x74(%eax),%edx
  8017c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c7:	39 c2                	cmp    %eax,%edx
  8017c9:	77 cb                	ja     801796 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017d1:	74 14                	je     8017e7 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	68 24 36 80 00       	push   $0x803624
  8017db:	6a 44                	push   $0x44
  8017dd:	68 c4 35 80 00       	push   $0x8035c4
  8017e2:	e8 23 fe ff ff       	call   80160a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017e7:	90                   	nop
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8017f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f3:	8b 00                	mov    (%eax),%eax
  8017f5:	8d 48 01             	lea    0x1(%eax),%ecx
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	89 0a                	mov    %ecx,(%edx)
  8017fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801800:	88 d1                	mov    %dl,%cl
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801813:	75 2c                	jne    801841 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801815:	a0 24 40 80 00       	mov    0x804024,%al
  80181a:	0f b6 c0             	movzbl %al,%eax
  80181d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801820:	8b 12                	mov    (%edx),%edx
  801822:	89 d1                	mov    %edx,%ecx
  801824:	8b 55 0c             	mov    0xc(%ebp),%edx
  801827:	83 c2 08             	add    $0x8,%edx
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	50                   	push   %eax
  80182e:	51                   	push   %ecx
  80182f:	52                   	push   %edx
  801830:	e8 3e 0e 00 00       	call   802673 <sys_cputs>
  801835:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801841:	8b 45 0c             	mov    0xc(%ebp),%eax
  801844:	8b 40 04             	mov    0x4(%eax),%eax
  801847:	8d 50 01             	lea    0x1(%eax),%edx
  80184a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801850:	90                   	nop
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80185c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801863:	00 00 00 
	b.cnt = 0;
  801866:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80186d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	ff 75 08             	pushl  0x8(%ebp)
  801876:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80187c:	50                   	push   %eax
  80187d:	68 ea 17 80 00       	push   $0x8017ea
  801882:	e8 11 02 00 00       	call   801a98 <vprintfmt>
  801887:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80188a:	a0 24 40 80 00       	mov    0x804024,%al
  80188f:	0f b6 c0             	movzbl %al,%eax
  801892:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	50                   	push   %eax
  80189c:	52                   	push   %edx
  80189d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8018a3:	83 c0 08             	add    $0x8,%eax
  8018a6:	50                   	push   %eax
  8018a7:	e8 c7 0d 00 00       	call   802673 <sys_cputs>
  8018ac:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8018af:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8018b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <cprintf>:

int cprintf(const char *fmt, ...) {
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018c4:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8018cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	83 ec 08             	sub    $0x8,%esp
  8018d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018da:	50                   	push   %eax
  8018db:	e8 73 ff ff ff       	call   801853 <vcprintf>
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8018f1:	e8 2b 0f 00 00       	call   802821 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	83 ec 08             	sub    $0x8,%esp
  801902:	ff 75 f4             	pushl  -0xc(%ebp)
  801905:	50                   	push   %eax
  801906:	e8 48 ff ff ff       	call   801853 <vcprintf>
  80190b:	83 c4 10             	add    $0x10,%esp
  80190e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801911:	e8 25 0f 00 00       	call   80283b <sys_enable_interrupt>
	return cnt;
  801916:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	53                   	push   %ebx
  80191f:	83 ec 14             	sub    $0x14,%esp
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801928:	8b 45 14             	mov    0x14(%ebp),%eax
  80192b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80192e:	8b 45 18             	mov    0x18(%ebp),%eax
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801939:	77 55                	ja     801990 <printnum+0x75>
  80193b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80193e:	72 05                	jb     801945 <printnum+0x2a>
  801940:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801943:	77 4b                	ja     801990 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801945:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801948:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80194b:	8b 45 18             	mov    0x18(%ebp),%eax
  80194e:	ba 00 00 00 00       	mov    $0x0,%edx
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	ff 75 f4             	pushl  -0xc(%ebp)
  801958:	ff 75 f0             	pushl  -0x10(%ebp)
  80195b:	e8 fc 13 00 00       	call   802d5c <__udivdi3>
  801960:	83 c4 10             	add    $0x10,%esp
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	ff 75 20             	pushl  0x20(%ebp)
  801969:	53                   	push   %ebx
  80196a:	ff 75 18             	pushl  0x18(%ebp)
  80196d:	52                   	push   %edx
  80196e:	50                   	push   %eax
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	e8 a1 ff ff ff       	call   80191b <printnum>
  80197a:	83 c4 20             	add    $0x20,%esp
  80197d:	eb 1a                	jmp    801999 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80197f:	83 ec 08             	sub    $0x8,%esp
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	ff 75 20             	pushl  0x20(%ebp)
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	ff d0                	call   *%eax
  80198d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801990:	ff 4d 1c             	decl   0x1c(%ebp)
  801993:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801997:	7f e6                	jg     80197f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801999:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80199c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a7:	53                   	push   %ebx
  8019a8:	51                   	push   %ecx
  8019a9:	52                   	push   %edx
  8019aa:	50                   	push   %eax
  8019ab:	e8 bc 14 00 00       	call   802e6c <__umoddi3>
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	05 94 38 80 00       	add    $0x803894,%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	0f be c0             	movsbl %al,%eax
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	50                   	push   %eax
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	ff d0                	call   *%eax
  8019c9:	83 c4 10             	add    $0x10,%esp
}
  8019cc:	90                   	nop
  8019cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019d5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019d9:	7e 1c                	jle    8019f7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	8b 00                	mov    (%eax),%eax
  8019e0:	8d 50 08             	lea    0x8(%eax),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	89 10                	mov    %edx,(%eax)
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	83 e8 08             	sub    $0x8,%eax
  8019f0:	8b 50 04             	mov    0x4(%eax),%edx
  8019f3:	8b 00                	mov    (%eax),%eax
  8019f5:	eb 40                	jmp    801a37 <getuint+0x65>
	else if (lflag)
  8019f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019fb:	74 1e                	je     801a1b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 50 04             	lea    0x4(%eax),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 10                	mov    %edx,(%eax)
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8b 00                	mov    (%eax),%eax
  801a0f:	83 e8 04             	sub    $0x4,%eax
  801a12:	8b 00                	mov    (%eax),%eax
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx
  801a19:	eb 1c                	jmp    801a37 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	8b 00                	mov    (%eax),%eax
  801a20:	8d 50 04             	lea    0x4(%eax),%edx
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	89 10                	mov    %edx,(%eax)
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	83 e8 04             	sub    $0x4,%eax
  801a30:	8b 00                	mov    (%eax),%eax
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    

00801a39 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a3c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a40:	7e 1c                	jle    801a5e <getint+0x25>
		return va_arg(*ap, long long);
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	8d 50 08             	lea    0x8(%eax),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	89 10                	mov    %edx,(%eax)
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	83 e8 08             	sub    $0x8,%eax
  801a57:	8b 50 04             	mov    0x4(%eax),%edx
  801a5a:	8b 00                	mov    (%eax),%eax
  801a5c:	eb 38                	jmp    801a96 <getint+0x5d>
	else if (lflag)
  801a5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a62:	74 1a                	je     801a7e <getint+0x45>
		return va_arg(*ap, long);
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8b 00                	mov    (%eax),%eax
  801a69:	8d 50 04             	lea    0x4(%eax),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	89 10                	mov    %edx,(%eax)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8b 00                	mov    (%eax),%eax
  801a76:	83 e8 04             	sub    $0x4,%eax
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	99                   	cltd   
  801a7c:	eb 18                	jmp    801a96 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	8b 00                	mov    (%eax),%eax
  801a83:	8d 50 04             	lea    0x4(%eax),%edx
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	89 10                	mov    %edx,(%eax)
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	83 e8 04             	sub    $0x4,%eax
  801a93:	8b 00                	mov    (%eax),%eax
  801a95:	99                   	cltd   
}
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    

00801a98 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	56                   	push   %esi
  801a9c:	53                   	push   %ebx
  801a9d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801aa0:	eb 17                	jmp    801ab9 <vprintfmt+0x21>
			if (ch == '\0')
  801aa2:	85 db                	test   %ebx,%ebx
  801aa4:	0f 84 af 03 00 00    	je     801e59 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801aaa:	83 ec 08             	sub    $0x8,%esp
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	53                   	push   %ebx
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	ff d0                	call   *%eax
  801ab6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  801abc:	8d 50 01             	lea    0x1(%eax),%edx
  801abf:	89 55 10             	mov    %edx,0x10(%ebp)
  801ac2:	8a 00                	mov    (%eax),%al
  801ac4:	0f b6 d8             	movzbl %al,%ebx
  801ac7:	83 fb 25             	cmp    $0x25,%ebx
  801aca:	75 d6                	jne    801aa2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801acc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801ad0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801ad7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801ade:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ae5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aec:	8b 45 10             	mov    0x10(%ebp),%eax
  801aef:	8d 50 01             	lea    0x1(%eax),%edx
  801af2:	89 55 10             	mov    %edx,0x10(%ebp)
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	0f b6 d8             	movzbl %al,%ebx
  801afa:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801afd:	83 f8 55             	cmp    $0x55,%eax
  801b00:	0f 87 2b 03 00 00    	ja     801e31 <vprintfmt+0x399>
  801b06:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  801b0d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801b0f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b13:	eb d7                	jmp    801aec <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b15:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b19:	eb d1                	jmp    801aec <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b1b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b25:	89 d0                	mov    %edx,%eax
  801b27:	c1 e0 02             	shl    $0x2,%eax
  801b2a:	01 d0                	add    %edx,%eax
  801b2c:	01 c0                	add    %eax,%eax
  801b2e:	01 d8                	add    %ebx,%eax
  801b30:	83 e8 30             	sub    $0x30,%eax
  801b33:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b36:	8b 45 10             	mov    0x10(%ebp),%eax
  801b39:	8a 00                	mov    (%eax),%al
  801b3b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b3e:	83 fb 2f             	cmp    $0x2f,%ebx
  801b41:	7e 3e                	jle    801b81 <vprintfmt+0xe9>
  801b43:	83 fb 39             	cmp    $0x39,%ebx
  801b46:	7f 39                	jg     801b81 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b48:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b4b:	eb d5                	jmp    801b22 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b50:	83 c0 04             	add    $0x4,%eax
  801b53:	89 45 14             	mov    %eax,0x14(%ebp)
  801b56:	8b 45 14             	mov    0x14(%ebp),%eax
  801b59:	83 e8 04             	sub    $0x4,%eax
  801b5c:	8b 00                	mov    (%eax),%eax
  801b5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b61:	eb 1f                	jmp    801b82 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b67:	79 83                	jns    801aec <vprintfmt+0x54>
				width = 0;
  801b69:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b70:	e9 77 ff ff ff       	jmp    801aec <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b75:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b7c:	e9 6b ff ff ff       	jmp    801aec <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b81:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b86:	0f 89 60 ff ff ff    	jns    801aec <vprintfmt+0x54>
				width = precision, precision = -1;
  801b8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b92:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b99:	e9 4e ff ff ff       	jmp    801aec <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b9e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ba1:	e9 46 ff ff ff       	jmp    801aec <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801ba6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba9:	83 c0 04             	add    $0x4,%eax
  801bac:	89 45 14             	mov    %eax,0x14(%ebp)
  801baf:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb2:	83 e8 04             	sub    $0x4,%eax
  801bb5:	8b 00                	mov    (%eax),%eax
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	50                   	push   %eax
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	ff d0                	call   *%eax
  801bc3:	83 c4 10             	add    $0x10,%esp
			break;
  801bc6:	e9 89 02 00 00       	jmp    801e54 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bce:	83 c0 04             	add    $0x4,%eax
  801bd1:	89 45 14             	mov    %eax,0x14(%ebp)
  801bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd7:	83 e8 04             	sub    $0x4,%eax
  801bda:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801bdc:	85 db                	test   %ebx,%ebx
  801bde:	79 02                	jns    801be2 <vprintfmt+0x14a>
				err = -err;
  801be0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801be2:	83 fb 64             	cmp    $0x64,%ebx
  801be5:	7f 0b                	jg     801bf2 <vprintfmt+0x15a>
  801be7:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  801bee:	85 f6                	test   %esi,%esi
  801bf0:	75 19                	jne    801c0b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801bf2:	53                   	push   %ebx
  801bf3:	68 a5 38 80 00       	push   $0x8038a5
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	ff 75 08             	pushl  0x8(%ebp)
  801bfe:	e8 5e 02 00 00       	call   801e61 <printfmt>
  801c03:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801c06:	e9 49 02 00 00       	jmp    801e54 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801c0b:	56                   	push   %esi
  801c0c:	68 ae 38 80 00       	push   $0x8038ae
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	ff 75 08             	pushl  0x8(%ebp)
  801c17:	e8 45 02 00 00       	call   801e61 <printfmt>
  801c1c:	83 c4 10             	add    $0x10,%esp
			break;
  801c1f:	e9 30 02 00 00       	jmp    801e54 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c24:	8b 45 14             	mov    0x14(%ebp),%eax
  801c27:	83 c0 04             	add    $0x4,%eax
  801c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  801c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c30:	83 e8 04             	sub    $0x4,%eax
  801c33:	8b 30                	mov    (%eax),%esi
  801c35:	85 f6                	test   %esi,%esi
  801c37:	75 05                	jne    801c3e <vprintfmt+0x1a6>
				p = "(null)";
  801c39:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  801c3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c42:	7e 6d                	jle    801cb1 <vprintfmt+0x219>
  801c44:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c48:	74 67                	je     801cb1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4d:	83 ec 08             	sub    $0x8,%esp
  801c50:	50                   	push   %eax
  801c51:	56                   	push   %esi
  801c52:	e8 0c 03 00 00       	call   801f63 <strnlen>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c5d:	eb 16                	jmp    801c75 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c5f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c63:	83 ec 08             	sub    $0x8,%esp
  801c66:	ff 75 0c             	pushl  0xc(%ebp)
  801c69:	50                   	push   %eax
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	ff d0                	call   *%eax
  801c6f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c72:	ff 4d e4             	decl   -0x1c(%ebp)
  801c75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c79:	7f e4                	jg     801c5f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c7b:	eb 34                	jmp    801cb1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c81:	74 1c                	je     801c9f <vprintfmt+0x207>
  801c83:	83 fb 1f             	cmp    $0x1f,%ebx
  801c86:	7e 05                	jle    801c8d <vprintfmt+0x1f5>
  801c88:	83 fb 7e             	cmp    $0x7e,%ebx
  801c8b:	7e 12                	jle    801c9f <vprintfmt+0x207>
					putch('?', putdat);
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	ff 75 0c             	pushl  0xc(%ebp)
  801c93:	6a 3f                	push   $0x3f
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	ff d0                	call   *%eax
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	eb 0f                	jmp    801cae <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	53                   	push   %ebx
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	ff d0                	call   *%eax
  801cab:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cae:	ff 4d e4             	decl   -0x1c(%ebp)
  801cb1:	89 f0                	mov    %esi,%eax
  801cb3:	8d 70 01             	lea    0x1(%eax),%esi
  801cb6:	8a 00                	mov    (%eax),%al
  801cb8:	0f be d8             	movsbl %al,%ebx
  801cbb:	85 db                	test   %ebx,%ebx
  801cbd:	74 24                	je     801ce3 <vprintfmt+0x24b>
  801cbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cc3:	78 b8                	js     801c7d <vprintfmt+0x1e5>
  801cc5:	ff 4d e0             	decl   -0x20(%ebp)
  801cc8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ccc:	79 af                	jns    801c7d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cce:	eb 13                	jmp    801ce3 <vprintfmt+0x24b>
				putch(' ', putdat);
  801cd0:	83 ec 08             	sub    $0x8,%esp
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	6a 20                	push   $0x20
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	ff d0                	call   *%eax
  801cdd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ce0:	ff 4d e4             	decl   -0x1c(%ebp)
  801ce3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ce7:	7f e7                	jg     801cd0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ce9:	e9 66 01 00 00       	jmp    801e54 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801cee:	83 ec 08             	sub    $0x8,%esp
  801cf1:	ff 75 e8             	pushl  -0x18(%ebp)
  801cf4:	8d 45 14             	lea    0x14(%ebp),%eax
  801cf7:	50                   	push   %eax
  801cf8:	e8 3c fd ff ff       	call   801a39 <getint>
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0c:	85 d2                	test   %edx,%edx
  801d0e:	79 23                	jns    801d33 <vprintfmt+0x29b>
				putch('-', putdat);
  801d10:	83 ec 08             	sub    $0x8,%esp
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	6a 2d                	push   $0x2d
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	ff d0                	call   *%eax
  801d1d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d26:	f7 d8                	neg    %eax
  801d28:	83 d2 00             	adc    $0x0,%edx
  801d2b:	f7 da                	neg    %edx
  801d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d3a:	e9 bc 00 00 00       	jmp    801dfb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d3f:	83 ec 08             	sub    $0x8,%esp
  801d42:	ff 75 e8             	pushl  -0x18(%ebp)
  801d45:	8d 45 14             	lea    0x14(%ebp),%eax
  801d48:	50                   	push   %eax
  801d49:	e8 84 fc ff ff       	call   8019d2 <getuint>
  801d4e:	83 c4 10             	add    $0x10,%esp
  801d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d54:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d57:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d5e:	e9 98 00 00 00       	jmp    801dfb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d63:	83 ec 08             	sub    $0x8,%esp
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	6a 58                	push   $0x58
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	ff d0                	call   *%eax
  801d70:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d73:	83 ec 08             	sub    $0x8,%esp
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	6a 58                	push   $0x58
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	ff d0                	call   *%eax
  801d80:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d83:	83 ec 08             	sub    $0x8,%esp
  801d86:	ff 75 0c             	pushl  0xc(%ebp)
  801d89:	6a 58                	push   $0x58
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	ff d0                	call   *%eax
  801d90:	83 c4 10             	add    $0x10,%esp
			break;
  801d93:	e9 bc 00 00 00       	jmp    801e54 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801d98:	83 ec 08             	sub    $0x8,%esp
  801d9b:	ff 75 0c             	pushl  0xc(%ebp)
  801d9e:	6a 30                	push   $0x30
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	ff d0                	call   *%eax
  801da5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801da8:	83 ec 08             	sub    $0x8,%esp
  801dab:	ff 75 0c             	pushl  0xc(%ebp)
  801dae:	6a 78                	push   $0x78
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	ff d0                	call   *%eax
  801db5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	83 c0 04             	add    $0x4,%eax
  801dbe:	89 45 14             	mov    %eax,0x14(%ebp)
  801dc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc4:	83 e8 04             	sub    $0x4,%eax
  801dc7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801dd3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801dda:	eb 1f                	jmp    801dfb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801ddc:	83 ec 08             	sub    $0x8,%esp
  801ddf:	ff 75 e8             	pushl  -0x18(%ebp)
  801de2:	8d 45 14             	lea    0x14(%ebp),%eax
  801de5:	50                   	push   %eax
  801de6:	e8 e7 fb ff ff       	call   8019d2 <getuint>
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801df1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801df4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801dfb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801dff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e02:	83 ec 04             	sub    $0x4,%esp
  801e05:	52                   	push   %edx
  801e06:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e09:	50                   	push   %eax
  801e0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e10:	ff 75 0c             	pushl  0xc(%ebp)
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	e8 00 fb ff ff       	call   80191b <printnum>
  801e1b:	83 c4 20             	add    $0x20,%esp
			break;
  801e1e:	eb 34                	jmp    801e54 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e20:	83 ec 08             	sub    $0x8,%esp
  801e23:	ff 75 0c             	pushl  0xc(%ebp)
  801e26:	53                   	push   %ebx
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	ff d0                	call   *%eax
  801e2c:	83 c4 10             	add    $0x10,%esp
			break;
  801e2f:	eb 23                	jmp    801e54 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e31:	83 ec 08             	sub    $0x8,%esp
  801e34:	ff 75 0c             	pushl  0xc(%ebp)
  801e37:	6a 25                	push   $0x25
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	ff d0                	call   *%eax
  801e3e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e41:	ff 4d 10             	decl   0x10(%ebp)
  801e44:	eb 03                	jmp    801e49 <vprintfmt+0x3b1>
  801e46:	ff 4d 10             	decl   0x10(%ebp)
  801e49:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4c:	48                   	dec    %eax
  801e4d:	8a 00                	mov    (%eax),%al
  801e4f:	3c 25                	cmp    $0x25,%al
  801e51:	75 f3                	jne    801e46 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801e53:	90                   	nop
		}
	}
  801e54:	e9 47 fc ff ff       	jmp    801aa0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e59:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5d:	5b                   	pop    %ebx
  801e5e:	5e                   	pop    %esi
  801e5f:	5d                   	pop    %ebp
  801e60:	c3                   	ret    

00801e61 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e67:	8d 45 10             	lea    0x10(%ebp),%eax
  801e6a:	83 c0 04             	add    $0x4,%eax
  801e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e70:	8b 45 10             	mov    0x10(%ebp),%eax
  801e73:	ff 75 f4             	pushl  -0xc(%ebp)
  801e76:	50                   	push   %eax
  801e77:	ff 75 0c             	pushl  0xc(%ebp)
  801e7a:	ff 75 08             	pushl  0x8(%ebp)
  801e7d:	e8 16 fc ff ff       	call   801a98 <vprintfmt>
  801e82:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e85:	90                   	nop
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8e:	8b 40 08             	mov    0x8(%eax),%eax
  801e91:	8d 50 01             	lea    0x1(%eax),%edx
  801e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e97:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9d:	8b 10                	mov    (%eax),%edx
  801e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea2:	8b 40 04             	mov    0x4(%eax),%eax
  801ea5:	39 c2                	cmp    %eax,%edx
  801ea7:	73 12                	jae    801ebb <sprintputch+0x33>
		*b->buf++ = ch;
  801ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eac:	8b 00                	mov    (%eax),%eax
  801eae:	8d 48 01             	lea    0x1(%eax),%ecx
  801eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb4:	89 0a                	mov    %ecx,(%edx)
  801eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb9:	88 10                	mov    %dl,(%eax)
}
  801ebb:	90                   	nop
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	01 d0                	add    %edx,%eax
  801ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ed8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801edf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ee3:	74 06                	je     801eeb <vsnprintf+0x2d>
  801ee5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ee9:	7f 07                	jg     801ef2 <vsnprintf+0x34>
		return -E_INVAL;
  801eeb:	b8 03 00 00 00       	mov    $0x3,%eax
  801ef0:	eb 20                	jmp    801f12 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ef2:	ff 75 14             	pushl  0x14(%ebp)
  801ef5:	ff 75 10             	pushl  0x10(%ebp)
  801ef8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801efb:	50                   	push   %eax
  801efc:	68 88 1e 80 00       	push   $0x801e88
  801f01:	e8 92 fb ff ff       	call   801a98 <vprintfmt>
  801f06:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f1a:	8d 45 10             	lea    0x10(%ebp),%eax
  801f1d:	83 c0 04             	add    $0x4,%eax
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f23:	8b 45 10             	mov    0x10(%ebp),%eax
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	50                   	push   %eax
  801f2a:	ff 75 0c             	pushl  0xc(%ebp)
  801f2d:	ff 75 08             	pushl  0x8(%ebp)
  801f30:	e8 89 ff ff ff       	call   801ebe <vsnprintf>
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f4d:	eb 06                	jmp    801f55 <strlen+0x15>
		n++;
  801f4f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f52:	ff 45 08             	incl   0x8(%ebp)
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8a 00                	mov    (%eax),%al
  801f5a:	84 c0                	test   %al,%al
  801f5c:	75 f1                	jne    801f4f <strlen+0xf>
		n++;
	return n;
  801f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f70:	eb 09                	jmp    801f7b <strnlen+0x18>
		n++;
  801f72:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f75:	ff 45 08             	incl   0x8(%ebp)
  801f78:	ff 4d 0c             	decl   0xc(%ebp)
  801f7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f7f:	74 09                	je     801f8a <strnlen+0x27>
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	8a 00                	mov    (%eax),%al
  801f86:	84 c0                	test   %al,%al
  801f88:	75 e8                	jne    801f72 <strnlen+0xf>
		n++;
	return n;
  801f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f9b:	90                   	nop
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	8d 50 01             	lea    0x1(%eax),%edx
  801fa2:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fae:	8a 12                	mov    (%edx),%dl
  801fb0:	88 10                	mov    %dl,(%eax)
  801fb2:	8a 00                	mov    (%eax),%al
  801fb4:	84 c0                	test   %al,%al
  801fb6:	75 e4                	jne    801f9c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801fc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fd0:	eb 1f                	jmp    801ff1 <strncpy+0x34>
		*dst++ = *src;
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	8d 50 01             	lea    0x1(%eax),%edx
  801fd8:	89 55 08             	mov    %edx,0x8(%ebp)
  801fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fde:	8a 12                	mov    (%edx),%dl
  801fe0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe5:	8a 00                	mov    (%eax),%al
  801fe7:	84 c0                	test   %al,%al
  801fe9:	74 03                	je     801fee <strncpy+0x31>
			src++;
  801feb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fee:	ff 45 fc             	incl   -0x4(%ebp)
  801ff1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff4:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ff7:	72 d9                	jb     801fd2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80200a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80200e:	74 30                	je     802040 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802010:	eb 16                	jmp    802028 <strlcpy+0x2a>
			*dst++ = *src++;
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	8d 50 01             	lea    0x1(%eax),%edx
  802018:	89 55 08             	mov    %edx,0x8(%ebp)
  80201b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802021:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802024:	8a 12                	mov    (%edx),%dl
  802026:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802028:	ff 4d 10             	decl   0x10(%ebp)
  80202b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80202f:	74 09                	je     80203a <strlcpy+0x3c>
  802031:	8b 45 0c             	mov    0xc(%ebp),%eax
  802034:	8a 00                	mov    (%eax),%al
  802036:	84 c0                	test   %al,%al
  802038:	75 d8                	jne    802012 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802040:	8b 55 08             	mov    0x8(%ebp),%edx
  802043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802046:	29 c2                	sub    %eax,%edx
  802048:	89 d0                	mov    %edx,%eax
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80204f:	eb 06                	jmp    802057 <strcmp+0xb>
		p++, q++;
  802051:	ff 45 08             	incl   0x8(%ebp)
  802054:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	84 c0                	test   %al,%al
  80205e:	74 0e                	je     80206e <strcmp+0x22>
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	8a 10                	mov    (%eax),%dl
  802065:	8b 45 0c             	mov    0xc(%ebp),%eax
  802068:	8a 00                	mov    (%eax),%al
  80206a:	38 c2                	cmp    %al,%dl
  80206c:	74 e3                	je     802051 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	8a 00                	mov    (%eax),%al
  802073:	0f b6 d0             	movzbl %al,%edx
  802076:	8b 45 0c             	mov    0xc(%ebp),%eax
  802079:	8a 00                	mov    (%eax),%al
  80207b:	0f b6 c0             	movzbl %al,%eax
  80207e:	29 c2                	sub    %eax,%edx
  802080:	89 d0                	mov    %edx,%eax
}
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802087:	eb 09                	jmp    802092 <strncmp+0xe>
		n--, p++, q++;
  802089:	ff 4d 10             	decl   0x10(%ebp)
  80208c:	ff 45 08             	incl   0x8(%ebp)
  80208f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802092:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802096:	74 17                	je     8020af <strncmp+0x2b>
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	8a 00                	mov    (%eax),%al
  80209d:	84 c0                	test   %al,%al
  80209f:	74 0e                	je     8020af <strncmp+0x2b>
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	8a 10                	mov    (%eax),%dl
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	8a 00                	mov    (%eax),%al
  8020ab:	38 c2                	cmp    %al,%dl
  8020ad:	74 da                	je     802089 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8020af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b3:	75 07                	jne    8020bc <strncmp+0x38>
		return 0;
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ba:	eb 14                	jmp    8020d0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8a 00                	mov    (%eax),%al
  8020c1:	0f b6 d0             	movzbl %al,%edx
  8020c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c7:	8a 00                	mov    (%eax),%al
  8020c9:	0f b6 c0             	movzbl %al,%eax
  8020cc:	29 c2                	sub    %eax,%edx
  8020ce:	89 d0                	mov    %edx,%eax
}
  8020d0:	5d                   	pop    %ebp
  8020d1:	c3                   	ret    

008020d2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020db:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020de:	eb 12                	jmp    8020f2 <strchr+0x20>
		if (*s == c)
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	8a 00                	mov    (%eax),%al
  8020e5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020e8:	75 05                	jne    8020ef <strchr+0x1d>
			return (char *) s;
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	eb 11                	jmp    802100 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020ef:	ff 45 08             	incl   0x8(%ebp)
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	8a 00                	mov    (%eax),%al
  8020f7:	84 c0                	test   %al,%al
  8020f9:	75 e5                	jne    8020e0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80210e:	eb 0d                	jmp    80211d <strfind+0x1b>
		if (*s == c)
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8a 00                	mov    (%eax),%al
  802115:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802118:	74 0e                	je     802128 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80211a:	ff 45 08             	incl   0x8(%ebp)
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	8a 00                	mov    (%eax),%al
  802122:	84 c0                	test   %al,%al
  802124:	75 ea                	jne    802110 <strfind+0xe>
  802126:	eb 01                	jmp    802129 <strfind+0x27>
		if (*s == c)
			break;
  802128:	90                   	nop
	return (char *) s;
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80213a:	8b 45 10             	mov    0x10(%ebp),%eax
  80213d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802140:	eb 0e                	jmp    802150 <memset+0x22>
		*p++ = c;
  802142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802145:	8d 50 01             	lea    0x1(%eax),%edx
  802148:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80214b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802150:	ff 4d f8             	decl   -0x8(%ebp)
  802153:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802157:	79 e9                	jns    802142 <memset+0x14>
		*p++ = c;

	return v;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802164:	8b 45 0c             	mov    0xc(%ebp),%eax
  802167:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802170:	eb 16                	jmp    802188 <memcpy+0x2a>
		*d++ = *s++;
  802172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802175:	8d 50 01             	lea    0x1(%eax),%edx
  802178:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80217b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802181:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802184:	8a 12                	mov    (%edx),%dl
  802186:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  802188:	8b 45 10             	mov    0x10(%ebp),%eax
  80218b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80218e:	89 55 10             	mov    %edx,0x10(%ebp)
  802191:	85 c0                	test   %eax,%eax
  802193:	75 dd                	jne    802172 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8021a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8021ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021b2:	73 50                	jae    802204 <memmove+0x6a>
  8021b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ba:	01 d0                	add    %edx,%eax
  8021bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021bf:	76 43                	jbe    802204 <memmove+0x6a>
		s += n;
  8021c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8021c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ca:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021cd:	eb 10                	jmp    8021df <memmove+0x45>
			*--d = *--s;
  8021cf:	ff 4d f8             	decl   -0x8(%ebp)
  8021d2:	ff 4d fc             	decl   -0x4(%ebp)
  8021d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d8:	8a 10                	mov    (%eax),%dl
  8021da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021dd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8021df:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	75 e3                	jne    8021cf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8021ec:	eb 23                	jmp    802211 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8021ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f1:	8d 50 01             	lea    0x1(%eax),%edx
  8021f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802200:	8a 12                	mov    (%edx),%dl
  802202:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802204:	8b 45 10             	mov    0x10(%ebp),%eax
  802207:	8d 50 ff             	lea    -0x1(%eax),%edx
  80220a:	89 55 10             	mov    %edx,0x10(%ebp)
  80220d:	85 c0                	test   %eax,%eax
  80220f:	75 dd                	jne    8021ee <memmove+0x54>
			*d++ = *s++;

	return dst;
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802228:	eb 2a                	jmp    802254 <memcmp+0x3e>
		if (*s1 != *s2)
  80222a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222d:	8a 10                	mov    (%eax),%dl
  80222f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802232:	8a 00                	mov    (%eax),%al
  802234:	38 c2                	cmp    %al,%dl
  802236:	74 16                	je     80224e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802238:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80223b:	8a 00                	mov    (%eax),%al
  80223d:	0f b6 d0             	movzbl %al,%edx
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8a 00                	mov    (%eax),%al
  802245:	0f b6 c0             	movzbl %al,%eax
  802248:	29 c2                	sub    %eax,%edx
  80224a:	89 d0                	mov    %edx,%eax
  80224c:	eb 18                	jmp    802266 <memcmp+0x50>
		s1++, s2++;
  80224e:	ff 45 fc             	incl   -0x4(%ebp)
  802251:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802254:	8b 45 10             	mov    0x10(%ebp),%eax
  802257:	8d 50 ff             	lea    -0x1(%eax),%edx
  80225a:	89 55 10             	mov    %edx,0x10(%ebp)
  80225d:	85 c0                	test   %eax,%eax
  80225f:	75 c9                	jne    80222a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802261:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
  802271:	8b 45 10             	mov    0x10(%ebp),%eax
  802274:	01 d0                	add    %edx,%eax
  802276:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802279:	eb 15                	jmp    802290 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	8a 00                	mov    (%eax),%al
  802280:	0f b6 d0             	movzbl %al,%edx
  802283:	8b 45 0c             	mov    0xc(%ebp),%eax
  802286:	0f b6 c0             	movzbl %al,%eax
  802289:	39 c2                	cmp    %eax,%edx
  80228b:	74 0d                	je     80229a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80228d:	ff 45 08             	incl   0x8(%ebp)
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802296:	72 e3                	jb     80227b <memfind+0x13>
  802298:	eb 01                	jmp    80229b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80229a:	90                   	nop
	return (void *) s;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8022a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8022ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022b4:	eb 03                	jmp    8022b9 <strtol+0x19>
		s++;
  8022b6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	8a 00                	mov    (%eax),%al
  8022be:	3c 20                	cmp    $0x20,%al
  8022c0:	74 f4                	je     8022b6 <strtol+0x16>
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	8a 00                	mov    (%eax),%al
  8022c7:	3c 09                	cmp    $0x9,%al
  8022c9:	74 eb                	je     8022b6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	8a 00                	mov    (%eax),%al
  8022d0:	3c 2b                	cmp    $0x2b,%al
  8022d2:	75 05                	jne    8022d9 <strtol+0x39>
		s++;
  8022d4:	ff 45 08             	incl   0x8(%ebp)
  8022d7:	eb 13                	jmp    8022ec <strtol+0x4c>
	else if (*s == '-')
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	8a 00                	mov    (%eax),%al
  8022de:	3c 2d                	cmp    $0x2d,%al
  8022e0:	75 0a                	jne    8022ec <strtol+0x4c>
		s++, neg = 1;
  8022e2:	ff 45 08             	incl   0x8(%ebp)
  8022e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022f0:	74 06                	je     8022f8 <strtol+0x58>
  8022f2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8022f6:	75 20                	jne    802318 <strtol+0x78>
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	8a 00                	mov    (%eax),%al
  8022fd:	3c 30                	cmp    $0x30,%al
  8022ff:	75 17                	jne    802318 <strtol+0x78>
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	40                   	inc    %eax
  802305:	8a 00                	mov    (%eax),%al
  802307:	3c 78                	cmp    $0x78,%al
  802309:	75 0d                	jne    802318 <strtol+0x78>
		s += 2, base = 16;
  80230b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80230f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802316:	eb 28                	jmp    802340 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80231c:	75 15                	jne    802333 <strtol+0x93>
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8a 00                	mov    (%eax),%al
  802323:	3c 30                	cmp    $0x30,%al
  802325:	75 0c                	jne    802333 <strtol+0x93>
		s++, base = 8;
  802327:	ff 45 08             	incl   0x8(%ebp)
  80232a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802331:	eb 0d                	jmp    802340 <strtol+0xa0>
	else if (base == 0)
  802333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802337:	75 07                	jne    802340 <strtol+0xa0>
		base = 10;
  802339:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	8a 00                	mov    (%eax),%al
  802345:	3c 2f                	cmp    $0x2f,%al
  802347:	7e 19                	jle    802362 <strtol+0xc2>
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8a 00                	mov    (%eax),%al
  80234e:	3c 39                	cmp    $0x39,%al
  802350:	7f 10                	jg     802362 <strtol+0xc2>
			dig = *s - '0';
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	8a 00                	mov    (%eax),%al
  802357:	0f be c0             	movsbl %al,%eax
  80235a:	83 e8 30             	sub    $0x30,%eax
  80235d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802360:	eb 42                	jmp    8023a4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8a 00                	mov    (%eax),%al
  802367:	3c 60                	cmp    $0x60,%al
  802369:	7e 19                	jle    802384 <strtol+0xe4>
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	8a 00                	mov    (%eax),%al
  802370:	3c 7a                	cmp    $0x7a,%al
  802372:	7f 10                	jg     802384 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8a 00                	mov    (%eax),%al
  802379:	0f be c0             	movsbl %al,%eax
  80237c:	83 e8 57             	sub    $0x57,%eax
  80237f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802382:	eb 20                	jmp    8023a4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	8a 00                	mov    (%eax),%al
  802389:	3c 40                	cmp    $0x40,%al
  80238b:	7e 39                	jle    8023c6 <strtol+0x126>
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	8a 00                	mov    (%eax),%al
  802392:	3c 5a                	cmp    $0x5a,%al
  802394:	7f 30                	jg     8023c6 <strtol+0x126>
			dig = *s - 'A' + 10;
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	8a 00                	mov    (%eax),%al
  80239b:	0f be c0             	movsbl %al,%eax
  80239e:	83 e8 37             	sub    $0x37,%eax
  8023a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8023aa:	7d 19                	jge    8023c5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8023ac:	ff 45 08             	incl   0x8(%ebp)
  8023af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023b2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8023b6:	89 c2                	mov    %eax,%edx
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	01 d0                	add    %edx,%eax
  8023bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8023c0:	e9 7b ff ff ff       	jmp    802340 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8023c5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8023c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023ca:	74 08                	je     8023d4 <strtol+0x134>
		*endptr = (char *) s;
  8023cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8023d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023d8:	74 07                	je     8023e1 <strtol+0x141>
  8023da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023dd:	f7 d8                	neg    %eax
  8023df:	eb 03                	jmp    8023e4 <strtol+0x144>
  8023e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <ltostr>:

void
ltostr(long value, char *str)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8023ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8023f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8023fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023fe:	79 13                	jns    802413 <ltostr+0x2d>
	{
		neg = 1;
  802400:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80240d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802410:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80241b:	99                   	cltd   
  80241c:	f7 f9                	idiv   %ecx
  80241e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802421:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802424:	8d 50 01             	lea    0x1(%eax),%edx
  802427:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80242a:	89 c2                	mov    %eax,%edx
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	01 d0                	add    %edx,%eax
  802431:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802434:	83 c2 30             	add    $0x30,%edx
  802437:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802439:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802441:	f7 e9                	imul   %ecx
  802443:	c1 fa 02             	sar    $0x2,%edx
  802446:	89 c8                	mov    %ecx,%eax
  802448:	c1 f8 1f             	sar    $0x1f,%eax
  80244b:	29 c2                	sub    %eax,%edx
  80244d:	89 d0                	mov    %edx,%eax
  80244f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802452:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802455:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80245a:	f7 e9                	imul   %ecx
  80245c:	c1 fa 02             	sar    $0x2,%edx
  80245f:	89 c8                	mov    %ecx,%eax
  802461:	c1 f8 1f             	sar    $0x1f,%eax
  802464:	29 c2                	sub    %eax,%edx
  802466:	89 d0                	mov    %edx,%eax
  802468:	c1 e0 02             	shl    $0x2,%eax
  80246b:	01 d0                	add    %edx,%eax
  80246d:	01 c0                	add    %eax,%eax
  80246f:	29 c1                	sub    %eax,%ecx
  802471:	89 ca                	mov    %ecx,%edx
  802473:	85 d2                	test   %edx,%edx
  802475:	75 9c                	jne    802413 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802477:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80247e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802481:	48                   	dec    %eax
  802482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802485:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802489:	74 3d                	je     8024c8 <ltostr+0xe2>
		start = 1 ;
  80248b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802492:	eb 34                	jmp    8024c8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802494:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249a:	01 d0                	add    %edx,%eax
  80249c:	8a 00                	mov    (%eax),%al
  80249e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8024a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a7:	01 c2                	add    %eax,%edx
  8024a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8024ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024af:	01 c8                	add    %ecx,%eax
  8024b1:	8a 00                	mov    (%eax),%al
  8024b3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8024b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bb:	01 c2                	add    %eax,%edx
  8024bd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8024c0:	88 02                	mov    %al,(%edx)
		start++ ;
  8024c2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8024c5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024ce:	7c c4                	jl     802494 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8024d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8024d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d6:	01 d0                	add    %edx,%eax
  8024d8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8024db:	90                   	nop
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8024e4:	ff 75 08             	pushl  0x8(%ebp)
  8024e7:	e8 54 fa ff ff       	call   801f40 <strlen>
  8024ec:	83 c4 04             	add    $0x4,%esp
  8024ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8024f2:	ff 75 0c             	pushl  0xc(%ebp)
  8024f5:	e8 46 fa ff ff       	call   801f40 <strlen>
  8024fa:	83 c4 04             	add    $0x4,%esp
  8024fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80250e:	eb 17                	jmp    802527 <strcconcat+0x49>
		final[s] = str1[s] ;
  802510:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802513:	8b 45 10             	mov    0x10(%ebp),%eax
  802516:	01 c2                	add    %eax,%edx
  802518:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	01 c8                	add    %ecx,%eax
  802520:	8a 00                	mov    (%eax),%al
  802522:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802524:	ff 45 fc             	incl   -0x4(%ebp)
  802527:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80252d:	7c e1                	jl     802510 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80252f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802536:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80253d:	eb 1f                	jmp    80255e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80253f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802542:	8d 50 01             	lea    0x1(%eax),%edx
  802545:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802548:	89 c2                	mov    %eax,%edx
  80254a:	8b 45 10             	mov    0x10(%ebp),%eax
  80254d:	01 c2                	add    %eax,%edx
  80254f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802552:	8b 45 0c             	mov    0xc(%ebp),%eax
  802555:	01 c8                	add    %ecx,%eax
  802557:	8a 00                	mov    (%eax),%al
  802559:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80255b:	ff 45 f8             	incl   -0x8(%ebp)
  80255e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802561:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802564:	7c d9                	jl     80253f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802566:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802569:	8b 45 10             	mov    0x10(%ebp),%eax
  80256c:	01 d0                	add    %edx,%eax
  80256e:	c6 00 00             	movb   $0x0,(%eax)
}
  802571:	90                   	nop
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802577:	8b 45 14             	mov    0x14(%ebp),%eax
  80257a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802580:	8b 45 14             	mov    0x14(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80258c:	8b 45 10             	mov    0x10(%ebp),%eax
  80258f:	01 d0                	add    %edx,%eax
  802591:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802597:	eb 0c                	jmp    8025a5 <strsplit+0x31>
			*string++ = 0;
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	8d 50 01             	lea    0x1(%eax),%edx
  80259f:	89 55 08             	mov    %edx,0x8(%ebp)
  8025a2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	8a 00                	mov    (%eax),%al
  8025aa:	84 c0                	test   %al,%al
  8025ac:	74 18                	je     8025c6 <strsplit+0x52>
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	8a 00                	mov    (%eax),%al
  8025b3:	0f be c0             	movsbl %al,%eax
  8025b6:	50                   	push   %eax
  8025b7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ba:	e8 13 fb ff ff       	call   8020d2 <strchr>
  8025bf:	83 c4 08             	add    $0x8,%esp
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	75 d3                	jne    802599 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	8a 00                	mov    (%eax),%al
  8025cb:	84 c0                	test   %al,%al
  8025cd:	74 5a                	je     802629 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8025cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	83 f8 0f             	cmp    $0xf,%eax
  8025d7:	75 07                	jne    8025e0 <strsplit+0x6c>
		{
			return 0;
  8025d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025de:	eb 66                	jmp    802646 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8025e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8025e8:	8b 55 14             	mov    0x14(%ebp),%edx
  8025eb:	89 0a                	mov    %ecx,(%edx)
  8025ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f7:	01 c2                	add    %eax,%edx
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025fe:	eb 03                	jmp    802603 <strsplit+0x8f>
			string++;
  802600:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	8a 00                	mov    (%eax),%al
  802608:	84 c0                	test   %al,%al
  80260a:	74 8b                	je     802597 <strsplit+0x23>
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	8a 00                	mov    (%eax),%al
  802611:	0f be c0             	movsbl %al,%eax
  802614:	50                   	push   %eax
  802615:	ff 75 0c             	pushl  0xc(%ebp)
  802618:	e8 b5 fa ff ff       	call   8020d2 <strchr>
  80261d:	83 c4 08             	add    $0x8,%esp
  802620:	85 c0                	test   %eax,%eax
  802622:	74 dc                	je     802600 <strsplit+0x8c>
			string++;
	}
  802624:	e9 6e ff ff ff       	jmp    802597 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802629:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80262a:	8b 45 14             	mov    0x14(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802636:	8b 45 10             	mov    0x10(%ebp),%eax
  802639:	01 d0                	add    %edx,%eax
  80263b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802641:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	57                   	push   %edi
  80264c:	56                   	push   %esi
  80264d:	53                   	push   %ebx
  80264e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	8b 55 0c             	mov    0xc(%ebp),%edx
  802657:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80265a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80265d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802660:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802663:	cd 30                	int    $0x30
  802665:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802668:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	5b                   	pop    %ebx
  80266f:	5e                   	pop    %esi
  802670:	5f                   	pop    %edi
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    

00802673 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 04             	sub    $0x4,%esp
  802679:	8b 45 10             	mov    0x10(%ebp),%eax
  80267c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80267f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	52                   	push   %edx
  80268b:	ff 75 0c             	pushl  0xc(%ebp)
  80268e:	50                   	push   %eax
  80268f:	6a 00                	push   $0x0
  802691:	e8 b2 ff ff ff       	call   802648 <syscall>
  802696:	83 c4 18             	add    $0x18,%esp
}
  802699:	90                   	nop
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <sys_cgetc>:

int
sys_cgetc(void)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 01                	push   $0x1
  8026ab:	e8 98 ff ff ff       	call   802648 <syscall>
  8026b0:	83 c4 18             	add    $0x18,%esp
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	52                   	push   %edx
  8026c5:	50                   	push   %eax
  8026c6:	6a 05                	push   $0x5
  8026c8:	e8 7b ff ff ff       	call   802648 <syscall>
  8026cd:	83 c4 18             	add    $0x18,%esp
}
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    

008026d2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	56                   	push   %esi
  8026d6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8026da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	56                   	push   %esi
  8026e7:	53                   	push   %ebx
  8026e8:	51                   	push   %ecx
  8026e9:	52                   	push   %edx
  8026ea:	50                   	push   %eax
  8026eb:	6a 06                	push   $0x6
  8026ed:	e8 56 ff ff ff       	call   802648 <syscall>
  8026f2:	83 c4 18             	add    $0x18,%esp
}
  8026f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026f8:	5b                   	pop    %ebx
  8026f9:	5e                   	pop    %esi
  8026fa:	5d                   	pop    %ebp
  8026fb:	c3                   	ret    

008026fc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8026ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	52                   	push   %edx
  80270c:	50                   	push   %eax
  80270d:	6a 07                	push   $0x7
  80270f:	e8 34 ff ff ff       	call   802648 <syscall>
  802714:	83 c4 18             	add    $0x18,%esp
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	ff 75 0c             	pushl  0xc(%ebp)
  802725:	ff 75 08             	pushl  0x8(%ebp)
  802728:	6a 08                	push   $0x8
  80272a:	e8 19 ff ff ff       	call   802648 <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 09                	push   $0x9
  802743:	e8 00 ff ff ff       	call   802648 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 0a                	push   $0xa
  80275c:	e8 e7 fe ff ff       	call   802648 <syscall>
  802761:	83 c4 18             	add    $0x18,%esp
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 0b                	push   $0xb
  802775:	e8 ce fe ff ff       	call   802648 <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
}
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    

0080277f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	ff 75 0c             	pushl  0xc(%ebp)
  80278b:	ff 75 08             	pushl  0x8(%ebp)
  80278e:	6a 0f                	push   $0xf
  802790:	e8 b3 fe ff ff       	call   802648 <syscall>
  802795:	83 c4 18             	add    $0x18,%esp
	return;
  802798:	90                   	nop
}
  802799:	c9                   	leave  
  80279a:	c3                   	ret    

0080279b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	ff 75 0c             	pushl  0xc(%ebp)
  8027a7:	ff 75 08             	pushl  0x8(%ebp)
  8027aa:	6a 10                	push   $0x10
  8027ac:	e8 97 fe ff ff       	call   802648 <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027b4:	90                   	nop
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	ff 75 10             	pushl  0x10(%ebp)
  8027c1:	ff 75 0c             	pushl  0xc(%ebp)
  8027c4:	ff 75 08             	pushl  0x8(%ebp)
  8027c7:	6a 11                	push   $0x11
  8027c9:	e8 7a fe ff ff       	call   802648 <syscall>
  8027ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d1:	90                   	nop
}
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 0c                	push   $0xc
  8027e3:	e8 60 fe ff ff       	call   802648 <syscall>
  8027e8:	83 c4 18             	add    $0x18,%esp
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	ff 75 08             	pushl  0x8(%ebp)
  8027fb:	6a 0d                	push   $0xd
  8027fd:	e8 46 fe ff ff       	call   802648 <syscall>
  802802:	83 c4 18             	add    $0x18,%esp
}
  802805:	c9                   	leave  
  802806:	c3                   	ret    

00802807 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 0e                	push   $0xe
  802816:	e8 2d fe ff ff       	call   802648 <syscall>
  80281b:	83 c4 18             	add    $0x18,%esp
}
  80281e:	90                   	nop
  80281f:	c9                   	leave  
  802820:	c3                   	ret    

00802821 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 13                	push   $0x13
  802830:	e8 13 fe ff ff       	call   802648 <syscall>
  802835:	83 c4 18             	add    $0x18,%esp
}
  802838:	90                   	nop
  802839:	c9                   	leave  
  80283a:	c3                   	ret    

0080283b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	6a 14                	push   $0x14
  80284a:	e8 f9 fd ff ff       	call   802648 <syscall>
  80284f:	83 c4 18             	add    $0x18,%esp
}
  802852:	90                   	nop
  802853:	c9                   	leave  
  802854:	c3                   	ret    

00802855 <sys_cputc>:


void
sys_cputc(const char c)
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802861:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	50                   	push   %eax
  80286e:	6a 15                	push   $0x15
  802870:	e8 d3 fd ff ff       	call   802648 <syscall>
  802875:	83 c4 18             	add    $0x18,%esp
}
  802878:	90                   	nop
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 16                	push   $0x16
  80288a:	e8 b9 fd ff ff       	call   802648 <syscall>
  80288f:	83 c4 18             	add    $0x18,%esp
}
  802892:	90                   	nop
  802893:	c9                   	leave  
  802894:	c3                   	ret    

00802895 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	6a 00                	push   $0x0
  80289d:	6a 00                	push   $0x0
  80289f:	6a 00                	push   $0x0
  8028a1:	ff 75 0c             	pushl  0xc(%ebp)
  8028a4:	50                   	push   %eax
  8028a5:	6a 17                	push   $0x17
  8028a7:	e8 9c fd ff ff       	call   802648 <syscall>
  8028ac:	83 c4 18             	add    $0x18,%esp
}
  8028af:	c9                   	leave  
  8028b0:	c3                   	ret    

008028b1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	52                   	push   %edx
  8028c1:	50                   	push   %eax
  8028c2:	6a 1a                	push   $0x1a
  8028c4:	e8 7f fd ff ff       	call   802648 <syscall>
  8028c9:	83 c4 18             	add    $0x18,%esp
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	6a 00                	push   $0x0
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	52                   	push   %edx
  8028de:	50                   	push   %eax
  8028df:	6a 18                	push   $0x18
  8028e1:	e8 62 fd ff ff       	call   802648 <syscall>
  8028e6:	83 c4 18             	add    $0x18,%esp
}
  8028e9:	90                   	nop
  8028ea:	c9                   	leave  
  8028eb:	c3                   	ret    

008028ec <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	52                   	push   %edx
  8028fc:	50                   	push   %eax
  8028fd:	6a 19                	push   $0x19
  8028ff:	e8 44 fd ff ff       	call   802648 <syscall>
  802904:	83 c4 18             	add    $0x18,%esp
}
  802907:	90                   	nop
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	83 ec 04             	sub    $0x4,%esp
  802910:	8b 45 10             	mov    0x10(%ebp),%eax
  802913:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802916:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802919:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	6a 00                	push   $0x0
  802922:	51                   	push   %ecx
  802923:	52                   	push   %edx
  802924:	ff 75 0c             	pushl  0xc(%ebp)
  802927:	50                   	push   %eax
  802928:	6a 1b                	push   $0x1b
  80292a:	e8 19 fd ff ff       	call   802648 <syscall>
  80292f:	83 c4 18             	add    $0x18,%esp
}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	52                   	push   %edx
  802944:	50                   	push   %eax
  802945:	6a 1c                	push   $0x1c
  802947:	e8 fc fc ff ff       	call   802648 <syscall>
  80294c:	83 c4 18             	add    $0x18,%esp
}
  80294f:	c9                   	leave  
  802950:	c3                   	ret    

00802951 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802954:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	51                   	push   %ecx
  802962:	52                   	push   %edx
  802963:	50                   	push   %eax
  802964:	6a 1d                	push   $0x1d
  802966:	e8 dd fc ff ff       	call   802648 <syscall>
  80296b:	83 c4 18             	add    $0x18,%esp
}
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802973:	8b 55 0c             	mov    0xc(%ebp),%edx
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	6a 00                	push   $0x0
  80297b:	6a 00                	push   $0x0
  80297d:	6a 00                	push   $0x0
  80297f:	52                   	push   %edx
  802980:	50                   	push   %eax
  802981:	6a 1e                	push   $0x1e
  802983:	e8 c0 fc ff ff       	call   802648 <syscall>
  802988:	83 c4 18             	add    $0x18,%esp
}
  80298b:	c9                   	leave  
  80298c:	c3                   	ret    

0080298d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80298d:	55                   	push   %ebp
  80298e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	6a 00                	push   $0x0
  80299a:	6a 1f                	push   $0x1f
  80299c:	e8 a7 fc ff ff       	call   802648 <syscall>
  8029a1:	83 c4 18             	add    $0x18,%esp
}
  8029a4:	c9                   	leave  
  8029a5:	c3                   	ret    

008029a6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8029a6:	55                   	push   %ebp
  8029a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	6a 00                	push   $0x0
  8029ae:	ff 75 14             	pushl  0x14(%ebp)
  8029b1:	ff 75 10             	pushl  0x10(%ebp)
  8029b4:	ff 75 0c             	pushl  0xc(%ebp)
  8029b7:	50                   	push   %eax
  8029b8:	6a 20                	push   $0x20
  8029ba:	e8 89 fc ff ff       	call   802648 <syscall>
  8029bf:	83 c4 18             	add    $0x18,%esp
}
  8029c2:	c9                   	leave  
  8029c3:	c3                   	ret    

008029c4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8029c4:	55                   	push   %ebp
  8029c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	6a 00                	push   $0x0
  8029cc:	6a 00                	push   $0x0
  8029ce:	6a 00                	push   $0x0
  8029d0:	6a 00                	push   $0x0
  8029d2:	50                   	push   %eax
  8029d3:	6a 21                	push   $0x21
  8029d5:	e8 6e fc ff ff       	call   802648 <syscall>
  8029da:	83 c4 18             	add    $0x18,%esp
}
  8029dd:	90                   	nop
  8029de:	c9                   	leave  
  8029df:	c3                   	ret    

008029e0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029e0:	55                   	push   %ebp
  8029e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	6a 00                	push   $0x0
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	50                   	push   %eax
  8029ef:	6a 22                	push   $0x22
  8029f1:	e8 52 fc ff ff       	call   802648 <syscall>
  8029f6:	83 c4 18             	add    $0x18,%esp
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 02                	push   $0x2
  802a0a:	e8 39 fc ff ff       	call   802648 <syscall>
  802a0f:	83 c4 18             	add    $0x18,%esp
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802a17:	6a 00                	push   $0x0
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 03                	push   $0x3
  802a23:	e8 20 fc ff ff       	call   802648 <syscall>
  802a28:	83 c4 18             	add    $0x18,%esp
}
  802a2b:	c9                   	leave  
  802a2c:	c3                   	ret    

00802a2d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a2d:	55                   	push   %ebp
  802a2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a30:	6a 00                	push   $0x0
  802a32:	6a 00                	push   $0x0
  802a34:	6a 00                	push   $0x0
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 04                	push   $0x4
  802a3c:	e8 07 fc ff ff       	call   802648 <syscall>
  802a41:	83 c4 18             	add    $0x18,%esp
}
  802a44:	c9                   	leave  
  802a45:	c3                   	ret    

00802a46 <sys_exit_env>:


void sys_exit_env(void)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 00                	push   $0x0
  802a53:	6a 23                	push   $0x23
  802a55:	e8 ee fb ff ff       	call   802648 <syscall>
  802a5a:	83 c4 18             	add    $0x18,%esp
}
  802a5d:	90                   	nop
  802a5e:	c9                   	leave  
  802a5f:	c3                   	ret    

00802a60 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802a60:	55                   	push   %ebp
  802a61:	89 e5                	mov    %esp,%ebp
  802a63:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a69:	8d 50 04             	lea    0x4(%eax),%edx
  802a6c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a6f:	6a 00                	push   $0x0
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	52                   	push   %edx
  802a76:	50                   	push   %eax
  802a77:	6a 24                	push   $0x24
  802a79:	e8 ca fb ff ff       	call   802648 <syscall>
  802a7e:	83 c4 18             	add    $0x18,%esp
	return result;
  802a81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a87:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a8a:	89 01                	mov    %eax,(%ecx)
  802a8c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	c9                   	leave  
  802a93:	c2 04 00             	ret    $0x4

00802a96 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	ff 75 10             	pushl  0x10(%ebp)
  802aa0:	ff 75 0c             	pushl  0xc(%ebp)
  802aa3:	ff 75 08             	pushl  0x8(%ebp)
  802aa6:	6a 12                	push   $0x12
  802aa8:	e8 9b fb ff ff       	call   802648 <syscall>
  802aad:	83 c4 18             	add    $0x18,%esp
	return ;
  802ab0:	90                   	nop
}
  802ab1:	c9                   	leave  
  802ab2:	c3                   	ret    

00802ab3 <sys_rcr2>:
uint32 sys_rcr2()
{
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 00                	push   $0x0
  802aba:	6a 00                	push   $0x0
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 25                	push   $0x25
  802ac2:	e8 81 fb ff ff       	call   802648 <syscall>
  802ac7:	83 c4 18             	add    $0x18,%esp
}
  802aca:	c9                   	leave  
  802acb:	c3                   	ret    

00802acc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802acc:	55                   	push   %ebp
  802acd:	89 e5                	mov    %esp,%ebp
  802acf:	83 ec 04             	sub    $0x4,%esp
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ad8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802adc:	6a 00                	push   $0x0
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	50                   	push   %eax
  802ae5:	6a 26                	push   $0x26
  802ae7:	e8 5c fb ff ff       	call   802648 <syscall>
  802aec:	83 c4 18             	add    $0x18,%esp
	return ;
  802aef:	90                   	nop
}
  802af0:	c9                   	leave  
  802af1:	c3                   	ret    

00802af2 <rsttst>:
void rsttst()
{
  802af2:	55                   	push   %ebp
  802af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802af5:	6a 00                	push   $0x0
  802af7:	6a 00                	push   $0x0
  802af9:	6a 00                	push   $0x0
  802afb:	6a 00                	push   $0x0
  802afd:	6a 00                	push   $0x0
  802aff:	6a 28                	push   $0x28
  802b01:	e8 42 fb ff ff       	call   802648 <syscall>
  802b06:	83 c4 18             	add    $0x18,%esp
	return ;
  802b09:	90                   	nop
}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
  802b0f:	83 ec 04             	sub    $0x4,%esp
  802b12:	8b 45 14             	mov    0x14(%ebp),%eax
  802b15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b18:	8b 55 18             	mov    0x18(%ebp),%edx
  802b1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b1f:	52                   	push   %edx
  802b20:	50                   	push   %eax
  802b21:	ff 75 10             	pushl  0x10(%ebp)
  802b24:	ff 75 0c             	pushl  0xc(%ebp)
  802b27:	ff 75 08             	pushl  0x8(%ebp)
  802b2a:	6a 27                	push   $0x27
  802b2c:	e8 17 fb ff ff       	call   802648 <syscall>
  802b31:	83 c4 18             	add    $0x18,%esp
	return ;
  802b34:	90                   	nop
}
  802b35:	c9                   	leave  
  802b36:	c3                   	ret    

00802b37 <chktst>:
void chktst(uint32 n)
{
  802b37:	55                   	push   %ebp
  802b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	ff 75 08             	pushl  0x8(%ebp)
  802b45:	6a 29                	push   $0x29
  802b47:	e8 fc fa ff ff       	call   802648 <syscall>
  802b4c:	83 c4 18             	add    $0x18,%esp
	return ;
  802b4f:	90                   	nop
}
  802b50:	c9                   	leave  
  802b51:	c3                   	ret    

00802b52 <inctst>:

void inctst()
{
  802b52:	55                   	push   %ebp
  802b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 2a                	push   $0x2a
  802b61:	e8 e2 fa ff ff       	call   802648 <syscall>
  802b66:	83 c4 18             	add    $0x18,%esp
	return ;
  802b69:	90                   	nop
}
  802b6a:	c9                   	leave  
  802b6b:	c3                   	ret    

00802b6c <gettst>:
uint32 gettst()
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 00                	push   $0x0
  802b77:	6a 00                	push   $0x0
  802b79:	6a 2b                	push   $0x2b
  802b7b:	e8 c8 fa ff ff       	call   802648 <syscall>
  802b80:	83 c4 18             	add    $0x18,%esp
}
  802b83:	c9                   	leave  
  802b84:	c3                   	ret    

00802b85 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b85:	55                   	push   %ebp
  802b86:	89 e5                	mov    %esp,%ebp
  802b88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 00                	push   $0x0
  802b91:	6a 00                	push   $0x0
  802b93:	6a 00                	push   $0x0
  802b95:	6a 2c                	push   $0x2c
  802b97:	e8 ac fa ff ff       	call   802648 <syscall>
  802b9c:	83 c4 18             	add    $0x18,%esp
  802b9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ba2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802ba6:	75 07                	jne    802baf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802ba8:	b8 01 00 00 00       	mov    $0x1,%eax
  802bad:	eb 05                	jmp    802bb4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802baf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 00                	push   $0x0
  802bc0:	6a 00                	push   $0x0
  802bc2:	6a 00                	push   $0x0
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 2c                	push   $0x2c
  802bc8:	e8 7b fa ff ff       	call   802648 <syscall>
  802bcd:	83 c4 18             	add    $0x18,%esp
  802bd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802bd3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802bd7:	75 07                	jne    802be0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802bd9:	b8 01 00 00 00       	mov    $0x1,%eax
  802bde:	eb 05                	jmp    802be5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802be0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
  802bea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bed:	6a 00                	push   $0x0
  802bef:	6a 00                	push   $0x0
  802bf1:	6a 00                	push   $0x0
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 2c                	push   $0x2c
  802bf9:	e8 4a fa ff ff       	call   802648 <syscall>
  802bfe:	83 c4 18             	add    $0x18,%esp
  802c01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802c04:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802c08:	75 07                	jne    802c11 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c0f:	eb 05                	jmp    802c16 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802c11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c16:	c9                   	leave  
  802c17:	c3                   	ret    

00802c18 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802c18:	55                   	push   %ebp
  802c19:	89 e5                	mov    %esp,%ebp
  802c1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 00                	push   $0x0
  802c24:	6a 00                	push   $0x0
  802c26:	6a 00                	push   $0x0
  802c28:	6a 2c                	push   $0x2c
  802c2a:	e8 19 fa ff ff       	call   802648 <syscall>
  802c2f:	83 c4 18             	add    $0x18,%esp
  802c32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c35:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c39:	75 07                	jne    802c42 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  802c40:	eb 05                	jmp    802c47 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c47:	c9                   	leave  
  802c48:	c3                   	ret    

00802c49 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c49:	55                   	push   %ebp
  802c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c4c:	6a 00                	push   $0x0
  802c4e:	6a 00                	push   $0x0
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	ff 75 08             	pushl  0x8(%ebp)
  802c57:	6a 2d                	push   $0x2d
  802c59:	e8 ea f9 ff ff       	call   802648 <syscall>
  802c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  802c61:	90                   	nop
}
  802c62:	c9                   	leave  
  802c63:	c3                   	ret    

00802c64 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
  802c67:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	6a 00                	push   $0x0
  802c76:	53                   	push   %ebx
  802c77:	51                   	push   %ecx
  802c78:	52                   	push   %edx
  802c79:	50                   	push   %eax
  802c7a:	6a 2e                	push   $0x2e
  802c7c:	e8 c7 f9 ff ff       	call   802648 <syscall>
  802c81:	83 c4 18             	add    $0x18,%esp
}
  802c84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c87:	c9                   	leave  
  802c88:	c3                   	ret    

00802c89 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802c89:	55                   	push   %ebp
  802c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	6a 00                	push   $0x0
  802c94:	6a 00                	push   $0x0
  802c96:	6a 00                	push   $0x0
  802c98:	52                   	push   %edx
  802c99:	50                   	push   %eax
  802c9a:	6a 2f                	push   $0x2f
  802c9c:	e8 a7 f9 ff ff       	call   802648 <syscall>
  802ca1:	83 c4 18             	add    $0x18,%esp
}
  802ca4:	c9                   	leave  
  802ca5:	c3                   	ret    

00802ca6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
  802ca9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802cac:	8b 55 08             	mov    0x8(%ebp),%edx
  802caf:	89 d0                	mov    %edx,%eax
  802cb1:	c1 e0 02             	shl    $0x2,%eax
  802cb4:	01 d0                	add    %edx,%eax
  802cb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cbd:	01 d0                	add    %edx,%eax
  802cbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cc6:	01 d0                	add    %edx,%eax
  802cc8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ccf:	01 d0                	add    %edx,%eax
  802cd1:	c1 e0 04             	shl    $0x4,%eax
  802cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802cd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802cde:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ce1:	83 ec 0c             	sub    $0xc,%esp
  802ce4:	50                   	push   %eax
  802ce5:	e8 76 fd ff ff       	call   802a60 <sys_get_virtual_time>
  802cea:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ced:	eb 41                	jmp    802d30 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802cef:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802cf2:	83 ec 0c             	sub    $0xc,%esp
  802cf5:	50                   	push   %eax
  802cf6:	e8 65 fd ff ff       	call   802a60 <sys_get_virtual_time>
  802cfb:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802cfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	29 c2                	sub    %eax,%edx
  802d06:	89 d0                	mov    %edx,%eax
  802d08:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802d0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d11:	89 d1                	mov    %edx,%ecx
  802d13:	29 c1                	sub    %eax,%ecx
  802d15:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1b:	39 c2                	cmp    %eax,%edx
  802d1d:	0f 97 c0             	seta   %al
  802d20:	0f b6 c0             	movzbl %al,%eax
  802d23:	29 c1                	sub    %eax,%ecx
  802d25:	89 c8                	mov    %ecx,%eax
  802d27:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802d2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d36:	72 b7                	jb     802cef <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802d38:	90                   	nop
  802d39:	c9                   	leave  
  802d3a:	c3                   	ret    

00802d3b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802d3b:	55                   	push   %ebp
  802d3c:	89 e5                	mov    %esp,%ebp
  802d3e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802d41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802d48:	eb 03                	jmp    802d4d <busy_wait+0x12>
  802d4a:	ff 45 fc             	incl   -0x4(%ebp)
  802d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d53:	72 f5                	jb     802d4a <busy_wait+0xf>
	return i;
  802d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802d58:	c9                   	leave  
  802d59:	c3                   	ret    
  802d5a:	66 90                	xchg   %ax,%ax

00802d5c <__udivdi3>:
  802d5c:	55                   	push   %ebp
  802d5d:	57                   	push   %edi
  802d5e:	56                   	push   %esi
  802d5f:	53                   	push   %ebx
  802d60:	83 ec 1c             	sub    $0x1c,%esp
  802d63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d73:	89 ca                	mov    %ecx,%edx
  802d75:	89 f8                	mov    %edi,%eax
  802d77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d7b:	85 f6                	test   %esi,%esi
  802d7d:	75 2d                	jne    802dac <__udivdi3+0x50>
  802d7f:	39 cf                	cmp    %ecx,%edi
  802d81:	77 65                	ja     802de8 <__udivdi3+0x8c>
  802d83:	89 fd                	mov    %edi,%ebp
  802d85:	85 ff                	test   %edi,%edi
  802d87:	75 0b                	jne    802d94 <__udivdi3+0x38>
  802d89:	b8 01 00 00 00       	mov    $0x1,%eax
  802d8e:	31 d2                	xor    %edx,%edx
  802d90:	f7 f7                	div    %edi
  802d92:	89 c5                	mov    %eax,%ebp
  802d94:	31 d2                	xor    %edx,%edx
  802d96:	89 c8                	mov    %ecx,%eax
  802d98:	f7 f5                	div    %ebp
  802d9a:	89 c1                	mov    %eax,%ecx
  802d9c:	89 d8                	mov    %ebx,%eax
  802d9e:	f7 f5                	div    %ebp
  802da0:	89 cf                	mov    %ecx,%edi
  802da2:	89 fa                	mov    %edi,%edx
  802da4:	83 c4 1c             	add    $0x1c,%esp
  802da7:	5b                   	pop    %ebx
  802da8:	5e                   	pop    %esi
  802da9:	5f                   	pop    %edi
  802daa:	5d                   	pop    %ebp
  802dab:	c3                   	ret    
  802dac:	39 ce                	cmp    %ecx,%esi
  802dae:	77 28                	ja     802dd8 <__udivdi3+0x7c>
  802db0:	0f bd fe             	bsr    %esi,%edi
  802db3:	83 f7 1f             	xor    $0x1f,%edi
  802db6:	75 40                	jne    802df8 <__udivdi3+0x9c>
  802db8:	39 ce                	cmp    %ecx,%esi
  802dba:	72 0a                	jb     802dc6 <__udivdi3+0x6a>
  802dbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802dc0:	0f 87 9e 00 00 00    	ja     802e64 <__udivdi3+0x108>
  802dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  802dcb:	89 fa                	mov    %edi,%edx
  802dcd:	83 c4 1c             	add    $0x1c,%esp
  802dd0:	5b                   	pop    %ebx
  802dd1:	5e                   	pop    %esi
  802dd2:	5f                   	pop    %edi
  802dd3:	5d                   	pop    %ebp
  802dd4:	c3                   	ret    
  802dd5:	8d 76 00             	lea    0x0(%esi),%esi
  802dd8:	31 ff                	xor    %edi,%edi
  802dda:	31 c0                	xor    %eax,%eax
  802ddc:	89 fa                	mov    %edi,%edx
  802dde:	83 c4 1c             	add    $0x1c,%esp
  802de1:	5b                   	pop    %ebx
  802de2:	5e                   	pop    %esi
  802de3:	5f                   	pop    %edi
  802de4:	5d                   	pop    %ebp
  802de5:	c3                   	ret    
  802de6:	66 90                	xchg   %ax,%ax
  802de8:	89 d8                	mov    %ebx,%eax
  802dea:	f7 f7                	div    %edi
  802dec:	31 ff                	xor    %edi,%edi
  802dee:	89 fa                	mov    %edi,%edx
  802df0:	83 c4 1c             	add    $0x1c,%esp
  802df3:	5b                   	pop    %ebx
  802df4:	5e                   	pop    %esi
  802df5:	5f                   	pop    %edi
  802df6:	5d                   	pop    %ebp
  802df7:	c3                   	ret    
  802df8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802dfd:	89 eb                	mov    %ebp,%ebx
  802dff:	29 fb                	sub    %edi,%ebx
  802e01:	89 f9                	mov    %edi,%ecx
  802e03:	d3 e6                	shl    %cl,%esi
  802e05:	89 c5                	mov    %eax,%ebp
  802e07:	88 d9                	mov    %bl,%cl
  802e09:	d3 ed                	shr    %cl,%ebp
  802e0b:	89 e9                	mov    %ebp,%ecx
  802e0d:	09 f1                	or     %esi,%ecx
  802e0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e13:	89 f9                	mov    %edi,%ecx
  802e15:	d3 e0                	shl    %cl,%eax
  802e17:	89 c5                	mov    %eax,%ebp
  802e19:	89 d6                	mov    %edx,%esi
  802e1b:	88 d9                	mov    %bl,%cl
  802e1d:	d3 ee                	shr    %cl,%esi
  802e1f:	89 f9                	mov    %edi,%ecx
  802e21:	d3 e2                	shl    %cl,%edx
  802e23:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e27:	88 d9                	mov    %bl,%cl
  802e29:	d3 e8                	shr    %cl,%eax
  802e2b:	09 c2                	or     %eax,%edx
  802e2d:	89 d0                	mov    %edx,%eax
  802e2f:	89 f2                	mov    %esi,%edx
  802e31:	f7 74 24 0c          	divl   0xc(%esp)
  802e35:	89 d6                	mov    %edx,%esi
  802e37:	89 c3                	mov    %eax,%ebx
  802e39:	f7 e5                	mul    %ebp
  802e3b:	39 d6                	cmp    %edx,%esi
  802e3d:	72 19                	jb     802e58 <__udivdi3+0xfc>
  802e3f:	74 0b                	je     802e4c <__udivdi3+0xf0>
  802e41:	89 d8                	mov    %ebx,%eax
  802e43:	31 ff                	xor    %edi,%edi
  802e45:	e9 58 ff ff ff       	jmp    802da2 <__udivdi3+0x46>
  802e4a:	66 90                	xchg   %ax,%ax
  802e4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e50:	89 f9                	mov    %edi,%ecx
  802e52:	d3 e2                	shl    %cl,%edx
  802e54:	39 c2                	cmp    %eax,%edx
  802e56:	73 e9                	jae    802e41 <__udivdi3+0xe5>
  802e58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e5b:	31 ff                	xor    %edi,%edi
  802e5d:	e9 40 ff ff ff       	jmp    802da2 <__udivdi3+0x46>
  802e62:	66 90                	xchg   %ax,%ax
  802e64:	31 c0                	xor    %eax,%eax
  802e66:	e9 37 ff ff ff       	jmp    802da2 <__udivdi3+0x46>
  802e6b:	90                   	nop

00802e6c <__umoddi3>:
  802e6c:	55                   	push   %ebp
  802e6d:	57                   	push   %edi
  802e6e:	56                   	push   %esi
  802e6f:	53                   	push   %ebx
  802e70:	83 ec 1c             	sub    $0x1c,%esp
  802e73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e77:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e8b:	89 f3                	mov    %esi,%ebx
  802e8d:	89 fa                	mov    %edi,%edx
  802e8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e93:	89 34 24             	mov    %esi,(%esp)
  802e96:	85 c0                	test   %eax,%eax
  802e98:	75 1a                	jne    802eb4 <__umoddi3+0x48>
  802e9a:	39 f7                	cmp    %esi,%edi
  802e9c:	0f 86 a2 00 00 00    	jbe    802f44 <__umoddi3+0xd8>
  802ea2:	89 c8                	mov    %ecx,%eax
  802ea4:	89 f2                	mov    %esi,%edx
  802ea6:	f7 f7                	div    %edi
  802ea8:	89 d0                	mov    %edx,%eax
  802eaa:	31 d2                	xor    %edx,%edx
  802eac:	83 c4 1c             	add    $0x1c,%esp
  802eaf:	5b                   	pop    %ebx
  802eb0:	5e                   	pop    %esi
  802eb1:	5f                   	pop    %edi
  802eb2:	5d                   	pop    %ebp
  802eb3:	c3                   	ret    
  802eb4:	39 f0                	cmp    %esi,%eax
  802eb6:	0f 87 ac 00 00 00    	ja     802f68 <__umoddi3+0xfc>
  802ebc:	0f bd e8             	bsr    %eax,%ebp
  802ebf:	83 f5 1f             	xor    $0x1f,%ebp
  802ec2:	0f 84 ac 00 00 00    	je     802f74 <__umoddi3+0x108>
  802ec8:	bf 20 00 00 00       	mov    $0x20,%edi
  802ecd:	29 ef                	sub    %ebp,%edi
  802ecf:	89 fe                	mov    %edi,%esi
  802ed1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ed5:	89 e9                	mov    %ebp,%ecx
  802ed7:	d3 e0                	shl    %cl,%eax
  802ed9:	89 d7                	mov    %edx,%edi
  802edb:	89 f1                	mov    %esi,%ecx
  802edd:	d3 ef                	shr    %cl,%edi
  802edf:	09 c7                	or     %eax,%edi
  802ee1:	89 e9                	mov    %ebp,%ecx
  802ee3:	d3 e2                	shl    %cl,%edx
  802ee5:	89 14 24             	mov    %edx,(%esp)
  802ee8:	89 d8                	mov    %ebx,%eax
  802eea:	d3 e0                	shl    %cl,%eax
  802eec:	89 c2                	mov    %eax,%edx
  802eee:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ef2:	d3 e0                	shl    %cl,%eax
  802ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ef8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802efc:	89 f1                	mov    %esi,%ecx
  802efe:	d3 e8                	shr    %cl,%eax
  802f00:	09 d0                	or     %edx,%eax
  802f02:	d3 eb                	shr    %cl,%ebx
  802f04:	89 da                	mov    %ebx,%edx
  802f06:	f7 f7                	div    %edi
  802f08:	89 d3                	mov    %edx,%ebx
  802f0a:	f7 24 24             	mull   (%esp)
  802f0d:	89 c6                	mov    %eax,%esi
  802f0f:	89 d1                	mov    %edx,%ecx
  802f11:	39 d3                	cmp    %edx,%ebx
  802f13:	0f 82 87 00 00 00    	jb     802fa0 <__umoddi3+0x134>
  802f19:	0f 84 91 00 00 00    	je     802fb0 <__umoddi3+0x144>
  802f1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f23:	29 f2                	sub    %esi,%edx
  802f25:	19 cb                	sbb    %ecx,%ebx
  802f27:	89 d8                	mov    %ebx,%eax
  802f29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f2d:	d3 e0                	shl    %cl,%eax
  802f2f:	89 e9                	mov    %ebp,%ecx
  802f31:	d3 ea                	shr    %cl,%edx
  802f33:	09 d0                	or     %edx,%eax
  802f35:	89 e9                	mov    %ebp,%ecx
  802f37:	d3 eb                	shr    %cl,%ebx
  802f39:	89 da                	mov    %ebx,%edx
  802f3b:	83 c4 1c             	add    $0x1c,%esp
  802f3e:	5b                   	pop    %ebx
  802f3f:	5e                   	pop    %esi
  802f40:	5f                   	pop    %edi
  802f41:	5d                   	pop    %ebp
  802f42:	c3                   	ret    
  802f43:	90                   	nop
  802f44:	89 fd                	mov    %edi,%ebp
  802f46:	85 ff                	test   %edi,%edi
  802f48:	75 0b                	jne    802f55 <__umoddi3+0xe9>
  802f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f4f:	31 d2                	xor    %edx,%edx
  802f51:	f7 f7                	div    %edi
  802f53:	89 c5                	mov    %eax,%ebp
  802f55:	89 f0                	mov    %esi,%eax
  802f57:	31 d2                	xor    %edx,%edx
  802f59:	f7 f5                	div    %ebp
  802f5b:	89 c8                	mov    %ecx,%eax
  802f5d:	f7 f5                	div    %ebp
  802f5f:	89 d0                	mov    %edx,%eax
  802f61:	e9 44 ff ff ff       	jmp    802eaa <__umoddi3+0x3e>
  802f66:	66 90                	xchg   %ax,%ax
  802f68:	89 c8                	mov    %ecx,%eax
  802f6a:	89 f2                	mov    %esi,%edx
  802f6c:	83 c4 1c             	add    $0x1c,%esp
  802f6f:	5b                   	pop    %ebx
  802f70:	5e                   	pop    %esi
  802f71:	5f                   	pop    %edi
  802f72:	5d                   	pop    %ebp
  802f73:	c3                   	ret    
  802f74:	3b 04 24             	cmp    (%esp),%eax
  802f77:	72 06                	jb     802f7f <__umoddi3+0x113>
  802f79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f7d:	77 0f                	ja     802f8e <__umoddi3+0x122>
  802f7f:	89 f2                	mov    %esi,%edx
  802f81:	29 f9                	sub    %edi,%ecx
  802f83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f87:	89 14 24             	mov    %edx,(%esp)
  802f8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f92:	8b 14 24             	mov    (%esp),%edx
  802f95:	83 c4 1c             	add    $0x1c,%esp
  802f98:	5b                   	pop    %ebx
  802f99:	5e                   	pop    %esi
  802f9a:	5f                   	pop    %edi
  802f9b:	5d                   	pop    %ebp
  802f9c:	c3                   	ret    
  802f9d:	8d 76 00             	lea    0x0(%esi),%esi
  802fa0:	2b 04 24             	sub    (%esp),%eax
  802fa3:	19 fa                	sbb    %edi,%edx
  802fa5:	89 d1                	mov    %edx,%ecx
  802fa7:	89 c6                	mov    %eax,%esi
  802fa9:	e9 71 ff ff ff       	jmp    802f1f <__umoddi3+0xb3>
  802fae:	66 90                	xchg   %ax,%ax
  802fb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fb4:	72 ea                	jb     802fa0 <__umoddi3+0x134>
  802fb6:	89 d9                	mov    %ebx,%ecx
  802fb8:	e9 62 ff ff ff       	jmp    802f1f <__umoddi3+0xb3>
