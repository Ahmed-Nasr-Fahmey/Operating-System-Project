
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 28 1e 00 00       	call   801e6e <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 25 80 00       	push   $0x802560
  80004e:	e8 75 0b 00 00       	call   800bc8 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 25 80 00       	push   $0x802562
  80005e:	e8 65 0b 00 00       	call   800bc8 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 25 80 00       	push   $0x802578
  80006e:	e8 55 0b 00 00       	call   800bc8 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 25 80 00       	push   $0x802562
  80007e:	e8 45 0b 00 00       	call   800bc8 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 25 80 00       	push   $0x802560
  80008e:	e8 35 0b 00 00       	call   800bc8 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 25 80 00       	push   $0x802590
  8000a5:	e8 a0 11 00 00       	call   80124a <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 f0 16 00 00       	call   8017b0 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 9d 1a 00 00       	call   801b72 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 b0 25 80 00       	push   $0x8025b0
  8000e3:	e8 e0 0a 00 00       	call   800bc8 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d2 25 80 00       	push   $0x8025d2
  8000f3:	e8 d0 0a 00 00       	call   800bc8 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e0 25 80 00       	push   $0x8025e0
  800103:	e8 c0 0a 00 00       	call   800bc8 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 ef 25 80 00       	push   $0x8025ef
  800113:	e8 b0 0a 00 00       	call   800bc8 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 ff 25 80 00       	push   $0x8025ff
  800123:	e8 a0 0a 00 00       	call   800bc8 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 21 1d 00 00       	call   801e88 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 92 1c 00 00       	call   801e6e <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 08 26 80 00       	push   $0x802608
  8001e4:	e8 df 09 00 00       	call   800bc8 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 97 1c 00 00       	call   801e88 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 3c 26 80 00       	push   $0x80263c
  800213:	6a 4a                	push   $0x4a
  800215:	68 5e 26 80 00       	push   $0x80265e
  80021a:	e8 f5 06 00 00       	call   800914 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 4a 1c 00 00       	call   801e6e <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 7c 26 80 00       	push   $0x80267c
  80022c:	e8 97 09 00 00       	call   800bc8 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 b0 26 80 00       	push   $0x8026b0
  80023c:	e8 87 09 00 00       	call   800bc8 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 e4 26 80 00       	push   $0x8026e4
  80024c:	e8 77 09 00 00       	call   800bc8 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 2f 1c 00 00       	call   801e88 <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 4f 19 00 00       	call   801bb3 <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 02 1c 00 00       	call   801e6e <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 16 27 80 00       	push   $0x802716
  80027a:	e8 49 09 00 00       	call   800bc8 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 c3 1b 00 00       	call   801e88 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 60 25 80 00       	push   $0x802560
  800459:	e8 6a 07 00 00       	call   800bc8 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 34 27 80 00       	push   $0x802734
  80047b:	e8 48 07 00 00       	call   800bc8 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 39 27 80 00       	push   $0x802739
  8004a9:	e8 1a 07 00 00       	call   800bc8 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 23 16 00 00       	call   801b72 <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 0e 16 00 00       	call   801b72 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 a2 14 00 00       	call   801bb3 <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 94 14 00 00       	call   801bb3 <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 64 17 00 00       	call   801ea2 <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 1f 17 00 00       	call   801e6e <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 40 17 00 00       	call   801ea2 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 1e 17 00 00       	call   801e88 <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 68 15 00 00       	call   801ce9 <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 d4 16 00 00       	call   801e6e <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 41 15 00 00       	call   801ce9 <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 d2 16 00 00       	call   801e88 <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 91 18 00 00       	call   802061 <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	c1 e0 02             	shl    $0x2,%eax
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007f1:	01 c8                	add    %ecx,%eax
  8007f3:	c1 e0 02             	shl    $0x2,%eax
  8007f6:	01 d0                	add    %edx,%eax
  8007f8:	c1 e0 02             	shl    $0x2,%eax
  8007fb:	01 d0                	add    %edx,%eax
  8007fd:	c1 e0 03             	shl    $0x3,%eax
  800800:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800805:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80080a:	a1 24 30 80 00       	mov    0x803024,%eax
  80080f:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	74 0f                	je     800828 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800819:	a1 24 30 80 00       	mov    0x803024,%eax
  80081e:	05 18 da 01 00       	add    $0x1da18,%eax
  800823:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800828:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80082c:	7e 0a                	jle    800838 <libmain+0x73>
		binaryname = argv[0];
  80082e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 f2 f7 ff ff       	call   800038 <_main>
  800846:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800849:	e8 20 16 00 00       	call   801e6e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80084e:	83 ec 0c             	sub    $0xc,%esp
  800851:	68 58 27 80 00       	push   $0x802758
  800856:	e8 6d 03 00 00       	call   800bc8 <cprintf>
  80085b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80085e:	a1 24 30 80 00       	mov    0x803024,%eax
  800863:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800869:	a1 24 30 80 00       	mov    0x803024,%eax
  80086e:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800874:	83 ec 04             	sub    $0x4,%esp
  800877:	52                   	push   %edx
  800878:	50                   	push   %eax
  800879:	68 80 27 80 00       	push   $0x802780
  80087e:	e8 45 03 00 00       	call   800bc8 <cprintf>
  800883:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800886:	a1 24 30 80 00       	mov    0x803024,%eax
  80088b:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800891:	a1 24 30 80 00       	mov    0x803024,%eax
  800896:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80089c:	a1 24 30 80 00       	mov    0x803024,%eax
  8008a1:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8008a7:	51                   	push   %ecx
  8008a8:	52                   	push   %edx
  8008a9:	50                   	push   %eax
  8008aa:	68 a8 27 80 00       	push   $0x8027a8
  8008af:	e8 14 03 00 00       	call   800bc8 <cprintf>
  8008b4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008b7:	a1 24 30 80 00       	mov    0x803024,%eax
  8008bc:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	68 00 28 80 00       	push   $0x802800
  8008cb:	e8 f8 02 00 00       	call   800bc8 <cprintf>
  8008d0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 58 27 80 00       	push   $0x802758
  8008db:	e8 e8 02 00 00       	call   800bc8 <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008e3:	e8 a0 15 00 00       	call   801e88 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008e8:	e8 19 00 00 00       	call   800906 <exit>
}
  8008ed:	90                   	nop
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008f6:	83 ec 0c             	sub    $0xc,%esp
  8008f9:	6a 00                	push   $0x0
  8008fb:	e8 2d 17 00 00       	call   80202d <sys_destroy_env>
  800900:	83 c4 10             	add    $0x10,%esp
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <exit>:

void
exit(void)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80090c:	e8 82 17 00 00       	call   802093 <sys_exit_env>
}
  800911:	90                   	nop
  800912:	c9                   	leave  
  800913:	c3                   	ret    

00800914 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80091a:	8d 45 10             	lea    0x10(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800923:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800928:	85 c0                	test   %eax,%eax
  80092a:	74 16                	je     800942 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80092c:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800931:	83 ec 08             	sub    $0x8,%esp
  800934:	50                   	push   %eax
  800935:	68 14 28 80 00       	push   $0x802814
  80093a:	e8 89 02 00 00       	call   800bc8 <cprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800942:	a1 00 30 80 00       	mov    0x803000,%eax
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	50                   	push   %eax
  80094e:	68 19 28 80 00       	push   $0x802819
  800953:	e8 70 02 00 00       	call   800bc8 <cprintf>
  800958:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80095b:	8b 45 10             	mov    0x10(%ebp),%eax
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	ff 75 f4             	pushl  -0xc(%ebp)
  800964:	50                   	push   %eax
  800965:	e8 f3 01 00 00       	call   800b5d <vcprintf>
  80096a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	6a 00                	push   $0x0
  800972:	68 35 28 80 00       	push   $0x802835
  800977:	e8 e1 01 00 00       	call   800b5d <vcprintf>
  80097c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80097f:	e8 82 ff ff ff       	call   800906 <exit>

	// should not return here
	while (1) ;
  800984:	eb fe                	jmp    800984 <_panic+0x70>

00800986 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80098c:	a1 24 30 80 00       	mov    0x803024,%eax
  800991:	8b 50 74             	mov    0x74(%eax),%edx
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	39 c2                	cmp    %eax,%edx
  800999:	74 14                	je     8009af <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80099b:	83 ec 04             	sub    $0x4,%esp
  80099e:	68 38 28 80 00       	push   $0x802838
  8009a3:	6a 26                	push   $0x26
  8009a5:	68 84 28 80 00       	push   $0x802884
  8009aa:	e8 65 ff ff ff       	call   800914 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009bd:	e9 c2 00 00 00       	jmp    800a84 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	01 d0                	add    %edx,%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	85 c0                	test   %eax,%eax
  8009d5:	75 08                	jne    8009df <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009d7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009da:	e9 a2 00 00 00       	jmp    800a81 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009ed:	eb 69                	jmp    800a58 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ef:	a1 24 30 80 00       	mov    0x803024,%eax
  8009f4:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8009fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009fd:	89 d0                	mov    %edx,%eax
  8009ff:	01 c0                	add    %eax,%eax
  800a01:	01 d0                	add    %edx,%eax
  800a03:	c1 e0 03             	shl    $0x3,%eax
  800a06:	01 c8                	add    %ecx,%eax
  800a08:	8a 40 04             	mov    0x4(%eax),%al
  800a0b:	84 c0                	test   %al,%al
  800a0d:	75 46                	jne    800a55 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0f:	a1 24 30 80 00       	mov    0x803024,%eax
  800a14:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800a1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a1d:	89 d0                	mov    %edx,%eax
  800a1f:	01 c0                	add    %eax,%eax
  800a21:	01 d0                	add    %edx,%eax
  800a23:	c1 e0 03             	shl    $0x3,%eax
  800a26:	01 c8                	add    %ecx,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a35:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	01 c8                	add    %ecx,%eax
  800a46:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a48:	39 c2                	cmp    %eax,%edx
  800a4a:	75 09                	jne    800a55 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a4c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a53:	eb 12                	jmp    800a67 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a55:	ff 45 e8             	incl   -0x18(%ebp)
  800a58:	a1 24 30 80 00       	mov    0x803024,%eax
  800a5d:	8b 50 74             	mov    0x74(%eax),%edx
  800a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a63:	39 c2                	cmp    %eax,%edx
  800a65:	77 88                	ja     8009ef <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a6b:	75 14                	jne    800a81 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a6d:	83 ec 04             	sub    $0x4,%esp
  800a70:	68 90 28 80 00       	push   $0x802890
  800a75:	6a 3a                	push   $0x3a
  800a77:	68 84 28 80 00       	push   $0x802884
  800a7c:	e8 93 fe ff ff       	call   800914 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a81:	ff 45 f0             	incl   -0x10(%ebp)
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a8a:	0f 8c 32 ff ff ff    	jl     8009c2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a97:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a9e:	eb 26                	jmp    800ac6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800aa0:	a1 24 30 80 00       	mov    0x803024,%eax
  800aa5:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800aab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aae:	89 d0                	mov    %edx,%eax
  800ab0:	01 c0                	add    %eax,%eax
  800ab2:	01 d0                	add    %edx,%eax
  800ab4:	c1 e0 03             	shl    $0x3,%eax
  800ab7:	01 c8                	add    %ecx,%eax
  800ab9:	8a 40 04             	mov    0x4(%eax),%al
  800abc:	3c 01                	cmp    $0x1,%al
  800abe:	75 03                	jne    800ac3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ac0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ac3:	ff 45 e0             	incl   -0x20(%ebp)
  800ac6:	a1 24 30 80 00       	mov    0x803024,%eax
  800acb:	8b 50 74             	mov    0x74(%eax),%edx
  800ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad1:	39 c2                	cmp    %eax,%edx
  800ad3:	77 cb                	ja     800aa0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800adb:	74 14                	je     800af1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800add:	83 ec 04             	sub    $0x4,%esp
  800ae0:	68 e4 28 80 00       	push   $0x8028e4
  800ae5:	6a 44                	push   $0x44
  800ae7:	68 84 28 80 00       	push   $0x802884
  800aec:	e8 23 fe ff ff       	call   800914 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800af1:	90                   	nop
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	8d 48 01             	lea    0x1(%eax),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 0a                	mov    %ecx,(%edx)
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	88 d1                	mov    %dl,%cl
  800b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b16:	8b 00                	mov    (%eax),%eax
  800b18:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b1d:	75 2c                	jne    800b4b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b1f:	a0 28 30 80 00       	mov    0x803028,%al
  800b24:	0f b6 c0             	movzbl %al,%eax
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	8b 12                	mov    (%edx),%edx
  800b2c:	89 d1                	mov    %edx,%ecx
  800b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b31:	83 c2 08             	add    $0x8,%edx
  800b34:	83 ec 04             	sub    $0x4,%esp
  800b37:	50                   	push   %eax
  800b38:	51                   	push   %ecx
  800b39:	52                   	push   %edx
  800b3a:	e8 81 11 00 00       	call   801cc0 <sys_cputs>
  800b3f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	8d 50 01             	lea    0x1(%eax),%edx
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b5a:	90                   	nop
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b66:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b6d:	00 00 00 
	b.cnt = 0;
  800b70:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b77:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b7a:	ff 75 0c             	pushl  0xc(%ebp)
  800b7d:	ff 75 08             	pushl  0x8(%ebp)
  800b80:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	68 f4 0a 80 00       	push   $0x800af4
  800b8c:	e8 11 02 00 00       	call   800da2 <vprintfmt>
  800b91:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b94:	a0 28 30 80 00       	mov    0x803028,%al
  800b99:	0f b6 c0             	movzbl %al,%eax
  800b9c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ba2:	83 ec 04             	sub    $0x4,%esp
  800ba5:	50                   	push   %eax
  800ba6:	52                   	push   %edx
  800ba7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bad:	83 c0 08             	add    $0x8,%eax
  800bb0:	50                   	push   %eax
  800bb1:	e8 0a 11 00 00       	call   801cc0 <sys_cputs>
  800bb6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bb9:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800bc0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bce:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800bd5:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 f4             	pushl  -0xc(%ebp)
  800be4:	50                   	push   %eax
  800be5:	e8 73 ff ff ff       	call   800b5d <vcprintf>
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bfb:	e8 6e 12 00 00       	call   801e6e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c00:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0f:	50                   	push   %eax
  800c10:	e8 48 ff ff ff       	call   800b5d <vcprintf>
  800c15:	83 c4 10             	add    $0x10,%esp
  800c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c1b:	e8 68 12 00 00       	call   801e88 <sys_enable_interrupt>
	return cnt;
  800c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	53                   	push   %ebx
  800c29:	83 ec 14             	sub    $0x14,%esp
  800c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c32:	8b 45 14             	mov    0x14(%ebp),%eax
  800c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c38:	8b 45 18             	mov    0x18(%ebp),%eax
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c43:	77 55                	ja     800c9a <printnum+0x75>
  800c45:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c48:	72 05                	jb     800c4f <printnum+0x2a>
  800c4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c4d:	77 4b                	ja     800c9a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c4f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c52:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c55:	8b 45 18             	mov    0x18(%ebp),%eax
  800c58:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5d:	52                   	push   %edx
  800c5e:	50                   	push   %eax
  800c5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c62:	ff 75 f0             	pushl  -0x10(%ebp)
  800c65:	e8 8a 16 00 00       	call   8022f4 <__udivdi3>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	83 ec 04             	sub    $0x4,%esp
  800c70:	ff 75 20             	pushl  0x20(%ebp)
  800c73:	53                   	push   %ebx
  800c74:	ff 75 18             	pushl  0x18(%ebp)
  800c77:	52                   	push   %edx
  800c78:	50                   	push   %eax
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 08             	pushl  0x8(%ebp)
  800c7f:	e8 a1 ff ff ff       	call   800c25 <printnum>
  800c84:	83 c4 20             	add    $0x20,%esp
  800c87:	eb 1a                	jmp    800ca3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	ff 75 20             	pushl  0x20(%ebp)
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	ff d0                	call   *%eax
  800c97:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c9a:	ff 4d 1c             	decl   0x1c(%ebp)
  800c9d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ca1:	7f e6                	jg     800c89 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ca3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ca6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	53                   	push   %ebx
  800cb2:	51                   	push   %ecx
  800cb3:	52                   	push   %edx
  800cb4:	50                   	push   %eax
  800cb5:	e8 4a 17 00 00       	call   802404 <__umoddi3>
  800cba:	83 c4 10             	add    $0x10,%esp
  800cbd:	05 54 2b 80 00       	add    $0x802b54,%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f be c0             	movsbl %al,%eax
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	50                   	push   %eax
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	ff d0                	call   *%eax
  800cd3:	83 c4 10             	add    $0x10,%esp
}
  800cd6:	90                   	nop
  800cd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cdf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ce3:	7e 1c                	jle    800d01 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8b 00                	mov    (%eax),%eax
  800cea:	8d 50 08             	lea    0x8(%eax),%edx
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	89 10                	mov    %edx,(%eax)
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	83 e8 08             	sub    $0x8,%eax
  800cfa:	8b 50 04             	mov    0x4(%eax),%edx
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	eb 40                	jmp    800d41 <getuint+0x65>
	else if (lflag)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 1e                	je     800d25 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8b 00                	mov    (%eax),%eax
  800d0c:	8d 50 04             	lea    0x4(%eax),%edx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 10                	mov    %edx,(%eax)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8b 00                	mov    (%eax),%eax
  800d19:	83 e8 04             	sub    $0x4,%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d23:	eb 1c                	jmp    800d41 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8b 00                	mov    (%eax),%eax
  800d2a:	8d 50 04             	lea    0x4(%eax),%edx
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	89 10                	mov    %edx,(%eax)
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8b 00                	mov    (%eax),%eax
  800d37:	83 e8 04             	sub    $0x4,%eax
  800d3a:	8b 00                	mov    (%eax),%eax
  800d3c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d46:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d4a:	7e 1c                	jle    800d68 <getint+0x25>
		return va_arg(*ap, long long);
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	8d 50 08             	lea    0x8(%eax),%edx
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	89 10                	mov    %edx,(%eax)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	83 e8 08             	sub    $0x8,%eax
  800d61:	8b 50 04             	mov    0x4(%eax),%edx
  800d64:	8b 00                	mov    (%eax),%eax
  800d66:	eb 38                	jmp    800da0 <getint+0x5d>
	else if (lflag)
  800d68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6c:	74 1a                	je     800d88 <getint+0x45>
		return va_arg(*ap, long);
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8b 00                	mov    (%eax),%eax
  800d73:	8d 50 04             	lea    0x4(%eax),%edx
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	89 10                	mov    %edx,(%eax)
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8b 00                	mov    (%eax),%eax
  800d80:	83 e8 04             	sub    $0x4,%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	99                   	cltd   
  800d86:	eb 18                	jmp    800da0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	8d 50 04             	lea    0x4(%eax),%edx
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 10                	mov    %edx,(%eax)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	83 e8 04             	sub    $0x4,%eax
  800d9d:	8b 00                	mov    (%eax),%eax
  800d9f:	99                   	cltd   
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
  800da7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800daa:	eb 17                	jmp    800dc3 <vprintfmt+0x21>
			if (ch == '\0')
  800dac:	85 db                	test   %ebx,%ebx
  800dae:	0f 84 af 03 00 00    	je     801163 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800db4:	83 ec 08             	sub    $0x8,%esp
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	53                   	push   %ebx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	ff d0                	call   *%eax
  800dc0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f b6 d8             	movzbl %al,%ebx
  800dd1:	83 fb 25             	cmp    $0x25,%ebx
  800dd4:	75 d6                	jne    800dac <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dd6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dda:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800de1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800de8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800def:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800df6:	8b 45 10             	mov    0x10(%ebp),%eax
  800df9:	8d 50 01             	lea    0x1(%eax),%edx
  800dfc:	89 55 10             	mov    %edx,0x10(%ebp)
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 d8             	movzbl %al,%ebx
  800e04:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e07:	83 f8 55             	cmp    $0x55,%eax
  800e0a:	0f 87 2b 03 00 00    	ja     80113b <vprintfmt+0x399>
  800e10:	8b 04 85 78 2b 80 00 	mov    0x802b78(,%eax,4),%eax
  800e17:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e19:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e1d:	eb d7                	jmp    800df6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e1f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e23:	eb d1                	jmp    800df6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e2f:	89 d0                	mov    %edx,%eax
  800e31:	c1 e0 02             	shl    $0x2,%eax
  800e34:	01 d0                	add    %edx,%eax
  800e36:	01 c0                	add    %eax,%eax
  800e38:	01 d8                	add    %ebx,%eax
  800e3a:	83 e8 30             	sub    $0x30,%eax
  800e3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e40:	8b 45 10             	mov    0x10(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e48:	83 fb 2f             	cmp    $0x2f,%ebx
  800e4b:	7e 3e                	jle    800e8b <vprintfmt+0xe9>
  800e4d:	83 fb 39             	cmp    $0x39,%ebx
  800e50:	7f 39                	jg     800e8b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e52:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e55:	eb d5                	jmp    800e2c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e57:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5a:	83 c0 04             	add    $0x4,%eax
  800e5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e60:	8b 45 14             	mov    0x14(%ebp),%eax
  800e63:	83 e8 04             	sub    $0x4,%eax
  800e66:	8b 00                	mov    (%eax),%eax
  800e68:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e6b:	eb 1f                	jmp    800e8c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e71:	79 83                	jns    800df6 <vprintfmt+0x54>
				width = 0;
  800e73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e7a:	e9 77 ff ff ff       	jmp    800df6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e7f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e86:	e9 6b ff ff ff       	jmp    800df6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e8b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e90:	0f 89 60 ff ff ff    	jns    800df6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ea3:	e9 4e ff ff ff       	jmp    800df6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800eab:	e9 46 ff ff ff       	jmp    800df6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800eb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb3:	83 c0 04             	add    $0x4,%eax
  800eb6:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebc:	83 e8 04             	sub    $0x4,%eax
  800ebf:	8b 00                	mov    (%eax),%eax
  800ec1:	83 ec 08             	sub    $0x8,%esp
  800ec4:	ff 75 0c             	pushl  0xc(%ebp)
  800ec7:	50                   	push   %eax
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	ff d0                	call   *%eax
  800ecd:	83 c4 10             	add    $0x10,%esp
			break;
  800ed0:	e9 89 02 00 00       	jmp    80115e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 c0 04             	add    $0x4,%eax
  800edb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ede:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee1:	83 e8 04             	sub    $0x4,%eax
  800ee4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ee6:	85 db                	test   %ebx,%ebx
  800ee8:	79 02                	jns    800eec <vprintfmt+0x14a>
				err = -err;
  800eea:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eec:	83 fb 64             	cmp    $0x64,%ebx
  800eef:	7f 0b                	jg     800efc <vprintfmt+0x15a>
  800ef1:	8b 34 9d c0 29 80 00 	mov    0x8029c0(,%ebx,4),%esi
  800ef8:	85 f6                	test   %esi,%esi
  800efa:	75 19                	jne    800f15 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800efc:	53                   	push   %ebx
  800efd:	68 65 2b 80 00       	push   $0x802b65
  800f02:	ff 75 0c             	pushl  0xc(%ebp)
  800f05:	ff 75 08             	pushl  0x8(%ebp)
  800f08:	e8 5e 02 00 00       	call   80116b <printfmt>
  800f0d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f10:	e9 49 02 00 00       	jmp    80115e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f15:	56                   	push   %esi
  800f16:	68 6e 2b 80 00       	push   $0x802b6e
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	ff 75 08             	pushl  0x8(%ebp)
  800f21:	e8 45 02 00 00       	call   80116b <printfmt>
  800f26:	83 c4 10             	add    $0x10,%esp
			break;
  800f29:	e9 30 02 00 00       	jmp    80115e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 30                	mov    (%eax),%esi
  800f3f:	85 f6                	test   %esi,%esi
  800f41:	75 05                	jne    800f48 <vprintfmt+0x1a6>
				p = "(null)";
  800f43:	be 71 2b 80 00       	mov    $0x802b71,%esi
			if (width > 0 && padc != '-')
  800f48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f4c:	7e 6d                	jle    800fbb <vprintfmt+0x219>
  800f4e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f52:	74 67                	je     800fbb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f57:	83 ec 08             	sub    $0x8,%esp
  800f5a:	50                   	push   %eax
  800f5b:	56                   	push   %esi
  800f5c:	e8 12 05 00 00       	call   801473 <strnlen>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f67:	eb 16                	jmp    800f7f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f69:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	50                   	push   %eax
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	ff d0                	call   *%eax
  800f79:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f7c:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f83:	7f e4                	jg     800f69 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f85:	eb 34                	jmp    800fbb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f87:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f8b:	74 1c                	je     800fa9 <vprintfmt+0x207>
  800f8d:	83 fb 1f             	cmp    $0x1f,%ebx
  800f90:	7e 05                	jle    800f97 <vprintfmt+0x1f5>
  800f92:	83 fb 7e             	cmp    $0x7e,%ebx
  800f95:	7e 12                	jle    800fa9 <vprintfmt+0x207>
					putch('?', putdat);
  800f97:	83 ec 08             	sub    $0x8,%esp
  800f9a:	ff 75 0c             	pushl  0xc(%ebp)
  800f9d:	6a 3f                	push   $0x3f
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	ff d0                	call   *%eax
  800fa4:	83 c4 10             	add    $0x10,%esp
  800fa7:	eb 0f                	jmp    800fb8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	ff 75 0c             	pushl  0xc(%ebp)
  800faf:	53                   	push   %ebx
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	ff d0                	call   *%eax
  800fb5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb8:	ff 4d e4             	decl   -0x1c(%ebp)
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	8d 70 01             	lea    0x1(%eax),%esi
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	0f be d8             	movsbl %al,%ebx
  800fc5:	85 db                	test   %ebx,%ebx
  800fc7:	74 24                	je     800fed <vprintfmt+0x24b>
  800fc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fcd:	78 b8                	js     800f87 <vprintfmt+0x1e5>
  800fcf:	ff 4d e0             	decl   -0x20(%ebp)
  800fd2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fd6:	79 af                	jns    800f87 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd8:	eb 13                	jmp    800fed <vprintfmt+0x24b>
				putch(' ', putdat);
  800fda:	83 ec 08             	sub    $0x8,%esp
  800fdd:	ff 75 0c             	pushl  0xc(%ebp)
  800fe0:	6a 20                	push   $0x20
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	ff d0                	call   *%eax
  800fe7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fea:	ff 4d e4             	decl   -0x1c(%ebp)
  800fed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff1:	7f e7                	jg     800fda <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ff3:	e9 66 01 00 00       	jmp    80115e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ffe:	8d 45 14             	lea    0x14(%ebp),%eax
  801001:	50                   	push   %eax
  801002:	e8 3c fd ff ff       	call   800d43 <getint>
  801007:	83 c4 10             	add    $0x10,%esp
  80100a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801013:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801016:	85 d2                	test   %edx,%edx
  801018:	79 23                	jns    80103d <vprintfmt+0x29b>
				putch('-', putdat);
  80101a:	83 ec 08             	sub    $0x8,%esp
  80101d:	ff 75 0c             	pushl  0xc(%ebp)
  801020:	6a 2d                	push   $0x2d
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	ff d0                	call   *%eax
  801027:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80102a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801030:	f7 d8                	neg    %eax
  801032:	83 d2 00             	adc    $0x0,%edx
  801035:	f7 da                	neg    %edx
  801037:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80103d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801044:	e9 bc 00 00 00       	jmp    801105 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801049:	83 ec 08             	sub    $0x8,%esp
  80104c:	ff 75 e8             	pushl  -0x18(%ebp)
  80104f:	8d 45 14             	lea    0x14(%ebp),%eax
  801052:	50                   	push   %eax
  801053:	e8 84 fc ff ff       	call   800cdc <getuint>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801061:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801068:	e9 98 00 00 00       	jmp    801105 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80106d:	83 ec 08             	sub    $0x8,%esp
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	6a 58                	push   $0x58
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	ff d0                	call   *%eax
  80107a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107d:	83 ec 08             	sub    $0x8,%esp
  801080:	ff 75 0c             	pushl  0xc(%ebp)
  801083:	6a 58                	push   $0x58
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	ff d0                	call   *%eax
  80108a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	6a 58                	push   $0x58
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	ff d0                	call   *%eax
  80109a:	83 c4 10             	add    $0x10,%esp
			break;
  80109d:	e9 bc 00 00 00       	jmp    80115e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8010a2:	83 ec 08             	sub    $0x8,%esp
  8010a5:	ff 75 0c             	pushl  0xc(%ebp)
  8010a8:	6a 30                	push   $0x30
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	ff d0                	call   *%eax
  8010af:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010b2:	83 ec 08             	sub    $0x8,%esp
  8010b5:	ff 75 0c             	pushl  0xc(%ebp)
  8010b8:	6a 78                	push   $0x78
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	ff d0                	call   *%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c5:	83 c0 04             	add    $0x4,%eax
  8010c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8010cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ce:	83 e8 04             	sub    $0x4,%eax
  8010d1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010e4:	eb 1f                	jmp    801105 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8010ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ef:	50                   	push   %eax
  8010f0:	e8 e7 fb ff ff       	call   800cdc <getuint>
  8010f5:	83 c4 10             	add    $0x10,%esp
  8010f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801105:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	52                   	push   %edx
  801110:	ff 75 e4             	pushl  -0x1c(%ebp)
  801113:	50                   	push   %eax
  801114:	ff 75 f4             	pushl  -0xc(%ebp)
  801117:	ff 75 f0             	pushl  -0x10(%ebp)
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	ff 75 08             	pushl  0x8(%ebp)
  801120:	e8 00 fb ff ff       	call   800c25 <printnum>
  801125:	83 c4 20             	add    $0x20,%esp
			break;
  801128:	eb 34                	jmp    80115e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80112a:	83 ec 08             	sub    $0x8,%esp
  80112d:	ff 75 0c             	pushl  0xc(%ebp)
  801130:	53                   	push   %ebx
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	ff d0                	call   *%eax
  801136:	83 c4 10             	add    $0x10,%esp
			break;
  801139:	eb 23                	jmp    80115e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	6a 25                	push   $0x25
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	ff d0                	call   *%eax
  801148:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80114b:	ff 4d 10             	decl   0x10(%ebp)
  80114e:	eb 03                	jmp    801153 <vprintfmt+0x3b1>
  801150:	ff 4d 10             	decl   0x10(%ebp)
  801153:	8b 45 10             	mov    0x10(%ebp),%eax
  801156:	48                   	dec    %eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 25                	cmp    $0x25,%al
  80115b:	75 f3                	jne    801150 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80115d:	90                   	nop
		}
	}
  80115e:	e9 47 fc ff ff       	jmp    800daa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801163:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801164:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801171:	8d 45 10             	lea    0x10(%ebp),%eax
  801174:	83 c0 04             	add    $0x4,%eax
  801177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	ff 75 f4             	pushl  -0xc(%ebp)
  801180:	50                   	push   %eax
  801181:	ff 75 0c             	pushl  0xc(%ebp)
  801184:	ff 75 08             	pushl  0x8(%ebp)
  801187:	e8 16 fc ff ff       	call   800da2 <vprintfmt>
  80118c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80118f:	90                   	nop
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	8b 40 08             	mov    0x8(%eax),%eax
  80119b:	8d 50 01             	lea    0x1(%eax),%edx
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	8b 10                	mov    (%eax),%edx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	8b 40 04             	mov    0x4(%eax),%eax
  8011af:	39 c2                	cmp    %eax,%edx
  8011b1:	73 12                	jae    8011c5 <sprintputch+0x33>
		*b->buf++ = ch;
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8b 00                	mov    (%eax),%eax
  8011b8:	8d 48 01             	lea    0x1(%eax),%ecx
  8011bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011be:	89 0a                	mov    %ecx,(%edx)
  8011c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c3:	88 10                	mov    %dl,(%eax)
}
  8011c5:	90                   	nop
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    

008011c8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	01 d0                	add    %edx,%eax
  8011df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ed:	74 06                	je     8011f5 <vsnprintf+0x2d>
  8011ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011f3:	7f 07                	jg     8011fc <vsnprintf+0x34>
		return -E_INVAL;
  8011f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8011fa:	eb 20                	jmp    80121c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011fc:	ff 75 14             	pushl  0x14(%ebp)
  8011ff:	ff 75 10             	pushl  0x10(%ebp)
  801202:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801205:	50                   	push   %eax
  801206:	68 92 11 80 00       	push   $0x801192
  80120b:	e8 92 fb ff ff       	call   800da2 <vprintfmt>
  801210:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801219:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801224:	8d 45 10             	lea    0x10(%ebp),%eax
  801227:	83 c0 04             	add    $0x4,%eax
  80122a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	ff 75 f4             	pushl  -0xc(%ebp)
  801233:	50                   	push   %eax
  801234:	ff 75 0c             	pushl  0xc(%ebp)
  801237:	ff 75 08             	pushl  0x8(%ebp)
  80123a:	e8 89 ff ff ff       	call   8011c8 <vsnprintf>
  80123f:	83 c4 10             	add    $0x10,%esp
  801242:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801245:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801254:	74 13                	je     801269 <readline+0x1f>
		cprintf("%s", prompt);
  801256:	83 ec 08             	sub    $0x8,%esp
  801259:	ff 75 08             	pushl  0x8(%ebp)
  80125c:	68 d0 2c 80 00       	push   $0x802cd0
  801261:	e8 62 f9 ff ff       	call   800bc8 <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	6a 00                	push   $0x0
  801275:	e8 41 f5 ff ff       	call   8007bb <iscons>
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801280:	e8 e8 f4 ff ff       	call   80076d <getchar>
  801285:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801288:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80128c:	79 22                	jns    8012b0 <readline+0x66>
			if (c != -E_EOF)
  80128e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801292:	0f 84 ad 00 00 00    	je     801345 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801298:	83 ec 08             	sub    $0x8,%esp
  80129b:	ff 75 ec             	pushl  -0x14(%ebp)
  80129e:	68 d3 2c 80 00       	push   $0x802cd3
  8012a3:	e8 20 f9 ff ff       	call   800bc8 <cprintf>
  8012a8:	83 c4 10             	add    $0x10,%esp
			return;
  8012ab:	e9 95 00 00 00       	jmp    801345 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012b0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012b4:	7e 34                	jle    8012ea <readline+0xa0>
  8012b6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012bd:	7f 2b                	jg     8012ea <readline+0xa0>
			if (echoing)
  8012bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c3:	74 0e                	je     8012d3 <readline+0x89>
				cputchar(c);
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012cb:	e8 55 f4 ff ff       	call   800725 <cputchar>
  8012d0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012dc:	89 c2                	mov    %eax,%edx
  8012de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e6:	88 10                	mov    %dl,(%eax)
  8012e8:	eb 56                	jmp    801340 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ea:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012ee:	75 1f                	jne    80130f <readline+0xc5>
  8012f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012f4:	7e 19                	jle    80130f <readline+0xc5>
			if (echoing)
  8012f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012fa:	74 0e                	je     80130a <readline+0xc0>
				cputchar(c);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801302:	e8 1e f4 ff ff       	call   800725 <cputchar>
  801307:	83 c4 10             	add    $0x10,%esp

			i--;
  80130a:	ff 4d f4             	decl   -0xc(%ebp)
  80130d:	eb 31                	jmp    801340 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80130f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801313:	74 0a                	je     80131f <readline+0xd5>
  801315:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801319:	0f 85 61 ff ff ff    	jne    801280 <readline+0x36>
			if (echoing)
  80131f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801323:	74 0e                	je     801333 <readline+0xe9>
				cputchar(c);
  801325:	83 ec 0c             	sub    $0xc,%esp
  801328:	ff 75 ec             	pushl  -0x14(%ebp)
  80132b:	e8 f5 f3 ff ff       	call   800725 <cputchar>
  801330:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801333:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80133e:	eb 06                	jmp    801346 <readline+0xfc>
		}
	}
  801340:	e9 3b ff ff ff       	jmp    801280 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801345:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80134e:	e8 1b 0b 00 00       	call   801e6e <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801353:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801357:	74 13                	je     80136c <atomic_readline+0x24>
		cprintf("%s", prompt);
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	ff 75 08             	pushl  0x8(%ebp)
  80135f:	68 d0 2c 80 00       	push   $0x802cd0
  801364:	e8 5f f8 ff ff       	call   800bc8 <cprintf>
  801369:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80136c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801373:	83 ec 0c             	sub    $0xc,%esp
  801376:	6a 00                	push   $0x0
  801378:	e8 3e f4 ff ff       	call   8007bb <iscons>
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801383:	e8 e5 f3 ff ff       	call   80076d <getchar>
  801388:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80138b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80138f:	79 23                	jns    8013b4 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801391:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801395:	74 13                	je     8013aa <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801397:	83 ec 08             	sub    $0x8,%esp
  80139a:	ff 75 ec             	pushl  -0x14(%ebp)
  80139d:	68 d3 2c 80 00       	push   $0x802cd3
  8013a2:	e8 21 f8 ff ff       	call   800bc8 <cprintf>
  8013a7:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8013aa:	e8 d9 0a 00 00       	call   801e88 <sys_enable_interrupt>
			return;
  8013af:	e9 9a 00 00 00       	jmp    80144e <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013b4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013b8:	7e 34                	jle    8013ee <atomic_readline+0xa6>
  8013ba:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013c1:	7f 2b                	jg     8013ee <atomic_readline+0xa6>
			if (echoing)
  8013c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c7:	74 0e                	je     8013d7 <atomic_readline+0x8f>
				cputchar(c);
  8013c9:	83 ec 0c             	sub    $0xc,%esp
  8013cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8013cf:	e8 51 f3 ff ff       	call   800725 <cputchar>
  8013d4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013da:	8d 50 01             	lea    0x1(%eax),%edx
  8013dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013e0:	89 c2                	mov    %eax,%edx
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	01 d0                	add    %edx,%eax
  8013e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ea:	88 10                	mov    %dl,(%eax)
  8013ec:	eb 5b                	jmp    801449 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013ee:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013f2:	75 1f                	jne    801413 <atomic_readline+0xcb>
  8013f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013f8:	7e 19                	jle    801413 <atomic_readline+0xcb>
			if (echoing)
  8013fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013fe:	74 0e                	je     80140e <atomic_readline+0xc6>
				cputchar(c);
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	ff 75 ec             	pushl  -0x14(%ebp)
  801406:	e8 1a f3 ff ff       	call   800725 <cputchar>
  80140b:	83 c4 10             	add    $0x10,%esp
			i--;
  80140e:	ff 4d f4             	decl   -0xc(%ebp)
  801411:	eb 36                	jmp    801449 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801413:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801417:	74 0a                	je     801423 <atomic_readline+0xdb>
  801419:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80141d:	0f 85 60 ff ff ff    	jne    801383 <atomic_readline+0x3b>
			if (echoing)
  801423:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801427:	74 0e                	je     801437 <atomic_readline+0xef>
				cputchar(c);
  801429:	83 ec 0c             	sub    $0xc,%esp
  80142c:	ff 75 ec             	pushl  -0x14(%ebp)
  80142f:	e8 f1 f2 ff ff       	call   800725 <cputchar>
  801434:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 d0                	add    %edx,%eax
  80143f:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801442:	e8 41 0a 00 00       	call   801e88 <sys_enable_interrupt>
			return;
  801447:	eb 05                	jmp    80144e <atomic_readline+0x106>
		}
	}
  801449:	e9 35 ff ff ff       	jmp    801383 <atomic_readline+0x3b>
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801456:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145d:	eb 06                	jmp    801465 <strlen+0x15>
		n++;
  80145f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801462:	ff 45 08             	incl   0x8(%ebp)
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	84 c0                	test   %al,%al
  80146c:	75 f1                	jne    80145f <strlen+0xf>
		n++;
	return n;
  80146e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801480:	eb 09                	jmp    80148b <strnlen+0x18>
		n++;
  801482:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801485:	ff 45 08             	incl   0x8(%ebp)
  801488:	ff 4d 0c             	decl   0xc(%ebp)
  80148b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148f:	74 09                	je     80149a <strnlen+0x27>
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	84 c0                	test   %al,%al
  801498:	75 e8                	jne    801482 <strnlen+0xf>
		n++;
	return n;
  80149a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8014ab:	90                   	nop
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8d 50 01             	lea    0x1(%eax),%edx
  8014b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014bb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014be:	8a 12                	mov    (%edx),%dl
  8014c0:	88 10                	mov    %dl,(%eax)
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	84 c0                	test   %al,%al
  8014c6:	75 e4                	jne    8014ac <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014e0:	eb 1f                	jmp    801501 <strncpy+0x34>
		*dst++ = *src;
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	8d 50 01             	lea    0x1(%eax),%edx
  8014e8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	8a 12                	mov    (%edx),%dl
  8014f0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	84 c0                	test   %al,%al
  8014f9:	74 03                	je     8014fe <strncpy+0x31>
			src++;
  8014fb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014fe:	ff 45 fc             	incl   -0x4(%ebp)
  801501:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801504:	3b 45 10             	cmp    0x10(%ebp),%eax
  801507:	72 d9                	jb     8014e2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801509:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80151a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80151e:	74 30                	je     801550 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801520:	eb 16                	jmp    801538 <strlcpy+0x2a>
			*dst++ = *src++;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8d 50 01             	lea    0x1(%eax),%edx
  801528:	89 55 08             	mov    %edx,0x8(%ebp)
  80152b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801531:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801534:	8a 12                	mov    (%edx),%dl
  801536:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801538:	ff 4d 10             	decl   0x10(%ebp)
  80153b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153f:	74 09                	je     80154a <strlcpy+0x3c>
  801541:	8b 45 0c             	mov    0xc(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	84 c0                	test   %al,%al
  801548:	75 d8                	jne    801522 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801550:	8b 55 08             	mov    0x8(%ebp),%edx
  801553:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801556:	29 c2                	sub    %eax,%edx
  801558:	89 d0                	mov    %edx,%eax
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80155f:	eb 06                	jmp    801567 <strcmp+0xb>
		p++, q++;
  801561:	ff 45 08             	incl   0x8(%ebp)
  801564:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	84 c0                	test   %al,%al
  80156e:	74 0e                	je     80157e <strcmp+0x22>
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8a 10                	mov    (%eax),%dl
  801575:	8b 45 0c             	mov    0xc(%ebp),%eax
  801578:	8a 00                	mov    (%eax),%al
  80157a:	38 c2                	cmp    %al,%dl
  80157c:	74 e3                	je     801561 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	0f b6 d0             	movzbl %al,%edx
  801586:	8b 45 0c             	mov    0xc(%ebp),%eax
  801589:	8a 00                	mov    (%eax),%al
  80158b:	0f b6 c0             	movzbl %al,%eax
  80158e:	29 c2                	sub    %eax,%edx
  801590:	89 d0                	mov    %edx,%eax
}
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    

00801594 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801597:	eb 09                	jmp    8015a2 <strncmp+0xe>
		n--, p++, q++;
  801599:	ff 4d 10             	decl   0x10(%ebp)
  80159c:	ff 45 08             	incl   0x8(%ebp)
  80159f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a6:	74 17                	je     8015bf <strncmp+0x2b>
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	84 c0                	test   %al,%al
  8015af:	74 0e                	je     8015bf <strncmp+0x2b>
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 10                	mov    (%eax),%dl
  8015b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	38 c2                	cmp    %al,%dl
  8015bd:	74 da                	je     801599 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c3:	75 07                	jne    8015cc <strncmp+0x38>
		return 0;
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ca:	eb 14                	jmp    8015e0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	0f b6 d0             	movzbl %al,%edx
  8015d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d7:	8a 00                	mov    (%eax),%al
  8015d9:	0f b6 c0             	movzbl %al,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
}
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    

008015e2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015ee:	eb 12                	jmp    801602 <strchr+0x20>
		if (*s == c)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015f8:	75 05                	jne    8015ff <strchr+0x1d>
			return (char *) s;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	eb 11                	jmp    801610 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ff:	ff 45 08             	incl   0x8(%ebp)
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	8a 00                	mov    (%eax),%al
  801607:	84 c0                	test   %al,%al
  801609:	75 e5                	jne    8015f0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80161e:	eb 0d                	jmp    80162d <strfind+0x1b>
		if (*s == c)
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801628:	74 0e                	je     801638 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8a 00                	mov    (%eax),%al
  801632:	84 c0                	test   %al,%al
  801634:	75 ea                	jne    801620 <strfind+0xe>
  801636:	eb 01                	jmp    801639 <strfind+0x27>
		if (*s == c)
			break;
  801638:	90                   	nop
	return (char *) s;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80164a:	8b 45 10             	mov    0x10(%ebp),%eax
  80164d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801650:	eb 0e                	jmp    801660 <memset+0x22>
		*p++ = c;
  801652:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801655:	8d 50 01             	lea    0x1(%eax),%edx
  801658:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801660:	ff 4d f8             	decl   -0x8(%ebp)
  801663:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801667:	79 e9                	jns    801652 <memset+0x14>
		*p++ = c;

	return v;
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801680:	eb 16                	jmp    801698 <memcpy+0x2a>
		*d++ = *s++;
  801682:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801685:	8d 50 01             	lea    0x1(%eax),%edx
  801688:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80168b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801691:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801694:	8a 12                	mov    (%edx),%dl
  801696:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801698:	8b 45 10             	mov    0x10(%ebp),%eax
  80169b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80169e:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	75 dd                	jne    801682 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016c2:	73 50                	jae    801714 <memmove+0x6a>
  8016c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016cf:	76 43                	jbe    801714 <memmove+0x6a>
		s += n;
  8016d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016dd:	eb 10                	jmp    8016ef <memmove+0x45>
			*--d = *--s;
  8016df:	ff 4d f8             	decl   -0x8(%ebp)
  8016e2:	ff 4d fc             	decl   -0x4(%ebp)
  8016e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e8:	8a 10                	mov    (%eax),%dl
  8016ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ed:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	75 e3                	jne    8016df <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016fc:	eb 23                	jmp    801721 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801701:	8d 50 01             	lea    0x1(%eax),%edx
  801704:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801707:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80170a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80170d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801710:	8a 12                	mov    (%edx),%dl
  801712:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801714:	8b 45 10             	mov    0x10(%ebp),%eax
  801717:	8d 50 ff             	lea    -0x1(%eax),%edx
  80171a:	89 55 10             	mov    %edx,0x10(%ebp)
  80171d:	85 c0                	test   %eax,%eax
  80171f:	75 dd                	jne    8016fe <memmove+0x54>
			*d++ = *s++;

	return dst;
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801732:	8b 45 0c             	mov    0xc(%ebp),%eax
  801735:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801738:	eb 2a                	jmp    801764 <memcmp+0x3e>
		if (*s1 != *s2)
  80173a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173d:	8a 10                	mov    (%eax),%dl
  80173f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	38 c2                	cmp    %al,%dl
  801746:	74 16                	je     80175e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801748:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	0f b6 d0             	movzbl %al,%edx
  801750:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	0f b6 c0             	movzbl %al,%eax
  801758:	29 c2                	sub    %eax,%edx
  80175a:	89 d0                	mov    %edx,%eax
  80175c:	eb 18                	jmp    801776 <memcmp+0x50>
		s1++, s2++;
  80175e:	ff 45 fc             	incl   -0x4(%ebp)
  801761:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801764:	8b 45 10             	mov    0x10(%ebp),%eax
  801767:	8d 50 ff             	lea    -0x1(%eax),%edx
  80176a:	89 55 10             	mov    %edx,0x10(%ebp)
  80176d:	85 c0                	test   %eax,%eax
  80176f:	75 c9                	jne    80173a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80177e:	8b 55 08             	mov    0x8(%ebp),%edx
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	01 d0                	add    %edx,%eax
  801786:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801789:	eb 15                	jmp    8017a0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	0f b6 d0             	movzbl %al,%edx
  801793:	8b 45 0c             	mov    0xc(%ebp),%eax
  801796:	0f b6 c0             	movzbl %al,%eax
  801799:	39 c2                	cmp    %eax,%edx
  80179b:	74 0d                	je     8017aa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80179d:	ff 45 08             	incl   0x8(%ebp)
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017a6:	72 e3                	jb     80178b <memfind+0x13>
  8017a8:	eb 01                	jmp    8017ab <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017aa:	90                   	nop
	return (void *) s;
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017c4:	eb 03                	jmp    8017c9 <strtol+0x19>
		s++;
  8017c6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 20                	cmp    $0x20,%al
  8017d0:	74 f4                	je     8017c6 <strtol+0x16>
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	3c 09                	cmp    $0x9,%al
  8017d9:	74 eb                	je     8017c6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8a 00                	mov    (%eax),%al
  8017e0:	3c 2b                	cmp    $0x2b,%al
  8017e2:	75 05                	jne    8017e9 <strtol+0x39>
		s++;
  8017e4:	ff 45 08             	incl   0x8(%ebp)
  8017e7:	eb 13                	jmp    8017fc <strtol+0x4c>
	else if (*s == '-')
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	3c 2d                	cmp    $0x2d,%al
  8017f0:	75 0a                	jne    8017fc <strtol+0x4c>
		s++, neg = 1;
  8017f2:	ff 45 08             	incl   0x8(%ebp)
  8017f5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801800:	74 06                	je     801808 <strtol+0x58>
  801802:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801806:	75 20                	jne    801828 <strtol+0x78>
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	8a 00                	mov    (%eax),%al
  80180d:	3c 30                	cmp    $0x30,%al
  80180f:	75 17                	jne    801828 <strtol+0x78>
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	40                   	inc    %eax
  801815:	8a 00                	mov    (%eax),%al
  801817:	3c 78                	cmp    $0x78,%al
  801819:	75 0d                	jne    801828 <strtol+0x78>
		s += 2, base = 16;
  80181b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80181f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801826:	eb 28                	jmp    801850 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801828:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182c:	75 15                	jne    801843 <strtol+0x93>
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3c 30                	cmp    $0x30,%al
  801835:	75 0c                	jne    801843 <strtol+0x93>
		s++, base = 8;
  801837:	ff 45 08             	incl   0x8(%ebp)
  80183a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801841:	eb 0d                	jmp    801850 <strtol+0xa0>
	else if (base == 0)
  801843:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801847:	75 07                	jne    801850 <strtol+0xa0>
		base = 10;
  801849:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	3c 2f                	cmp    $0x2f,%al
  801857:	7e 19                	jle    801872 <strtol+0xc2>
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8a 00                	mov    (%eax),%al
  80185e:	3c 39                	cmp    $0x39,%al
  801860:	7f 10                	jg     801872 <strtol+0xc2>
			dig = *s - '0';
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	8a 00                	mov    (%eax),%al
  801867:	0f be c0             	movsbl %al,%eax
  80186a:	83 e8 30             	sub    $0x30,%eax
  80186d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801870:	eb 42                	jmp    8018b4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	3c 60                	cmp    $0x60,%al
  801879:	7e 19                	jle    801894 <strtol+0xe4>
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	8a 00                	mov    (%eax),%al
  801880:	3c 7a                	cmp    $0x7a,%al
  801882:	7f 10                	jg     801894 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	8a 00                	mov    (%eax),%al
  801889:	0f be c0             	movsbl %al,%eax
  80188c:	83 e8 57             	sub    $0x57,%eax
  80188f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801892:	eb 20                	jmp    8018b4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	8a 00                	mov    (%eax),%al
  801899:	3c 40                	cmp    $0x40,%al
  80189b:	7e 39                	jle    8018d6 <strtol+0x126>
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8a 00                	mov    (%eax),%al
  8018a2:	3c 5a                	cmp    $0x5a,%al
  8018a4:	7f 30                	jg     8018d6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	8a 00                	mov    (%eax),%al
  8018ab:	0f be c0             	movsbl %al,%eax
  8018ae:	83 e8 37             	sub    $0x37,%eax
  8018b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018ba:	7d 19                	jge    8018d5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018bc:	ff 45 08             	incl   0x8(%ebp)
  8018bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018c6:	89 c2                	mov    %eax,%edx
  8018c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cb:	01 d0                	add    %edx,%eax
  8018cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018d0:	e9 7b ff ff ff       	jmp    801850 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018d5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018da:	74 08                	je     8018e4 <strtol+0x134>
		*endptr = (char *) s;
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018e8:	74 07                	je     8018f1 <strtol+0x141>
  8018ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ed:	f7 d8                	neg    %eax
  8018ef:	eb 03                	jmp    8018f4 <strtol+0x144>
  8018f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <ltostr>:

void
ltostr(long value, char *str)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801903:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80190a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80190e:	79 13                	jns    801923 <ltostr+0x2d>
	{
		neg = 1;
  801910:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80191d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801920:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80192b:	99                   	cltd   
  80192c:	f7 f9                	idiv   %ecx
  80192e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801931:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801934:	8d 50 01             	lea    0x1(%eax),%edx
  801937:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80193a:	89 c2                	mov    %eax,%edx
  80193c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193f:	01 d0                	add    %edx,%eax
  801941:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801944:	83 c2 30             	add    $0x30,%edx
  801947:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801949:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801951:	f7 e9                	imul   %ecx
  801953:	c1 fa 02             	sar    $0x2,%edx
  801956:	89 c8                	mov    %ecx,%eax
  801958:	c1 f8 1f             	sar    $0x1f,%eax
  80195b:	29 c2                	sub    %eax,%edx
  80195d:	89 d0                	mov    %edx,%eax
  80195f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801962:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801965:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80196a:	f7 e9                	imul   %ecx
  80196c:	c1 fa 02             	sar    $0x2,%edx
  80196f:	89 c8                	mov    %ecx,%eax
  801971:	c1 f8 1f             	sar    $0x1f,%eax
  801974:	29 c2                	sub    %eax,%edx
  801976:	89 d0                	mov    %edx,%eax
  801978:	c1 e0 02             	shl    $0x2,%eax
  80197b:	01 d0                	add    %edx,%eax
  80197d:	01 c0                	add    %eax,%eax
  80197f:	29 c1                	sub    %eax,%ecx
  801981:	89 ca                	mov    %ecx,%edx
  801983:	85 d2                	test   %edx,%edx
  801985:	75 9c                	jne    801923 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801987:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80198e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801991:	48                   	dec    %eax
  801992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801995:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801999:	74 3d                	je     8019d8 <ltostr+0xe2>
		start = 1 ;
  80199b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019a2:	eb 34                	jmp    8019d8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8019a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019aa:	01 d0                	add    %edx,%eax
  8019ac:	8a 00                	mov    (%eax),%al
  8019ae:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b7:	01 c2                	add    %eax,%edx
  8019b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bf:	01 c8                	add    %ecx,%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cb:	01 c2                	add    %eax,%edx
  8019cd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019d0:	88 02                	mov    %al,(%edx)
		start++ ;
  8019d2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019d5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019de:	7c c4                	jl     8019a4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e6:	01 d0                	add    %edx,%eax
  8019e8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019eb:	90                   	nop
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019f4:	ff 75 08             	pushl  0x8(%ebp)
  8019f7:	e8 54 fa ff ff       	call   801450 <strlen>
  8019fc:	83 c4 04             	add    $0x4,%esp
  8019ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	e8 46 fa ff ff       	call   801450 <strlen>
  801a0a:	83 c4 04             	add    $0x4,%esp
  801a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a1e:	eb 17                	jmp    801a37 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a23:	8b 45 10             	mov    0x10(%ebp),%eax
  801a26:	01 c2                	add    %eax,%edx
  801a28:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	01 c8                	add    %ecx,%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a34:	ff 45 fc             	incl   -0x4(%ebp)
  801a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a3d:	7c e1                	jl     801a20 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a3f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a46:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a4d:	eb 1f                	jmp    801a6e <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a52:	8d 50 01             	lea    0x1(%eax),%edx
  801a55:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a58:	89 c2                	mov    %eax,%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 c2                	add    %eax,%edx
  801a5f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a65:	01 c8                	add    %ecx,%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a6b:	ff 45 f8             	incl   -0x8(%ebp)
  801a6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a71:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a74:	7c d9                	jl     801a4f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	01 d0                	add    %edx,%eax
  801a7e:	c6 00 00             	movb   $0x0,(%eax)
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a87:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a90:	8b 45 14             	mov    0x14(%ebp),%eax
  801a93:	8b 00                	mov    (%eax),%eax
  801a95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9f:	01 d0                	add    %edx,%eax
  801aa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa7:	eb 0c                	jmp    801ab5 <strsplit+0x31>
			*string++ = 0;
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	8d 50 01             	lea    0x1(%eax),%edx
  801aaf:	89 55 08             	mov    %edx,0x8(%ebp)
  801ab2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	8a 00                	mov    (%eax),%al
  801aba:	84 c0                	test   %al,%al
  801abc:	74 18                	je     801ad6 <strsplit+0x52>
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8a 00                	mov    (%eax),%al
  801ac3:	0f be c0             	movsbl %al,%eax
  801ac6:	50                   	push   %eax
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	e8 13 fb ff ff       	call   8015e2 <strchr>
  801acf:	83 c4 08             	add    $0x8,%esp
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	75 d3                	jne    801aa9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	84 c0                	test   %al,%al
  801add:	74 5a                	je     801b39 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801adf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae2:	8b 00                	mov    (%eax),%eax
  801ae4:	83 f8 0f             	cmp    $0xf,%eax
  801ae7:	75 07                	jne    801af0 <strsplit+0x6c>
		{
			return 0;
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aee:	eb 66                	jmp    801b56 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801af0:	8b 45 14             	mov    0x14(%ebp),%eax
  801af3:	8b 00                	mov    (%eax),%eax
  801af5:	8d 48 01             	lea    0x1(%eax),%ecx
  801af8:	8b 55 14             	mov    0x14(%ebp),%edx
  801afb:	89 0a                	mov    %ecx,(%edx)
  801afd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b04:	8b 45 10             	mov    0x10(%ebp),%eax
  801b07:	01 c2                	add    %eax,%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b0e:	eb 03                	jmp    801b13 <strsplit+0x8f>
			string++;
  801b10:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	8a 00                	mov    (%eax),%al
  801b18:	84 c0                	test   %al,%al
  801b1a:	74 8b                	je     801aa7 <strsplit+0x23>
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	8a 00                	mov    (%eax),%al
  801b21:	0f be c0             	movsbl %al,%eax
  801b24:	50                   	push   %eax
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	e8 b5 fa ff ff       	call   8015e2 <strchr>
  801b2d:	83 c4 08             	add    $0x8,%esp
  801b30:	85 c0                	test   %eax,%eax
  801b32:	74 dc                	je     801b10 <strsplit+0x8c>
			string++;
	}
  801b34:	e9 6e ff ff ff       	jmp    801aa7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b39:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3d:	8b 00                	mov    (%eax),%eax
  801b3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b46:	8b 45 10             	mov    0x10(%ebp),%eax
  801b49:	01 d0                	add    %edx,%eax
  801b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b51:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801b5e:	83 ec 04             	sub    $0x4,%esp
  801b61:	68 e4 2c 80 00       	push   $0x802ce4
  801b66:	6a 0e                	push   $0xe
  801b68:	68 1e 2d 80 00       	push   $0x802d1e
  801b6d:	e8 a2 ed ff ff       	call   800914 <_panic>

00801b72 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801b78:	a1 04 30 80 00       	mov    0x803004,%eax
  801b7d:	85 c0                	test   %eax,%eax
  801b7f:	74 0f                	je     801b90 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801b81:	e8 d2 ff ff ff       	call   801b58 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b86:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801b8d:	00 00 00 
	}
	if (size == 0) return NULL ;
  801b90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b94:	75 07                	jne    801b9d <malloc+0x2b>
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9b:	eb 14                	jmp    801bb1 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	68 2c 2d 80 00       	push   $0x802d2c
  801ba5:	6a 2e                	push   $0x2e
  801ba7:	68 1e 2d 80 00       	push   $0x802d1e
  801bac:	e8 63 ed ff ff       	call   800914 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801bb9:	83 ec 04             	sub    $0x4,%esp
  801bbc:	68 54 2d 80 00       	push   $0x802d54
  801bc1:	6a 49                	push   $0x49
  801bc3:	68 1e 2d 80 00       	push   $0x802d1e
  801bc8:	e8 47 ed ff ff       	call   800914 <_panic>

00801bcd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 18             	sub    $0x18,%esp
  801bd3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd6:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 78 2d 80 00       	push   $0x802d78
  801be1:	6a 57                	push   $0x57
  801be3:	68 1e 2d 80 00       	push   $0x802d1e
  801be8:	e8 27 ed ff ff       	call   800914 <_panic>

00801bed <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801bf3:	83 ec 04             	sub    $0x4,%esp
  801bf6:	68 a0 2d 80 00       	push   $0x802da0
  801bfb:	6a 60                	push   $0x60
  801bfd:	68 1e 2d 80 00       	push   $0x802d1e
  801c02:	e8 0d ed ff ff       	call   800914 <_panic>

00801c07 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	68 c4 2d 80 00       	push   $0x802dc4
  801c15:	6a 7c                	push   $0x7c
  801c17:	68 1e 2d 80 00       	push   $0x802d1e
  801c1c:	e8 f3 ec ff ff       	call   800914 <_panic>

00801c21 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	68 ec 2d 80 00       	push   $0x802dec
  801c2f:	68 86 00 00 00       	push   $0x86
  801c34:	68 1e 2d 80 00       	push   $0x802d1e
  801c39:	e8 d6 ec ff ff       	call   800914 <_panic>

00801c3e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	68 10 2e 80 00       	push   $0x802e10
  801c4c:	68 91 00 00 00       	push   $0x91
  801c51:	68 1e 2d 80 00       	push   $0x802d1e
  801c56:	e8 b9 ec ff ff       	call   800914 <_panic>

00801c5b <shrink>:

}
void shrink(uint32 newSize)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	68 10 2e 80 00       	push   $0x802e10
  801c69:	68 96 00 00 00       	push   $0x96
  801c6e:	68 1e 2d 80 00       	push   $0x802d1e
  801c73:	e8 9c ec ff ff       	call   800914 <_panic>

00801c78 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	68 10 2e 80 00       	push   $0x802e10
  801c86:	68 9b 00 00 00       	push   $0x9b
  801c8b:	68 1e 2d 80 00       	push   $0x802d1e
  801c90:	e8 7f ec ff ff       	call   800914 <_panic>

00801c95 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	57                   	push   %edi
  801c99:	56                   	push   %esi
  801c9a:	53                   	push   %ebx
  801c9b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801caa:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cad:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cb0:	cd 30                	int    $0x30
  801cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cb8:	83 c4 10             	add    $0x10,%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5e                   	pop    %esi
  801cbd:	5f                   	pop    %edi
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    

00801cc0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ccc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	52                   	push   %edx
  801cd8:	ff 75 0c             	pushl  0xc(%ebp)
  801cdb:	50                   	push   %eax
  801cdc:	6a 00                	push   $0x0
  801cde:	e8 b2 ff ff ff       	call   801c95 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 01                	push   $0x1
  801cf8:	e8 98 ff ff ff       	call   801c95 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	52                   	push   %edx
  801d12:	50                   	push   %eax
  801d13:	6a 05                	push   $0x5
  801d15:	e8 7b ff ff ff       	call   801c95 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d24:	8b 75 18             	mov    0x18(%ebp),%esi
  801d27:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	51                   	push   %ecx
  801d36:	52                   	push   %edx
  801d37:	50                   	push   %eax
  801d38:	6a 06                	push   $0x6
  801d3a:	e8 56 ff ff ff       	call   801c95 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5e                   	pop    %esi
  801d47:	5d                   	pop    %ebp
  801d48:	c3                   	ret    

00801d49 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	52                   	push   %edx
  801d59:	50                   	push   %eax
  801d5a:	6a 07                	push   $0x7
  801d5c:	e8 34 ff ff ff       	call   801c95 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	6a 08                	push   $0x8
  801d77:	e8 19 ff ff ff       	call   801c95 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 09                	push   $0x9
  801d90:	e8 00 ff ff ff       	call   801c95 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 0a                	push   $0xa
  801da9:	e8 e7 fe ff ff       	call   801c95 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 0b                	push   $0xb
  801dc2:	e8 ce fe ff ff       	call   801c95 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	ff 75 0c             	pushl  0xc(%ebp)
  801dd8:	ff 75 08             	pushl  0x8(%ebp)
  801ddb:	6a 0f                	push   $0xf
  801ddd:	e8 b3 fe ff ff       	call   801c95 <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
	return;
  801de5:	90                   	nop
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	ff 75 0c             	pushl  0xc(%ebp)
  801df4:	ff 75 08             	pushl  0x8(%ebp)
  801df7:	6a 10                	push   $0x10
  801df9:	e8 97 fe ff ff       	call   801c95 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801e01:	90                   	nop
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	ff 75 10             	pushl  0x10(%ebp)
  801e0e:	ff 75 0c             	pushl  0xc(%ebp)
  801e11:	ff 75 08             	pushl  0x8(%ebp)
  801e14:	6a 11                	push   $0x11
  801e16:	e8 7a fe ff ff       	call   801c95 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1e:	90                   	nop
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 0c                	push   $0xc
  801e30:	e8 60 fe ff ff       	call   801c95 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	6a 0d                	push   $0xd
  801e4a:	e8 46 fe ff ff       	call   801c95 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 0e                	push   $0xe
  801e63:	e8 2d fe ff ff       	call   801c95 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 13                	push   $0x13
  801e7d:	e8 13 fe ff ff       	call   801c95 <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
}
  801e85:	90                   	nop
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 14                	push   $0x14
  801e97:	e8 f9 fd ff ff       	call   801c95 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	90                   	nop
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	50                   	push   %eax
  801ebb:	6a 15                	push   $0x15
  801ebd:	e8 d3 fd ff ff       	call   801c95 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	90                   	nop
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 16                	push   $0x16
  801ed7:	e8 b9 fd ff ff       	call   801c95 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	90                   	nop
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	ff 75 0c             	pushl  0xc(%ebp)
  801ef1:	50                   	push   %eax
  801ef2:	6a 17                	push   $0x17
  801ef4:	e8 9c fd ff ff       	call   801c95 <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	52                   	push   %edx
  801f0e:	50                   	push   %eax
  801f0f:	6a 1a                	push   $0x1a
  801f11:	e8 7f fd ff ff       	call   801c95 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	52                   	push   %edx
  801f2b:	50                   	push   %eax
  801f2c:	6a 18                	push   $0x18
  801f2e:	e8 62 fd ff ff       	call   801c95 <syscall>
  801f33:	83 c4 18             	add    $0x18,%esp
}
  801f36:	90                   	nop
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	52                   	push   %edx
  801f49:	50                   	push   %eax
  801f4a:	6a 19                	push   $0x19
  801f4c:	e8 44 fd ff ff       	call   801c95 <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
}
  801f54:	90                   	nop
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f60:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f63:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	6a 00                	push   $0x0
  801f6f:	51                   	push   %ecx
  801f70:	52                   	push   %edx
  801f71:	ff 75 0c             	pushl  0xc(%ebp)
  801f74:	50                   	push   %eax
  801f75:	6a 1b                	push   $0x1b
  801f77:	e8 19 fd ff ff       	call   801c95 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	52                   	push   %edx
  801f91:	50                   	push   %eax
  801f92:	6a 1c                	push   $0x1c
  801f94:	e8 fc fc ff ff       	call   801c95 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fa1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	51                   	push   %ecx
  801faf:	52                   	push   %edx
  801fb0:	50                   	push   %eax
  801fb1:	6a 1d                	push   $0x1d
  801fb3:	e8 dd fc ff ff       	call   801c95 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	52                   	push   %edx
  801fcd:	50                   	push   %eax
  801fce:	6a 1e                	push   $0x1e
  801fd0:	e8 c0 fc ff ff       	call   801c95 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 1f                	push   $0x1f
  801fe9:	e8 a7 fc ff ff       	call   801c95 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	6a 00                	push   $0x0
  801ffb:	ff 75 14             	pushl  0x14(%ebp)
  801ffe:	ff 75 10             	pushl  0x10(%ebp)
  802001:	ff 75 0c             	pushl  0xc(%ebp)
  802004:	50                   	push   %eax
  802005:	6a 20                	push   $0x20
  802007:	e8 89 fc ff ff       	call   801c95 <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	50                   	push   %eax
  802020:	6a 21                	push   $0x21
  802022:	e8 6e fc ff ff       	call   801c95 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	90                   	nop
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	50                   	push   %eax
  80203c:	6a 22                	push   $0x22
  80203e:	e8 52 fc ff ff       	call   801c95 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 02                	push   $0x2
  802057:	e8 39 fc ff ff       	call   801c95 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 03                	push   $0x3
  802070:	e8 20 fc ff ff       	call   801c95 <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 04                	push   $0x4
  802089:	e8 07 fc ff ff       	call   801c95 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_exit_env>:


void sys_exit_env(void)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 23                	push   $0x23
  8020a2:	e8 ee fb ff ff       	call   801c95 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020b3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020b6:	8d 50 04             	lea    0x4(%eax),%edx
  8020b9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	52                   	push   %edx
  8020c3:	50                   	push   %eax
  8020c4:	6a 24                	push   $0x24
  8020c6:	e8 ca fb ff ff       	call   801c95 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
	return result;
  8020ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020d7:	89 01                	mov    %eax,(%ecx)
  8020d9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	c9                   	leave  
  8020e0:	c2 04 00             	ret    $0x4

008020e3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	ff 75 10             	pushl  0x10(%ebp)
  8020ed:	ff 75 0c             	pushl  0xc(%ebp)
  8020f0:	ff 75 08             	pushl  0x8(%ebp)
  8020f3:	6a 12                	push   $0x12
  8020f5:	e8 9b fb ff ff       	call   801c95 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fd:	90                   	nop
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_rcr2>:
uint32 sys_rcr2()
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 25                	push   $0x25
  80210f:	e8 81 fb ff ff       	call   801c95 <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802125:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	50                   	push   %eax
  802132:	6a 26                	push   $0x26
  802134:	e8 5c fb ff ff       	call   801c95 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
	return ;
  80213c:	90                   	nop
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <rsttst>:
void rsttst()
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 28                	push   $0x28
  80214e:	e8 42 fb ff ff       	call   801c95 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
	return ;
  802156:	90                   	nop
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	8b 45 14             	mov    0x14(%ebp),%eax
  802162:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802165:	8b 55 18             	mov    0x18(%ebp),%edx
  802168:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80216c:	52                   	push   %edx
  80216d:	50                   	push   %eax
  80216e:	ff 75 10             	pushl  0x10(%ebp)
  802171:	ff 75 0c             	pushl  0xc(%ebp)
  802174:	ff 75 08             	pushl  0x8(%ebp)
  802177:	6a 27                	push   $0x27
  802179:	e8 17 fb ff ff       	call   801c95 <syscall>
  80217e:	83 c4 18             	add    $0x18,%esp
	return ;
  802181:	90                   	nop
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <chktst>:
void chktst(uint32 n)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	ff 75 08             	pushl  0x8(%ebp)
  802192:	6a 29                	push   $0x29
  802194:	e8 fc fa ff ff       	call   801c95 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
	return ;
  80219c:	90                   	nop
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <inctst>:

void inctst()
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 2a                	push   $0x2a
  8021ae:	e8 e2 fa ff ff       	call   801c95 <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b6:	90                   	nop
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <gettst>:
uint32 gettst()
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 2b                	push   $0x2b
  8021c8:	e8 c8 fa ff ff       	call   801c95 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 2c                	push   $0x2c
  8021e4:	e8 ac fa ff ff       	call   801c95 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
  8021ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021ef:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021f3:	75 07                	jne    8021fc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fa:	eb 05                	jmp    802201 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 2c                	push   $0x2c
  802215:	e8 7b fa ff ff       	call   801c95 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
  80221d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802220:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802224:	75 07                	jne    80222d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802226:	b8 01 00 00 00       	mov    $0x1,%eax
  80222b:	eb 05                	jmp    802232 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 2c                	push   $0x2c
  802246:	e8 4a fa ff ff       	call   801c95 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
  80224e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802251:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802255:	75 07                	jne    80225e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802257:	b8 01 00 00 00       	mov    $0x1,%eax
  80225c:	eb 05                	jmp    802263 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80225e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 2c                	push   $0x2c
  802277:	e8 19 fa ff ff       	call   801c95 <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
  80227f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802282:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802286:	75 07                	jne    80228f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802288:	b8 01 00 00 00       	mov    $0x1,%eax
  80228d:	eb 05                	jmp    802294 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	ff 75 08             	pushl  0x8(%ebp)
  8022a4:	6a 2d                	push   $0x2d
  8022a6:	e8 ea f9 ff ff       	call   801c95 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ae:	90                   	nop
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	6a 00                	push   $0x0
  8022c3:	53                   	push   %ebx
  8022c4:	51                   	push   %ecx
  8022c5:	52                   	push   %edx
  8022c6:	50                   	push   %eax
  8022c7:	6a 2e                	push   $0x2e
  8022c9:	e8 c7 f9 ff ff       	call   801c95 <syscall>
  8022ce:	83 c4 18             	add    $0x18,%esp
}
  8022d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	52                   	push   %edx
  8022e6:	50                   	push   %eax
  8022e7:	6a 2f                	push   $0x2f
  8022e9:	e8 a7 f9 ff ff       	call   801c95 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    
  8022f3:	90                   	nop

008022f4 <__udivdi3>:
  8022f4:	55                   	push   %ebp
  8022f5:	57                   	push   %edi
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 1c             	sub    $0x1c,%esp
  8022fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802303:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802307:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80230b:	89 ca                	mov    %ecx,%edx
  80230d:	89 f8                	mov    %edi,%eax
  80230f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802313:	85 f6                	test   %esi,%esi
  802315:	75 2d                	jne    802344 <__udivdi3+0x50>
  802317:	39 cf                	cmp    %ecx,%edi
  802319:	77 65                	ja     802380 <__udivdi3+0x8c>
  80231b:	89 fd                	mov    %edi,%ebp
  80231d:	85 ff                	test   %edi,%edi
  80231f:	75 0b                	jne    80232c <__udivdi3+0x38>
  802321:	b8 01 00 00 00       	mov    $0x1,%eax
  802326:	31 d2                	xor    %edx,%edx
  802328:	f7 f7                	div    %edi
  80232a:	89 c5                	mov    %eax,%ebp
  80232c:	31 d2                	xor    %edx,%edx
  80232e:	89 c8                	mov    %ecx,%eax
  802330:	f7 f5                	div    %ebp
  802332:	89 c1                	mov    %eax,%ecx
  802334:	89 d8                	mov    %ebx,%eax
  802336:	f7 f5                	div    %ebp
  802338:	89 cf                	mov    %ecx,%edi
  80233a:	89 fa                	mov    %edi,%edx
  80233c:	83 c4 1c             	add    $0x1c,%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    
  802344:	39 ce                	cmp    %ecx,%esi
  802346:	77 28                	ja     802370 <__udivdi3+0x7c>
  802348:	0f bd fe             	bsr    %esi,%edi
  80234b:	83 f7 1f             	xor    $0x1f,%edi
  80234e:	75 40                	jne    802390 <__udivdi3+0x9c>
  802350:	39 ce                	cmp    %ecx,%esi
  802352:	72 0a                	jb     80235e <__udivdi3+0x6a>
  802354:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802358:	0f 87 9e 00 00 00    	ja     8023fc <__udivdi3+0x108>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	89 fa                	mov    %edi,%edx
  802365:	83 c4 1c             	add    $0x1c,%esp
  802368:	5b                   	pop    %ebx
  802369:	5e                   	pop    %esi
  80236a:	5f                   	pop    %edi
  80236b:	5d                   	pop    %ebp
  80236c:	c3                   	ret    
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	31 ff                	xor    %edi,%edi
  802372:	31 c0                	xor    %eax,%eax
  802374:	89 fa                	mov    %edi,%edx
  802376:	83 c4 1c             	add    $0x1c,%esp
  802379:	5b                   	pop    %ebx
  80237a:	5e                   	pop    %esi
  80237b:	5f                   	pop    %edi
  80237c:	5d                   	pop    %ebp
  80237d:	c3                   	ret    
  80237e:	66 90                	xchg   %ax,%ax
  802380:	89 d8                	mov    %ebx,%eax
  802382:	f7 f7                	div    %edi
  802384:	31 ff                	xor    %edi,%edi
  802386:	89 fa                	mov    %edi,%edx
  802388:	83 c4 1c             	add    $0x1c,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5f                   	pop    %edi
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    
  802390:	bd 20 00 00 00       	mov    $0x20,%ebp
  802395:	89 eb                	mov    %ebp,%ebx
  802397:	29 fb                	sub    %edi,%ebx
  802399:	89 f9                	mov    %edi,%ecx
  80239b:	d3 e6                	shl    %cl,%esi
  80239d:	89 c5                	mov    %eax,%ebp
  80239f:	88 d9                	mov    %bl,%cl
  8023a1:	d3 ed                	shr    %cl,%ebp
  8023a3:	89 e9                	mov    %ebp,%ecx
  8023a5:	09 f1                	or     %esi,%ecx
  8023a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e0                	shl    %cl,%eax
  8023af:	89 c5                	mov    %eax,%ebp
  8023b1:	89 d6                	mov    %edx,%esi
  8023b3:	88 d9                	mov    %bl,%cl
  8023b5:	d3 ee                	shr    %cl,%esi
  8023b7:	89 f9                	mov    %edi,%ecx
  8023b9:	d3 e2                	shl    %cl,%edx
  8023bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023bf:	88 d9                	mov    %bl,%cl
  8023c1:	d3 e8                	shr    %cl,%eax
  8023c3:	09 c2                	or     %eax,%edx
  8023c5:	89 d0                	mov    %edx,%eax
  8023c7:	89 f2                	mov    %esi,%edx
  8023c9:	f7 74 24 0c          	divl   0xc(%esp)
  8023cd:	89 d6                	mov    %edx,%esi
  8023cf:	89 c3                	mov    %eax,%ebx
  8023d1:	f7 e5                	mul    %ebp
  8023d3:	39 d6                	cmp    %edx,%esi
  8023d5:	72 19                	jb     8023f0 <__udivdi3+0xfc>
  8023d7:	74 0b                	je     8023e4 <__udivdi3+0xf0>
  8023d9:	89 d8                	mov    %ebx,%eax
  8023db:	31 ff                	xor    %edi,%edi
  8023dd:	e9 58 ff ff ff       	jmp    80233a <__udivdi3+0x46>
  8023e2:	66 90                	xchg   %ax,%ax
  8023e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023e8:	89 f9                	mov    %edi,%ecx
  8023ea:	d3 e2                	shl    %cl,%edx
  8023ec:	39 c2                	cmp    %eax,%edx
  8023ee:	73 e9                	jae    8023d9 <__udivdi3+0xe5>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 40 ff ff ff       	jmp    80233a <__udivdi3+0x46>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	31 c0                	xor    %eax,%eax
  8023fe:	e9 37 ff ff ff       	jmp    80233a <__udivdi3+0x46>
  802403:	90                   	nop

00802404 <__umoddi3>:
  802404:	55                   	push   %ebp
  802405:	57                   	push   %edi
  802406:	56                   	push   %esi
  802407:	53                   	push   %ebx
  802408:	83 ec 1c             	sub    $0x1c,%esp
  80240b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80240f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802417:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80241b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80241f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802423:	89 f3                	mov    %esi,%ebx
  802425:	89 fa                	mov    %edi,%edx
  802427:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80242b:	89 34 24             	mov    %esi,(%esp)
  80242e:	85 c0                	test   %eax,%eax
  802430:	75 1a                	jne    80244c <__umoddi3+0x48>
  802432:	39 f7                	cmp    %esi,%edi
  802434:	0f 86 a2 00 00 00    	jbe    8024dc <__umoddi3+0xd8>
  80243a:	89 c8                	mov    %ecx,%eax
  80243c:	89 f2                	mov    %esi,%edx
  80243e:	f7 f7                	div    %edi
  802440:	89 d0                	mov    %edx,%eax
  802442:	31 d2                	xor    %edx,%edx
  802444:	83 c4 1c             	add    $0x1c,%esp
  802447:	5b                   	pop    %ebx
  802448:	5e                   	pop    %esi
  802449:	5f                   	pop    %edi
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    
  80244c:	39 f0                	cmp    %esi,%eax
  80244e:	0f 87 ac 00 00 00    	ja     802500 <__umoddi3+0xfc>
  802454:	0f bd e8             	bsr    %eax,%ebp
  802457:	83 f5 1f             	xor    $0x1f,%ebp
  80245a:	0f 84 ac 00 00 00    	je     80250c <__umoddi3+0x108>
  802460:	bf 20 00 00 00       	mov    $0x20,%edi
  802465:	29 ef                	sub    %ebp,%edi
  802467:	89 fe                	mov    %edi,%esi
  802469:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80246d:	89 e9                	mov    %ebp,%ecx
  80246f:	d3 e0                	shl    %cl,%eax
  802471:	89 d7                	mov    %edx,%edi
  802473:	89 f1                	mov    %esi,%ecx
  802475:	d3 ef                	shr    %cl,%edi
  802477:	09 c7                	or     %eax,%edi
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	d3 e2                	shl    %cl,%edx
  80247d:	89 14 24             	mov    %edx,(%esp)
  802480:	89 d8                	mov    %ebx,%eax
  802482:	d3 e0                	shl    %cl,%eax
  802484:	89 c2                	mov    %eax,%edx
  802486:	8b 44 24 08          	mov    0x8(%esp),%eax
  80248a:	d3 e0                	shl    %cl,%eax
  80248c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802490:	8b 44 24 08          	mov    0x8(%esp),%eax
  802494:	89 f1                	mov    %esi,%ecx
  802496:	d3 e8                	shr    %cl,%eax
  802498:	09 d0                	or     %edx,%eax
  80249a:	d3 eb                	shr    %cl,%ebx
  80249c:	89 da                	mov    %ebx,%edx
  80249e:	f7 f7                	div    %edi
  8024a0:	89 d3                	mov    %edx,%ebx
  8024a2:	f7 24 24             	mull   (%esp)
  8024a5:	89 c6                	mov    %eax,%esi
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	39 d3                	cmp    %edx,%ebx
  8024ab:	0f 82 87 00 00 00    	jb     802538 <__umoddi3+0x134>
  8024b1:	0f 84 91 00 00 00    	je     802548 <__umoddi3+0x144>
  8024b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024bb:	29 f2                	sub    %esi,%edx
  8024bd:	19 cb                	sbb    %ecx,%ebx
  8024bf:	89 d8                	mov    %ebx,%eax
  8024c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024c5:	d3 e0                	shl    %cl,%eax
  8024c7:	89 e9                	mov    %ebp,%ecx
  8024c9:	d3 ea                	shr    %cl,%edx
  8024cb:	09 d0                	or     %edx,%eax
  8024cd:	89 e9                	mov    %ebp,%ecx
  8024cf:	d3 eb                	shr    %cl,%ebx
  8024d1:	89 da                	mov    %ebx,%edx
  8024d3:	83 c4 1c             	add    $0x1c,%esp
  8024d6:	5b                   	pop    %ebx
  8024d7:	5e                   	pop    %esi
  8024d8:	5f                   	pop    %edi
  8024d9:	5d                   	pop    %ebp
  8024da:	c3                   	ret    
  8024db:	90                   	nop
  8024dc:	89 fd                	mov    %edi,%ebp
  8024de:	85 ff                	test   %edi,%edi
  8024e0:	75 0b                	jne    8024ed <__umoddi3+0xe9>
  8024e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e7:	31 d2                	xor    %edx,%edx
  8024e9:	f7 f7                	div    %edi
  8024eb:	89 c5                	mov    %eax,%ebp
  8024ed:	89 f0                	mov    %esi,%eax
  8024ef:	31 d2                	xor    %edx,%edx
  8024f1:	f7 f5                	div    %ebp
  8024f3:	89 c8                	mov    %ecx,%eax
  8024f5:	f7 f5                	div    %ebp
  8024f7:	89 d0                	mov    %edx,%eax
  8024f9:	e9 44 ff ff ff       	jmp    802442 <__umoddi3+0x3e>
  8024fe:	66 90                	xchg   %ax,%ax
  802500:	89 c8                	mov    %ecx,%eax
  802502:	89 f2                	mov    %esi,%edx
  802504:	83 c4 1c             	add    $0x1c,%esp
  802507:	5b                   	pop    %ebx
  802508:	5e                   	pop    %esi
  802509:	5f                   	pop    %edi
  80250a:	5d                   	pop    %ebp
  80250b:	c3                   	ret    
  80250c:	3b 04 24             	cmp    (%esp),%eax
  80250f:	72 06                	jb     802517 <__umoddi3+0x113>
  802511:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802515:	77 0f                	ja     802526 <__umoddi3+0x122>
  802517:	89 f2                	mov    %esi,%edx
  802519:	29 f9                	sub    %edi,%ecx
  80251b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80251f:	89 14 24             	mov    %edx,(%esp)
  802522:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802526:	8b 44 24 04          	mov    0x4(%esp),%eax
  80252a:	8b 14 24             	mov    (%esp),%edx
  80252d:	83 c4 1c             	add    $0x1c,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	2b 04 24             	sub    (%esp),%eax
  80253b:	19 fa                	sbb    %edi,%edx
  80253d:	89 d1                	mov    %edx,%ecx
  80253f:	89 c6                	mov    %eax,%esi
  802541:	e9 71 ff ff ff       	jmp    8024b7 <__umoddi3+0xb3>
  802546:	66 90                	xchg   %ax,%ax
  802548:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80254c:	72 ea                	jb     802538 <__umoddi3+0x134>
  80254e:	89 d9                	mov    %ebx,%ecx
  802550:	e9 62 ff ff ff       	jmp    8024b7 <__umoddi3+0xb3>
