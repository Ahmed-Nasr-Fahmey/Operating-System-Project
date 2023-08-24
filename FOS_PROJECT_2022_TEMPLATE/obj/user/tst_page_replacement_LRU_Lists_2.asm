
obj/user/tst_page_replacement_LRU_Lists_2:     file format elf32-i386


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
  800031:	e8 83 02 00 00       	call   8002b9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*13];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
//	cprintf("envID = %d\n",envID);
	int x = 0;
  800044:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

	//("STEP 0: checking Initial WS entries ...\n");
	{
		uint32 actual_active_list[6] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x204000, 0x203000};
  80004b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80004e:	bb f8 1e 80 00       	mov    $0x801ef8,%ebx
  800053:	ba 06 00 00 00       	mov    $0x6,%edx
  800058:	89 c7                	mov    %eax,%edi
  80005a:	89 de                	mov    %ebx,%esi
  80005c:	89 d1                	mov    %edx,%ecx
  80005e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		uint32 actual_second_list[5] = {0x202000, 0x201000, 0x200000, 0x802000, 0x205000};
  800060:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  800066:	bb 10 1f 80 00       	mov    $0x801f10,%ebx
  80006b:	ba 05 00 00 00       	mov    $0x5,%edx
  800070:	89 c7                	mov    %eax,%edi
  800072:	89 de                	mov    %ebx,%esi
  800074:	89 d1                	mov    %edx,%ecx
  800076:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  800078:	6a 05                	push   $0x5
  80007a:	6a 06                	push   $0x6
  80007c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  800082:	50                   	push   %eax
  800083:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 d6 19 00 00       	call   801a62 <sys_check_LRU_lists>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if(check == 0)
  800092:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800096:	75 14                	jne    8000ac <_main+0x74>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 20 1d 80 00       	push   $0x801d20
  8000a0:	6a 18                	push   $0x18
  8000a2:	68 70 1d 80 00       	push   $0x801d70
  8000a7:	e8 5c 03 00 00       	call   800408 <_panic>
	}

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8000ac:	a0 5f 51 83 00       	mov    0x83515f,%al
  8000b1:	88 45 db             	mov    %al,-0x25(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8000b4:	a0 5f 61 83 00       	mov    0x83615f,%al
  8000b9:	88 45 da             	mov    %al,-0x26(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000c3:	eb 37                	jmp    8000fc <_main+0xc4>
	{
		arr[i] = -1 ;
  8000c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c8:	05 60 a1 82 00       	add    $0x82a160,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8000d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d5:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8000db:	8a 12                	mov    (%edx),%dl
  8000dd:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8000df:	a1 00 30 80 00       	mov    0x803000,%eax
  8000e4:	40                   	inc    %eax
  8000e5:	a3 00 30 80 00       	mov    %eax,0x803000
  8000ea:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ef:	40                   	inc    %eax
  8000f0:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000f5:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8000fc:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  800103:	7e c0                	jle    8000c5 <_main+0x8d>
	}

	//===================

	//("STEP 1: checking LRU LISTS after a new page FAULTS...\n");
	uint32 actual_active_list[6] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x804000, 0x80c000};
  800105:	8d 45 b0             	lea    -0x50(%ebp),%eax
  800108:	bb 24 1f 80 00       	mov    $0x801f24,%ebx
  80010d:	ba 06 00 00 00       	mov    $0x6,%edx
  800112:	89 c7                	mov    %eax,%edi
  800114:	89 de                	mov    %ebx,%esi
  800116:	89 d1                	mov    %edx,%ecx
  800118:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	uint32 actual_second_list[5] = {0x80b000, 0x80a000, 0x809000, 0x808000, 0x807000};
  80011a:	8d 45 9c             	lea    -0x64(%ebp),%eax
  80011d:	bb 3c 1f 80 00       	mov    $0x801f3c,%ebx
  800122:	ba 05 00 00 00       	mov    $0x5,%edx
  800127:	89 c7                	mov    %eax,%edi
  800129:	89 de                	mov    %ebx,%esi
  80012b:	89 d1                	mov    %edx,%ecx
  80012d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  80012f:	6a 05                	push   $0x5
  800131:	6a 06                	push   $0x6
  800133:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800136:	50                   	push   %eax
  800137:	8d 45 b0             	lea    -0x50(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 22 19 00 00       	call   801a62 <sys_check_LRU_lists>
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(check == 0)
  800146:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80014a:	75 14                	jne    800160 <_main+0x128>
		panic("PAGE LRU Lists entry checking failed when a new PAGE FAULTs occurred..!!");
  80014c:	83 ec 04             	sub    $0x4,%esp
  80014f:	68 98 1d 80 00       	push   $0x801d98
  800154:	6a 33                	push   $0x33
  800156:	68 70 1d 80 00       	push   $0x801d70
  80015b:	e8 a8 02 00 00       	call   800408 <_panic>


	//("STEP 2: Checking PAGE LRU LIST algorithm after faults due to ACCESS in the second chance list... \n");
	{
		uint32* secondlistVA = (uint32*)0x809000;
  800160:	c7 45 d0 00 90 80 00 	movl   $0x809000,-0x30(%ebp)
		x = x + *secondlistVA;
  800167:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80016a:	8b 10                	mov    (%eax),%edx
  80016c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016f:	01 d0                	add    %edx,%eax
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		secondlistVA = (uint32*)0x807000;
  800174:	c7 45 d0 00 70 80 00 	movl   $0x807000,-0x30(%ebp)
		x = x + *secondlistVA;
  80017b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80017e:	8b 10                	mov    (%eax),%edx
  800180:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
		secondlistVA = (uint32*)0x804000;
  800188:	c7 45 d0 00 40 80 00 	movl   $0x804000,-0x30(%ebp)
		x = x + *secondlistVA;
  80018f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800192:	8b 10                	mov    (%eax),%edx
  800194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)

		actual_active_list[0] = 0x801000;
  80019c:	c7 45 b0 00 10 80 00 	movl   $0x801000,-0x50(%ebp)
		actual_active_list[1] = 0x800000;
  8001a3:	c7 45 b4 00 00 80 00 	movl   $0x800000,-0x4c(%ebp)
		actual_active_list[2] = 0xeebfd000;
  8001aa:	c7 45 b8 00 d0 bf ee 	movl   $0xeebfd000,-0x48(%ebp)
		actual_active_list[3] = 0x804000;
  8001b1:	c7 45 bc 00 40 80 00 	movl   $0x804000,-0x44(%ebp)
		actual_active_list[4] = 0x807000;
  8001b8:	c7 45 c0 00 70 80 00 	movl   $0x807000,-0x40(%ebp)
		actual_active_list[5] = 0x809000;
  8001bf:	c7 45 c4 00 90 80 00 	movl   $0x809000,-0x3c(%ebp)

		actual_second_list[0] = 0x803000;
  8001c6:	c7 45 9c 00 30 80 00 	movl   $0x803000,-0x64(%ebp)
		actual_second_list[1] = 0x80c000;
  8001cd:	c7 45 a0 00 c0 80 00 	movl   $0x80c000,-0x60(%ebp)
		actual_second_list[2] = 0x80b000;
  8001d4:	c7 45 a4 00 b0 80 00 	movl   $0x80b000,-0x5c(%ebp)
		actual_second_list[3] = 0x80a000;
  8001db:	c7 45 a8 00 a0 80 00 	movl   $0x80a000,-0x58(%ebp)
		actual_second_list[4] = 0x808000;
  8001e2:	c7 45 ac 00 80 80 00 	movl   $0x808000,-0x54(%ebp)
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  8001e9:	6a 05                	push   $0x5
  8001eb:	6a 06                	push   $0x6
  8001ed:	8d 45 9c             	lea    -0x64(%ebp),%eax
  8001f0:	50                   	push   %eax
  8001f1:	8d 45 b0             	lea    -0x50(%ebp),%eax
  8001f4:	50                   	push   %eax
  8001f5:	e8 68 18 00 00       	call   801a62 <sys_check_LRU_lists>
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if(check == 0)
  800200:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800204:	75 14                	jne    80021a <_main+0x1e2>
			panic("PAGE LRU Lists entry checking failed when a new PAGE ACCESS from the SECOND LIST is occurred..!!");
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 e4 1d 80 00       	push   $0x801de4
  80020e:	6a 4d                	push   $0x4d
  800210:	68 70 1d 80 00       	push   $0x801d70
  800215:	e8 ee 01 00 00       	call   800408 <_panic>
	}

	//("STEP 3: NEW FAULTS to test applying LRU algorithm on the second list by removing the LRU page... \n");
	{
		//Reading (Not Modified)
		char garbage3 = arr[PAGE_SIZE*13-1] ;
  80021a:	a0 5f 71 83 00       	mov    0x83715f,%al
  80021f:	88 45 cb             	mov    %al,-0x35(%ebp)
		actual_active_list[0] = 0x810000;
  800222:	c7 45 b0 00 00 81 00 	movl   $0x810000,-0x50(%ebp)
		actual_active_list[1] = 0x801000;
  800229:	c7 45 b4 00 10 80 00 	movl   $0x801000,-0x4c(%ebp)
		actual_active_list[2] = 0x800000;
  800230:	c7 45 b8 00 00 80 00 	movl   $0x800000,-0x48(%ebp)
		actual_active_list[3] = 0xeebfd000;
  800237:	c7 45 bc 00 d0 bf ee 	movl   $0xeebfd000,-0x44(%ebp)
		actual_active_list[4] = 0x804000;
  80023e:	c7 45 c0 00 40 80 00 	movl   $0x804000,-0x40(%ebp)
		actual_active_list[5] = 0x807000;
  800245:	c7 45 c4 00 70 80 00 	movl   $0x807000,-0x3c(%ebp)

		actual_second_list[0] = 0x809000;
  80024c:	c7 45 9c 00 90 80 00 	movl   $0x809000,-0x64(%ebp)
		actual_second_list[1] = 0x803000;
  800253:	c7 45 a0 00 30 80 00 	movl   $0x803000,-0x60(%ebp)
		actual_second_list[2] = 0x80c000;
  80025a:	c7 45 a4 00 c0 80 00 	movl   $0x80c000,-0x5c(%ebp)
		actual_second_list[3] = 0x80b000;
  800261:	c7 45 a8 00 b0 80 00 	movl   $0x80b000,-0x58(%ebp)
		actual_second_list[4] = 0x80a000;
  800268:	c7 45 ac 00 a0 80 00 	movl   $0x80a000,-0x54(%ebp)
		check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  80026f:	6a 05                	push   $0x5
  800271:	6a 06                	push   $0x6
  800273:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	8d 45 b0             	lea    -0x50(%ebp),%eax
  80027a:	50                   	push   %eax
  80027b:	e8 e2 17 00 00       	call   801a62 <sys_check_LRU_lists>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if(check == 0)
  800286:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80028a:	75 14                	jne    8002a0 <_main+0x268>
			panic("PAGE LRU Lists entry checking failed when a new PAGE FAULT occurred..!!");
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 48 1e 80 00       	push   $0x801e48
  800294:	6a 62                	push   $0x62
  800296:	68 70 1d 80 00       	push   $0x801d70
  80029b:	e8 68 01 00 00       	call   800408 <_panic>
	}
	cprintf("Congratulations!! test PAGE replacement [LRU Alg. on the 2nd chance list] is completed successfully.\n");
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	68 90 1e 80 00       	push   $0x801e90
  8002a8:	e8 0f 04 00 00       	call   8006bc <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	return;
  8002b0:	90                   	nop
}
  8002b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b4:	5b                   	pop    %ebx
  8002b5:	5e                   	pop    %esi
  8002b6:	5f                   	pop    %edi
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    

008002b9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002bf:	e8 4e 15 00 00       	call   801812 <sys_getenvindex>
  8002c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002ca:	89 d0                	mov    %edx,%eax
  8002cc:	01 c0                	add    %eax,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8002d7:	01 c8                	add    %ecx,%eax
  8002d9:	c1 e0 02             	shl    $0x2,%eax
  8002dc:	01 d0                	add    %edx,%eax
  8002de:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8002e5:	01 c8                	add    %ecx,%eax
  8002e7:	c1 e0 02             	shl    $0x2,%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	c1 e0 02             	shl    $0x2,%eax
  8002ef:	01 d0                	add    %edx,%eax
  8002f1:	c1 e0 03             	shl    $0x3,%eax
  8002f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f9:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800303:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800309:	84 c0                	test   %al,%al
  80030b:	74 0f                	je     80031c <libmain+0x63>
		binaryname = myEnv->prog_name;
  80030d:	a1 20 30 80 00       	mov    0x803020,%eax
  800312:	05 18 da 01 00       	add    $0x1da18,%eax
  800317:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800320:	7e 0a                	jle    80032c <libmain+0x73>
		binaryname = argv[0];
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	ff 75 0c             	pushl  0xc(%ebp)
  800332:	ff 75 08             	pushl  0x8(%ebp)
  800335:	e8 fe fc ff ff       	call   800038 <_main>
  80033a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80033d:	e8 dd 12 00 00       	call   80161f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800342:	83 ec 0c             	sub    $0xc,%esp
  800345:	68 68 1f 80 00       	push   $0x801f68
  80034a:	e8 6d 03 00 00       	call   8006bc <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800352:	a1 20 30 80 00       	mov    0x803020,%eax
  800357:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80035d:	a1 20 30 80 00       	mov    0x803020,%eax
  800362:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800368:	83 ec 04             	sub    $0x4,%esp
  80036b:	52                   	push   %edx
  80036c:	50                   	push   %eax
  80036d:	68 90 1f 80 00       	push   $0x801f90
  800372:	e8 45 03 00 00       	call   8006bc <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80037a:	a1 20 30 80 00       	mov    0x803020,%eax
  80037f:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800385:	a1 20 30 80 00       	mov    0x803020,%eax
  80038a:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800390:	a1 20 30 80 00       	mov    0x803020,%eax
  800395:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80039b:	51                   	push   %ecx
  80039c:	52                   	push   %edx
  80039d:	50                   	push   %eax
  80039e:	68 b8 1f 80 00       	push   $0x801fb8
  8003a3:	e8 14 03 00 00       	call   8006bc <cprintf>
  8003a8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b0:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	50                   	push   %eax
  8003ba:	68 10 20 80 00       	push   $0x802010
  8003bf:	e8 f8 02 00 00       	call   8006bc <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003c7:	83 ec 0c             	sub    $0xc,%esp
  8003ca:	68 68 1f 80 00       	push   $0x801f68
  8003cf:	e8 e8 02 00 00       	call   8006bc <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003d7:	e8 5d 12 00 00       	call   801639 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003dc:	e8 19 00 00 00       	call   8003fa <exit>
}
  8003e1:	90                   	nop
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003ea:	83 ec 0c             	sub    $0xc,%esp
  8003ed:	6a 00                	push   $0x0
  8003ef:	e8 ea 13 00 00       	call   8017de <sys_destroy_env>
  8003f4:	83 c4 10             	add    $0x10,%esp
}
  8003f7:	90                   	nop
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <exit>:

void
exit(void)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800400:	e8 3f 14 00 00       	call   801844 <sys_exit_env>
}
  800405:	90                   	nop
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80040e:	8d 45 10             	lea    0x10(%ebp),%eax
  800411:	83 c0 04             	add    $0x4,%eax
  800414:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800417:	a1 58 72 83 00       	mov    0x837258,%eax
  80041c:	85 c0                	test   %eax,%eax
  80041e:	74 16                	je     800436 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800420:	a1 58 72 83 00       	mov    0x837258,%eax
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	50                   	push   %eax
  800429:	68 24 20 80 00       	push   $0x802024
  80042e:	e8 89 02 00 00       	call   8006bc <cprintf>
  800433:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800436:	a1 08 30 80 00       	mov    0x803008,%eax
  80043b:	ff 75 0c             	pushl  0xc(%ebp)
  80043e:	ff 75 08             	pushl  0x8(%ebp)
  800441:	50                   	push   %eax
  800442:	68 29 20 80 00       	push   $0x802029
  800447:	e8 70 02 00 00       	call   8006bc <cprintf>
  80044c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80044f:	8b 45 10             	mov    0x10(%ebp),%eax
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	ff 75 f4             	pushl  -0xc(%ebp)
  800458:	50                   	push   %eax
  800459:	e8 f3 01 00 00       	call   800651 <vcprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800461:	83 ec 08             	sub    $0x8,%esp
  800464:	6a 00                	push   $0x0
  800466:	68 45 20 80 00       	push   $0x802045
  80046b:	e8 e1 01 00 00       	call   800651 <vcprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800473:	e8 82 ff ff ff       	call   8003fa <exit>

	// should not return here
	while (1) ;
  800478:	eb fe                	jmp    800478 <_panic+0x70>

0080047a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800480:	a1 20 30 80 00       	mov    0x803020,%eax
  800485:	8b 50 74             	mov    0x74(%eax),%edx
  800488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	74 14                	je     8004a3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80048f:	83 ec 04             	sub    $0x4,%esp
  800492:	68 48 20 80 00       	push   $0x802048
  800497:	6a 26                	push   $0x26
  800499:	68 94 20 80 00       	push   $0x802094
  80049e:	e8 65 ff ff ff       	call   800408 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004b1:	e9 c2 00 00 00       	jmp    800578 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	85 c0                	test   %eax,%eax
  8004c9:	75 08                	jne    8004d3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004cb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ce:	e9 a2 00 00 00       	jmp    800575 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004e1:	eb 69                	jmp    80054c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e8:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8004ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f1:	89 d0                	mov    %edx,%eax
  8004f3:	01 c0                	add    %eax,%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	c1 e0 03             	shl    $0x3,%eax
  8004fa:	01 c8                	add    %ecx,%eax
  8004fc:	8a 40 04             	mov    0x4(%eax),%al
  8004ff:	84 c0                	test   %al,%al
  800501:	75 46                	jne    800549 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800503:	a1 20 30 80 00       	mov    0x803020,%eax
  800508:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80050e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800511:	89 d0                	mov    %edx,%eax
  800513:	01 c0                	add    %eax,%eax
  800515:	01 d0                	add    %edx,%eax
  800517:	c1 e0 03             	shl    $0x3,%eax
  80051a:	01 c8                	add    %ecx,%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800521:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800524:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800529:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80052b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800535:	8b 45 08             	mov    0x8(%ebp),%eax
  800538:	01 c8                	add    %ecx,%eax
  80053a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80053c:	39 c2                	cmp    %eax,%edx
  80053e:	75 09                	jne    800549 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800540:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800547:	eb 12                	jmp    80055b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800549:	ff 45 e8             	incl   -0x18(%ebp)
  80054c:	a1 20 30 80 00       	mov    0x803020,%eax
  800551:	8b 50 74             	mov    0x74(%eax),%edx
  800554:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800557:	39 c2                	cmp    %eax,%edx
  800559:	77 88                	ja     8004e3 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80055b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80055f:	75 14                	jne    800575 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800561:	83 ec 04             	sub    $0x4,%esp
  800564:	68 a0 20 80 00       	push   $0x8020a0
  800569:	6a 3a                	push   $0x3a
  80056b:	68 94 20 80 00       	push   $0x802094
  800570:	e8 93 fe ff ff       	call   800408 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800575:	ff 45 f0             	incl   -0x10(%ebp)
  800578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80057e:	0f 8c 32 ff ff ff    	jl     8004b6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800592:	eb 26                	jmp    8005ba <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800594:	a1 20 30 80 00       	mov    0x803020,%eax
  800599:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80059f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	01 c0                	add    %eax,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	c1 e0 03             	shl    $0x3,%eax
  8005ab:	01 c8                	add    %ecx,%eax
  8005ad:	8a 40 04             	mov    0x4(%eax),%al
  8005b0:	3c 01                	cmp    $0x1,%al
  8005b2:	75 03                	jne    8005b7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005b4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b7:	ff 45 e0             	incl   -0x20(%ebp)
  8005ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bf:	8b 50 74             	mov    0x74(%eax),%edx
  8005c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c5:	39 c2                	cmp    %eax,%edx
  8005c7:	77 cb                	ja     800594 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005cc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005cf:	74 14                	je     8005e5 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	68 f4 20 80 00       	push   $0x8020f4
  8005d9:	6a 44                	push   $0x44
  8005db:	68 94 20 80 00       	push   $0x802094
  8005e0:	e8 23 fe ff ff       	call   800408 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005e5:	90                   	nop
  8005e6:	c9                   	leave  
  8005e7:	c3                   	ret    

008005e8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005e8:	55                   	push   %ebp
  8005e9:	89 e5                	mov    %esp,%ebp
  8005eb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8005f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f9:	89 0a                	mov    %ecx,(%edx)
  8005fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8005fe:	88 d1                	mov    %dl,%cl
  800600:	8b 55 0c             	mov    0xc(%ebp),%edx
  800603:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800611:	75 2c                	jne    80063f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800613:	a0 24 30 80 00       	mov    0x803024,%al
  800618:	0f b6 c0             	movzbl %al,%eax
  80061b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061e:	8b 12                	mov    (%edx),%edx
  800620:	89 d1                	mov    %edx,%ecx
  800622:	8b 55 0c             	mov    0xc(%ebp),%edx
  800625:	83 c2 08             	add    $0x8,%edx
  800628:	83 ec 04             	sub    $0x4,%esp
  80062b:	50                   	push   %eax
  80062c:	51                   	push   %ecx
  80062d:	52                   	push   %edx
  80062e:	e8 3e 0e 00 00       	call   801471 <sys_cputs>
  800633:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800636:	8b 45 0c             	mov    0xc(%ebp),%eax
  800639:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80063f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800642:	8b 40 04             	mov    0x4(%eax),%eax
  800645:	8d 50 01             	lea    0x1(%eax),%edx
  800648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80064e:	90                   	nop
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80065a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800661:	00 00 00 
	b.cnt = 0;
  800664:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80066b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80066e:	ff 75 0c             	pushl  0xc(%ebp)
  800671:	ff 75 08             	pushl  0x8(%ebp)
  800674:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80067a:	50                   	push   %eax
  80067b:	68 e8 05 80 00       	push   $0x8005e8
  800680:	e8 11 02 00 00       	call   800896 <vprintfmt>
  800685:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800688:	a0 24 30 80 00       	mov    0x803024,%al
  80068d:	0f b6 c0             	movzbl %al,%eax
  800690:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800696:	83 ec 04             	sub    $0x4,%esp
  800699:	50                   	push   %eax
  80069a:	52                   	push   %edx
  80069b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a1:	83 c0 08             	add    $0x8,%eax
  8006a4:	50                   	push   %eax
  8006a5:	e8 c7 0d 00 00       	call   801471 <sys_cputs>
  8006aa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006ad:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8006b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    

008006bc <cprintf>:

int cprintf(const char *fmt, ...) {
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006c2:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8006c9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d8:	50                   	push   %eax
  8006d9:	e8 73 ff ff ff       	call   800651 <vcprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006ef:	e8 2b 0f 00 00       	call   80161f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006f4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 48 ff ff ff       	call   800651 <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80070f:	e8 25 0f 00 00       	call   801639 <sys_enable_interrupt>
	return cnt;
  800714:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800717:	c9                   	leave  
  800718:	c3                   	ret    

00800719 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	53                   	push   %ebx
  80071d:	83 ec 14             	sub    $0x14,%esp
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072c:	8b 45 18             	mov    0x18(%ebp),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800737:	77 55                	ja     80078e <printnum+0x75>
  800739:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073c:	72 05                	jb     800743 <printnum+0x2a>
  80073e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800741:	77 4b                	ja     80078e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800743:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800746:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800749:	8b 45 18             	mov    0x18(%ebp),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	52                   	push   %edx
  800752:	50                   	push   %eax
  800753:	ff 75 f4             	pushl  -0xc(%ebp)
  800756:	ff 75 f0             	pushl  -0x10(%ebp)
  800759:	e8 46 13 00 00       	call   801aa4 <__udivdi3>
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	83 ec 04             	sub    $0x4,%esp
  800764:	ff 75 20             	pushl  0x20(%ebp)
  800767:	53                   	push   %ebx
  800768:	ff 75 18             	pushl  0x18(%ebp)
  80076b:	52                   	push   %edx
  80076c:	50                   	push   %eax
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	ff 75 08             	pushl  0x8(%ebp)
  800773:	e8 a1 ff ff ff       	call   800719 <printnum>
  800778:	83 c4 20             	add    $0x20,%esp
  80077b:	eb 1a                	jmp    800797 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	ff 75 20             	pushl  0x20(%ebp)
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078e:	ff 4d 1c             	decl   0x1c(%ebp)
  800791:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800795:	7f e6                	jg     80077d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800797:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80079a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a5:	53                   	push   %ebx
  8007a6:	51                   	push   %ecx
  8007a7:	52                   	push   %edx
  8007a8:	50                   	push   %eax
  8007a9:	e8 06 14 00 00       	call   801bb4 <__umoddi3>
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	05 54 23 80 00       	add    $0x802354,%eax
  8007b6:	8a 00                	mov    (%eax),%al
  8007b8:	0f be c0             	movsbl %al,%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
}
  8007ca:	90                   	nop
  8007cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d7:	7e 1c                	jle    8007f5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	8d 50 08             	lea    0x8(%eax),%edx
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	89 10                	mov    %edx,(%eax)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	83 e8 08             	sub    $0x8,%eax
  8007ee:	8b 50 04             	mov    0x4(%eax),%edx
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	eb 40                	jmp    800835 <getuint+0x65>
	else if (lflag)
  8007f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f9:	74 1e                	je     800819 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	8d 50 04             	lea    0x4(%eax),%edx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	89 10                	mov    %edx,(%eax)
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	83 e8 04             	sub    $0x4,%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
  800817:	eb 1c                	jmp    800835 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	8d 50 04             	lea    0x4(%eax),%edx
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	89 10                	mov    %edx,(%eax)
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	83 e8 04             	sub    $0x4,%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80083a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80083e:	7e 1c                	jle    80085c <getint+0x25>
		return va_arg(*ap, long long);
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	8d 50 08             	lea    0x8(%eax),%edx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	89 10                	mov    %edx,(%eax)
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	8b 00                	mov    (%eax),%eax
  800852:	83 e8 08             	sub    $0x8,%eax
  800855:	8b 50 04             	mov    0x4(%eax),%edx
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	eb 38                	jmp    800894 <getint+0x5d>
	else if (lflag)
  80085c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800860:	74 1a                	je     80087c <getint+0x45>
		return va_arg(*ap, long);
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	8d 50 04             	lea    0x4(%eax),%edx
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	89 10                	mov    %edx,(%eax)
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	83 e8 04             	sub    $0x4,%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	99                   	cltd   
  80087a:	eb 18                	jmp    800894 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	99                   	cltd   
}
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089e:	eb 17                	jmp    8008b7 <vprintfmt+0x21>
			if (ch == '\0')
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	0f 84 af 03 00 00    	je     800c57 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	53                   	push   %ebx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	ff d0                	call   *%eax
  8008b4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ba:	8d 50 01             	lea    0x1(%eax),%edx
  8008bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8008c0:	8a 00                	mov    (%eax),%al
  8008c2:	0f b6 d8             	movzbl %al,%ebx
  8008c5:	83 fb 25             	cmp    $0x25,%ebx
  8008c8:	75 d6                	jne    8008a0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ce:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ed:	8d 50 01             	lea    0x1(%eax),%edx
  8008f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f3:	8a 00                	mov    (%eax),%al
  8008f5:	0f b6 d8             	movzbl %al,%ebx
  8008f8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008fb:	83 f8 55             	cmp    $0x55,%eax
  8008fe:	0f 87 2b 03 00 00    	ja     800c2f <vprintfmt+0x399>
  800904:	8b 04 85 78 23 80 00 	mov    0x802378(,%eax,4),%eax
  80090b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80090d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800911:	eb d7                	jmp    8008ea <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800913:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800917:	eb d1                	jmp    8008ea <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800919:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800920:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800923:	89 d0                	mov    %edx,%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	01 d0                	add    %edx,%eax
  80092a:	01 c0                	add    %eax,%eax
  80092c:	01 d8                	add    %ebx,%eax
  80092e:	83 e8 30             	sub    $0x30,%eax
  800931:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800934:	8b 45 10             	mov    0x10(%ebp),%eax
  800937:	8a 00                	mov    (%eax),%al
  800939:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093c:	83 fb 2f             	cmp    $0x2f,%ebx
  80093f:	7e 3e                	jle    80097f <vprintfmt+0xe9>
  800941:	83 fb 39             	cmp    $0x39,%ebx
  800944:	7f 39                	jg     80097f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800946:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800949:	eb d5                	jmp    800920 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 c0 04             	add    $0x4,%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 e8 04             	sub    $0x4,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80095f:	eb 1f                	jmp    800980 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800961:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800965:	79 83                	jns    8008ea <vprintfmt+0x54>
				width = 0;
  800967:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80096e:	e9 77 ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800973:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80097a:	e9 6b ff ff ff       	jmp    8008ea <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80097f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	0f 89 60 ff ff ff    	jns    8008ea <vprintfmt+0x54>
				width = precision, precision = -1;
  80098a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800990:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800997:	e9 4e ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80099f:	e9 46 ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	83 e8 04             	sub    $0x4,%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			break;
  8009c4:	e9 89 02 00 00       	jmp    800c52 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	83 c0 04             	add    $0x4,%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	83 e8 04             	sub    $0x4,%eax
  8009d8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009da:	85 db                	test   %ebx,%ebx
  8009dc:	79 02                	jns    8009e0 <vprintfmt+0x14a>
				err = -err;
  8009de:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009e0:	83 fb 64             	cmp    $0x64,%ebx
  8009e3:	7f 0b                	jg     8009f0 <vprintfmt+0x15a>
  8009e5:	8b 34 9d c0 21 80 00 	mov    0x8021c0(,%ebx,4),%esi
  8009ec:	85 f6                	test   %esi,%esi
  8009ee:	75 19                	jne    800a09 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009f0:	53                   	push   %ebx
  8009f1:	68 65 23 80 00       	push   $0x802365
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 5e 02 00 00       	call   800c5f <printfmt>
  800a01:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a04:	e9 49 02 00 00       	jmp    800c52 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a09:	56                   	push   %esi
  800a0a:	68 6e 23 80 00       	push   $0x80236e
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	ff 75 08             	pushl  0x8(%ebp)
  800a15:	e8 45 02 00 00       	call   800c5f <printfmt>
  800a1a:	83 c4 10             	add    $0x10,%esp
			break;
  800a1d:	e9 30 02 00 00       	jmp    800c52 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 c0 04             	add    $0x4,%eax
  800a28:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 e8 04             	sub    $0x4,%eax
  800a31:	8b 30                	mov    (%eax),%esi
  800a33:	85 f6                	test   %esi,%esi
  800a35:	75 05                	jne    800a3c <vprintfmt+0x1a6>
				p = "(null)";
  800a37:	be 71 23 80 00       	mov    $0x802371,%esi
			if (width > 0 && padc != '-')
  800a3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a40:	7e 6d                	jle    800aaf <vprintfmt+0x219>
  800a42:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a46:	74 67                	je     800aaf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	50                   	push   %eax
  800a4f:	56                   	push   %esi
  800a50:	e8 0c 03 00 00       	call   800d61 <strnlen>
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a5b:	eb 16                	jmp    800a73 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a5d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	50                   	push   %eax
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	ff d0                	call   *%eax
  800a6d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a70:	ff 4d e4             	decl   -0x1c(%ebp)
  800a73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a77:	7f e4                	jg     800a5d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a79:	eb 34                	jmp    800aaf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a7f:	74 1c                	je     800a9d <vprintfmt+0x207>
  800a81:	83 fb 1f             	cmp    $0x1f,%ebx
  800a84:	7e 05                	jle    800a8b <vprintfmt+0x1f5>
  800a86:	83 fb 7e             	cmp    $0x7e,%ebx
  800a89:	7e 12                	jle    800a9d <vprintfmt+0x207>
					putch('?', putdat);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 0c             	pushl  0xc(%ebp)
  800a91:	6a 3f                	push   $0x3f
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	ff d0                	call   *%eax
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	eb 0f                	jmp    800aac <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	53                   	push   %ebx
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aac:	ff 4d e4             	decl   -0x1c(%ebp)
  800aaf:	89 f0                	mov    %esi,%eax
  800ab1:	8d 70 01             	lea    0x1(%eax),%esi
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	0f be d8             	movsbl %al,%ebx
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	74 24                	je     800ae1 <vprintfmt+0x24b>
  800abd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac1:	78 b8                	js     800a7b <vprintfmt+0x1e5>
  800ac3:	ff 4d e0             	decl   -0x20(%ebp)
  800ac6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aca:	79 af                	jns    800a7b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acc:	eb 13                	jmp    800ae1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	6a 20                	push   $0x20
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	ff d0                	call   *%eax
  800adb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ade:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae5:	7f e7                	jg     800ace <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae7:	e9 66 01 00 00       	jmp    800c52 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 e8             	pushl  -0x18(%ebp)
  800af2:	8d 45 14             	lea    0x14(%ebp),%eax
  800af5:	50                   	push   %eax
  800af6:	e8 3c fd ff ff       	call   800837 <getint>
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0a:	85 d2                	test   %edx,%edx
  800b0c:	79 23                	jns    800b31 <vprintfmt+0x29b>
				putch('-', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	6a 2d                	push   $0x2d
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	ff d0                	call   *%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b24:	f7 d8                	neg    %eax
  800b26:	83 d2 00             	adc    $0x0,%edx
  800b29:	f7 da                	neg    %edx
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b31:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b38:	e9 bc 00 00 00       	jmp    800bf9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 e8             	pushl  -0x18(%ebp)
  800b43:	8d 45 14             	lea    0x14(%ebp),%eax
  800b46:	50                   	push   %eax
  800b47:	e8 84 fc ff ff       	call   8007d0 <getuint>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b55:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5c:	e9 98 00 00 00       	jmp    800bf9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	6a 58                	push   $0x58
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	ff d0                	call   *%eax
  800b6e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b71:	83 ec 08             	sub    $0x8,%esp
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	6a 58                	push   $0x58
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 58                	push   $0x58
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			break;
  800b91:	e9 bc 00 00 00       	jmp    800c52 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	6a 30                	push   $0x30
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	6a 78                	push   $0x78
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	83 e8 04             	sub    $0x4,%eax
  800bc5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bd1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd8:	eb 1f                	jmp    800bf9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 e8             	pushl  -0x18(%ebp)
  800be0:	8d 45 14             	lea    0x14(%ebp),%eax
  800be3:	50                   	push   %eax
  800be4:	e8 e7 fb ff ff       	call   8007d0 <getuint>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c00:	83 ec 04             	sub    $0x4,%esp
  800c03:	52                   	push   %edx
  800c04:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c07:	50                   	push   %eax
  800c08:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0b:	ff 75 f0             	pushl  -0x10(%ebp)
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	ff 75 08             	pushl  0x8(%ebp)
  800c14:	e8 00 fb ff ff       	call   800719 <printnum>
  800c19:	83 c4 20             	add    $0x20,%esp
			break;
  800c1c:	eb 34                	jmp    800c52 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	53                   	push   %ebx
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	ff d0                	call   *%eax
  800c2a:	83 c4 10             	add    $0x10,%esp
			break;
  800c2d:	eb 23                	jmp    800c52 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 25                	push   $0x25
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c3f:	ff 4d 10             	decl   0x10(%ebp)
  800c42:	eb 03                	jmp    800c47 <vprintfmt+0x3b1>
  800c44:	ff 4d 10             	decl   0x10(%ebp)
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4a:	48                   	dec    %eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	3c 25                	cmp    $0x25,%al
  800c4f:	75 f3                	jne    800c44 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c51:	90                   	nop
		}
	}
  800c52:	e9 47 fc ff ff       	jmp    80089e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c57:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c65:	8d 45 10             	lea    0x10(%ebp),%eax
  800c68:	83 c0 04             	add    $0x4,%eax
  800c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c71:	ff 75 f4             	pushl  -0xc(%ebp)
  800c74:	50                   	push   %eax
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	ff 75 08             	pushl  0x8(%ebp)
  800c7b:	e8 16 fc ff ff       	call   800896 <vprintfmt>
  800c80:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c83:	90                   	nop
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 08             	mov    0x8(%eax),%eax
  800c8f:	8d 50 01             	lea    0x1(%eax),%edx
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8b 10                	mov    (%eax),%edx
  800c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca0:	8b 40 04             	mov    0x4(%eax),%eax
  800ca3:	39 c2                	cmp    %eax,%edx
  800ca5:	73 12                	jae    800cb9 <sprintputch+0x33>
		*b->buf++ = ch;
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	8d 48 01             	lea    0x1(%eax),%ecx
  800caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb2:	89 0a                	mov    %ecx,(%edx)
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	88 10                	mov    %dl,(%eax)
}
  800cb9:	90                   	nop
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ce1:	74 06                	je     800ce9 <vsnprintf+0x2d>
  800ce3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce7:	7f 07                	jg     800cf0 <vsnprintf+0x34>
		return -E_INVAL;
  800ce9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cee:	eb 20                	jmp    800d10 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cf0:	ff 75 14             	pushl  0x14(%ebp)
  800cf3:	ff 75 10             	pushl  0x10(%ebp)
  800cf6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cf9:	50                   	push   %eax
  800cfa:	68 86 0c 80 00       	push   $0x800c86
  800cff:	e8 92 fb ff ff       	call   800896 <vprintfmt>
  800d04:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d0a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d18:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1b:	83 c0 04             	add    $0x4,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	50                   	push   %eax
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 89 ff ff ff       	call   800cbc <vsnprintf>
  800d33:	83 c4 10             	add    $0x10,%esp
  800d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    

00800d3e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d4b:	eb 06                	jmp    800d53 <strlen+0x15>
		n++;
  800d4d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	84 c0                	test   %al,%al
  800d5a:	75 f1                	jne    800d4d <strlen+0xf>
		n++;
	return n;
  800d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5f:	c9                   	leave  
  800d60:	c3                   	ret    

00800d61 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d6e:	eb 09                	jmp    800d79 <strnlen+0x18>
		n++;
  800d70:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d73:	ff 45 08             	incl   0x8(%ebp)
  800d76:	ff 4d 0c             	decl   0xc(%ebp)
  800d79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7d:	74 09                	je     800d88 <strnlen+0x27>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	84 c0                	test   %al,%al
  800d86:	75 e8                	jne    800d70 <strnlen+0xf>
		n++;
	return n;
  800d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8b:	c9                   	leave  
  800d8c:	c3                   	ret    

00800d8d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d99:	90                   	nop
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8d 50 01             	lea    0x1(%eax),%edx
  800da0:	89 55 08             	mov    %edx,0x8(%ebp)
  800da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dac:	8a 12                	mov    (%edx),%dl
  800dae:	88 10                	mov    %dl,(%eax)
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	84 c0                	test   %al,%al
  800db4:	75 e4                	jne    800d9a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dce:	eb 1f                	jmp    800def <strncpy+0x34>
		*dst++ = *src;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8d 50 01             	lea    0x1(%eax),%edx
  800dd6:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddc:	8a 12                	mov    (%edx),%dl
  800dde:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	84 c0                	test   %al,%al
  800de7:	74 03                	je     800dec <strncpy+0x31>
			src++;
  800de9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
  800def:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df5:	72 d9                	jb     800dd0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0c:	74 30                	je     800e3e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e0e:	eb 16                	jmp    800e26 <strlcpy+0x2a>
			*dst++ = *src++;
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8d 50 01             	lea    0x1(%eax),%edx
  800e16:	89 55 08             	mov    %edx,0x8(%ebp)
  800e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e22:	8a 12                	mov    (%edx),%dl
  800e24:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e26:	ff 4d 10             	decl   0x10(%ebp)
  800e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2d:	74 09                	je     800e38 <strlcpy+0x3c>
  800e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	84 c0                	test   %al,%al
  800e36:	75 d8                	jne    800e10 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e44:	29 c2                	sub    %eax,%edx
  800e46:	89 d0                	mov    %edx,%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e4d:	eb 06                	jmp    800e55 <strcmp+0xb>
		p++, q++;
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	84 c0                	test   %al,%al
  800e5c:	74 0e                	je     800e6c <strcmp+0x22>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 10                	mov    (%eax),%dl
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	38 c2                	cmp    %al,%dl
  800e6a:	74 e3                	je     800e4f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	0f b6 d0             	movzbl %al,%edx
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	0f b6 c0             	movzbl %al,%eax
  800e7c:	29 c2                	sub    %eax,%edx
  800e7e:	89 d0                	mov    %edx,%eax
}
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e85:	eb 09                	jmp    800e90 <strncmp+0xe>
		n--, p++, q++;
  800e87:	ff 4d 10             	decl   0x10(%ebp)
  800e8a:	ff 45 08             	incl   0x8(%ebp)
  800e8d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e94:	74 17                	je     800ead <strncmp+0x2b>
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	84 c0                	test   %al,%al
  800e9d:	74 0e                	je     800ead <strncmp+0x2b>
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8a 10                	mov    (%eax),%dl
  800ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	38 c2                	cmp    %al,%dl
  800eab:	74 da                	je     800e87 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ead:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb1:	75 07                	jne    800eba <strncmp+0x38>
		return 0;
  800eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb8:	eb 14                	jmp    800ece <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	0f b6 d0             	movzbl %al,%edx
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	0f b6 c0             	movzbl %al,%eax
  800eca:	29 c2                	sub    %eax,%edx
  800ecc:	89 d0                	mov    %edx,%eax
}
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 04             	sub    $0x4,%esp
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800edc:	eb 12                	jmp    800ef0 <strchr+0x20>
		if (*s == c)
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee6:	75 05                	jne    800eed <strchr+0x1d>
			return (char *) s;
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	eb 11                	jmp    800efe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eed:	ff 45 08             	incl   0x8(%ebp)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	84 c0                	test   %al,%al
  800ef7:	75 e5                	jne    800ede <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ef9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 04             	sub    $0x4,%esp
  800f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f09:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f0c:	eb 0d                	jmp    800f1b <strfind+0x1b>
		if (*s == c)
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f16:	74 0e                	je     800f26 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f18:	ff 45 08             	incl   0x8(%ebp)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	84 c0                	test   %al,%al
  800f22:	75 ea                	jne    800f0e <strfind+0xe>
  800f24:	eb 01                	jmp    800f27 <strfind+0x27>
		if (*s == c)
			break;
  800f26:	90                   	nop
	return (char *) s;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f3e:	eb 0e                	jmp    800f4e <memset+0x22>
		*p++ = c;
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	8d 50 01             	lea    0x1(%eax),%edx
  800f46:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f4e:	ff 4d f8             	decl   -0x8(%ebp)
  800f51:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f55:	79 e9                	jns    800f40 <memset+0x14>
		*p++ = c;

	return v;
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f6e:	eb 16                	jmp    800f86 <memcpy+0x2a>
		*d++ = *s++;
  800f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f73:	8d 50 01             	lea    0x1(%eax),%edx
  800f76:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f82:	8a 12                	mov    (%edx),%dl
  800f84:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	75 dd                	jne    800f70 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb0:	73 50                	jae    801002 <memmove+0x6a>
  800fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	01 d0                	add    %edx,%eax
  800fba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbd:	76 43                	jbe    801002 <memmove+0x6a>
		s += n;
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcb:	eb 10                	jmp    800fdd <memmove+0x45>
			*--d = *--s;
  800fcd:	ff 4d f8             	decl   -0x8(%ebp)
  800fd0:	ff 4d fc             	decl   -0x4(%ebp)
  800fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd6:	8a 10                	mov    (%eax),%dl
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	75 e3                	jne    800fcd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fea:	eb 23                	jmp    80100f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fef:	8d 50 01             	lea    0x1(%eax),%edx
  800ff2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ffe:	8a 12                	mov    (%edx),%dl
  801000:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801002:	8b 45 10             	mov    0x10(%ebp),%eax
  801005:	8d 50 ff             	lea    -0x1(%eax),%edx
  801008:	89 55 10             	mov    %edx,0x10(%ebp)
  80100b:	85 c0                	test   %eax,%eax
  80100d:	75 dd                	jne    800fec <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801026:	eb 2a                	jmp    801052 <memcmp+0x3e>
		if (*s1 != *s2)
  801028:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102b:	8a 10                	mov    (%eax),%dl
  80102d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	38 c2                	cmp    %al,%dl
  801034:	74 16                	je     80104c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801036:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 d0             	movzbl %al,%edx
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f b6 c0             	movzbl %al,%eax
  801046:	29 c2                	sub    %eax,%edx
  801048:	89 d0                	mov    %edx,%eax
  80104a:	eb 18                	jmp    801064 <memcmp+0x50>
		s1++, s2++;
  80104c:	ff 45 fc             	incl   -0x4(%ebp)
  80104f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	8d 50 ff             	lea    -0x1(%eax),%edx
  801058:	89 55 10             	mov    %edx,0x10(%ebp)
  80105b:	85 c0                	test   %eax,%eax
  80105d:	75 c9                	jne    801028 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106c:	8b 55 08             	mov    0x8(%ebp),%edx
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801077:	eb 15                	jmp    80108e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	0f b6 d0             	movzbl %al,%edx
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	0f b6 c0             	movzbl %al,%eax
  801087:	39 c2                	cmp    %eax,%edx
  801089:	74 0d                	je     801098 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801094:	72 e3                	jb     801079 <memfind+0x13>
  801096:	eb 01                	jmp    801099 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801098:	90                   	nop
	return (void *) s;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b2:	eb 03                	jmp    8010b7 <strtol+0x19>
		s++;
  8010b4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 20                	cmp    $0x20,%al
  8010be:	74 f4                	je     8010b4 <strtol+0x16>
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 09                	cmp    $0x9,%al
  8010c7:	74 eb                	je     8010b4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 2b                	cmp    $0x2b,%al
  8010d0:	75 05                	jne    8010d7 <strtol+0x39>
		s++;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	eb 13                	jmp    8010ea <strtol+0x4c>
	else if (*s == '-')
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 2d                	cmp    $0x2d,%al
  8010de:	75 0a                	jne    8010ea <strtol+0x4c>
		s++, neg = 1;
  8010e0:	ff 45 08             	incl   0x8(%ebp)
  8010e3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ee:	74 06                	je     8010f6 <strtol+0x58>
  8010f0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f4:	75 20                	jne    801116 <strtol+0x78>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 30                	cmp    $0x30,%al
  8010fd:	75 17                	jne    801116 <strtol+0x78>
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	40                   	inc    %eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 78                	cmp    $0x78,%al
  801107:	75 0d                	jne    801116 <strtol+0x78>
		s += 2, base = 16;
  801109:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801114:	eb 28                	jmp    80113e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801116:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111a:	75 15                	jne    801131 <strtol+0x93>
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 30                	cmp    $0x30,%al
  801123:	75 0c                	jne    801131 <strtol+0x93>
		s++, base = 8;
  801125:	ff 45 08             	incl   0x8(%ebp)
  801128:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112f:	eb 0d                	jmp    80113e <strtol+0xa0>
	else if (base == 0)
  801131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801135:	75 07                	jne    80113e <strtol+0xa0>
		base = 10;
  801137:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	3c 2f                	cmp    $0x2f,%al
  801145:	7e 19                	jle    801160 <strtol+0xc2>
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 39                	cmp    $0x39,%al
  80114e:	7f 10                	jg     801160 <strtol+0xc2>
			dig = *s - '0';
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f be c0             	movsbl %al,%eax
  801158:	83 e8 30             	sub    $0x30,%eax
  80115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115e:	eb 42                	jmp    8011a2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 60                	cmp    $0x60,%al
  801167:	7e 19                	jle    801182 <strtol+0xe4>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	3c 7a                	cmp    $0x7a,%al
  801170:	7f 10                	jg     801182 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f be c0             	movsbl %al,%eax
  80117a:	83 e8 57             	sub    $0x57,%eax
  80117d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801180:	eb 20                	jmp    8011a2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 40                	cmp    $0x40,%al
  801189:	7e 39                	jle    8011c4 <strtol+0x126>
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	3c 5a                	cmp    $0x5a,%al
  801192:	7f 30                	jg     8011c4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f be c0             	movsbl %al,%eax
  80119c:	83 e8 37             	sub    $0x37,%eax
  80119f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a8:	7d 19                	jge    8011c3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b9:	01 d0                	add    %edx,%eax
  8011bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011be:	e9 7b ff ff ff       	jmp    80113e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c8:	74 08                	je     8011d2 <strtol+0x134>
		*endptr = (char *) s;
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d6:	74 07                	je     8011df <strtol+0x141>
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	f7 d8                	neg    %eax
  8011dd:	eb 03                	jmp    8011e2 <strtol+0x144>
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fc:	79 13                	jns    801211 <ltostr+0x2d>
	{
		neg = 1;
  8011fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801219:	99                   	cltd   
  80121a:	f7 f9                	idiv   %ecx
  80121c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801228:	89 c2                	mov    %eax,%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801232:	83 c2 30             	add    $0x30,%edx
  801235:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123f:	f7 e9                	imul   %ecx
  801241:	c1 fa 02             	sar    $0x2,%edx
  801244:	89 c8                	mov    %ecx,%eax
  801246:	c1 f8 1f             	sar    $0x1f,%eax
  801249:	29 c2                	sub    %eax,%edx
  80124b:	89 d0                	mov    %edx,%eax
  80124d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801253:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801258:	f7 e9                	imul   %ecx
  80125a:	c1 fa 02             	sar    $0x2,%edx
  80125d:	89 c8                	mov    %ecx,%eax
  80125f:	c1 f8 1f             	sar    $0x1f,%eax
  801262:	29 c2                	sub    %eax,%edx
  801264:	89 d0                	mov    %edx,%eax
  801266:	c1 e0 02             	shl    $0x2,%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	01 c0                	add    %eax,%eax
  80126d:	29 c1                	sub    %eax,%ecx
  80126f:	89 ca                	mov    %ecx,%edx
  801271:	85 d2                	test   %edx,%edx
  801273:	75 9c                	jne    801211 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80127c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127f:	48                   	dec    %eax
  801280:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801283:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801287:	74 3d                	je     8012c6 <ltostr+0xe2>
		start = 1 ;
  801289:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801290:	eb 34                	jmp    8012c6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	01 d0                	add    %edx,%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80129f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c8                	add    %ecx,%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c2                	add    %eax,%edx
  8012bb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012be:	88 02                	mov    %al,(%edx)
		start++ ;
  8012c0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012c3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012cc:	7c c4                	jl     801292 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	01 d0                	add    %edx,%eax
  8012d6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012d9:	90                   	nop
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e2:	ff 75 08             	pushl  0x8(%ebp)
  8012e5:	e8 54 fa ff ff       	call   800d3e <strlen>
  8012ea:	83 c4 04             	add    $0x4,%esp
  8012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	e8 46 fa ff ff       	call   800d3e <strlen>
  8012f8:	83 c4 04             	add    $0x4,%esp
  8012fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130c:	eb 17                	jmp    801325 <strcconcat+0x49>
		final[s] = str1[s] ;
  80130e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801311:	8b 45 10             	mov    0x10(%ebp),%eax
  801314:	01 c2                	add    %eax,%edx
  801316:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	01 c8                	add    %ecx,%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801322:	ff 45 fc             	incl   -0x4(%ebp)
  801325:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801328:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80132b:	7c e1                	jl     80130e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80132d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801334:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80133b:	eb 1f                	jmp    80135c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801346:	89 c2                	mov    %eax,%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 c2                	add    %eax,%edx
  80134d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801350:	8b 45 0c             	mov    0xc(%ebp),%eax
  801353:	01 c8                	add    %ecx,%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801359:	ff 45 f8             	incl   -0x8(%ebp)
  80135c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801362:	7c d9                	jl     80133d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801364:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801367:	8b 45 10             	mov    0x10(%ebp),%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	c6 00 00             	movb   $0x0,(%eax)
}
  80136f:	90                   	nop
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801375:	8b 45 14             	mov    0x14(%ebp),%eax
  801378:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80137e:	8b 45 14             	mov    0x14(%ebp),%eax
  801381:	8b 00                	mov    (%eax),%eax
  801383:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138a:	8b 45 10             	mov    0x10(%ebp),%eax
  80138d:	01 d0                	add    %edx,%eax
  80138f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801395:	eb 0c                	jmp    8013a3 <strsplit+0x31>
			*string++ = 0;
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8d 50 01             	lea    0x1(%eax),%edx
  80139d:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 00                	mov    (%eax),%al
  8013a8:	84 c0                	test   %al,%al
  8013aa:	74 18                	je     8013c4 <strsplit+0x52>
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	0f be c0             	movsbl %al,%eax
  8013b4:	50                   	push   %eax
  8013b5:	ff 75 0c             	pushl  0xc(%ebp)
  8013b8:	e8 13 fb ff ff       	call   800ed0 <strchr>
  8013bd:	83 c4 08             	add    $0x8,%esp
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	75 d3                	jne    801397 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	84 c0                	test   %al,%al
  8013cb:	74 5a                	je     801427 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d0:	8b 00                	mov    (%eax),%eax
  8013d2:	83 f8 0f             	cmp    $0xf,%eax
  8013d5:	75 07                	jne    8013de <strsplit+0x6c>
		{
			return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 66                	jmp    801444 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013de:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e1:	8b 00                	mov    (%eax),%eax
  8013e3:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e6:	8b 55 14             	mov    0x14(%ebp),%edx
  8013e9:	89 0a                	mov    %ecx,(%edx)
  8013eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f5:	01 c2                	add    %eax,%edx
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fc:	eb 03                	jmp    801401 <strsplit+0x8f>
			string++;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	84 c0                	test   %al,%al
  801408:	74 8b                	je     801395 <strsplit+0x23>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	0f be c0             	movsbl %al,%eax
  801412:	50                   	push   %eax
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	e8 b5 fa ff ff       	call   800ed0 <strchr>
  80141b:	83 c4 08             	add    $0x8,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	74 dc                	je     8013fe <strsplit+0x8c>
			string++;
	}
  801422:	e9 6e ff ff ff       	jmp    801395 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801427:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801428:	8b 45 14             	mov    0x14(%ebp),%eax
  80142b:	8b 00                	mov    (%eax),%eax
  80142d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801434:	8b 45 10             	mov    0x10(%ebp),%eax
  801437:	01 d0                	add    %edx,%eax
  801439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80143f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	57                   	push   %edi
  80144a:	56                   	push   %esi
  80144b:	53                   	push   %ebx
  80144c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	8b 55 0c             	mov    0xc(%ebp),%edx
  801455:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801458:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80145b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80145e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801461:	cd 30                	int    $0x30
  801463:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801466:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5e                   	pop    %esi
  80146e:	5f                   	pop    %edi
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    

00801471 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80147d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	52                   	push   %edx
  801489:	ff 75 0c             	pushl  0xc(%ebp)
  80148c:	50                   	push   %eax
  80148d:	6a 00                	push   $0x0
  80148f:	e8 b2 ff ff ff       	call   801446 <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	90                   	nop
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <sys_cgetc>:

int
sys_cgetc(void)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 01                	push   $0x1
  8014a9:	e8 98 ff ff ff       	call   801446 <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	52                   	push   %edx
  8014c3:	50                   	push   %eax
  8014c4:	6a 05                	push   $0x5
  8014c6:	e8 7b ff ff ff       	call   801446 <syscall>
  8014cb:	83 c4 18             	add    $0x18,%esp
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014d5:	8b 75 18             	mov    0x18(%ebp),%esi
  8014d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	56                   	push   %esi
  8014e5:	53                   	push   %ebx
  8014e6:	51                   	push   %ecx
  8014e7:	52                   	push   %edx
  8014e8:	50                   	push   %eax
  8014e9:	6a 06                	push   $0x6
  8014eb:	e8 56 ff ff ff       	call   801446 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f6:	5b                   	pop    %ebx
  8014f7:	5e                   	pop    %esi
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    

008014fa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	52                   	push   %edx
  80150a:	50                   	push   %eax
  80150b:	6a 07                	push   $0x7
  80150d:	e8 34 ff ff ff       	call   801446 <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	ff 75 08             	pushl  0x8(%ebp)
  801526:	6a 08                	push   $0x8
  801528:	e8 19 ff ff ff       	call   801446 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 09                	push   $0x9
  801541:	e8 00 ff ff ff       	call   801446 <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 0a                	push   $0xa
  80155a:	e8 e7 fe ff ff       	call   801446 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 0b                	push   $0xb
  801573:	e8 ce fe ff ff       	call   801446 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	ff 75 08             	pushl  0x8(%ebp)
  80158c:	6a 0f                	push   $0xf
  80158e:	e8 b3 fe ff ff       	call   801446 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
	return;
  801596:	90                   	nop
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	ff 75 0c             	pushl  0xc(%ebp)
  8015a5:	ff 75 08             	pushl  0x8(%ebp)
  8015a8:	6a 10                	push   $0x10
  8015aa:	e8 97 fe ff ff       	call   801446 <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b2:	90                   	nop
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	ff 75 10             	pushl  0x10(%ebp)
  8015bf:	ff 75 0c             	pushl  0xc(%ebp)
  8015c2:	ff 75 08             	pushl  0x8(%ebp)
  8015c5:	6a 11                	push   $0x11
  8015c7:	e8 7a fe ff ff       	call   801446 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8015cf:	90                   	nop
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 0c                	push   $0xc
  8015e1:	e8 60 fe ff ff       	call   801446 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	ff 75 08             	pushl  0x8(%ebp)
  8015f9:	6a 0d                	push   $0xd
  8015fb:	e8 46 fe ff ff       	call   801446 <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 0e                	push   $0xe
  801614:	e8 2d fe ff ff       	call   801446 <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	90                   	nop
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 13                	push   $0x13
  80162e:	e8 13 fe ff ff       	call   801446 <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 14                	push   $0x14
  801648:	e8 f9 fd ff ff       	call   801446 <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	90                   	nop
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_cputc>:


void
sys_cputc(const char c)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80165f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	50                   	push   %eax
  80166c:	6a 15                	push   $0x15
  80166e:	e8 d3 fd ff ff       	call   801446 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	90                   	nop
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 16                	push   $0x16
  801688:	e8 b9 fd ff ff       	call   801446 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	ff 75 0c             	pushl  0xc(%ebp)
  8016a2:	50                   	push   %eax
  8016a3:	6a 17                	push   $0x17
  8016a5:	e8 9c fd ff ff       	call   801446 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	52                   	push   %edx
  8016bf:	50                   	push   %eax
  8016c0:	6a 1a                	push   $0x1a
  8016c2:	e8 7f fd ff ff       	call   801446 <syscall>
  8016c7:	83 c4 18             	add    $0x18,%esp
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	52                   	push   %edx
  8016dc:	50                   	push   %eax
  8016dd:	6a 18                	push   $0x18
  8016df:	e8 62 fd ff ff       	call   801446 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	90                   	nop
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	52                   	push   %edx
  8016fa:	50                   	push   %eax
  8016fb:	6a 19                	push   $0x19
  8016fd:	e8 44 fd ff ff       	call   801446 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	90                   	nop
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	8b 45 10             	mov    0x10(%ebp),%eax
  801711:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801714:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801717:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	6a 00                	push   $0x0
  801720:	51                   	push   %ecx
  801721:	52                   	push   %edx
  801722:	ff 75 0c             	pushl  0xc(%ebp)
  801725:	50                   	push   %eax
  801726:	6a 1b                	push   $0x1b
  801728:	e8 19 fd ff ff       	call   801446 <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801735:	8b 55 0c             	mov    0xc(%ebp),%edx
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	52                   	push   %edx
  801742:	50                   	push   %eax
  801743:	6a 1c                	push   $0x1c
  801745:	e8 fc fc ff ff       	call   801446 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801752:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801755:	8b 55 0c             	mov    0xc(%ebp),%edx
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	51                   	push   %ecx
  801760:	52                   	push   %edx
  801761:	50                   	push   %eax
  801762:	6a 1d                	push   $0x1d
  801764:	e8 dd fc ff ff       	call   801446 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801771:	8b 55 0c             	mov    0xc(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	52                   	push   %edx
  80177e:	50                   	push   %eax
  80177f:	6a 1e                	push   $0x1e
  801781:	e8 c0 fc ff ff       	call   801446 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 1f                	push   $0x1f
  80179a:	e8 a7 fc ff ff       	call   801446 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	ff 75 14             	pushl  0x14(%ebp)
  8017af:	ff 75 10             	pushl  0x10(%ebp)
  8017b2:	ff 75 0c             	pushl  0xc(%ebp)
  8017b5:	50                   	push   %eax
  8017b6:	6a 20                	push   $0x20
  8017b8:	e8 89 fc ff ff       	call   801446 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	50                   	push   %eax
  8017d1:	6a 21                	push   $0x21
  8017d3:	e8 6e fc ff ff       	call   801446 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	90                   	nop
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	50                   	push   %eax
  8017ed:	6a 22                	push   $0x22
  8017ef:	e8 52 fc ff ff       	call   801446 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 02                	push   $0x2
  801808:	e8 39 fc ff ff       	call   801446 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 03                	push   $0x3
  801821:	e8 20 fc ff ff       	call   801446 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 04                	push   $0x4
  80183a:	e8 07 fc ff ff       	call   801446 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_exit_env>:


void sys_exit_env(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 23                	push   $0x23
  801853:	e8 ee fb ff ff       	call   801446 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	90                   	nop
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801864:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801867:	8d 50 04             	lea    0x4(%eax),%edx
  80186a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	52                   	push   %edx
  801874:	50                   	push   %eax
  801875:	6a 24                	push   $0x24
  801877:	e8 ca fb ff ff       	call   801446 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
	return result;
  80187f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801888:	89 01                	mov    %eax,(%ecx)
  80188a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	c9                   	leave  
  801891:	c2 04 00             	ret    $0x4

00801894 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	ff 75 10             	pushl  0x10(%ebp)
  80189e:	ff 75 0c             	pushl  0xc(%ebp)
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	6a 12                	push   $0x12
  8018a6:	e8 9b fb ff ff       	call   801446 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ae:	90                   	nop
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 25                	push   $0x25
  8018c0:	e8 81 fb ff ff       	call   801446 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018d6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	50                   	push   %eax
  8018e3:	6a 26                	push   $0x26
  8018e5:	e8 5c fb ff ff       	call   801446 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ed:	90                   	nop
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <rsttst>:
void rsttst()
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 28                	push   $0x28
  8018ff:	e8 42 fb ff ff       	call   801446 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
	return ;
  801907:	90                   	nop
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	8b 45 14             	mov    0x14(%ebp),%eax
  801913:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801916:	8b 55 18             	mov    0x18(%ebp),%edx
  801919:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	ff 75 10             	pushl  0x10(%ebp)
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 27                	push   $0x27
  80192a:	e8 17 fb ff ff       	call   801446 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
	return ;
  801932:	90                   	nop
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <chktst>:
void chktst(uint32 n)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	ff 75 08             	pushl  0x8(%ebp)
  801943:	6a 29                	push   $0x29
  801945:	e8 fc fa ff ff       	call   801446 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
	return ;
  80194d:	90                   	nop
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <inctst>:

void inctst()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 2a                	push   $0x2a
  80195f:	e8 e2 fa ff ff       	call   801446 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
	return ;
  801967:	90                   	nop
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <gettst>:
uint32 gettst()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 2b                	push   $0x2b
  801979:	e8 c8 fa ff ff       	call   801446 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 2c                	push   $0x2c
  801995:	e8 ac fa ff ff       	call   801446 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
  80199d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019a4:	75 07                	jne    8019ad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ab:	eb 05                	jmp    8019b2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 2c                	push   $0x2c
  8019c6:	e8 7b fa ff ff       	call   801446 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
  8019ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019d1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019d5:	75 07                	jne    8019de <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019dc:	eb 05                	jmp    8019e3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 2c                	push   $0x2c
  8019f7:	e8 4a fa ff ff       	call   801446 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
  8019ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a02:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a06:	75 07                	jne    801a0f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a08:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0d:	eb 05                	jmp    801a14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 2c                	push   $0x2c
  801a28:	e8 19 fa ff ff       	call   801446 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
  801a30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a33:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a37:	75 07                	jne    801a40 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3e:	eb 05                	jmp    801a45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	6a 2d                	push   $0x2d
  801a57:	e8 ea f9 ff ff       	call   801446 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5f:	90                   	nop
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	53                   	push   %ebx
  801a75:	51                   	push   %ecx
  801a76:	52                   	push   %edx
  801a77:	50                   	push   %eax
  801a78:	6a 2e                	push   $0x2e
  801a7a:	e8 c7 f9 ff ff       	call   801446 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	52                   	push   %edx
  801a97:	50                   	push   %eax
  801a98:	6a 2f                	push   $0x2f
  801a9a:	e8 a7 f9 ff ff       	call   801446 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <__udivdi3>:
  801aa4:	55                   	push   %ebp
  801aa5:	57                   	push   %edi
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 1c             	sub    $0x1c,%esp
  801aab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aaf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ab7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801abb:	89 ca                	mov    %ecx,%edx
  801abd:	89 f8                	mov    %edi,%eax
  801abf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ac3:	85 f6                	test   %esi,%esi
  801ac5:	75 2d                	jne    801af4 <__udivdi3+0x50>
  801ac7:	39 cf                	cmp    %ecx,%edi
  801ac9:	77 65                	ja     801b30 <__udivdi3+0x8c>
  801acb:	89 fd                	mov    %edi,%ebp
  801acd:	85 ff                	test   %edi,%edi
  801acf:	75 0b                	jne    801adc <__udivdi3+0x38>
  801ad1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad6:	31 d2                	xor    %edx,%edx
  801ad8:	f7 f7                	div    %edi
  801ada:	89 c5                	mov    %eax,%ebp
  801adc:	31 d2                	xor    %edx,%edx
  801ade:	89 c8                	mov    %ecx,%eax
  801ae0:	f7 f5                	div    %ebp
  801ae2:	89 c1                	mov    %eax,%ecx
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	f7 f5                	div    %ebp
  801ae8:	89 cf                	mov    %ecx,%edi
  801aea:	89 fa                	mov    %edi,%edx
  801aec:	83 c4 1c             	add    $0x1c,%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5f                   	pop    %edi
  801af2:	5d                   	pop    %ebp
  801af3:	c3                   	ret    
  801af4:	39 ce                	cmp    %ecx,%esi
  801af6:	77 28                	ja     801b20 <__udivdi3+0x7c>
  801af8:	0f bd fe             	bsr    %esi,%edi
  801afb:	83 f7 1f             	xor    $0x1f,%edi
  801afe:	75 40                	jne    801b40 <__udivdi3+0x9c>
  801b00:	39 ce                	cmp    %ecx,%esi
  801b02:	72 0a                	jb     801b0e <__udivdi3+0x6a>
  801b04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b08:	0f 87 9e 00 00 00    	ja     801bac <__udivdi3+0x108>
  801b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b13:	89 fa                	mov    %edi,%edx
  801b15:	83 c4 1c             	add    $0x1c,%esp
  801b18:	5b                   	pop    %ebx
  801b19:	5e                   	pop    %esi
  801b1a:	5f                   	pop    %edi
  801b1b:	5d                   	pop    %ebp
  801b1c:	c3                   	ret    
  801b1d:	8d 76 00             	lea    0x0(%esi),%esi
  801b20:	31 ff                	xor    %edi,%edi
  801b22:	31 c0                	xor    %eax,%eax
  801b24:	89 fa                	mov    %edi,%edx
  801b26:	83 c4 1c             	add    $0x1c,%esp
  801b29:	5b                   	pop    %ebx
  801b2a:	5e                   	pop    %esi
  801b2b:	5f                   	pop    %edi
  801b2c:	5d                   	pop    %ebp
  801b2d:	c3                   	ret    
  801b2e:	66 90                	xchg   %ax,%ax
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	f7 f7                	div    %edi
  801b34:	31 ff                	xor    %edi,%edi
  801b36:	89 fa                	mov    %edi,%edx
  801b38:	83 c4 1c             	add    $0x1c,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5f                   	pop    %edi
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    
  801b40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b45:	89 eb                	mov    %ebp,%ebx
  801b47:	29 fb                	sub    %edi,%ebx
  801b49:	89 f9                	mov    %edi,%ecx
  801b4b:	d3 e6                	shl    %cl,%esi
  801b4d:	89 c5                	mov    %eax,%ebp
  801b4f:	88 d9                	mov    %bl,%cl
  801b51:	d3 ed                	shr    %cl,%ebp
  801b53:	89 e9                	mov    %ebp,%ecx
  801b55:	09 f1                	or     %esi,%ecx
  801b57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b5b:	89 f9                	mov    %edi,%ecx
  801b5d:	d3 e0                	shl    %cl,%eax
  801b5f:	89 c5                	mov    %eax,%ebp
  801b61:	89 d6                	mov    %edx,%esi
  801b63:	88 d9                	mov    %bl,%cl
  801b65:	d3 ee                	shr    %cl,%esi
  801b67:	89 f9                	mov    %edi,%ecx
  801b69:	d3 e2                	shl    %cl,%edx
  801b6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b6f:	88 d9                	mov    %bl,%cl
  801b71:	d3 e8                	shr    %cl,%eax
  801b73:	09 c2                	or     %eax,%edx
  801b75:	89 d0                	mov    %edx,%eax
  801b77:	89 f2                	mov    %esi,%edx
  801b79:	f7 74 24 0c          	divl   0xc(%esp)
  801b7d:	89 d6                	mov    %edx,%esi
  801b7f:	89 c3                	mov    %eax,%ebx
  801b81:	f7 e5                	mul    %ebp
  801b83:	39 d6                	cmp    %edx,%esi
  801b85:	72 19                	jb     801ba0 <__udivdi3+0xfc>
  801b87:	74 0b                	je     801b94 <__udivdi3+0xf0>
  801b89:	89 d8                	mov    %ebx,%eax
  801b8b:	31 ff                	xor    %edi,%edi
  801b8d:	e9 58 ff ff ff       	jmp    801aea <__udivdi3+0x46>
  801b92:	66 90                	xchg   %ax,%ax
  801b94:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b98:	89 f9                	mov    %edi,%ecx
  801b9a:	d3 e2                	shl    %cl,%edx
  801b9c:	39 c2                	cmp    %eax,%edx
  801b9e:	73 e9                	jae    801b89 <__udivdi3+0xe5>
  801ba0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ba3:	31 ff                	xor    %edi,%edi
  801ba5:	e9 40 ff ff ff       	jmp    801aea <__udivdi3+0x46>
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	31 c0                	xor    %eax,%eax
  801bae:	e9 37 ff ff ff       	jmp    801aea <__udivdi3+0x46>
  801bb3:	90                   	nop

00801bb4 <__umoddi3>:
  801bb4:	55                   	push   %ebp
  801bb5:	57                   	push   %edi
  801bb6:	56                   	push   %esi
  801bb7:	53                   	push   %ebx
  801bb8:	83 ec 1c             	sub    $0x1c,%esp
  801bbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bcf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bd3:	89 f3                	mov    %esi,%ebx
  801bd5:	89 fa                	mov    %edi,%edx
  801bd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bdb:	89 34 24             	mov    %esi,(%esp)
  801bde:	85 c0                	test   %eax,%eax
  801be0:	75 1a                	jne    801bfc <__umoddi3+0x48>
  801be2:	39 f7                	cmp    %esi,%edi
  801be4:	0f 86 a2 00 00 00    	jbe    801c8c <__umoddi3+0xd8>
  801bea:	89 c8                	mov    %ecx,%eax
  801bec:	89 f2                	mov    %esi,%edx
  801bee:	f7 f7                	div    %edi
  801bf0:	89 d0                	mov    %edx,%eax
  801bf2:	31 d2                	xor    %edx,%edx
  801bf4:	83 c4 1c             	add    $0x1c,%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
  801bfc:	39 f0                	cmp    %esi,%eax
  801bfe:	0f 87 ac 00 00 00    	ja     801cb0 <__umoddi3+0xfc>
  801c04:	0f bd e8             	bsr    %eax,%ebp
  801c07:	83 f5 1f             	xor    $0x1f,%ebp
  801c0a:	0f 84 ac 00 00 00    	je     801cbc <__umoddi3+0x108>
  801c10:	bf 20 00 00 00       	mov    $0x20,%edi
  801c15:	29 ef                	sub    %ebp,%edi
  801c17:	89 fe                	mov    %edi,%esi
  801c19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c1d:	89 e9                	mov    %ebp,%ecx
  801c1f:	d3 e0                	shl    %cl,%eax
  801c21:	89 d7                	mov    %edx,%edi
  801c23:	89 f1                	mov    %esi,%ecx
  801c25:	d3 ef                	shr    %cl,%edi
  801c27:	09 c7                	or     %eax,%edi
  801c29:	89 e9                	mov    %ebp,%ecx
  801c2b:	d3 e2                	shl    %cl,%edx
  801c2d:	89 14 24             	mov    %edx,(%esp)
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	d3 e0                	shl    %cl,%eax
  801c34:	89 c2                	mov    %eax,%edx
  801c36:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3a:	d3 e0                	shl    %cl,%eax
  801c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c40:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c44:	89 f1                	mov    %esi,%ecx
  801c46:	d3 e8                	shr    %cl,%eax
  801c48:	09 d0                	or     %edx,%eax
  801c4a:	d3 eb                	shr    %cl,%ebx
  801c4c:	89 da                	mov    %ebx,%edx
  801c4e:	f7 f7                	div    %edi
  801c50:	89 d3                	mov    %edx,%ebx
  801c52:	f7 24 24             	mull   (%esp)
  801c55:	89 c6                	mov    %eax,%esi
  801c57:	89 d1                	mov    %edx,%ecx
  801c59:	39 d3                	cmp    %edx,%ebx
  801c5b:	0f 82 87 00 00 00    	jb     801ce8 <__umoddi3+0x134>
  801c61:	0f 84 91 00 00 00    	je     801cf8 <__umoddi3+0x144>
  801c67:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c6b:	29 f2                	sub    %esi,%edx
  801c6d:	19 cb                	sbb    %ecx,%ebx
  801c6f:	89 d8                	mov    %ebx,%eax
  801c71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c75:	d3 e0                	shl    %cl,%eax
  801c77:	89 e9                	mov    %ebp,%ecx
  801c79:	d3 ea                	shr    %cl,%edx
  801c7b:	09 d0                	or     %edx,%eax
  801c7d:	89 e9                	mov    %ebp,%ecx
  801c7f:	d3 eb                	shr    %cl,%ebx
  801c81:	89 da                	mov    %ebx,%edx
  801c83:	83 c4 1c             	add    $0x1c,%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5f                   	pop    %edi
  801c89:	5d                   	pop    %ebp
  801c8a:	c3                   	ret    
  801c8b:	90                   	nop
  801c8c:	89 fd                	mov    %edi,%ebp
  801c8e:	85 ff                	test   %edi,%edi
  801c90:	75 0b                	jne    801c9d <__umoddi3+0xe9>
  801c92:	b8 01 00 00 00       	mov    $0x1,%eax
  801c97:	31 d2                	xor    %edx,%edx
  801c99:	f7 f7                	div    %edi
  801c9b:	89 c5                	mov    %eax,%ebp
  801c9d:	89 f0                	mov    %esi,%eax
  801c9f:	31 d2                	xor    %edx,%edx
  801ca1:	f7 f5                	div    %ebp
  801ca3:	89 c8                	mov    %ecx,%eax
  801ca5:	f7 f5                	div    %ebp
  801ca7:	89 d0                	mov    %edx,%eax
  801ca9:	e9 44 ff ff ff       	jmp    801bf2 <__umoddi3+0x3e>
  801cae:	66 90                	xchg   %ax,%ax
  801cb0:	89 c8                	mov    %ecx,%eax
  801cb2:	89 f2                	mov    %esi,%edx
  801cb4:	83 c4 1c             	add    $0x1c,%esp
  801cb7:	5b                   	pop    %ebx
  801cb8:	5e                   	pop    %esi
  801cb9:	5f                   	pop    %edi
  801cba:	5d                   	pop    %ebp
  801cbb:	c3                   	ret    
  801cbc:	3b 04 24             	cmp    (%esp),%eax
  801cbf:	72 06                	jb     801cc7 <__umoddi3+0x113>
  801cc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cc5:	77 0f                	ja     801cd6 <__umoddi3+0x122>
  801cc7:	89 f2                	mov    %esi,%edx
  801cc9:	29 f9                	sub    %edi,%ecx
  801ccb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ccf:	89 14 24             	mov    %edx,(%esp)
  801cd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cda:	8b 14 24             	mov    (%esp),%edx
  801cdd:	83 c4 1c             	add    $0x1c,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    
  801ce5:	8d 76 00             	lea    0x0(%esi),%esi
  801ce8:	2b 04 24             	sub    (%esp),%eax
  801ceb:	19 fa                	sbb    %edi,%edx
  801ced:	89 d1                	mov    %edx,%ecx
  801cef:	89 c6                	mov    %eax,%esi
  801cf1:	e9 71 ff ff ff       	jmp    801c67 <__umoddi3+0xb3>
  801cf6:	66 90                	xchg   %ax,%ax
  801cf8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cfc:	72 ea                	jb     801ce8 <__umoddi3+0x134>
  801cfe:	89 d9                	mov    %ebx,%ecx
  801d00:	e9 62 ff ff ff       	jmp    801c67 <__umoddi3+0xb3>
