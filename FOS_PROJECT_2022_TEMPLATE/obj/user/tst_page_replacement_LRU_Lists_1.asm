
obj/user/tst_page_replacement_LRU_Lists_1:     file format elf32-i386


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
  800031:	e8 b9 01 00 00       	call   8001ef <libmain>
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
  80003e:	83 ec 5c             	sub    $0x5c,%esp

//	cprintf("envID = %d\n",envID);

	//("STEP 0: checking Initial WS entries ...\n");
	{
		uint32 actual_active_list[5] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x203000};
  800041:	8d 45 b8             	lea    -0x48(%ebp),%eax
  800044:	bb 34 1e 80 00       	mov    $0x801e34,%ebx
  800049:	ba 05 00 00 00       	mov    $0x5,%edx
  80004e:	89 c7                	mov    %eax,%edi
  800050:	89 de                	mov    %ebx,%esi
  800052:	89 d1                	mov    %edx,%ecx
  800054:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		uint32 actual_second_list[5] = {0x202000, 0x201000, 0x200000, 0x802000, 0x205000};
  800056:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  800059:	bb 48 1e 80 00       	mov    $0x801e48,%ebx
  80005e:	ba 05 00 00 00       	mov    $0x5,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 5, 5);
  80006b:	6a 05                	push   $0x5
  80006d:	6a 05                	push   $0x5
  80006f:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  800072:	50                   	push   %eax
  800073:	8d 45 b8             	lea    -0x48(%ebp),%eax
  800076:	50                   	push   %eax
  800077:	e8 1c 19 00 00       	call   801998 <sys_check_LRU_lists>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  800082:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800086:	75 14                	jne    80009c <_main+0x64>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  800088:	83 ec 04             	sub    $0x4,%esp
  80008b:	68 40 1c 80 00       	push   $0x801c40
  800090:	6a 18                	push   $0x18
  800092:	68 90 1c 80 00       	push   $0x801c90
  800097:	e8 a2 02 00 00       	call   80033e <_panic>
	}

	int freePages = sys_calculate_free_frames();
  80009c:	e8 c7 13 00 00       	call   801468 <sys_calculate_free_frames>
  8000a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000a4:	e8 5f 14 00 00       	call   801508 <sys_pf_calculate_allocated_pages>
  8000a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8000ac:	a0 5f 51 83 00       	mov    0x83515f,%al
  8000b1:	88 45 d7             	mov    %al,-0x29(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8000b4:	a0 5f 61 83 00       	mov    0x83615f,%al
  8000b9:	88 45 d6             	mov    %al,-0x2a(%ebp)

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

	//===================

	//cprintf("Checking Allocation in Mem & Page File... \n");
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800105:	e8 fe 13 00 00       	call   801508 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 b8 1c 80 00       	push   $0x801cb8
  800117:	6a 33                	push   $0x33
  800119:	68 90 1c 80 00       	push   $0x801c90
  80011e:	e8 1b 02 00 00       	call   80033e <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800123:	e8 40 13 00 00       	call   801468 <sys_calculate_free_frames>
  800128:	89 c3                	mov    %eax,%ebx
  80012a:	e8 52 13 00 00       	call   801481 <sys_calculate_modified_frames>
  80012f:	01 d8                	add    %ebx,%eax
  800131:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800134:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800137:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80013a:	74 14                	je     800150 <_main+0x118>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 24 1d 80 00       	push   $0x801d24
  800144:	6a 37                	push   $0x37
  800146:	68 90 1c 80 00       	push   $0x801c90
  80014b:	e8 ee 01 00 00       	call   80033e <_panic>
	}

	//cprintf("Checking CONTENT in Mem ... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800150:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800157:	eb 29                	jmp    800182 <_main+0x14a>
			if( arr[i] != -1) panic("Modified page(s) not restored correctly");
  800159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80015c:	05 60 a1 82 00       	add    $0x82a160,%eax
  800161:	8a 00                	mov    (%eax),%al
  800163:	3c ff                	cmp    $0xff,%al
  800165:	74 14                	je     80017b <_main+0x143>
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	68 88 1d 80 00       	push   $0x801d88
  80016f:	6a 3d                	push   $0x3d
  800171:	68 90 1c 80 00       	push   $0x801c90
  800176:	e8 c3 01 00 00       	call   80033e <_panic>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
	}

	//cprintf("Checking CONTENT in Mem ... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80017b:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  800182:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  800189:	7e ce                	jle    800159 <_main+0x121>
			if( arr[i] != -1) panic("Modified page(s) not restored correctly");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  80018b:	e8 78 13 00 00       	call   801508 <sys_pf_calculate_allocated_pages>
  800190:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 b8 1c 80 00       	push   $0x801cb8
  80019d:	6a 3e                	push   $0x3e
  80019f:	68 90 1c 80 00       	push   $0x801c90
  8001a4:	e8 95 01 00 00       	call   80033e <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8001a9:	e8 ba 12 00 00       	call   801468 <sys_calculate_free_frames>
  8001ae:	89 c3                	mov    %eax,%ebx
  8001b0:	e8 cc 12 00 00       	call   801481 <sys_calculate_modified_frames>
  8001b5:	01 d8                	add    %ebx,%eax
  8001b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  8001ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001bd:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 24 1d 80 00       	push   $0x801d24
  8001ca:	6a 42                	push   $0x42
  8001cc:	68 90 1c 80 00       	push   $0x801c90
  8001d1:	e8 68 01 00 00       	call   80033e <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] by REMOVING ONLY ONE PAGE using APRROXIMATED LRU is completed successfully.\n");
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 b0 1d 80 00       	push   $0x801db0
  8001de:	e8 0f 04 00 00       	call   8005f2 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	return;
  8001e6:	90                   	nop
}
  8001e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5e                   	pop    %esi
  8001ec:	5f                   	pop    %edi
  8001ed:	5d                   	pop    %ebp
  8001ee:	c3                   	ret    

008001ef <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f5:	e8 4e 15 00 00       	call   801748 <sys_getenvindex>
  8001fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800200:	89 d0                	mov    %edx,%eax
  800202:	01 c0                	add    %eax,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80020d:	01 c8                	add    %ecx,%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	01 d0                	add    %edx,%eax
  800214:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80021b:	01 c8                	add    %ecx,%eax
  80021d:	c1 e0 02             	shl    $0x2,%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	c1 e0 02             	shl    $0x2,%eax
  800225:	01 d0                	add    %edx,%eax
  800227:	c1 e0 03             	shl    $0x3,%eax
  80022a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80022f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800234:	a1 20 30 80 00       	mov    0x803020,%eax
  800239:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80023f:	84 c0                	test   %al,%al
  800241:	74 0f                	je     800252 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800243:	a1 20 30 80 00       	mov    0x803020,%eax
  800248:	05 18 da 01 00       	add    $0x1da18,%eax
  80024d:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800256:	7e 0a                	jle    800262 <libmain+0x73>
		binaryname = argv[0];
  800258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025b:	8b 00                	mov    (%eax),%eax
  80025d:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	ff 75 0c             	pushl  0xc(%ebp)
  800268:	ff 75 08             	pushl  0x8(%ebp)
  80026b:	e8 c8 fd ff ff       	call   800038 <_main>
  800270:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800273:	e8 dd 12 00 00       	call   801555 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	68 74 1e 80 00       	push   $0x801e74
  800280:	e8 6d 03 00 00       	call   8005f2 <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800288:	a1 20 30 80 00       	mov    0x803020,%eax
  80028d:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800293:	a1 20 30 80 00       	mov    0x803020,%eax
  800298:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	52                   	push   %edx
  8002a2:	50                   	push   %eax
  8002a3:	68 9c 1e 80 00       	push   $0x801e9c
  8002a8:	e8 45 03 00 00       	call   8005f2 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b5:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8002bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c0:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8002c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cb:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8002d1:	51                   	push   %ecx
  8002d2:	52                   	push   %edx
  8002d3:	50                   	push   %eax
  8002d4:	68 c4 1e 80 00       	push   $0x801ec4
  8002d9:	e8 14 03 00 00       	call   8005f2 <cprintf>
  8002de:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e6:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8002ec:	83 ec 08             	sub    $0x8,%esp
  8002ef:	50                   	push   %eax
  8002f0:	68 1c 1f 80 00       	push   $0x801f1c
  8002f5:	e8 f8 02 00 00       	call   8005f2 <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	68 74 1e 80 00       	push   $0x801e74
  800305:	e8 e8 02 00 00       	call   8005f2 <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80030d:	e8 5d 12 00 00       	call   80156f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800312:	e8 19 00 00 00       	call   800330 <exit>
}
  800317:	90                   	nop
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	6a 00                	push   $0x0
  800325:	e8 ea 13 00 00       	call   801714 <sys_destroy_env>
  80032a:	83 c4 10             	add    $0x10,%esp
}
  80032d:	90                   	nop
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <exit>:

void
exit(void)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800336:	e8 3f 14 00 00       	call   80177a <sys_exit_env>
}
  80033b:	90                   	nop
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800344:	8d 45 10             	lea    0x10(%ebp),%eax
  800347:	83 c0 04             	add    $0x4,%eax
  80034a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80034d:	a1 58 62 83 00       	mov    0x836258,%eax
  800352:	85 c0                	test   %eax,%eax
  800354:	74 16                	je     80036c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800356:	a1 58 62 83 00       	mov    0x836258,%eax
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	50                   	push   %eax
  80035f:	68 30 1f 80 00       	push   $0x801f30
  800364:	e8 89 02 00 00       	call   8005f2 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80036c:	a1 08 30 80 00       	mov    0x803008,%eax
  800371:	ff 75 0c             	pushl  0xc(%ebp)
  800374:	ff 75 08             	pushl  0x8(%ebp)
  800377:	50                   	push   %eax
  800378:	68 35 1f 80 00       	push   $0x801f35
  80037d:	e8 70 02 00 00       	call   8005f2 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800385:	8b 45 10             	mov    0x10(%ebp),%eax
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	ff 75 f4             	pushl  -0xc(%ebp)
  80038e:	50                   	push   %eax
  80038f:	e8 f3 01 00 00       	call   800587 <vcprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	6a 00                	push   $0x0
  80039c:	68 51 1f 80 00       	push   $0x801f51
  8003a1:	e8 e1 01 00 00       	call   800587 <vcprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a9:	e8 82 ff ff ff       	call   800330 <exit>

	// should not return here
	while (1) ;
  8003ae:	eb fe                	jmp    8003ae <_panic+0x70>

008003b0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bb:	8b 50 74             	mov    0x74(%eax),%edx
  8003be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c1:	39 c2                	cmp    %eax,%edx
  8003c3:	74 14                	je     8003d9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003c5:	83 ec 04             	sub    $0x4,%esp
  8003c8:	68 54 1f 80 00       	push   $0x801f54
  8003cd:	6a 26                	push   $0x26
  8003cf:	68 a0 1f 80 00       	push   $0x801fa0
  8003d4:	e8 65 ff ff ff       	call   80033e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003e7:	e9 c2 00 00 00       	jmp    8004ae <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	85 c0                	test   %eax,%eax
  8003ff:	75 08                	jne    800409 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800401:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800404:	e9 a2 00 00 00       	jmp    8004ab <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800409:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800410:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800417:	eb 69                	jmp    800482 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800419:	a1 20 30 80 00       	mov    0x803020,%eax
  80041e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800424:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800427:	89 d0                	mov    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	c1 e0 03             	shl    $0x3,%eax
  800430:	01 c8                	add    %ecx,%eax
  800432:	8a 40 04             	mov    0x4(%eax),%al
  800435:	84 c0                	test   %al,%al
  800437:	75 46                	jne    80047f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800439:	a1 20 30 80 00       	mov    0x803020,%eax
  80043e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800444:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800447:	89 d0                	mov    %edx,%eax
  800449:	01 c0                	add    %eax,%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	c1 e0 03             	shl    $0x3,%eax
  800450:	01 c8                	add    %ecx,%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800457:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80045a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80045f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800464:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 c8                	add    %ecx,%eax
  800470:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800472:	39 c2                	cmp    %eax,%edx
  800474:	75 09                	jne    80047f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800476:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80047d:	eb 12                	jmp    800491 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047f:	ff 45 e8             	incl   -0x18(%ebp)
  800482:	a1 20 30 80 00       	mov    0x803020,%eax
  800487:	8b 50 74             	mov    0x74(%eax),%edx
  80048a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80048d:	39 c2                	cmp    %eax,%edx
  80048f:	77 88                	ja     800419 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800491:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800495:	75 14                	jne    8004ab <CheckWSWithoutLastIndex+0xfb>
			panic(
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 ac 1f 80 00       	push   $0x801fac
  80049f:	6a 3a                	push   $0x3a
  8004a1:	68 a0 1f 80 00       	push   $0x801fa0
  8004a6:	e8 93 fe ff ff       	call   80033e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004ab:	ff 45 f0             	incl   -0x10(%ebp)
  8004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b4:	0f 8c 32 ff ff ff    	jl     8003ec <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004c8:	eb 26                	jmp    8004f0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8004cf:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8004d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d8:	89 d0                	mov    %edx,%eax
  8004da:	01 c0                	add    %eax,%eax
  8004dc:	01 d0                	add    %edx,%eax
  8004de:	c1 e0 03             	shl    $0x3,%eax
  8004e1:	01 c8                	add    %ecx,%eax
  8004e3:	8a 40 04             	mov    0x4(%eax),%al
  8004e6:	3c 01                	cmp    $0x1,%al
  8004e8:	75 03                	jne    8004ed <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004ea:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ed:	ff 45 e0             	incl   -0x20(%ebp)
  8004f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f5:	8b 50 74             	mov    0x74(%eax),%edx
  8004f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004fb:	39 c2                	cmp    %eax,%edx
  8004fd:	77 cb                	ja     8004ca <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800502:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800505:	74 14                	je     80051b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800507:	83 ec 04             	sub    $0x4,%esp
  80050a:	68 00 20 80 00       	push   $0x802000
  80050f:	6a 44                	push   $0x44
  800511:	68 a0 1f 80 00       	push   $0x801fa0
  800516:	e8 23 fe ff ff       	call   80033e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800524:	8b 45 0c             	mov    0xc(%ebp),%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	8d 48 01             	lea    0x1(%eax),%ecx
  80052c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052f:	89 0a                	mov    %ecx,(%edx)
  800531:	8b 55 08             	mov    0x8(%ebp),%edx
  800534:	88 d1                	mov    %dl,%cl
  800536:	8b 55 0c             	mov    0xc(%ebp),%edx
  800539:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	3d ff 00 00 00       	cmp    $0xff,%eax
  800547:	75 2c                	jne    800575 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800549:	a0 24 30 80 00       	mov    0x803024,%al
  80054e:	0f b6 c0             	movzbl %al,%eax
  800551:	8b 55 0c             	mov    0xc(%ebp),%edx
  800554:	8b 12                	mov    (%edx),%edx
  800556:	89 d1                	mov    %edx,%ecx
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	83 c2 08             	add    $0x8,%edx
  80055e:	83 ec 04             	sub    $0x4,%esp
  800561:	50                   	push   %eax
  800562:	51                   	push   %ecx
  800563:	52                   	push   %edx
  800564:	e8 3e 0e 00 00       	call   8013a7 <sys_cputs>
  800569:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	8b 40 04             	mov    0x4(%eax),%eax
  80057b:	8d 50 01             	lea    0x1(%eax),%edx
  80057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800581:	89 50 04             	mov    %edx,0x4(%eax)
}
  800584:	90                   	nop
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800590:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800597:	00 00 00 
	b.cnt = 0;
  80059a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005a1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	ff 75 08             	pushl  0x8(%ebp)
  8005aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b0:	50                   	push   %eax
  8005b1:	68 1e 05 80 00       	push   $0x80051e
  8005b6:	e8 11 02 00 00       	call   8007cc <vprintfmt>
  8005bb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005be:	a0 24 30 80 00       	mov    0x803024,%al
  8005c3:	0f b6 c0             	movzbl %al,%eax
  8005c6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005cc:	83 ec 04             	sub    $0x4,%esp
  8005cf:	50                   	push   %eax
  8005d0:	52                   	push   %edx
  8005d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d7:	83 c0 08             	add    $0x8,%eax
  8005da:	50                   	push   %eax
  8005db:	e8 c7 0d 00 00       	call   8013a7 <sys_cputs>
  8005e0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005e3:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005f0:	c9                   	leave  
  8005f1:	c3                   	ret    

008005f2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005f2:	55                   	push   %ebp
  8005f3:	89 e5                	mov    %esp,%ebp
  8005f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005f8:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800602:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800605:	8b 45 08             	mov    0x8(%ebp),%eax
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	ff 75 f4             	pushl  -0xc(%ebp)
  80060e:	50                   	push   %eax
  80060f:	e8 73 ff ff ff       	call   800587 <vcprintf>
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80061a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 2b 0f 00 00       	call   801555 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80062a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	ff 75 f4             	pushl  -0xc(%ebp)
  800639:	50                   	push   %eax
  80063a:	e8 48 ff ff ff       	call   800587 <vcprintf>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800645:	e8 25 0f 00 00       	call   80156f <sys_enable_interrupt>
	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	53                   	push   %ebx
  800653:	83 ec 14             	sub    $0x14,%esp
  800656:	8b 45 10             	mov    0x10(%ebp),%eax
  800659:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800662:	8b 45 18             	mov    0x18(%ebp),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80066d:	77 55                	ja     8006c4 <printnum+0x75>
  80066f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800672:	72 05                	jb     800679 <printnum+0x2a>
  800674:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800677:	77 4b                	ja     8006c4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800679:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80067c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80067f:	8b 45 18             	mov    0x18(%ebp),%eax
  800682:	ba 00 00 00 00       	mov    $0x0,%edx
  800687:	52                   	push   %edx
  800688:	50                   	push   %eax
  800689:	ff 75 f4             	pushl  -0xc(%ebp)
  80068c:	ff 75 f0             	pushl  -0x10(%ebp)
  80068f:	e8 48 13 00 00       	call   8019dc <__udivdi3>
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	83 ec 04             	sub    $0x4,%esp
  80069a:	ff 75 20             	pushl  0x20(%ebp)
  80069d:	53                   	push   %ebx
  80069e:	ff 75 18             	pushl  0x18(%ebp)
  8006a1:	52                   	push   %edx
  8006a2:	50                   	push   %eax
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	ff 75 08             	pushl  0x8(%ebp)
  8006a9:	e8 a1 ff ff ff       	call   80064f <printnum>
  8006ae:	83 c4 20             	add    $0x20,%esp
  8006b1:	eb 1a                	jmp    8006cd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 20             	pushl  0x20(%ebp)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	ff d0                	call   *%eax
  8006c1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006c7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006cb:	7f e6                	jg     8006b3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006cd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006db:	53                   	push   %ebx
  8006dc:	51                   	push   %ecx
  8006dd:	52                   	push   %edx
  8006de:	50                   	push   %eax
  8006df:	e8 08 14 00 00       	call   801aec <__umoddi3>
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	05 74 22 80 00       	add    $0x802274,%eax
  8006ec:	8a 00                	mov    (%eax),%al
  8006ee:	0f be c0             	movsbl %al,%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 0c             	pushl  0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	ff d0                	call   *%eax
  8006fd:	83 c4 10             	add    $0x10,%esp
}
  800700:	90                   	nop
  800701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800709:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80070d:	7e 1c                	jle    80072b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 50 08             	lea    0x8(%eax),%edx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 10                	mov    %edx,(%eax)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	83 e8 08             	sub    $0x8,%eax
  800724:	8b 50 04             	mov    0x4(%eax),%edx
  800727:	8b 00                	mov    (%eax),%eax
  800729:	eb 40                	jmp    80076b <getuint+0x65>
	else if (lflag)
  80072b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80072f:	74 1e                	je     80074f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	ba 00 00 00 00       	mov    $0x0,%edx
  80074d:	eb 1c                	jmp    80076b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 04             	lea    0x4(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 04             	sub    $0x4,%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80076b:	5d                   	pop    %ebp
  80076c:	c3                   	ret    

0080076d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800770:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800774:	7e 1c                	jle    800792 <getint+0x25>
		return va_arg(*ap, long long);
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	8d 50 08             	lea    0x8(%eax),%edx
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	89 10                	mov    %edx,(%eax)
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	83 e8 08             	sub    $0x8,%eax
  80078b:	8b 50 04             	mov    0x4(%eax),%edx
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	eb 38                	jmp    8007ca <getint+0x5d>
	else if (lflag)
  800792:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800796:	74 1a                	je     8007b2 <getint+0x45>
		return va_arg(*ap, long);
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	8d 50 04             	lea    0x4(%eax),%edx
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	89 10                	mov    %edx,(%eax)
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	99                   	cltd   
  8007b0:	eb 18                	jmp    8007ca <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	89 10                	mov    %edx,(%eax)
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	83 e8 04             	sub    $0x4,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	99                   	cltd   
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	56                   	push   %esi
  8007d0:	53                   	push   %ebx
  8007d1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d4:	eb 17                	jmp    8007ed <vprintfmt+0x21>
			if (ch == '\0')
  8007d6:	85 db                	test   %ebx,%ebx
  8007d8:	0f 84 af 03 00 00    	je     800b8d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	53                   	push   %ebx
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	ff d0                	call   *%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f0:	8d 50 01             	lea    0x1(%eax),%edx
  8007f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f6:	8a 00                	mov    (%eax),%al
  8007f8:	0f b6 d8             	movzbl %al,%ebx
  8007fb:	83 fb 25             	cmp    $0x25,%ebx
  8007fe:	75 d6                	jne    8007d6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800800:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800804:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80080b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800812:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800819:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	8d 50 01             	lea    0x1(%eax),%edx
  800826:	89 55 10             	mov    %edx,0x10(%ebp)
  800829:	8a 00                	mov    (%eax),%al
  80082b:	0f b6 d8             	movzbl %al,%ebx
  80082e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800831:	83 f8 55             	cmp    $0x55,%eax
  800834:	0f 87 2b 03 00 00    	ja     800b65 <vprintfmt+0x399>
  80083a:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  800841:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800843:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800847:	eb d7                	jmp    800820 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800849:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80084d:	eb d1                	jmp    800820 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800856:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800859:	89 d0                	mov    %edx,%eax
  80085b:	c1 e0 02             	shl    $0x2,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	01 c0                	add    %eax,%eax
  800862:	01 d8                	add    %ebx,%eax
  800864:	83 e8 30             	sub    $0x30,%eax
  800867:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80086a:	8b 45 10             	mov    0x10(%ebp),%eax
  80086d:	8a 00                	mov    (%eax),%al
  80086f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800872:	83 fb 2f             	cmp    $0x2f,%ebx
  800875:	7e 3e                	jle    8008b5 <vprintfmt+0xe9>
  800877:	83 fb 39             	cmp    $0x39,%ebx
  80087a:	7f 39                	jg     8008b5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80087f:	eb d5                	jmp    800856 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 c0 04             	add    $0x4,%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 e8 04             	sub    $0x4,%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800895:	eb 1f                	jmp    8008b6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800897:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089b:	79 83                	jns    800820 <vprintfmt+0x54>
				width = 0;
  80089d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008a4:	e9 77 ff ff ff       	jmp    800820 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b0:	e9 6b ff ff ff       	jmp    800820 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	0f 89 60 ff ff ff    	jns    800820 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008cd:	e9 4e ff ff ff       	jmp    800820 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008d5:	e9 46 ff ff ff       	jmp    800820 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 c0 04             	add    $0x4,%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 e8 04             	sub    $0x4,%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	50                   	push   %eax
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	ff d0                	call   *%eax
  8008f7:	83 c4 10             	add    $0x10,%esp
			break;
  8008fa:	e9 89 02 00 00       	jmp    800b88 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 c0 04             	add    $0x4,%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	83 e8 04             	sub    $0x4,%eax
  80090e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800910:	85 db                	test   %ebx,%ebx
  800912:	79 02                	jns    800916 <vprintfmt+0x14a>
				err = -err;
  800914:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800916:	83 fb 64             	cmp    $0x64,%ebx
  800919:	7f 0b                	jg     800926 <vprintfmt+0x15a>
  80091b:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  800922:	85 f6                	test   %esi,%esi
  800924:	75 19                	jne    80093f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800926:	53                   	push   %ebx
  800927:	68 85 22 80 00       	push   $0x802285
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	ff 75 08             	pushl  0x8(%ebp)
  800932:	e8 5e 02 00 00       	call   800b95 <printfmt>
  800937:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80093a:	e9 49 02 00 00       	jmp    800b88 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80093f:	56                   	push   %esi
  800940:	68 8e 22 80 00       	push   $0x80228e
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	ff 75 08             	pushl  0x8(%ebp)
  80094b:	e8 45 02 00 00       	call   800b95 <printfmt>
  800950:	83 c4 10             	add    $0x10,%esp
			break;
  800953:	e9 30 02 00 00       	jmp    800b88 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 c0 04             	add    $0x4,%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	83 e8 04             	sub    $0x4,%eax
  800967:	8b 30                	mov    (%eax),%esi
  800969:	85 f6                	test   %esi,%esi
  80096b:	75 05                	jne    800972 <vprintfmt+0x1a6>
				p = "(null)";
  80096d:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  800972:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800976:	7e 6d                	jle    8009e5 <vprintfmt+0x219>
  800978:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80097c:	74 67                	je     8009e5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	50                   	push   %eax
  800985:	56                   	push   %esi
  800986:	e8 0c 03 00 00       	call   800c97 <strnlen>
  80098b:	83 c4 10             	add    $0x10,%esp
  80098e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800991:	eb 16                	jmp    8009a9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800993:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	50                   	push   %eax
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ad:	7f e4                	jg     800993 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009af:	eb 34                	jmp    8009e5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009b5:	74 1c                	je     8009d3 <vprintfmt+0x207>
  8009b7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ba:	7e 05                	jle    8009c1 <vprintfmt+0x1f5>
  8009bc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009bf:	7e 12                	jle    8009d3 <vprintfmt+0x207>
					putch('?', putdat);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	6a 3f                	push   $0x3f
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	eb 0f                	jmp    8009e2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	53                   	push   %ebx
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	ff d0                	call   *%eax
  8009df:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e5:	89 f0                	mov    %esi,%eax
  8009e7:	8d 70 01             	lea    0x1(%eax),%esi
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
  8009ef:	85 db                	test   %ebx,%ebx
  8009f1:	74 24                	je     800a17 <vprintfmt+0x24b>
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	78 b8                	js     8009b1 <vprintfmt+0x1e5>
  8009f9:	ff 4d e0             	decl   -0x20(%ebp)
  8009fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a00:	79 af                	jns    8009b1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a02:	eb 13                	jmp    800a17 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 20                	push   $0x20
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a14:	ff 4d e4             	decl   -0x1c(%ebp)
  800a17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1b:	7f e7                	jg     800a04 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a1d:	e9 66 01 00 00       	jmp    800b88 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 e8             	pushl  -0x18(%ebp)
  800a28:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2b:	50                   	push   %eax
  800a2c:	e8 3c fd ff ff       	call   80076d <getint>
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a40:	85 d2                	test   %edx,%edx
  800a42:	79 23                	jns    800a67 <vprintfmt+0x29b>
				putch('-', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 2d                	push   $0x2d
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5a:	f7 d8                	neg    %eax
  800a5c:	83 d2 00             	adc    $0x0,%edx
  800a5f:	f7 da                	neg    %edx
  800a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6e:	e9 bc 00 00 00       	jmp    800b2f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 e8             	pushl  -0x18(%ebp)
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7c:	50                   	push   %eax
  800a7d:	e8 84 fc ff ff       	call   800706 <getuint>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a92:	e9 98 00 00 00       	jmp    800b2f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	6a 58                	push   $0x58
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	6a 58                	push   $0x58
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 58                	push   $0x58
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			break;
  800ac7:	e9 bc 00 00 00       	jmp    800b88 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	6a 30                	push   $0x30
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	ff d0                	call   *%eax
  800ad9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	6a 78                	push   $0x78
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	ff d0                	call   *%eax
  800ae9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 14             	mov    %eax,0x14(%ebp)
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 e8 04             	sub    $0x4,%eax
  800afb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b0e:	eb 1f                	jmp    800b2f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 e8             	pushl  -0x18(%ebp)
  800b16:	8d 45 14             	lea    0x14(%ebp),%eax
  800b19:	50                   	push   %eax
  800b1a:	e8 e7 fb ff ff       	call   800706 <getuint>
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b25:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b2f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b36:	83 ec 04             	sub    $0x4,%esp
  800b39:	52                   	push   %edx
  800b3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b41:	ff 75 f0             	pushl  -0x10(%ebp)
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	ff 75 08             	pushl  0x8(%ebp)
  800b4a:	e8 00 fb ff ff       	call   80064f <printnum>
  800b4f:	83 c4 20             	add    $0x20,%esp
			break;
  800b52:	eb 34                	jmp    800b88 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	53                   	push   %ebx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
			break;
  800b63:	eb 23                	jmp    800b88 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 25                	push   $0x25
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b75:	ff 4d 10             	decl   0x10(%ebp)
  800b78:	eb 03                	jmp    800b7d <vprintfmt+0x3b1>
  800b7a:	ff 4d 10             	decl   0x10(%ebp)
  800b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b80:	48                   	dec    %eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	3c 25                	cmp    $0x25,%al
  800b85:	75 f3                	jne    800b7a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b87:	90                   	nop
		}
	}
  800b88:	e9 47 fc ff ff       	jmp    8007d4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b8d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b91:	5b                   	pop    %ebx
  800b92:	5e                   	pop    %esi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b9b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b9e:	83 c0 04             	add    $0x4,%eax
  800ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba7:	ff 75 f4             	pushl  -0xc(%ebp)
  800baa:	50                   	push   %eax
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	ff 75 08             	pushl  0x8(%ebp)
  800bb1:	e8 16 fc ff ff       	call   8007cc <vprintfmt>
  800bb6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb9:	90                   	nop
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	8b 40 08             	mov    0x8(%eax),%eax
  800bc5:	8d 50 01             	lea    0x1(%eax),%edx
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	8b 10                	mov    (%eax),%edx
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	8b 40 04             	mov    0x4(%eax),%eax
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	73 12                	jae    800bef <sprintputch+0x33>
		*b->buf++ = ch;
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	8b 00                	mov    (%eax),%eax
  800be2:	8d 48 01             	lea    0x1(%eax),%ecx
  800be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be8:	89 0a                	mov    %ecx,(%edx)
  800bea:	8b 55 08             	mov    0x8(%ebp),%edx
  800bed:	88 10                	mov    %dl,(%eax)
}
  800bef:	90                   	nop
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	01 d0                	add    %edx,%eax
  800c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c17:	74 06                	je     800c1f <vsnprintf+0x2d>
  800c19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1d:	7f 07                	jg     800c26 <vsnprintf+0x34>
		return -E_INVAL;
  800c1f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c24:	eb 20                	jmp    800c46 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c26:	ff 75 14             	pushl  0x14(%ebp)
  800c29:	ff 75 10             	pushl  0x10(%ebp)
  800c2c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c2f:	50                   	push   %eax
  800c30:	68 bc 0b 80 00       	push   $0x800bbc
  800c35:	e8 92 fb ff ff       	call   8007cc <vprintfmt>
  800c3a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c40:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c4e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c51:	83 c0 04             	add    $0x4,%eax
  800c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c57:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5d:	50                   	push   %eax
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	ff 75 08             	pushl  0x8(%ebp)
  800c64:	e8 89 ff ff ff       	call   800bf2 <vsnprintf>
  800c69:	83 c4 10             	add    $0x10,%esp
  800c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c81:	eb 06                	jmp    800c89 <strlen+0x15>
		n++;
  800c83:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c86:	ff 45 08             	incl   0x8(%ebp)
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	84 c0                	test   %al,%al
  800c90:	75 f1                	jne    800c83 <strlen+0xf>
		n++;
	return n;
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca4:	eb 09                	jmp    800caf <strnlen+0x18>
		n++;
  800ca6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca9:	ff 45 08             	incl   0x8(%ebp)
  800cac:	ff 4d 0c             	decl   0xc(%ebp)
  800caf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb3:	74 09                	je     800cbe <strnlen+0x27>
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 e8                	jne    800ca6 <strnlen+0xf>
		n++;
	return n;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ccf:	90                   	nop
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8d 50 01             	lea    0x1(%eax),%edx
  800cd6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce2:	8a 12                	mov    (%edx),%dl
  800ce4:	88 10                	mov    %dl,(%eax)
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	84 c0                	test   %al,%al
  800cea:	75 e4                	jne    800cd0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d04:	eb 1f                	jmp    800d25 <strncpy+0x34>
		*dst++ = *src;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8d 50 01             	lea    0x1(%eax),%edx
  800d0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	84 c0                	test   %al,%al
  800d1d:	74 03                	je     800d22 <strncpy+0x31>
			src++;
  800d1f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d22:	ff 45 fc             	incl   -0x4(%ebp)
  800d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d28:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d2b:	72 d9                	jb     800d06 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 30                	je     800d74 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d44:	eb 16                	jmp    800d5c <strlcpy+0x2a>
			*dst++ = *src++;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d55:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d58:	8a 12                	mov    (%edx),%dl
  800d5a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d5c:	ff 4d 10             	decl   0x10(%ebp)
  800d5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d63:	74 09                	je     800d6e <strlcpy+0x3c>
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	84 c0                	test   %al,%al
  800d6c:	75 d8                	jne    800d46 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	29 c2                	sub    %eax,%edx
  800d7c:	89 d0                	mov    %edx,%eax
}
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d83:	eb 06                	jmp    800d8b <strcmp+0xb>
		p++, q++;
  800d85:	ff 45 08             	incl   0x8(%ebp)
  800d88:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	84 c0                	test   %al,%al
  800d92:	74 0e                	je     800da2 <strcmp+0x22>
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 10                	mov    (%eax),%dl
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	38 c2                	cmp    %al,%dl
  800da0:	74 e3                	je     800d85 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	0f b6 d0             	movzbl %al,%edx
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	0f b6 c0             	movzbl %al,%eax
  800db2:	29 c2                	sub    %eax,%edx
  800db4:	89 d0                	mov    %edx,%eax
}
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dbb:	eb 09                	jmp    800dc6 <strncmp+0xe>
		n--, p++, q++;
  800dbd:	ff 4d 10             	decl   0x10(%ebp)
  800dc0:	ff 45 08             	incl   0x8(%ebp)
  800dc3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dca:	74 17                	je     800de3 <strncmp+0x2b>
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 0e                	je     800de3 <strncmp+0x2b>
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8a 10                	mov    (%eax),%dl
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	38 c2                	cmp    %al,%dl
  800de1:	74 da                	je     800dbd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800de3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de7:	75 07                	jne    800df0 <strncmp+0x38>
		return 0;
  800de9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dee:	eb 14                	jmp    800e04 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	0f b6 d0             	movzbl %al,%edx
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	0f b6 c0             	movzbl %al,%eax
  800e00:	29 c2                	sub    %eax,%edx
  800e02:	89 d0                	mov    %edx,%eax
}
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 04             	sub    $0x4,%esp
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e12:	eb 12                	jmp    800e26 <strchr+0x20>
		if (*s == c)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e1c:	75 05                	jne    800e23 <strchr+0x1d>
			return (char *) s;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	eb 11                	jmp    800e34 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e23:	ff 45 08             	incl   0x8(%ebp)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 e5                	jne    800e14 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 0d                	jmp    800e51 <strfind+0x1b>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	74 0e                	je     800e5c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e4e:	ff 45 08             	incl   0x8(%ebp)
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	84 c0                	test   %al,%al
  800e58:	75 ea                	jne    800e44 <strfind+0xe>
  800e5a:	eb 01                	jmp    800e5d <strfind+0x27>
		if (*s == c)
			break;
  800e5c:	90                   	nop
	return (char *) s;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e71:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e74:	eb 0e                	jmp    800e84 <memset+0x22>
		*p++ = c;
  800e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e79:	8d 50 01             	lea    0x1(%eax),%edx
  800e7c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e84:	ff 4d f8             	decl   -0x8(%ebp)
  800e87:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e8b:	79 e9                	jns    800e76 <memset+0x14>
		*p++ = c;

	return v;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ea4:	eb 16                	jmp    800ebc <memcpy+0x2a>
		*d++ = *s++;
  800ea6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb8:	8a 12                	mov    (%edx),%dl
  800eba:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ebc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	75 dd                	jne    800ea6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ecc:	c9                   	leave  
  800ecd:	c3                   	ret    

00800ece <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee6:	73 50                	jae    800f38 <memmove+0x6a>
  800ee8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	01 d0                	add    %edx,%eax
  800ef0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef3:	76 43                	jbe    800f38 <memmove+0x6a>
		s += n;
  800ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f01:	eb 10                	jmp    800f13 <memmove+0x45>
			*--d = *--s;
  800f03:	ff 4d f8             	decl   -0x8(%ebp)
  800f06:	ff 4d fc             	decl   -0x4(%ebp)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f13:	8b 45 10             	mov    0x10(%ebp),%eax
  800f16:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f19:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	75 e3                	jne    800f03 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f20:	eb 23                	jmp    800f45 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f25:	8d 50 01             	lea    0x1(%eax),%edx
  800f28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f31:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f34:	8a 12                	mov    (%edx),%dl
  800f36:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f41:	85 c0                	test   %eax,%eax
  800f43:	75 dd                	jne    800f22 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    

00800f4a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f5c:	eb 2a                	jmp    800f88 <memcmp+0x3e>
		if (*s1 != *s2)
  800f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f61:	8a 10                	mov    (%eax),%dl
  800f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	38 c2                	cmp    %al,%dl
  800f6a:	74 16                	je     800f82 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	0f b6 d0             	movzbl %al,%edx
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	0f b6 c0             	movzbl %al,%eax
  800f7c:	29 c2                	sub    %eax,%edx
  800f7e:	89 d0                	mov    %edx,%eax
  800f80:	eb 18                	jmp    800f9a <memcmp+0x50>
		s1++, s2++;
  800f82:	ff 45 fc             	incl   -0x4(%ebp)
  800f85:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f91:	85 c0                	test   %eax,%eax
  800f93:	75 c9                	jne    800f5e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fad:	eb 15                	jmp    800fc4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	0f b6 d0             	movzbl %al,%edx
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	0f b6 c0             	movzbl %al,%eax
  800fbd:	39 c2                	cmp    %eax,%edx
  800fbf:	74 0d                	je     800fce <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fca:	72 e3                	jb     800faf <memfind+0x13>
  800fcc:	eb 01                	jmp    800fcf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fce:	90                   	nop
	return (void *) s;
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    

00800fd4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fe1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe8:	eb 03                	jmp    800fed <strtol+0x19>
		s++;
  800fea:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 20                	cmp    $0x20,%al
  800ff4:	74 f4                	je     800fea <strtol+0x16>
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 09                	cmp    $0x9,%al
  800ffd:	74 eb                	je     800fea <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	3c 2b                	cmp    $0x2b,%al
  801006:	75 05                	jne    80100d <strtol+0x39>
		s++;
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	eb 13                	jmp    801020 <strtol+0x4c>
	else if (*s == '-')
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 2d                	cmp    $0x2d,%al
  801014:	75 0a                	jne    801020 <strtol+0x4c>
		s++, neg = 1;
  801016:	ff 45 08             	incl   0x8(%ebp)
  801019:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801020:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801024:	74 06                	je     80102c <strtol+0x58>
  801026:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80102a:	75 20                	jne    80104c <strtol+0x78>
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 30                	cmp    $0x30,%al
  801033:	75 17                	jne    80104c <strtol+0x78>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	40                   	inc    %eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 78                	cmp    $0x78,%al
  80103d:	75 0d                	jne    80104c <strtol+0x78>
		s += 2, base = 16;
  80103f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801043:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80104a:	eb 28                	jmp    801074 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	75 15                	jne    801067 <strtol+0x93>
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	3c 30                	cmp    $0x30,%al
  801059:	75 0c                	jne    801067 <strtol+0x93>
		s++, base = 8;
  80105b:	ff 45 08             	incl   0x8(%ebp)
  80105e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801065:	eb 0d                	jmp    801074 <strtol+0xa0>
	else if (base == 0)
  801067:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106b:	75 07                	jne    801074 <strtol+0xa0>
		base = 10;
  80106d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 2f                	cmp    $0x2f,%al
  80107b:	7e 19                	jle    801096 <strtol+0xc2>
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	3c 39                	cmp    $0x39,%al
  801084:	7f 10                	jg     801096 <strtol+0xc2>
			dig = *s - '0';
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	0f be c0             	movsbl %al,%eax
  80108e:	83 e8 30             	sub    $0x30,%eax
  801091:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801094:	eb 42                	jmp    8010d8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 60                	cmp    $0x60,%al
  80109d:	7e 19                	jle    8010b8 <strtol+0xe4>
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	3c 7a                	cmp    $0x7a,%al
  8010a6:	7f 10                	jg     8010b8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	0f be c0             	movsbl %al,%eax
  8010b0:	83 e8 57             	sub    $0x57,%eax
  8010b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b6:	eb 20                	jmp    8010d8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 40                	cmp    $0x40,%al
  8010bf:	7e 39                	jle    8010fa <strtol+0x126>
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 5a                	cmp    $0x5a,%al
  8010c8:	7f 30                	jg     8010fa <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	83 e8 37             	sub    $0x37,%eax
  8010d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010db:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010de:	7d 19                	jge    8010f9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010e0:	ff 45 08             	incl   0x8(%ebp)
  8010e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ef:	01 d0                	add    %edx,%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f4:	e9 7b ff ff ff       	jmp    801074 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fe:	74 08                	je     801108 <strtol+0x134>
		*endptr = (char *) s;
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801108:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110c:	74 07                	je     801115 <strtol+0x141>
  80110e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801111:	f7 d8                	neg    %eax
  801113:	eb 03                	jmp    801118 <strtol+0x144>
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <ltostr>:

void
ltostr(long value, char *str)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801127:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80112e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801132:	79 13                	jns    801147 <ltostr+0x2d>
	{
		neg = 1;
  801134:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801141:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801144:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80114f:	99                   	cltd   
  801150:	f7 f9                	idiv   %ecx
  801152:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801158:	8d 50 01             	lea    0x1(%eax),%edx
  80115b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80115e:	89 c2                	mov    %eax,%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 d0                	add    %edx,%eax
  801165:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801168:	83 c2 30             	add    $0x30,%edx
  80116b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80116d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801170:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801175:	f7 e9                	imul   %ecx
  801177:	c1 fa 02             	sar    $0x2,%edx
  80117a:	89 c8                	mov    %ecx,%eax
  80117c:	c1 f8 1f             	sar    $0x1f,%eax
  80117f:	29 c2                	sub    %eax,%edx
  801181:	89 d0                	mov    %edx,%eax
  801183:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801186:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801189:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80118e:	f7 e9                	imul   %ecx
  801190:	c1 fa 02             	sar    $0x2,%edx
  801193:	89 c8                	mov    %ecx,%eax
  801195:	c1 f8 1f             	sar    $0x1f,%eax
  801198:	29 c2                	sub    %eax,%edx
  80119a:	89 d0                	mov    %edx,%eax
  80119c:	c1 e0 02             	shl    $0x2,%eax
  80119f:	01 d0                	add    %edx,%eax
  8011a1:	01 c0                	add    %eax,%eax
  8011a3:	29 c1                	sub    %eax,%ecx
  8011a5:	89 ca                	mov    %ecx,%edx
  8011a7:	85 d2                	test   %edx,%edx
  8011a9:	75 9c                	jne    801147 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b5:	48                   	dec    %eax
  8011b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011bd:	74 3d                	je     8011fc <ltostr+0xe2>
		start = 1 ;
  8011bf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011c6:	eb 34                	jmp    8011fc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	01 d0                	add    %edx,%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 c2                	add    %eax,%edx
  8011dd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	01 c8                	add    %ecx,%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	01 c2                	add    %eax,%edx
  8011f1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011f4:	88 02                	mov    %al,(%edx)
		start++ ;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801202:	7c c4                	jl     8011c8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801204:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	01 d0                	add    %edx,%eax
  80120c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80120f:	90                   	nop
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801218:	ff 75 08             	pushl  0x8(%ebp)
  80121b:	e8 54 fa ff ff       	call   800c74 <strlen>
  801220:	83 c4 04             	add    $0x4,%esp
  801223:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	e8 46 fa ff ff       	call   800c74 <strlen>
  80122e:	83 c4 04             	add    $0x4,%esp
  801231:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80123b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801242:	eb 17                	jmp    80125b <strcconcat+0x49>
		final[s] = str1[s] ;
  801244:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801247:	8b 45 10             	mov    0x10(%ebp),%eax
  80124a:	01 c2                	add    %eax,%edx
  80124c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	01 c8                	add    %ecx,%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801258:	ff 45 fc             	incl   -0x4(%ebp)
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801261:	7c e1                	jl     801244 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801263:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80126a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801271:	eb 1f                	jmp    801292 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801276:	8d 50 01             	lea    0x1(%eax),%edx
  801279:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80127c:	89 c2                	mov    %eax,%edx
  80127e:	8b 45 10             	mov    0x10(%ebp),%eax
  801281:	01 c2                	add    %eax,%edx
  801283:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	01 c8                	add    %ecx,%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80128f:	ff 45 f8             	incl   -0x8(%ebp)
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801295:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801298:	7c d9                	jl     801273 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80129a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012a5:	90                   	nop
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b7:	8b 00                	mov    (%eax),%eax
  8012b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c3:	01 d0                	add    %edx,%eax
  8012c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012cb:	eb 0c                	jmp    8012d9 <strsplit+0x31>
			*string++ = 0;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8d 50 01             	lea    0x1(%eax),%edx
  8012d3:	89 55 08             	mov    %edx,0x8(%ebp)
  8012d6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	84 c0                	test   %al,%al
  8012e0:	74 18                	je     8012fa <strsplit+0x52>
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	0f be c0             	movsbl %al,%eax
  8012ea:	50                   	push   %eax
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	e8 13 fb ff ff       	call   800e06 <strchr>
  8012f3:	83 c4 08             	add    $0x8,%esp
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	75 d3                	jne    8012cd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	84 c0                	test   %al,%al
  801301:	74 5a                	je     80135d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801303:	8b 45 14             	mov    0x14(%ebp),%eax
  801306:	8b 00                	mov    (%eax),%eax
  801308:	83 f8 0f             	cmp    $0xf,%eax
  80130b:	75 07                	jne    801314 <strsplit+0x6c>
		{
			return 0;
  80130d:	b8 00 00 00 00       	mov    $0x0,%eax
  801312:	eb 66                	jmp    80137a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801314:	8b 45 14             	mov    0x14(%ebp),%eax
  801317:	8b 00                	mov    (%eax),%eax
  801319:	8d 48 01             	lea    0x1(%eax),%ecx
  80131c:	8b 55 14             	mov    0x14(%ebp),%edx
  80131f:	89 0a                	mov    %ecx,(%edx)
  801321:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801328:	8b 45 10             	mov    0x10(%ebp),%eax
  80132b:	01 c2                	add    %eax,%edx
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801332:	eb 03                	jmp    801337 <strsplit+0x8f>
			string++;
  801334:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	84 c0                	test   %al,%al
  80133e:	74 8b                	je     8012cb <strsplit+0x23>
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	0f be c0             	movsbl %al,%eax
  801348:	50                   	push   %eax
  801349:	ff 75 0c             	pushl  0xc(%ebp)
  80134c:	e8 b5 fa ff ff       	call   800e06 <strchr>
  801351:	83 c4 08             	add    $0x8,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	74 dc                	je     801334 <strsplit+0x8c>
			string++;
	}
  801358:	e9 6e ff ff ff       	jmp    8012cb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80135d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80135e:	8b 45 14             	mov    0x14(%ebp),%eax
  801361:	8b 00                	mov    (%eax),%eax
  801363:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136a:	8b 45 10             	mov    0x10(%ebp),%eax
  80136d:	01 d0                	add    %edx,%eax
  80136f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801375:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	57                   	push   %edi
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80138e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801391:	8b 7d 18             	mov    0x18(%ebp),%edi
  801394:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801397:	cd 30                	int    $0x30
  801399:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80139c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	5b                   	pop    %ebx
  8013a3:	5e                   	pop    %esi
  8013a4:	5f                   	pop    %edi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8013b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	52                   	push   %edx
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	50                   	push   %eax
  8013c3:	6a 00                	push   $0x0
  8013c5:	e8 b2 ff ff ff       	call   80137c <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
}
  8013cd:	90                   	nop
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 01                	push   $0x1
  8013df:	e8 98 ff ff ff       	call   80137c <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	52                   	push   %edx
  8013f9:	50                   	push   %eax
  8013fa:	6a 05                	push   $0x5
  8013fc:	e8 7b ff ff ff       	call   80137c <syscall>
  801401:	83 c4 18             	add    $0x18,%esp
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80140b:	8b 75 18             	mov    0x18(%ebp),%esi
  80140e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801411:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801414:	8b 55 0c             	mov    0xc(%ebp),%edx
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	56                   	push   %esi
  80141b:	53                   	push   %ebx
  80141c:	51                   	push   %ecx
  80141d:	52                   	push   %edx
  80141e:	50                   	push   %eax
  80141f:	6a 06                	push   $0x6
  801421:	e8 56 ff ff ff       	call   80137c <syscall>
  801426:	83 c4 18             	add    $0x18,%esp
}
  801429:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80142c:	5b                   	pop    %ebx
  80142d:	5e                   	pop    %esi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801433:	8b 55 0c             	mov    0xc(%ebp),%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	52                   	push   %edx
  801440:	50                   	push   %eax
  801441:	6a 07                	push   $0x7
  801443:	e8 34 ff ff ff       	call   80137c <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	ff 75 0c             	pushl  0xc(%ebp)
  801459:	ff 75 08             	pushl  0x8(%ebp)
  80145c:	6a 08                	push   $0x8
  80145e:	e8 19 ff ff ff       	call   80137c <syscall>
  801463:	83 c4 18             	add    $0x18,%esp
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 09                	push   $0x9
  801477:	e8 00 ff ff ff       	call   80137c <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 0a                	push   $0xa
  801490:	e8 e7 fe ff ff       	call   80137c <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
}
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 0b                	push   $0xb
  8014a9:	e8 ce fe ff ff       	call   80137c <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	ff 75 08             	pushl  0x8(%ebp)
  8014c2:	6a 0f                	push   $0xf
  8014c4:	e8 b3 fe ff ff       	call   80137c <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
	return;
  8014cc:	90                   	nop
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	ff 75 0c             	pushl  0xc(%ebp)
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	6a 10                	push   $0x10
  8014e0:	e8 97 fe ff ff       	call   80137c <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e8:	90                   	nop
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	ff 75 10             	pushl  0x10(%ebp)
  8014f5:	ff 75 0c             	pushl  0xc(%ebp)
  8014f8:	ff 75 08             	pushl  0x8(%ebp)
  8014fb:	6a 11                	push   $0x11
  8014fd:	e8 7a fe ff ff       	call   80137c <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
	return ;
  801505:	90                   	nop
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 0c                	push   $0xc
  801517:	e8 60 fe ff ff       	call   80137c <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	ff 75 08             	pushl  0x8(%ebp)
  80152f:	6a 0d                	push   $0xd
  801531:	e8 46 fe ff ff       	call   80137c <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 0e                	push   $0xe
  80154a:	e8 2d fe ff ff       	call   80137c <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
}
  801552:	90                   	nop
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 13                	push   $0x13
  801564:	e8 13 fe ff ff       	call   80137c <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	90                   	nop
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 14                	push   $0x14
  80157e:	e8 f9 fd ff ff       	call   80137c <syscall>
  801583:	83 c4 18             	add    $0x18,%esp
}
  801586:	90                   	nop
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <sys_cputc>:


void
sys_cputc(const char c)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 04             	sub    $0x4,%esp
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801595:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	50                   	push   %eax
  8015a2:	6a 15                	push   $0x15
  8015a4:	e8 d3 fd ff ff       	call   80137c <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	90                   	nop
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 16                	push   $0x16
  8015be:	e8 b9 fd ff ff       	call   80137c <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	90                   	nop
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	ff 75 0c             	pushl  0xc(%ebp)
  8015d8:	50                   	push   %eax
  8015d9:	6a 17                	push   $0x17
  8015db:	e8 9c fd ff ff       	call   80137c <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	52                   	push   %edx
  8015f5:	50                   	push   %eax
  8015f6:	6a 1a                	push   $0x1a
  8015f8:	e8 7f fd ff ff       	call   80137c <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801605:	8b 55 0c             	mov    0xc(%ebp),%edx
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	52                   	push   %edx
  801612:	50                   	push   %eax
  801613:	6a 18                	push   $0x18
  801615:	e8 62 fd ff ff       	call   80137c <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	90                   	nop
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	52                   	push   %edx
  801630:	50                   	push   %eax
  801631:	6a 19                	push   $0x19
  801633:	e8 44 fd ff ff       	call   80137c <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	90                   	nop
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	8b 45 10             	mov    0x10(%ebp),%eax
  801647:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80164a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80164d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	6a 00                	push   $0x0
  801656:	51                   	push   %ecx
  801657:	52                   	push   %edx
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	50                   	push   %eax
  80165c:	6a 1b                	push   $0x1b
  80165e:	e8 19 fd ff ff       	call   80137c <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80166b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	52                   	push   %edx
  801678:	50                   	push   %eax
  801679:	6a 1c                	push   $0x1c
  80167b:	e8 fc fc ff ff       	call   80137c <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801688:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	51                   	push   %ecx
  801696:	52                   	push   %edx
  801697:	50                   	push   %eax
  801698:	6a 1d                	push   $0x1d
  80169a:	e8 dd fc ff ff       	call   80137c <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	6a 1e                	push   $0x1e
  8016b7:	e8 c0 fc ff ff       	call   80137c <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 1f                	push   $0x1f
  8016d0:	e8 a7 fc ff ff       	call   80137c <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	ff 75 14             	pushl  0x14(%ebp)
  8016e5:	ff 75 10             	pushl  0x10(%ebp)
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	50                   	push   %eax
  8016ec:	6a 20                	push   $0x20
  8016ee:	e8 89 fc ff ff       	call   80137c <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	50                   	push   %eax
  801707:	6a 21                	push   $0x21
  801709:	e8 6e fc ff ff       	call   80137c <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	90                   	nop
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	50                   	push   %eax
  801723:	6a 22                	push   $0x22
  801725:	e8 52 fc ff ff       	call   80137c <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 02                	push   $0x2
  80173e:	e8 39 fc ff ff       	call   80137c <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 03                	push   $0x3
  801757:	e8 20 fc ff ff       	call   80137c <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 04                	push   $0x4
  801770:	e8 07 fc ff ff       	call   80137c <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_exit_env>:


void sys_exit_env(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 23                	push   $0x23
  801789:	e8 ee fb ff ff       	call   80137c <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	90                   	nop
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80179a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80179d:	8d 50 04             	lea    0x4(%eax),%edx
  8017a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	6a 24                	push   $0x24
  8017ad:	e8 ca fb ff ff       	call   80137c <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
	return result;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017be:	89 01                	mov    %eax,(%ecx)
  8017c0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	c9                   	leave  
  8017c7:	c2 04 00             	ret    $0x4

008017ca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	ff 75 10             	pushl  0x10(%ebp)
  8017d4:	ff 75 0c             	pushl  0xc(%ebp)
  8017d7:	ff 75 08             	pushl  0x8(%ebp)
  8017da:	6a 12                	push   $0x12
  8017dc:	e8 9b fb ff ff       	call   80137c <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e4:	90                   	nop
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 25                	push   $0x25
  8017f6:	e8 81 fb ff ff       	call   80137c <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80180c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	50                   	push   %eax
  801819:	6a 26                	push   $0x26
  80181b:	e8 5c fb ff ff       	call   80137c <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
	return ;
  801823:	90                   	nop
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <rsttst>:
void rsttst()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 28                	push   $0x28
  801835:	e8 42 fb ff ff       	call   80137c <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return ;
  80183d:	90                   	nop
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80184c:	8b 55 18             	mov    0x18(%ebp),%edx
  80184f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	ff 75 10             	pushl  0x10(%ebp)
  801858:	ff 75 0c             	pushl  0xc(%ebp)
  80185b:	ff 75 08             	pushl  0x8(%ebp)
  80185e:	6a 27                	push   $0x27
  801860:	e8 17 fb ff ff       	call   80137c <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
	return ;
  801868:	90                   	nop
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <chktst>:
void chktst(uint32 n)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	ff 75 08             	pushl  0x8(%ebp)
  801879:	6a 29                	push   $0x29
  80187b:	e8 fc fa ff ff       	call   80137c <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
	return ;
  801883:	90                   	nop
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <inctst>:

void inctst()
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 2a                	push   $0x2a
  801895:	e8 e2 fa ff ff       	call   80137c <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
	return ;
  80189d:	90                   	nop
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <gettst>:
uint32 gettst()
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 2b                	push   $0x2b
  8018af:	e8 c8 fa ff ff       	call   80137c <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 2c                	push   $0x2c
  8018cb:	e8 ac fa ff ff       	call   80137c <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
  8018d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018d6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018da:	75 07                	jne    8018e3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e1:	eb 05                	jmp    8018e8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 2c                	push   $0x2c
  8018fc:	e8 7b fa ff ff       	call   80137c <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
  801904:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801907:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80190b:	75 07                	jne    801914 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80190d:	b8 01 00 00 00       	mov    $0x1,%eax
  801912:	eb 05                	jmp    801919 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 2c                	push   $0x2c
  80192d:	e8 4a fa ff ff       	call   80137c <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
  801935:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801938:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80193c:	75 07                	jne    801945 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80193e:	b8 01 00 00 00       	mov    $0x1,%eax
  801943:	eb 05                	jmp    80194a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 2c                	push   $0x2c
  80195e:	e8 19 fa ff ff       	call   80137c <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
  801966:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801969:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80196d:	75 07                	jne    801976 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80196f:	b8 01 00 00 00       	mov    $0x1,%eax
  801974:	eb 05                	jmp    80197b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	6a 2d                	push   $0x2d
  80198d:	e8 ea f9 ff ff       	call   80137c <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
	return ;
  801995:	90                   	nop
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80199c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80199f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	53                   	push   %ebx
  8019ab:	51                   	push   %ecx
  8019ac:	52                   	push   %edx
  8019ad:	50                   	push   %eax
  8019ae:	6a 2e                	push   $0x2e
  8019b0:	e8 c7 f9 ff ff       	call   80137c <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	52                   	push   %edx
  8019cd:	50                   	push   %eax
  8019ce:	6a 2f                	push   $0x2f
  8019d0:	e8 a7 f9 ff ff       	call   80137c <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    
  8019da:	66 90                	xchg   %ax,%ax

008019dc <__udivdi3>:
  8019dc:	55                   	push   %ebp
  8019dd:	57                   	push   %edi
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	83 ec 1c             	sub    $0x1c,%esp
  8019e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019f3:	89 ca                	mov    %ecx,%edx
  8019f5:	89 f8                	mov    %edi,%eax
  8019f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019fb:	85 f6                	test   %esi,%esi
  8019fd:	75 2d                	jne    801a2c <__udivdi3+0x50>
  8019ff:	39 cf                	cmp    %ecx,%edi
  801a01:	77 65                	ja     801a68 <__udivdi3+0x8c>
  801a03:	89 fd                	mov    %edi,%ebp
  801a05:	85 ff                	test   %edi,%edi
  801a07:	75 0b                	jne    801a14 <__udivdi3+0x38>
  801a09:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0e:	31 d2                	xor    %edx,%edx
  801a10:	f7 f7                	div    %edi
  801a12:	89 c5                	mov    %eax,%ebp
  801a14:	31 d2                	xor    %edx,%edx
  801a16:	89 c8                	mov    %ecx,%eax
  801a18:	f7 f5                	div    %ebp
  801a1a:	89 c1                	mov    %eax,%ecx
  801a1c:	89 d8                	mov    %ebx,%eax
  801a1e:	f7 f5                	div    %ebp
  801a20:	89 cf                	mov    %ecx,%edi
  801a22:	89 fa                	mov    %edi,%edx
  801a24:	83 c4 1c             	add    $0x1c,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    
  801a2c:	39 ce                	cmp    %ecx,%esi
  801a2e:	77 28                	ja     801a58 <__udivdi3+0x7c>
  801a30:	0f bd fe             	bsr    %esi,%edi
  801a33:	83 f7 1f             	xor    $0x1f,%edi
  801a36:	75 40                	jne    801a78 <__udivdi3+0x9c>
  801a38:	39 ce                	cmp    %ecx,%esi
  801a3a:	72 0a                	jb     801a46 <__udivdi3+0x6a>
  801a3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a40:	0f 87 9e 00 00 00    	ja     801ae4 <__udivdi3+0x108>
  801a46:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4b:	89 fa                	mov    %edi,%edx
  801a4d:	83 c4 1c             	add    $0x1c,%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5f                   	pop    %edi
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    
  801a55:	8d 76 00             	lea    0x0(%esi),%esi
  801a58:	31 ff                	xor    %edi,%edi
  801a5a:	31 c0                	xor    %eax,%eax
  801a5c:	89 fa                	mov    %edi,%edx
  801a5e:	83 c4 1c             	add    $0x1c,%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5e                   	pop    %esi
  801a63:	5f                   	pop    %edi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	89 d8                	mov    %ebx,%eax
  801a6a:	f7 f7                	div    %edi
  801a6c:	31 ff                	xor    %edi,%edi
  801a6e:	89 fa                	mov    %edi,%edx
  801a70:	83 c4 1c             	add    $0x1c,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5e                   	pop    %esi
  801a75:	5f                   	pop    %edi
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    
  801a78:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a7d:	89 eb                	mov    %ebp,%ebx
  801a7f:	29 fb                	sub    %edi,%ebx
  801a81:	89 f9                	mov    %edi,%ecx
  801a83:	d3 e6                	shl    %cl,%esi
  801a85:	89 c5                	mov    %eax,%ebp
  801a87:	88 d9                	mov    %bl,%cl
  801a89:	d3 ed                	shr    %cl,%ebp
  801a8b:	89 e9                	mov    %ebp,%ecx
  801a8d:	09 f1                	or     %esi,%ecx
  801a8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a93:	89 f9                	mov    %edi,%ecx
  801a95:	d3 e0                	shl    %cl,%eax
  801a97:	89 c5                	mov    %eax,%ebp
  801a99:	89 d6                	mov    %edx,%esi
  801a9b:	88 d9                	mov    %bl,%cl
  801a9d:	d3 ee                	shr    %cl,%esi
  801a9f:	89 f9                	mov    %edi,%ecx
  801aa1:	d3 e2                	shl    %cl,%edx
  801aa3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aa7:	88 d9                	mov    %bl,%cl
  801aa9:	d3 e8                	shr    %cl,%eax
  801aab:	09 c2                	or     %eax,%edx
  801aad:	89 d0                	mov    %edx,%eax
  801aaf:	89 f2                	mov    %esi,%edx
  801ab1:	f7 74 24 0c          	divl   0xc(%esp)
  801ab5:	89 d6                	mov    %edx,%esi
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	f7 e5                	mul    %ebp
  801abb:	39 d6                	cmp    %edx,%esi
  801abd:	72 19                	jb     801ad8 <__udivdi3+0xfc>
  801abf:	74 0b                	je     801acc <__udivdi3+0xf0>
  801ac1:	89 d8                	mov    %ebx,%eax
  801ac3:	31 ff                	xor    %edi,%edi
  801ac5:	e9 58 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801aca:	66 90                	xchg   %ax,%ax
  801acc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ad0:	89 f9                	mov    %edi,%ecx
  801ad2:	d3 e2                	shl    %cl,%edx
  801ad4:	39 c2                	cmp    %eax,%edx
  801ad6:	73 e9                	jae    801ac1 <__udivdi3+0xe5>
  801ad8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801adb:	31 ff                	xor    %edi,%edi
  801add:	e9 40 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801ae2:	66 90                	xchg   %ax,%ax
  801ae4:	31 c0                	xor    %eax,%eax
  801ae6:	e9 37 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801aeb:	90                   	nop

00801aec <__umoddi3>:
  801aec:	55                   	push   %ebp
  801aed:	57                   	push   %edi
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 1c             	sub    $0x1c,%esp
  801af3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801af7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801afb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b0b:	89 f3                	mov    %esi,%ebx
  801b0d:	89 fa                	mov    %edi,%edx
  801b0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b13:	89 34 24             	mov    %esi,(%esp)
  801b16:	85 c0                	test   %eax,%eax
  801b18:	75 1a                	jne    801b34 <__umoddi3+0x48>
  801b1a:	39 f7                	cmp    %esi,%edi
  801b1c:	0f 86 a2 00 00 00    	jbe    801bc4 <__umoddi3+0xd8>
  801b22:	89 c8                	mov    %ecx,%eax
  801b24:	89 f2                	mov    %esi,%edx
  801b26:	f7 f7                	div    %edi
  801b28:	89 d0                	mov    %edx,%eax
  801b2a:	31 d2                	xor    %edx,%edx
  801b2c:	83 c4 1c             	add    $0x1c,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5f                   	pop    %edi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
  801b34:	39 f0                	cmp    %esi,%eax
  801b36:	0f 87 ac 00 00 00    	ja     801be8 <__umoddi3+0xfc>
  801b3c:	0f bd e8             	bsr    %eax,%ebp
  801b3f:	83 f5 1f             	xor    $0x1f,%ebp
  801b42:	0f 84 ac 00 00 00    	je     801bf4 <__umoddi3+0x108>
  801b48:	bf 20 00 00 00       	mov    $0x20,%edi
  801b4d:	29 ef                	sub    %ebp,%edi
  801b4f:	89 fe                	mov    %edi,%esi
  801b51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b55:	89 e9                	mov    %ebp,%ecx
  801b57:	d3 e0                	shl    %cl,%eax
  801b59:	89 d7                	mov    %edx,%edi
  801b5b:	89 f1                	mov    %esi,%ecx
  801b5d:	d3 ef                	shr    %cl,%edi
  801b5f:	09 c7                	or     %eax,%edi
  801b61:	89 e9                	mov    %ebp,%ecx
  801b63:	d3 e2                	shl    %cl,%edx
  801b65:	89 14 24             	mov    %edx,(%esp)
  801b68:	89 d8                	mov    %ebx,%eax
  801b6a:	d3 e0                	shl    %cl,%eax
  801b6c:	89 c2                	mov    %eax,%edx
  801b6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b72:	d3 e0                	shl    %cl,%eax
  801b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b78:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b7c:	89 f1                	mov    %esi,%ecx
  801b7e:	d3 e8                	shr    %cl,%eax
  801b80:	09 d0                	or     %edx,%eax
  801b82:	d3 eb                	shr    %cl,%ebx
  801b84:	89 da                	mov    %ebx,%edx
  801b86:	f7 f7                	div    %edi
  801b88:	89 d3                	mov    %edx,%ebx
  801b8a:	f7 24 24             	mull   (%esp)
  801b8d:	89 c6                	mov    %eax,%esi
  801b8f:	89 d1                	mov    %edx,%ecx
  801b91:	39 d3                	cmp    %edx,%ebx
  801b93:	0f 82 87 00 00 00    	jb     801c20 <__umoddi3+0x134>
  801b99:	0f 84 91 00 00 00    	je     801c30 <__umoddi3+0x144>
  801b9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ba3:	29 f2                	sub    %esi,%edx
  801ba5:	19 cb                	sbb    %ecx,%ebx
  801ba7:	89 d8                	mov    %ebx,%eax
  801ba9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bad:	d3 e0                	shl    %cl,%eax
  801baf:	89 e9                	mov    %ebp,%ecx
  801bb1:	d3 ea                	shr    %cl,%edx
  801bb3:	09 d0                	or     %edx,%eax
  801bb5:	89 e9                	mov    %ebp,%ecx
  801bb7:	d3 eb                	shr    %cl,%ebx
  801bb9:	89 da                	mov    %ebx,%edx
  801bbb:	83 c4 1c             	add    $0x1c,%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5f                   	pop    %edi
  801bc1:	5d                   	pop    %ebp
  801bc2:	c3                   	ret    
  801bc3:	90                   	nop
  801bc4:	89 fd                	mov    %edi,%ebp
  801bc6:	85 ff                	test   %edi,%edi
  801bc8:	75 0b                	jne    801bd5 <__umoddi3+0xe9>
  801bca:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcf:	31 d2                	xor    %edx,%edx
  801bd1:	f7 f7                	div    %edi
  801bd3:	89 c5                	mov    %eax,%ebp
  801bd5:	89 f0                	mov    %esi,%eax
  801bd7:	31 d2                	xor    %edx,%edx
  801bd9:	f7 f5                	div    %ebp
  801bdb:	89 c8                	mov    %ecx,%eax
  801bdd:	f7 f5                	div    %ebp
  801bdf:	89 d0                	mov    %edx,%eax
  801be1:	e9 44 ff ff ff       	jmp    801b2a <__umoddi3+0x3e>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	89 c8                	mov    %ecx,%eax
  801bea:	89 f2                	mov    %esi,%edx
  801bec:	83 c4 1c             	add    $0x1c,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5f                   	pop    %edi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    
  801bf4:	3b 04 24             	cmp    (%esp),%eax
  801bf7:	72 06                	jb     801bff <__umoddi3+0x113>
  801bf9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bfd:	77 0f                	ja     801c0e <__umoddi3+0x122>
  801bff:	89 f2                	mov    %esi,%edx
  801c01:	29 f9                	sub    %edi,%ecx
  801c03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c07:	89 14 24             	mov    %edx,(%esp)
  801c0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c12:	8b 14 24             	mov    (%esp),%edx
  801c15:	83 c4 1c             	add    $0x1c,%esp
  801c18:	5b                   	pop    %ebx
  801c19:	5e                   	pop    %esi
  801c1a:	5f                   	pop    %edi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    
  801c1d:	8d 76 00             	lea    0x0(%esi),%esi
  801c20:	2b 04 24             	sub    (%esp),%eax
  801c23:	19 fa                	sbb    %edi,%edx
  801c25:	89 d1                	mov    %edx,%ecx
  801c27:	89 c6                	mov    %eax,%esi
  801c29:	e9 71 ff ff ff       	jmp    801b9f <__umoddi3+0xb3>
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c34:	72 ea                	jb     801c20 <__umoddi3+0x134>
  801c36:	89 d9                	mov    %ebx,%ecx
  801c38:	e9 62 ff ff ff       	jmp    801b9f <__umoddi3+0xb3>
