
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 9a 07 00 00       	call   8007d0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_disable_interrupt();
  80004b:	e8 23 1c 00 00       	call   801c73 <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 60 23 80 00       	push   $0x802360
  800058:	e8 76 0b 00 00       	call   800bd3 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 62 23 80 00       	push   $0x802362
  800068:	e8 66 0b 00 00       	call   800bd3 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 78 23 80 00       	push   $0x802378
  800078:	e8 56 0b 00 00       	call   800bd3 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 62 23 80 00       	push   $0x802362
  800088:	e8 46 0b 00 00       	call   800bd3 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 60 23 80 00       	push   $0x802360
  800098:	e8 36 0b 00 00       	call   800bd3 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 90 23 80 00       	push   $0x802390
  8000a8:	e8 26 0b 00 00       	call   800bd3 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 af 23 80 00       	push   $0x8023af
  8000d7:	e8 f7 0a 00 00       	call   800bd3 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 89 18 00 00       	call   801977 <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 b4 23 80 00       	push   $0x8023b4
  8000fc:	e8 d2 0a 00 00       	call   800bd3 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 d6 23 80 00       	push   $0x8023d6
  80010c:	e8 c2 0a 00 00       	call   800bd3 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 e4 23 80 00       	push   $0x8023e4
  80011c:	e8 b2 0a 00 00       	call   800bd3 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 f3 23 80 00       	push   $0x8023f3
  80012c:	e8 a2 0a 00 00       	call   800bd3 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 03 24 80 00       	push   $0x802403
  80013c:	e8 92 0a 00 00       	call   800bd3 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 c9 05 00 00       	call   800730 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 bc 05 00 00       	call   800730 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800189:	e8 ff 1a 00 00       	call   801c8d <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f4 01 00 00       	call   8003a3 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 12 02 00 00       	call   8003d4 <InitializeDescending>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 34 02 00 00       	call   800409 <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 21 02 00 00       	call   800409 <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 e0 02 00 00       	call   8004db <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001fe:	e8 70 1a 00 00       	call   801c73 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 0c 24 80 00       	push   $0x80240c
  80020b:	e8 c3 09 00 00       	call   800bd3 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 75 1a 00 00       	call   801c8d <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d3 00 00 00       	call   8002f9 <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 40 24 80 00       	push   $0x802440
  80023a:	6a 58                	push   $0x58
  80023c:	68 62 24 80 00       	push   $0x802462
  800241:	e8 d9 06 00 00       	call   80091f <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 28 1a 00 00       	call   801c73 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 80 24 80 00       	push   $0x802480
  800253:	e8 7b 09 00 00       	call   800bd3 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 b4 24 80 00       	push   $0x8024b4
  800263:	e8 6b 09 00 00       	call   800bd3 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 e8 24 80 00       	push   $0x8024e8
  800273:	e8 5b 09 00 00       	call   800bd3 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 0d 1a 00 00       	call   801c8d <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 ee 19 00 00       	call   801c73 <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 1a 25 80 00       	push   $0x80251a
  800293:	e8 3b 09 00 00       	call   800bd3 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 72 04 00 00       	call   800730 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 65 04 00 00       	call   800730 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 58 04 00 00       	call   800730 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_enable_interrupt();
  8002e7:	e8 a1 19 00 00       	call   801c8d <sys_enable_interrupt>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80030d:	eb 33                	jmp    800342 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80030f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800323:	40                   	inc    %eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	7e 09                	jle    80033f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80033d:	eb 0c                	jmp    80034b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80033f:	ff 45 f8             	incl   -0x8(%ebp)
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	48                   	dec    %eax
  800346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800349:	7f c4                	jg     80030f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80034b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 c2                	add    %eax,%edx
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c2                	add    %eax,%edx
  80039b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039e:	89 02                	mov    %eax,(%edx)
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 17                	jmp    8003c9 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c e1                	jl     8003b2 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e1:	eb 1b                	jmp    8003fe <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c2                	add    %eax,%edx
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003f8:	48                   	dec    %eax
  8003f9:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003fb:	ff 45 fc             	incl   -0x4(%ebp)
  8003fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	7c dd                	jl     8003e3 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80040f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800412:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800417:	f7 e9                	imul   %ecx
  800419:	c1 f9 1f             	sar    $0x1f,%ecx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	29 c8                	sub    %ecx,%eax
  800420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042a:	eb 1e                	jmp    80044a <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80042c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80043c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043f:	99                   	cltd   
  800440:	f7 7d f8             	idivl  -0x8(%ebp)
  800443:	89 d0                	mov    %edx,%eax
  800445:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800447:	ff 45 fc             	incl   -0x4(%ebp)
  80044a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800450:	7c da                	jl     80042c <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800452:	90                   	nop
  800453:	c9                   	leave  
  800454:	c3                   	ret    

00800455 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80045b:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800469:	eb 42                	jmp    8004ad <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	99                   	cltd   
  80046f:	f7 7d f0             	idivl  -0x10(%ebp)
  800472:	89 d0                	mov    %edx,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 10                	jne    800488 <PrintElements+0x33>
			cprintf("\n");
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 60 23 80 00       	push   $0x802360
  800480:	e8 4e 07 00 00       	call   800bd3 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	50                   	push   %eax
  80049d:	68 38 25 80 00       	push   $0x802538
  8004a2:	e8 2c 07 00 00       	call   800bd3 <cprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004aa:	ff 45 f4             	incl   -0xc(%ebp)
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	48                   	dec    %eax
  8004b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004b4:	7f b5                	jg     80046b <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	50                   	push   %eax
  8004cb:	68 af 23 80 00       	push   $0x8023af
  8004d0:	e8 fe 06 00 00       	call   800bd3 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <MSort>:


void MSort(int* A, int p, int r)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004e7:	7d 54                	jge    80053d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 1f             	shr    $0x1f,%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	d1 f8                	sar    %eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 cd ff ff ff       	call   8004db <MSort>
  80050e:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	40                   	inc    %eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	50                   	push   %eax
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 b7 ff ff ff       	call   8004db <MSort>
  800524:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800527:	ff 75 10             	pushl  0x10(%ebp)
  80052a:	ff 75 f4             	pushl  -0xc(%ebp)
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 08             	pushl  0x8(%ebp)
  800533:	e8 08 00 00 00       	call   800540 <Merge>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb 01                	jmp    80053e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80053d:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	2b 45 0c             	sub    0xc(%ebp),%eax
  80054c:	40                   	inc    %eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	2b 45 10             	sub    0x10(%ebp),%eax
  800556:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	50                   	push   %eax
  800571:	e8 01 14 00 00       	call   801977 <malloc>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	c1 e0 02             	shl    $0x2,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 ec 13 00 00       	call   801977 <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800598:	eb 2f                	jmp    8005c9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80059a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	01 c2                	add    %eax,%edx
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005c6:	ff 45 ec             	incl   -0x14(%ebp)
  8005c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005cf:	7c c9                	jl     80059a <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 2a                	jmp    800604 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005e7:	01 c2                	add    %eax,%edx
  8005e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800607:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80060a:	7c ce                	jl     8005da <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	e9 0a 01 00 00       	jmp    800721 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80061d:	0f 8d 95 00 00 00    	jge    8006b8 <Merge+0x178>
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800629:	0f 8d 89 00 00 00    	jge    8006b8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	7d 33                	jge    800688 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066d:	8d 50 01             	lea    0x1(%eax),%edx
  800670:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800683:	e9 96 00 00 00       	jmp    80071e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 50 01             	lea    0x1(%eax),%edx
  8006a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006b6:	eb 66                	jmp    80071e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006be:	7d 30                	jge    8006f0 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 01                	mov    %eax,(%ecx)
  8006ee:	eb 2e                	jmp    80071e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80070e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
  800721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800724:	3b 45 14             	cmp    0x14(%ebp),%eax
  800727:	0f 8e ea fe ff ff    	jle    800617 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80073c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 5e 15 00 00       	call   801ca7 <sys_cputc>
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 19 15 00 00       	call   801c73 <sys_disable_interrupt>
	char c = ch;
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800760:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	50                   	push   %eax
  800768:	e8 3a 15 00 00       	call   801ca7 <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 18 15 00 00       	call   801c8d <sys_enable_interrupt>
}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getchar>:

int
getchar(void)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800785:	eb 08                	jmp    80078f <getchar+0x17>
	{
		c = sys_cgetc();
  800787:	e8 62 13 00 00       	call   801aee <sys_cgetc>
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80078f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800793:	74 f2                	je     800787 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <atomic_getchar>:

int
atomic_getchar(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a0:	e8 ce 14 00 00       	call   801c73 <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 3b 13 00 00       	call   801aee <sys_cgetc>
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007ba:	74 f2                	je     8007ae <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007bc:	e8 cc 14 00 00       	call   801c8d <sys_enable_interrupt>
	return c;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <iscons>:

int iscons(int fdnum)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007d6:	e8 8b 16 00 00       	call   801e66 <sys_getenvindex>
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	89 d0                	mov    %edx,%eax
  8007e3:	01 c0                	add    %eax,%eax
  8007e5:	01 d0                	add    %edx,%eax
  8007e7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007ee:	01 c8                	add    %ecx,%eax
  8007f0:	c1 e0 02             	shl    $0x2,%eax
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007fc:	01 c8                	add    %ecx,%eax
  8007fe:	c1 e0 02             	shl    $0x2,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	c1 e0 02             	shl    $0x2,%eax
  800806:	01 d0                	add    %edx,%eax
  800808:	c1 e0 03             	shl    $0x3,%eax
  80080b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800810:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800815:	a1 24 30 80 00       	mov    0x803024,%eax
  80081a:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800820:	84 c0                	test   %al,%al
  800822:	74 0f                	je     800833 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800824:	a1 24 30 80 00       	mov    0x803024,%eax
  800829:	05 18 da 01 00       	add    $0x1da18,%eax
  80082e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800833:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800837:	7e 0a                	jle    800843 <libmain+0x73>
		binaryname = argv[0];
  800839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	ff 75 08             	pushl  0x8(%ebp)
  80084c:	e8 e7 f7 ff ff       	call   800038 <_main>
  800851:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800854:	e8 1a 14 00 00       	call   801c73 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800859:	83 ec 0c             	sub    $0xc,%esp
  80085c:	68 58 25 80 00       	push   $0x802558
  800861:	e8 6d 03 00 00       	call   800bd3 <cprintf>
  800866:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800869:	a1 24 30 80 00       	mov    0x803024,%eax
  80086e:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800874:	a1 24 30 80 00       	mov    0x803024,%eax
  800879:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	52                   	push   %edx
  800883:	50                   	push   %eax
  800884:	68 80 25 80 00       	push   $0x802580
  800889:	e8 45 03 00 00       	call   800bd3 <cprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800891:	a1 24 30 80 00       	mov    0x803024,%eax
  800896:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80089c:	a1 24 30 80 00       	mov    0x803024,%eax
  8008a1:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8008a7:	a1 24 30 80 00       	mov    0x803024,%eax
  8008ac:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8008b2:	51                   	push   %ecx
  8008b3:	52                   	push   %edx
  8008b4:	50                   	push   %eax
  8008b5:	68 a8 25 80 00       	push   $0x8025a8
  8008ba:	e8 14 03 00 00       	call   800bd3 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008c2:	a1 24 30 80 00       	mov    0x803024,%eax
  8008c7:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	50                   	push   %eax
  8008d1:	68 00 26 80 00       	push   $0x802600
  8008d6:	e8 f8 02 00 00       	call   800bd3 <cprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008de:	83 ec 0c             	sub    $0xc,%esp
  8008e1:	68 58 25 80 00       	push   $0x802558
  8008e6:	e8 e8 02 00 00       	call   800bd3 <cprintf>
  8008eb:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008ee:	e8 9a 13 00 00       	call   801c8d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008f3:	e8 19 00 00 00       	call   800911 <exit>
}
  8008f8:	90                   	nop
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    

008008fb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800901:	83 ec 0c             	sub    $0xc,%esp
  800904:	6a 00                	push   $0x0
  800906:	e8 27 15 00 00       	call   801e32 <sys_destroy_env>
  80090b:	83 c4 10             	add    $0x10,%esp
}
  80090e:	90                   	nop
  80090f:	c9                   	leave  
  800910:	c3                   	ret    

00800911 <exit>:

void
exit(void)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800917:	e8 7c 15 00 00       	call   801e98 <sys_exit_env>
}
  80091c:	90                   	nop
  80091d:	c9                   	leave  
  80091e:	c3                   	ret    

0080091f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800925:	8d 45 10             	lea    0x10(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80092e:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800933:	85 c0                	test   %eax,%eax
  800935:	74 16                	je     80094d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800937:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	50                   	push   %eax
  800940:	68 14 26 80 00       	push   $0x802614
  800945:	e8 89 02 00 00       	call   800bd3 <cprintf>
  80094a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80094d:	a1 00 30 80 00       	mov    0x803000,%eax
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	ff 75 08             	pushl  0x8(%ebp)
  800958:	50                   	push   %eax
  800959:	68 19 26 80 00       	push   $0x802619
  80095e:	e8 70 02 00 00       	call   800bd3 <cprintf>
  800963:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800966:	8b 45 10             	mov    0x10(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 f4             	pushl  -0xc(%ebp)
  80096f:	50                   	push   %eax
  800970:	e8 f3 01 00 00       	call   800b68 <vcprintf>
  800975:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	6a 00                	push   $0x0
  80097d:	68 35 26 80 00       	push   $0x802635
  800982:	e8 e1 01 00 00       	call   800b68 <vcprintf>
  800987:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80098a:	e8 82 ff ff ff       	call   800911 <exit>

	// should not return here
	while (1) ;
  80098f:	eb fe                	jmp    80098f <_panic+0x70>

00800991 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800997:	a1 24 30 80 00       	mov    0x803024,%eax
  80099c:	8b 50 74             	mov    0x74(%eax),%edx
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a2:	39 c2                	cmp    %eax,%edx
  8009a4:	74 14                	je     8009ba <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009a6:	83 ec 04             	sub    $0x4,%esp
  8009a9:	68 38 26 80 00       	push   $0x802638
  8009ae:	6a 26                	push   $0x26
  8009b0:	68 84 26 80 00       	push   $0x802684
  8009b5:	e8 65 ff ff ff       	call   80091f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009c8:	e9 c2 00 00 00       	jmp    800a8f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	01 d0                	add    %edx,%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	85 c0                	test   %eax,%eax
  8009e0:	75 08                	jne    8009ea <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009e2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009e5:	e9 a2 00 00 00       	jmp    800a8c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009f8:	eb 69                	jmp    800a63 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009fa:	a1 24 30 80 00       	mov    0x803024,%eax
  8009ff:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800a05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a08:	89 d0                	mov    %edx,%eax
  800a0a:	01 c0                	add    %eax,%eax
  800a0c:	01 d0                	add    %edx,%eax
  800a0e:	c1 e0 03             	shl    $0x3,%eax
  800a11:	01 c8                	add    %ecx,%eax
  800a13:	8a 40 04             	mov    0x4(%eax),%al
  800a16:	84 c0                	test   %al,%al
  800a18:	75 46                	jne    800a60 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a1a:	a1 24 30 80 00       	mov    0x803024,%eax
  800a1f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800a25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	01 c0                	add    %eax,%eax
  800a2c:	01 d0                	add    %edx,%eax
  800a2e:	c1 e0 03             	shl    $0x3,%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a40:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a45:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	01 c8                	add    %ecx,%eax
  800a51:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a53:	39 c2                	cmp    %eax,%edx
  800a55:	75 09                	jne    800a60 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a57:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a5e:	eb 12                	jmp    800a72 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a60:	ff 45 e8             	incl   -0x18(%ebp)
  800a63:	a1 24 30 80 00       	mov    0x803024,%eax
  800a68:	8b 50 74             	mov    0x74(%eax),%edx
  800a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a6e:	39 c2                	cmp    %eax,%edx
  800a70:	77 88                	ja     8009fa <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a76:	75 14                	jne    800a8c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a78:	83 ec 04             	sub    $0x4,%esp
  800a7b:	68 90 26 80 00       	push   $0x802690
  800a80:	6a 3a                	push   $0x3a
  800a82:	68 84 26 80 00       	push   $0x802684
  800a87:	e8 93 fe ff ff       	call   80091f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a8c:	ff 45 f0             	incl   -0x10(%ebp)
  800a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a92:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a95:	0f 8c 32 ff ff ff    	jl     8009cd <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800aa9:	eb 26                	jmp    800ad1 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800aab:	a1 24 30 80 00       	mov    0x803024,%eax
  800ab0:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800ab6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ab9:	89 d0                	mov    %edx,%eax
  800abb:	01 c0                	add    %eax,%eax
  800abd:	01 d0                	add    %edx,%eax
  800abf:	c1 e0 03             	shl    $0x3,%eax
  800ac2:	01 c8                	add    %ecx,%eax
  800ac4:	8a 40 04             	mov    0x4(%eax),%al
  800ac7:	3c 01                	cmp    $0x1,%al
  800ac9:	75 03                	jne    800ace <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800acb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ace:	ff 45 e0             	incl   -0x20(%ebp)
  800ad1:	a1 24 30 80 00       	mov    0x803024,%eax
  800ad6:	8b 50 74             	mov    0x74(%eax),%edx
  800ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adc:	39 c2                	cmp    %eax,%edx
  800ade:	77 cb                	ja     800aab <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ae6:	74 14                	je     800afc <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ae8:	83 ec 04             	sub    $0x4,%esp
  800aeb:	68 e4 26 80 00       	push   $0x8026e4
  800af0:	6a 44                	push   $0x44
  800af2:	68 84 26 80 00       	push   $0x802684
  800af7:	e8 23 fe ff ff       	call   80091f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800afc:	90                   	nop
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	89 0a                	mov    %ecx,(%edx)
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	88 d1                	mov    %dl,%cl
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b28:	75 2c                	jne    800b56 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b2a:	a0 28 30 80 00       	mov    0x803028,%al
  800b2f:	0f b6 c0             	movzbl %al,%eax
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	8b 12                	mov    (%edx),%edx
  800b37:	89 d1                	mov    %edx,%ecx
  800b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3c:	83 c2 08             	add    $0x8,%edx
  800b3f:	83 ec 04             	sub    $0x4,%esp
  800b42:	50                   	push   %eax
  800b43:	51                   	push   %ecx
  800b44:	52                   	push   %edx
  800b45:	e8 7b 0f 00 00       	call   801ac5 <sys_cputs>
  800b4a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8b 40 04             	mov    0x4(%eax),%eax
  800b5c:	8d 50 01             	lea    0x1(%eax),%edx
  800b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b62:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b65:	90                   	nop
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b78:	00 00 00 
	b.cnt = 0;
  800b7b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b82:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	ff 75 08             	pushl  0x8(%ebp)
  800b8b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b91:	50                   	push   %eax
  800b92:	68 ff 0a 80 00       	push   $0x800aff
  800b97:	e8 11 02 00 00       	call   800dad <vprintfmt>
  800b9c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b9f:	a0 28 30 80 00       	mov    0x803028,%al
  800ba4:	0f b6 c0             	movzbl %al,%eax
  800ba7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	50                   	push   %eax
  800bb1:	52                   	push   %edx
  800bb2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bb8:	83 c0 08             	add    $0x8,%eax
  800bbb:	50                   	push   %eax
  800bbc:	e8 04 0f 00 00       	call   801ac5 <sys_cputs>
  800bc1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bc4:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800bcb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    

00800bd3 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bd9:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800be0:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 f4             	pushl  -0xc(%ebp)
  800bef:	50                   	push   %eax
  800bf0:	e8 73 ff ff ff       	call   800b68 <vcprintf>
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfe:	c9                   	leave  
  800bff:	c3                   	ret    

00800c00 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c06:	e8 68 10 00 00       	call   801c73 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c0b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1a:	50                   	push   %eax
  800c1b:	e8 48 ff ff ff       	call   800b68 <vcprintf>
  800c20:	83 c4 10             	add    $0x10,%esp
  800c23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c26:	e8 62 10 00 00       	call   801c8d <sys_enable_interrupt>
	return cnt;
  800c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	53                   	push   %ebx
  800c34:	83 ec 14             	sub    $0x14,%esp
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c43:	8b 45 18             	mov    0x18(%ebp),%eax
  800c46:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c4e:	77 55                	ja     800ca5 <printnum+0x75>
  800c50:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c53:	72 05                	jb     800c5a <printnum+0x2a>
  800c55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c58:	77 4b                	ja     800ca5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c5a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c5d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c60:	8b 45 18             	mov    0x18(%ebp),%eax
  800c63:	ba 00 00 00 00       	mov    $0x0,%edx
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800c70:	e8 83 14 00 00       	call   8020f8 <__udivdi3>
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	83 ec 04             	sub    $0x4,%esp
  800c7b:	ff 75 20             	pushl  0x20(%ebp)
  800c7e:	53                   	push   %ebx
  800c7f:	ff 75 18             	pushl  0x18(%ebp)
  800c82:	52                   	push   %edx
  800c83:	50                   	push   %eax
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 08             	pushl  0x8(%ebp)
  800c8a:	e8 a1 ff ff ff       	call   800c30 <printnum>
  800c8f:	83 c4 20             	add    $0x20,%esp
  800c92:	eb 1a                	jmp    800cae <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	ff 75 20             	pushl  0x20(%ebp)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	ff d0                	call   *%eax
  800ca2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ca5:	ff 4d 1c             	decl   0x1c(%ebp)
  800ca8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cac:	7f e6                	jg     800c94 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cae:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbc:	53                   	push   %ebx
  800cbd:	51                   	push   %ecx
  800cbe:	52                   	push   %edx
  800cbf:	50                   	push   %eax
  800cc0:	e8 43 15 00 00       	call   802208 <__umoddi3>
  800cc5:	83 c4 10             	add    $0x10,%esp
  800cc8:	05 54 29 80 00       	add    $0x802954,%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f be c0             	movsbl %al,%eax
  800cd2:	83 ec 08             	sub    $0x8,%esp
  800cd5:	ff 75 0c             	pushl  0xc(%ebp)
  800cd8:	50                   	push   %eax
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	ff d0                	call   *%eax
  800cde:	83 c4 10             	add    $0x10,%esp
}
  800ce1:	90                   	nop
  800ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cee:	7e 1c                	jle    800d0c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  800d0a:	eb 40                	jmp    800d4c <getuint+0x65>
	else if (lflag)
  800d0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d10:	74 1e                	je     800d30 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2e:	eb 1c                	jmp    800d4c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8b 00                	mov    (%eax),%eax
  800d35:	8d 50 04             	lea    0x4(%eax),%edx
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	89 10                	mov    %edx,(%eax)
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8b 00                	mov    (%eax),%eax
  800d42:	83 e8 04             	sub    $0x4,%eax
  800d45:	8b 00                	mov    (%eax),%eax
  800d47:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d51:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d55:	7e 1c                	jle    800d73 <getint+0x25>
		return va_arg(*ap, long long);
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	8d 50 08             	lea    0x8(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	89 10                	mov    %edx,(%eax)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 e8 08             	sub    $0x8,%eax
  800d6c:	8b 50 04             	mov    0x4(%eax),%edx
  800d6f:	8b 00                	mov    (%eax),%eax
  800d71:	eb 38                	jmp    800dab <getint+0x5d>
	else if (lflag)
  800d73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d77:	74 1a                	je     800d93 <getint+0x45>
		return va_arg(*ap, long);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	8d 50 04             	lea    0x4(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	89 10                	mov    %edx,(%eax)
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 00                	mov    (%eax),%eax
  800d8b:	83 e8 04             	sub    $0x4,%eax
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	99                   	cltd   
  800d91:	eb 18                	jmp    800dab <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	8d 50 04             	lea    0x4(%eax),%edx
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 10                	mov    %edx,(%eax)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	83 e8 04             	sub    $0x4,%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	99                   	cltd   
}
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db5:	eb 17                	jmp    800dce <vprintfmt+0x21>
			if (ch == '\0')
  800db7:	85 db                	test   %ebx,%ebx
  800db9:	0f 84 af 03 00 00    	je     80116e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dbf:	83 ec 08             	sub    $0x8,%esp
  800dc2:	ff 75 0c             	pushl  0xc(%ebp)
  800dc5:	53                   	push   %ebx
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	ff d0                	call   *%eax
  800dcb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dce:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d8             	movzbl %al,%ebx
  800ddc:	83 fb 25             	cmp    $0x25,%ebx
  800ddf:	75 d6                	jne    800db7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800de1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800de5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800df3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dfa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	8d 50 01             	lea    0x1(%eax),%edx
  800e07:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	0f b6 d8             	movzbl %al,%ebx
  800e0f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e12:	83 f8 55             	cmp    $0x55,%eax
  800e15:	0f 87 2b 03 00 00    	ja     801146 <vprintfmt+0x399>
  800e1b:	8b 04 85 78 29 80 00 	mov    0x802978(,%eax,4),%eax
  800e22:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e24:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e28:	eb d7                	jmp    800e01 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e2a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e2e:	eb d1                	jmp    800e01 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e3a:	89 d0                	mov    %edx,%eax
  800e3c:	c1 e0 02             	shl    $0x2,%eax
  800e3f:	01 d0                	add    %edx,%eax
  800e41:	01 c0                	add    %eax,%eax
  800e43:	01 d8                	add    %ebx,%eax
  800e45:	83 e8 30             	sub    $0x30,%eax
  800e48:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e53:	83 fb 2f             	cmp    $0x2f,%ebx
  800e56:	7e 3e                	jle    800e96 <vprintfmt+0xe9>
  800e58:	83 fb 39             	cmp    $0x39,%ebx
  800e5b:	7f 39                	jg     800e96 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e5d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e60:	eb d5                	jmp    800e37 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e62:	8b 45 14             	mov    0x14(%ebp),%eax
  800e65:	83 c0 04             	add    $0x4,%eax
  800e68:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6e:	83 e8 04             	sub    $0x4,%eax
  800e71:	8b 00                	mov    (%eax),%eax
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e76:	eb 1f                	jmp    800e97 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7c:	79 83                	jns    800e01 <vprintfmt+0x54>
				width = 0;
  800e7e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e85:	e9 77 ff ff ff       	jmp    800e01 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e8a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e91:	e9 6b ff ff ff       	jmp    800e01 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e96:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e9b:	0f 89 60 ff ff ff    	jns    800e01 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ea7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800eae:	e9 4e ff ff ff       	jmp    800e01 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800eb3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800eb6:	e9 46 ff ff ff       	jmp    800e01 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ebb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebe:	83 c0 04             	add    $0x4,%eax
  800ec1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec7:	83 e8 04             	sub    $0x4,%eax
  800eca:	8b 00                	mov    (%eax),%eax
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	50                   	push   %eax
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	ff d0                	call   *%eax
  800ed8:	83 c4 10             	add    $0x10,%esp
			break;
  800edb:	e9 89 02 00 00       	jmp    801169 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ee0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee3:	83 c0 04             	add    $0x4,%eax
  800ee6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee9:	8b 45 14             	mov    0x14(%ebp),%eax
  800eec:	83 e8 04             	sub    $0x4,%eax
  800eef:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ef1:	85 db                	test   %ebx,%ebx
  800ef3:	79 02                	jns    800ef7 <vprintfmt+0x14a>
				err = -err;
  800ef5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ef7:	83 fb 64             	cmp    $0x64,%ebx
  800efa:	7f 0b                	jg     800f07 <vprintfmt+0x15a>
  800efc:	8b 34 9d c0 27 80 00 	mov    0x8027c0(,%ebx,4),%esi
  800f03:	85 f6                	test   %esi,%esi
  800f05:	75 19                	jne    800f20 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f07:	53                   	push   %ebx
  800f08:	68 65 29 80 00       	push   $0x802965
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	ff 75 08             	pushl  0x8(%ebp)
  800f13:	e8 5e 02 00 00       	call   801176 <printfmt>
  800f18:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f1b:	e9 49 02 00 00       	jmp    801169 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f20:	56                   	push   %esi
  800f21:	68 6e 29 80 00       	push   $0x80296e
  800f26:	ff 75 0c             	pushl  0xc(%ebp)
  800f29:	ff 75 08             	pushl  0x8(%ebp)
  800f2c:	e8 45 02 00 00       	call   801176 <printfmt>
  800f31:	83 c4 10             	add    $0x10,%esp
			break;
  800f34:	e9 30 02 00 00       	jmp    801169 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f39:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3c:	83 c0 04             	add    $0x4,%eax
  800f3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f42:	8b 45 14             	mov    0x14(%ebp),%eax
  800f45:	83 e8 04             	sub    $0x4,%eax
  800f48:	8b 30                	mov    (%eax),%esi
  800f4a:	85 f6                	test   %esi,%esi
  800f4c:	75 05                	jne    800f53 <vprintfmt+0x1a6>
				p = "(null)";
  800f4e:	be 71 29 80 00       	mov    $0x802971,%esi
			if (width > 0 && padc != '-')
  800f53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f57:	7e 6d                	jle    800fc6 <vprintfmt+0x219>
  800f59:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f5d:	74 67                	je     800fc6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	50                   	push   %eax
  800f66:	56                   	push   %esi
  800f67:	e8 0c 03 00 00       	call   801278 <strnlen>
  800f6c:	83 c4 10             	add    $0x10,%esp
  800f6f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f72:	eb 16                	jmp    800f8a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f74:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	50                   	push   %eax
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	ff d0                	call   *%eax
  800f84:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f87:	ff 4d e4             	decl   -0x1c(%ebp)
  800f8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f8e:	7f e4                	jg     800f74 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f90:	eb 34                	jmp    800fc6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f92:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f96:	74 1c                	je     800fb4 <vprintfmt+0x207>
  800f98:	83 fb 1f             	cmp    $0x1f,%ebx
  800f9b:	7e 05                	jle    800fa2 <vprintfmt+0x1f5>
  800f9d:	83 fb 7e             	cmp    $0x7e,%ebx
  800fa0:	7e 12                	jle    800fb4 <vprintfmt+0x207>
					putch('?', putdat);
  800fa2:	83 ec 08             	sub    $0x8,%esp
  800fa5:	ff 75 0c             	pushl  0xc(%ebp)
  800fa8:	6a 3f                	push   $0x3f
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	ff d0                	call   *%eax
  800faf:	83 c4 10             	add    $0x10,%esp
  800fb2:	eb 0f                	jmp    800fc3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	53                   	push   %ebx
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	ff d0                	call   *%eax
  800fc0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fc3:	ff 4d e4             	decl   -0x1c(%ebp)
  800fc6:	89 f0                	mov    %esi,%eax
  800fc8:	8d 70 01             	lea    0x1(%eax),%esi
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	0f be d8             	movsbl %al,%ebx
  800fd0:	85 db                	test   %ebx,%ebx
  800fd2:	74 24                	je     800ff8 <vprintfmt+0x24b>
  800fd4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fd8:	78 b8                	js     800f92 <vprintfmt+0x1e5>
  800fda:	ff 4d e0             	decl   -0x20(%ebp)
  800fdd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fe1:	79 af                	jns    800f92 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe3:	eb 13                	jmp    800ff8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 0c             	pushl  0xc(%ebp)
  800feb:	6a 20                	push   $0x20
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	ff d0                	call   *%eax
  800ff2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ff5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ff8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ffc:	7f e7                	jg     800fe5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ffe:	e9 66 01 00 00       	jmp    801169 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801003:	83 ec 08             	sub    $0x8,%esp
  801006:	ff 75 e8             	pushl  -0x18(%ebp)
  801009:	8d 45 14             	lea    0x14(%ebp),%eax
  80100c:	50                   	push   %eax
  80100d:	e8 3c fd ff ff       	call   800d4e <getint>
  801012:	83 c4 10             	add    $0x10,%esp
  801015:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801018:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80101b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801021:	85 d2                	test   %edx,%edx
  801023:	79 23                	jns    801048 <vprintfmt+0x29b>
				putch('-', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 2d                	push   $0x2d
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103b:	f7 d8                	neg    %eax
  80103d:	83 d2 00             	adc    $0x0,%edx
  801040:	f7 da                	neg    %edx
  801042:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801045:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801048:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80104f:	e9 bc 00 00 00       	jmp    801110 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801054:	83 ec 08             	sub    $0x8,%esp
  801057:	ff 75 e8             	pushl  -0x18(%ebp)
  80105a:	8d 45 14             	lea    0x14(%ebp),%eax
  80105d:	50                   	push   %eax
  80105e:	e8 84 fc ff ff       	call   800ce7 <getuint>
  801063:	83 c4 10             	add    $0x10,%esp
  801066:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801069:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80106c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801073:	e9 98 00 00 00       	jmp    801110 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	ff 75 0c             	pushl  0xc(%ebp)
  80107e:	6a 58                	push   $0x58
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	ff d0                	call   *%eax
  801085:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801088:	83 ec 08             	sub    $0x8,%esp
  80108b:	ff 75 0c             	pushl  0xc(%ebp)
  80108e:	6a 58                	push   $0x58
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	ff d0                	call   *%eax
  801095:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801098:	83 ec 08             	sub    $0x8,%esp
  80109b:	ff 75 0c             	pushl  0xc(%ebp)
  80109e:	6a 58                	push   $0x58
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	ff d0                	call   *%eax
  8010a5:	83 c4 10             	add    $0x10,%esp
			break;
  8010a8:	e9 bc 00 00 00       	jmp    801169 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8010ad:	83 ec 08             	sub    $0x8,%esp
  8010b0:	ff 75 0c             	pushl  0xc(%ebp)
  8010b3:	6a 30                	push   $0x30
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	ff d0                	call   *%eax
  8010ba:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 0c             	pushl  0xc(%ebp)
  8010c3:	6a 78                	push   $0x78
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	ff d0                	call   *%eax
  8010ca:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d0:	83 c0 04             	add    $0x4,%eax
  8010d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d9:	83 e8 04             	sub    $0x4,%eax
  8010dc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010e8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010ef:	eb 1f                	jmp    801110 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010f1:	83 ec 08             	sub    $0x8,%esp
  8010f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8010f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8010fa:	50                   	push   %eax
  8010fb:	e8 e7 fb ff ff       	call   800ce7 <getuint>
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801106:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801109:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801110:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	52                   	push   %edx
  80111b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80111e:	50                   	push   %eax
  80111f:	ff 75 f4             	pushl  -0xc(%ebp)
  801122:	ff 75 f0             	pushl  -0x10(%ebp)
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	ff 75 08             	pushl  0x8(%ebp)
  80112b:	e8 00 fb ff ff       	call   800c30 <printnum>
  801130:	83 c4 20             	add    $0x20,%esp
			break;
  801133:	eb 34                	jmp    801169 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801135:	83 ec 08             	sub    $0x8,%esp
  801138:	ff 75 0c             	pushl  0xc(%ebp)
  80113b:	53                   	push   %ebx
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	ff d0                	call   *%eax
  801141:	83 c4 10             	add    $0x10,%esp
			break;
  801144:	eb 23                	jmp    801169 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	ff 75 0c             	pushl  0xc(%ebp)
  80114c:	6a 25                	push   $0x25
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	ff d0                	call   *%eax
  801153:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801156:	ff 4d 10             	decl   0x10(%ebp)
  801159:	eb 03                	jmp    80115e <vprintfmt+0x3b1>
  80115b:	ff 4d 10             	decl   0x10(%ebp)
  80115e:	8b 45 10             	mov    0x10(%ebp),%eax
  801161:	48                   	dec    %eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 25                	cmp    $0x25,%al
  801166:	75 f3                	jne    80115b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801168:	90                   	nop
		}
	}
  801169:	e9 47 fc ff ff       	jmp    800db5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80116e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80116f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801172:	5b                   	pop    %ebx
  801173:	5e                   	pop    %esi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80117c:	8d 45 10             	lea    0x10(%ebp),%eax
  80117f:	83 c0 04             	add    $0x4,%eax
  801182:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801185:	8b 45 10             	mov    0x10(%ebp),%eax
  801188:	ff 75 f4             	pushl  -0xc(%ebp)
  80118b:	50                   	push   %eax
  80118c:	ff 75 0c             	pushl  0xc(%ebp)
  80118f:	ff 75 08             	pushl  0x8(%ebp)
  801192:	e8 16 fc ff ff       	call   800dad <vprintfmt>
  801197:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80119a:	90                   	nop
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 40 08             	mov    0x8(%eax),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	8b 10                	mov    (%eax),%edx
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8b 40 04             	mov    0x4(%eax),%eax
  8011ba:	39 c2                	cmp    %eax,%edx
  8011bc:	73 12                	jae    8011d0 <sprintputch+0x33>
		*b->buf++ = ch;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8011c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c9:	89 0a                	mov    %ecx,(%edx)
  8011cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ce:	88 10                	mov    %dl,(%eax)
}
  8011d0:	90                   	nop
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	01 d0                	add    %edx,%eax
  8011ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f8:	74 06                	je     801200 <vsnprintf+0x2d>
  8011fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011fe:	7f 07                	jg     801207 <vsnprintf+0x34>
		return -E_INVAL;
  801200:	b8 03 00 00 00       	mov    $0x3,%eax
  801205:	eb 20                	jmp    801227 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801207:	ff 75 14             	pushl  0x14(%ebp)
  80120a:	ff 75 10             	pushl  0x10(%ebp)
  80120d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801210:	50                   	push   %eax
  801211:	68 9d 11 80 00       	push   $0x80119d
  801216:	e8 92 fb ff ff       	call   800dad <vprintfmt>
  80121b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80121e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801224:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80122f:	8d 45 10             	lea    0x10(%ebp),%eax
  801232:	83 c0 04             	add    $0x4,%eax
  801235:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	ff 75 f4             	pushl  -0xc(%ebp)
  80123e:	50                   	push   %eax
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	ff 75 08             	pushl  0x8(%ebp)
  801245:	e8 89 ff ff ff       	call   8011d3 <vsnprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801253:	c9                   	leave  
  801254:	c3                   	ret    

00801255 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80125b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801262:	eb 06                	jmp    80126a <strlen+0x15>
		n++;
  801264:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	75 f1                	jne    801264 <strlen+0xf>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80127e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801285:	eb 09                	jmp    801290 <strnlen+0x18>
		n++;
  801287:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128a:	ff 45 08             	incl   0x8(%ebp)
  80128d:	ff 4d 0c             	decl   0xc(%ebp)
  801290:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801294:	74 09                	je     80129f <strnlen+0x27>
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	84 c0                	test   %al,%al
  80129d:	75 e8                	jne    801287 <strnlen+0xf>
		n++;
	return n;
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012b0:	90                   	nop
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8d 50 01             	lea    0x1(%eax),%edx
  8012b7:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012c3:	8a 12                	mov    (%edx),%dl
  8012c5:	88 10                	mov    %dl,(%eax)
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	84 c0                	test   %al,%al
  8012cb:	75 e4                	jne    8012b1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e5:	eb 1f                	jmp    801306 <strncpy+0x34>
		*dst++ = *src;
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8d 50 01             	lea    0x1(%eax),%edx
  8012ed:	89 55 08             	mov    %edx,0x8(%ebp)
  8012f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f3:	8a 12                	mov    (%edx),%dl
  8012f5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	84 c0                	test   %al,%al
  8012fe:	74 03                	je     801303 <strncpy+0x31>
			src++;
  801300:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801303:	ff 45 fc             	incl   -0x4(%ebp)
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801309:	3b 45 10             	cmp    0x10(%ebp),%eax
  80130c:	72 d9                	jb     8012e7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80130e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80131f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801323:	74 30                	je     801355 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801325:	eb 16                	jmp    80133d <strlcpy+0x2a>
			*dst++ = *src++;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8d 50 01             	lea    0x1(%eax),%edx
  80132d:	89 55 08             	mov    %edx,0x8(%ebp)
  801330:	8b 55 0c             	mov    0xc(%ebp),%edx
  801333:	8d 4a 01             	lea    0x1(%edx),%ecx
  801336:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801339:	8a 12                	mov    (%edx),%dl
  80133b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80133d:	ff 4d 10             	decl   0x10(%ebp)
  801340:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801344:	74 09                	je     80134f <strlcpy+0x3c>
  801346:	8b 45 0c             	mov    0xc(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	84 c0                	test   %al,%al
  80134d:	75 d8                	jne    801327 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801355:	8b 55 08             	mov    0x8(%ebp),%edx
  801358:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135b:	29 c2                	sub    %eax,%edx
  80135d:	89 d0                	mov    %edx,%eax
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801364:	eb 06                	jmp    80136c <strcmp+0xb>
		p++, q++;
  801366:	ff 45 08             	incl   0x8(%ebp)
  801369:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	84 c0                	test   %al,%al
  801373:	74 0e                	je     801383 <strcmp+0x22>
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8a 10                	mov    (%eax),%dl
  80137a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	38 c2                	cmp    %al,%dl
  801381:	74 e3                	je     801366 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8a 00                	mov    (%eax),%al
  801388:	0f b6 d0             	movzbl %al,%edx
  80138b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	0f b6 c0             	movzbl %al,%eax
  801393:	29 c2                	sub    %eax,%edx
  801395:	89 d0                	mov    %edx,%eax
}
  801397:	5d                   	pop    %ebp
  801398:	c3                   	ret    

00801399 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80139c:	eb 09                	jmp    8013a7 <strncmp+0xe>
		n--, p++, q++;
  80139e:	ff 4d 10             	decl   0x10(%ebp)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 17                	je     8013c4 <strncmp+0x2b>
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	74 0e                	je     8013c4 <strncmp+0x2b>
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8a 10                	mov    (%eax),%dl
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	38 c2                	cmp    %al,%dl
  8013c2:	74 da                	je     80139e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c8:	75 07                	jne    8013d1 <strncmp+0x38>
		return 0;
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cf:	eb 14                	jmp    8013e5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f b6 d0             	movzbl %al,%edx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	0f b6 c0             	movzbl %al,%eax
  8013e1:	29 c2                	sub    %eax,%edx
  8013e3:	89 d0                	mov    %edx,%eax
}
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013f3:	eb 12                	jmp    801407 <strchr+0x20>
		if (*s == c)
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013fd:	75 05                	jne    801404 <strchr+0x1d>
			return (char *) s;
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	eb 11                	jmp    801415 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801404:	ff 45 08             	incl   0x8(%ebp)
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	84 c0                	test   %al,%al
  80140e:	75 e5                	jne    8013f5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801423:	eb 0d                	jmp    801432 <strfind+0x1b>
		if (*s == c)
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80142d:	74 0e                	je     80143d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80142f:	ff 45 08             	incl   0x8(%ebp)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	84 c0                	test   %al,%al
  801439:	75 ea                	jne    801425 <strfind+0xe>
  80143b:	eb 01                	jmp    80143e <strfind+0x27>
		if (*s == c)
			break;
  80143d:	90                   	nop
	return (char *) s;
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80144f:	8b 45 10             	mov    0x10(%ebp),%eax
  801452:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801455:	eb 0e                	jmp    801465 <memset+0x22>
		*p++ = c;
  801457:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145a:	8d 50 01             	lea    0x1(%eax),%edx
  80145d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801460:	8b 55 0c             	mov    0xc(%ebp),%edx
  801463:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801465:	ff 4d f8             	decl   -0x8(%ebp)
  801468:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80146c:	79 e9                	jns    801457 <memset+0x14>
		*p++ = c;

	return v;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801485:	eb 16                	jmp    80149d <memcpy+0x2a>
		*d++ = *s++;
  801487:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148a:	8d 50 01             	lea    0x1(%eax),%edx
  80148d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801490:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801493:	8d 4a 01             	lea    0x1(%edx),%ecx
  801496:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801499:	8a 12                	mov    (%edx),%dl
  80149b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	75 dd                	jne    801487 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c7:	73 50                	jae    801519 <memmove+0x6a>
  8014c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d4:	76 43                	jbe    801519 <memmove+0x6a>
		s += n;
  8014d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014e2:	eb 10                	jmp    8014f4 <memmove+0x45>
			*--d = *--s;
  8014e4:	ff 4d f8             	decl   -0x8(%ebp)
  8014e7:	ff 4d fc             	decl   -0x4(%ebp)
  8014ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ed:	8a 10                	mov    (%eax),%dl
  8014ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	75 e3                	jne    8014e4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801501:	eb 23                	jmp    801526 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	8d 50 01             	lea    0x1(%eax),%edx
  801509:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80150c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801512:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801515:	8a 12                	mov    (%edx),%dl
  801517:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801519:	8b 45 10             	mov    0x10(%ebp),%eax
  80151c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151f:	89 55 10             	mov    %edx,0x10(%ebp)
  801522:	85 c0                	test   %eax,%eax
  801524:	75 dd                	jne    801503 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80153d:	eb 2a                	jmp    801569 <memcmp+0x3e>
		if (*s1 != *s2)
  80153f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801542:	8a 10                	mov    (%eax),%dl
  801544:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	38 c2                	cmp    %al,%dl
  80154b:	74 16                	je     801563 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80154d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	0f b6 d0             	movzbl %al,%edx
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 c0             	movzbl %al,%eax
  80155d:	29 c2                	sub    %eax,%edx
  80155f:	89 d0                	mov    %edx,%eax
  801561:	eb 18                	jmp    80157b <memcmp+0x50>
		s1++, s2++;
  801563:	ff 45 fc             	incl   -0x4(%ebp)
  801566:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801569:	8b 45 10             	mov    0x10(%ebp),%eax
  80156c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80156f:	89 55 10             	mov    %edx,0x10(%ebp)
  801572:	85 c0                	test   %eax,%eax
  801574:	75 c9                	jne    80153f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801576:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801583:	8b 55 08             	mov    0x8(%ebp),%edx
  801586:	8b 45 10             	mov    0x10(%ebp),%eax
  801589:	01 d0                	add    %edx,%eax
  80158b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80158e:	eb 15                	jmp    8015a5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	0f b6 d0             	movzbl %al,%edx
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	0f b6 c0             	movzbl %al,%eax
  80159e:	39 c2                	cmp    %eax,%edx
  8015a0:	74 0d                	je     8015af <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015a2:	ff 45 08             	incl   0x8(%ebp)
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015ab:	72 e3                	jb     801590 <memfind+0x13>
  8015ad:	eb 01                	jmp    8015b0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015af:	90                   	nop
	return (void *) s;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c9:	eb 03                	jmp    8015ce <strtol+0x19>
		s++;
  8015cb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	3c 20                	cmp    $0x20,%al
  8015d5:	74 f4                	je     8015cb <strtol+0x16>
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	3c 09                	cmp    $0x9,%al
  8015de:	74 eb                	je     8015cb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	8a 00                	mov    (%eax),%al
  8015e5:	3c 2b                	cmp    $0x2b,%al
  8015e7:	75 05                	jne    8015ee <strtol+0x39>
		s++;
  8015e9:	ff 45 08             	incl   0x8(%ebp)
  8015ec:	eb 13                	jmp    801601 <strtol+0x4c>
	else if (*s == '-')
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	3c 2d                	cmp    $0x2d,%al
  8015f5:	75 0a                	jne    801601 <strtol+0x4c>
		s++, neg = 1;
  8015f7:	ff 45 08             	incl   0x8(%ebp)
  8015fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801605:	74 06                	je     80160d <strtol+0x58>
  801607:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80160b:	75 20                	jne    80162d <strtol+0x78>
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3c 30                	cmp    $0x30,%al
  801614:	75 17                	jne    80162d <strtol+0x78>
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	40                   	inc    %eax
  80161a:	8a 00                	mov    (%eax),%al
  80161c:	3c 78                	cmp    $0x78,%al
  80161e:	75 0d                	jne    80162d <strtol+0x78>
		s += 2, base = 16;
  801620:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801624:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80162b:	eb 28                	jmp    801655 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80162d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801631:	75 15                	jne    801648 <strtol+0x93>
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 30                	cmp    $0x30,%al
  80163a:	75 0c                	jne    801648 <strtol+0x93>
		s++, base = 8;
  80163c:	ff 45 08             	incl   0x8(%ebp)
  80163f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801646:	eb 0d                	jmp    801655 <strtol+0xa0>
	else if (base == 0)
  801648:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80164c:	75 07                	jne    801655 <strtol+0xa0>
		base = 10;
  80164e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2f                	cmp    $0x2f,%al
  80165c:	7e 19                	jle    801677 <strtol+0xc2>
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8a 00                	mov    (%eax),%al
  801663:	3c 39                	cmp    $0x39,%al
  801665:	7f 10                	jg     801677 <strtol+0xc2>
			dig = *s - '0';
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8a 00                	mov    (%eax),%al
  80166c:	0f be c0             	movsbl %al,%eax
  80166f:	83 e8 30             	sub    $0x30,%eax
  801672:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801675:	eb 42                	jmp    8016b9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8a 00                	mov    (%eax),%al
  80167c:	3c 60                	cmp    $0x60,%al
  80167e:	7e 19                	jle    801699 <strtol+0xe4>
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	3c 7a                	cmp    $0x7a,%al
  801687:	7f 10                	jg     801699 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	0f be c0             	movsbl %al,%eax
  801691:	83 e8 57             	sub    $0x57,%eax
  801694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801697:	eb 20                	jmp    8016b9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	3c 40                	cmp    $0x40,%al
  8016a0:	7e 39                	jle    8016db <strtol+0x126>
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	3c 5a                	cmp    $0x5a,%al
  8016a9:	7f 30                	jg     8016db <strtol+0x126>
			dig = *s - 'A' + 10;
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	0f be c0             	movsbl %al,%eax
  8016b3:	83 e8 37             	sub    $0x37,%eax
  8016b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016bf:	7d 19                	jge    8016da <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016c1:	ff 45 08             	incl   0x8(%ebp)
  8016c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016cb:	89 c2                	mov    %eax,%edx
  8016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d0:	01 d0                	add    %edx,%eax
  8016d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016d5:	e9 7b ff ff ff       	jmp    801655 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016da:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016df:	74 08                	je     8016e9 <strtol+0x134>
		*endptr = (char *) s;
  8016e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016ed:	74 07                	je     8016f6 <strtol+0x141>
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	f7 d8                	neg    %eax
  8016f4:	eb 03                	jmp    8016f9 <strtol+0x144>
  8016f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <ltostr>:

void
ltostr(long value, char *str)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801701:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801708:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80170f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801713:	79 13                	jns    801728 <ltostr+0x2d>
	{
		neg = 1;
  801715:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801722:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801725:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801730:	99                   	cltd   
  801731:	f7 f9                	idiv   %ecx
  801733:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801736:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801739:	8d 50 01             	lea    0x1(%eax),%edx
  80173c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80173f:	89 c2                	mov    %eax,%edx
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	01 d0                	add    %edx,%eax
  801746:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801749:	83 c2 30             	add    $0x30,%edx
  80174c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80174e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801751:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801756:	f7 e9                	imul   %ecx
  801758:	c1 fa 02             	sar    $0x2,%edx
  80175b:	89 c8                	mov    %ecx,%eax
  80175d:	c1 f8 1f             	sar    $0x1f,%eax
  801760:	29 c2                	sub    %eax,%edx
  801762:	89 d0                	mov    %edx,%eax
  801764:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801767:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80176a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80176f:	f7 e9                	imul   %ecx
  801771:	c1 fa 02             	sar    $0x2,%edx
  801774:	89 c8                	mov    %ecx,%eax
  801776:	c1 f8 1f             	sar    $0x1f,%eax
  801779:	29 c2                	sub    %eax,%edx
  80177b:	89 d0                	mov    %edx,%eax
  80177d:	c1 e0 02             	shl    $0x2,%eax
  801780:	01 d0                	add    %edx,%eax
  801782:	01 c0                	add    %eax,%eax
  801784:	29 c1                	sub    %eax,%ecx
  801786:	89 ca                	mov    %ecx,%edx
  801788:	85 d2                	test   %edx,%edx
  80178a:	75 9c                	jne    801728 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80178c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801793:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801796:	48                   	dec    %eax
  801797:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80179a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80179e:	74 3d                	je     8017dd <ltostr+0xe2>
		start = 1 ;
  8017a0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017a7:	eb 34                	jmp    8017dd <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017af:	01 d0                	add    %edx,%eax
  8017b1:	8a 00                	mov    (%eax),%al
  8017b3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 c2                	add    %eax,%edx
  8017be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c4:	01 c8                	add    %ecx,%eax
  8017c6:	8a 00                	mov    (%eax),%al
  8017c8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d0:	01 c2                	add    %eax,%edx
  8017d2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017d5:	88 02                	mov    %al,(%edx)
		start++ ;
  8017d7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017da:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017e3:	7c c4                	jl     8017a9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017f0:	90                   	nop
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	e8 54 fa ff ff       	call   801255 <strlen>
  801801:	83 c4 04             	add    $0x4,%esp
  801804:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	e8 46 fa ff ff       	call   801255 <strlen>
  80180f:	83 c4 04             	add    $0x4,%esp
  801812:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80181c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801823:	eb 17                	jmp    80183c <strcconcat+0x49>
		final[s] = str1[s] ;
  801825:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	01 c2                	add    %eax,%edx
  80182d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	01 c8                	add    %ecx,%eax
  801835:	8a 00                	mov    (%eax),%al
  801837:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801839:	ff 45 fc             	incl   -0x4(%ebp)
  80183c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80183f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801842:	7c e1                	jl     801825 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801844:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80184b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801852:	eb 1f                	jmp    801873 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801854:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801857:	8d 50 01             	lea    0x1(%eax),%edx
  80185a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80185d:	89 c2                	mov    %eax,%edx
  80185f:	8b 45 10             	mov    0x10(%ebp),%eax
  801862:	01 c2                	add    %eax,%edx
  801864:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186a:	01 c8                	add    %ecx,%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801870:	ff 45 f8             	incl   -0x8(%ebp)
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801879:	7c d9                	jl     801854 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80187b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80187e:	8b 45 10             	mov    0x10(%ebp),%eax
  801881:	01 d0                	add    %edx,%eax
  801883:	c6 00 00             	movb   $0x0,(%eax)
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80188c:	8b 45 14             	mov    0x14(%ebp),%eax
  80188f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801895:	8b 45 14             	mov    0x14(%ebp),%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a4:	01 d0                	add    %edx,%eax
  8018a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018ac:	eb 0c                	jmp    8018ba <strsplit+0x31>
			*string++ = 0;
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	8d 50 01             	lea    0x1(%eax),%edx
  8018b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8018b7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	8a 00                	mov    (%eax),%al
  8018bf:	84 c0                	test   %al,%al
  8018c1:	74 18                	je     8018db <strsplit+0x52>
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8a 00                	mov    (%eax),%al
  8018c8:	0f be c0             	movsbl %al,%eax
  8018cb:	50                   	push   %eax
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	e8 13 fb ff ff       	call   8013e7 <strchr>
  8018d4:	83 c4 08             	add    $0x8,%esp
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	75 d3                	jne    8018ae <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	84 c0                	test   %al,%al
  8018e2:	74 5a                	je     80193e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e7:	8b 00                	mov    (%eax),%eax
  8018e9:	83 f8 0f             	cmp    $0xf,%eax
  8018ec:	75 07                	jne    8018f5 <strsplit+0x6c>
		{
			return 0;
  8018ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f3:	eb 66                	jmp    80195b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f8:	8b 00                	mov    (%eax),%eax
  8018fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8018fd:	8b 55 14             	mov    0x14(%ebp),%edx
  801900:	89 0a                	mov    %ecx,(%edx)
  801902:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801909:	8b 45 10             	mov    0x10(%ebp),%eax
  80190c:	01 c2                	add    %eax,%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801913:	eb 03                	jmp    801918 <strsplit+0x8f>
			string++;
  801915:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 00                	mov    (%eax),%al
  80191d:	84 c0                	test   %al,%al
  80191f:	74 8b                	je     8018ac <strsplit+0x23>
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	0f be c0             	movsbl %al,%eax
  801929:	50                   	push   %eax
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	e8 b5 fa ff ff       	call   8013e7 <strchr>
  801932:	83 c4 08             	add    $0x8,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	74 dc                	je     801915 <strsplit+0x8c>
			string++;
	}
  801939:	e9 6e ff ff ff       	jmp    8018ac <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80193e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80193f:	8b 45 14             	mov    0x14(%ebp),%eax
  801942:	8b 00                	mov    (%eax),%eax
  801944:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80194b:	8b 45 10             	mov    0x10(%ebp),%eax
  80194e:	01 d0                	add    %edx,%eax
  801950:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801956:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	68 d0 2a 80 00       	push   $0x802ad0
  80196b:	6a 0e                	push   $0xe
  80196d:	68 0a 2b 80 00       	push   $0x802b0a
  801972:	e8 a8 ef ff ff       	call   80091f <_panic>

00801977 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80197d:	a1 04 30 80 00       	mov    0x803004,%eax
  801982:	85 c0                	test   %eax,%eax
  801984:	74 0f                	je     801995 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801986:	e8 d2 ff ff ff       	call   80195d <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80198b:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801992:	00 00 00 
	}
	if (size == 0) return NULL ;
  801995:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801999:	75 07                	jne    8019a2 <malloc+0x2b>
  80199b:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a0:	eb 14                	jmp    8019b6 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	68 18 2b 80 00       	push   $0x802b18
  8019aa:	6a 2e                	push   $0x2e
  8019ac:	68 0a 2b 80 00       	push   $0x802b0a
  8019b1:	e8 69 ef ff ff       	call   80091f <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019be:	83 ec 04             	sub    $0x4,%esp
  8019c1:	68 40 2b 80 00       	push   $0x802b40
  8019c6:	6a 49                	push   $0x49
  8019c8:	68 0a 2b 80 00       	push   $0x802b0a
  8019cd:	e8 4d ef ff ff       	call   80091f <_panic>

008019d2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 18             	sub    $0x18,%esp
  8019d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019db:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	68 64 2b 80 00       	push   $0x802b64
  8019e6:	6a 57                	push   $0x57
  8019e8:	68 0a 2b 80 00       	push   $0x802b0a
  8019ed:	e8 2d ef ff ff       	call   80091f <_panic>

008019f2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	68 8c 2b 80 00       	push   $0x802b8c
  801a00:	6a 60                	push   $0x60
  801a02:	68 0a 2b 80 00       	push   $0x802b0a
  801a07:	e8 13 ef ff ff       	call   80091f <_panic>

00801a0c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	68 b0 2b 80 00       	push   $0x802bb0
  801a1a:	6a 7c                	push   $0x7c
  801a1c:	68 0a 2b 80 00       	push   $0x802b0a
  801a21:	e8 f9 ee ff ff       	call   80091f <_panic>

00801a26 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	68 d8 2b 80 00       	push   $0x802bd8
  801a34:	68 86 00 00 00       	push   $0x86
  801a39:	68 0a 2b 80 00       	push   $0x802b0a
  801a3e:	e8 dc ee ff ff       	call   80091f <_panic>

00801a43 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 fc 2b 80 00       	push   $0x802bfc
  801a51:	68 91 00 00 00       	push   $0x91
  801a56:	68 0a 2b 80 00       	push   $0x802b0a
  801a5b:	e8 bf ee ff ff       	call   80091f <_panic>

00801a60 <shrink>:

}
void shrink(uint32 newSize)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	68 fc 2b 80 00       	push   $0x802bfc
  801a6e:	68 96 00 00 00       	push   $0x96
  801a73:	68 0a 2b 80 00       	push   $0x802b0a
  801a78:	e8 a2 ee ff ff       	call   80091f <_panic>

00801a7d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 fc 2b 80 00       	push   $0x802bfc
  801a8b:	68 9b 00 00 00       	push   $0x9b
  801a90:	68 0a 2b 80 00       	push   $0x802b0a
  801a95:	e8 85 ee ff ff       	call   80091f <_panic>

00801a9a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	57                   	push   %edi
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aaf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ab2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ab5:	cd 30                	int    $0x30
  801ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5f                   	pop    %edi
  801ac3:	5d                   	pop    %ebp
  801ac4:	c3                   	ret    

00801ac5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ace:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ad1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	52                   	push   %edx
  801add:	ff 75 0c             	pushl  0xc(%ebp)
  801ae0:	50                   	push   %eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	e8 b2 ff ff ff       	call   801a9a <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_cgetc>:

int
sys_cgetc(void)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 01                	push   $0x1
  801afd:	e8 98 ff ff ff       	call   801a9a <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	52                   	push   %edx
  801b17:	50                   	push   %eax
  801b18:	6a 05                	push   $0x5
  801b1a:	e8 7b ff ff ff       	call   801a9a <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	56                   	push   %esi
  801b28:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b29:	8b 75 18             	mov    0x18(%ebp),%esi
  801b2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	51                   	push   %ecx
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 06                	push   $0x6
  801b3f:	e8 56 ff ff ff       	call   801a9a <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4a:	5b                   	pop    %ebx
  801b4b:	5e                   	pop    %esi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	52                   	push   %edx
  801b5e:	50                   	push   %eax
  801b5f:	6a 07                	push   $0x7
  801b61:	e8 34 ff ff ff       	call   801a9a <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	ff 75 08             	pushl  0x8(%ebp)
  801b7a:	6a 08                	push   $0x8
  801b7c:	e8 19 ff ff ff       	call   801a9a <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 09                	push   $0x9
  801b95:	e8 00 ff ff ff       	call   801a9a <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 0a                	push   $0xa
  801bae:	e8 e7 fe ff ff       	call   801a9a <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 0b                	push   $0xb
  801bc7:	e8 ce fe ff ff       	call   801a9a <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	ff 75 08             	pushl  0x8(%ebp)
  801be0:	6a 0f                	push   $0xf
  801be2:	e8 b3 fe ff ff       	call   801a9a <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
	return;
  801bea:	90                   	nop
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	ff 75 08             	pushl  0x8(%ebp)
  801bfc:	6a 10                	push   $0x10
  801bfe:	e8 97 fe ff ff       	call   801a9a <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
	return ;
  801c06:	90                   	nop
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	ff 75 10             	pushl  0x10(%ebp)
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	ff 75 08             	pushl  0x8(%ebp)
  801c19:	6a 11                	push   $0x11
  801c1b:	e8 7a fe ff ff       	call   801a9a <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
	return ;
  801c23:	90                   	nop
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 0c                	push   $0xc
  801c35:	e8 60 fe ff ff       	call   801a9a <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 0d                	push   $0xd
  801c4f:	e8 46 fe ff ff       	call   801a9a <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 0e                	push   $0xe
  801c68:	e8 2d fe ff ff       	call   801a9a <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	90                   	nop
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 13                	push   $0x13
  801c82:	e8 13 fe ff ff       	call   801a9a <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	90                   	nop
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 14                	push   $0x14
  801c9c:	e8 f9 fd ff ff       	call   801a9a <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cb3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	50                   	push   %eax
  801cc0:	6a 15                	push   $0x15
  801cc2:	e8 d3 fd ff ff       	call   801a9a <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	90                   	nop
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 16                	push   $0x16
  801cdc:	e8 b9 fd ff ff       	call   801a9a <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	90                   	nop
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	ff 75 0c             	pushl  0xc(%ebp)
  801cf6:	50                   	push   %eax
  801cf7:	6a 17                	push   $0x17
  801cf9:	e8 9c fd ff ff       	call   801a9a <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	6a 1a                	push   $0x1a
  801d16:	e8 7f fd ff ff       	call   801a9a <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	52                   	push   %edx
  801d30:	50                   	push   %eax
  801d31:	6a 18                	push   $0x18
  801d33:	e8 62 fd ff ff       	call   801a9a <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	90                   	nop
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	52                   	push   %edx
  801d4e:	50                   	push   %eax
  801d4f:	6a 19                	push   $0x19
  801d51:	e8 44 fd ff ff       	call   801a9a <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	90                   	nop
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 04             	sub    $0x4,%esp
  801d62:	8b 45 10             	mov    0x10(%ebp),%eax
  801d65:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d68:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d6b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	51                   	push   %ecx
  801d75:	52                   	push   %edx
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	50                   	push   %eax
  801d7a:	6a 1b                	push   $0x1b
  801d7c:	e8 19 fd ff ff       	call   801a9a <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	52                   	push   %edx
  801d96:	50                   	push   %eax
  801d97:	6a 1c                	push   $0x1c
  801d99:	e8 fc fc ff ff       	call   801a9a <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801da6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	51                   	push   %ecx
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 1d                	push   $0x1d
  801db8:	e8 dd fc ff ff       	call   801a9a <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	52                   	push   %edx
  801dd2:	50                   	push   %eax
  801dd3:	6a 1e                	push   $0x1e
  801dd5:	e8 c0 fc ff ff       	call   801a9a <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 1f                	push   $0x1f
  801dee:	e8 a7 fc ff ff       	call   801a9a <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	6a 00                	push   $0x0
  801e00:	ff 75 14             	pushl  0x14(%ebp)
  801e03:	ff 75 10             	pushl  0x10(%ebp)
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	50                   	push   %eax
  801e0a:	6a 20                	push   $0x20
  801e0c:	e8 89 fc ff ff       	call   801a9a <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	50                   	push   %eax
  801e25:	6a 21                	push   $0x21
  801e27:	e8 6e fc ff ff       	call   801a9a <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	90                   	nop
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	50                   	push   %eax
  801e41:	6a 22                	push   $0x22
  801e43:	e8 52 fc ff ff       	call   801a9a <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 02                	push   $0x2
  801e5c:	e8 39 fc ff ff       	call   801a9a <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 03                	push   $0x3
  801e75:	e8 20 fc ff ff       	call   801a9a <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 04                	push   $0x4
  801e8e:	e8 07 fc ff ff       	call   801a9a <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_exit_env>:


void sys_exit_env(void)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 23                	push   $0x23
  801ea7:	e8 ee fb ff ff       	call   801a9a <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	90                   	nop
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801eb8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ebb:	8d 50 04             	lea    0x4(%eax),%edx
  801ebe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	52                   	push   %edx
  801ec8:	50                   	push   %eax
  801ec9:	6a 24                	push   $0x24
  801ecb:	e8 ca fb ff ff       	call   801a9a <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
	return result;
  801ed3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801edc:	89 01                	mov    %eax,(%ecx)
  801ede:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	c9                   	leave  
  801ee5:	c2 04 00             	ret    $0x4

00801ee8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	ff 75 10             	pushl  0x10(%ebp)
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	6a 12                	push   $0x12
  801efa:	e8 9b fb ff ff       	call   801a9a <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
	return ;
  801f02:	90                   	nop
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 25                	push   $0x25
  801f14:	e8 81 fb ff ff       	call   801a9a <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 04             	sub    $0x4,%esp
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f2a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	50                   	push   %eax
  801f37:	6a 26                	push   $0x26
  801f39:	e8 5c fb ff ff       	call   801a9a <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f41:	90                   	nop
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <rsttst>:
void rsttst()
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 28                	push   $0x28
  801f53:	e8 42 fb ff ff       	call   801a9a <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5b:	90                   	nop
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	83 ec 04             	sub    $0x4,%esp
  801f64:	8b 45 14             	mov    0x14(%ebp),%eax
  801f67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f6a:	8b 55 18             	mov    0x18(%ebp),%edx
  801f6d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f71:	52                   	push   %edx
  801f72:	50                   	push   %eax
  801f73:	ff 75 10             	pushl  0x10(%ebp)
  801f76:	ff 75 0c             	pushl  0xc(%ebp)
  801f79:	ff 75 08             	pushl  0x8(%ebp)
  801f7c:	6a 27                	push   $0x27
  801f7e:	e8 17 fb ff ff       	call   801a9a <syscall>
  801f83:	83 c4 18             	add    $0x18,%esp
	return ;
  801f86:	90                   	nop
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <chktst>:
void chktst(uint32 n)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	ff 75 08             	pushl  0x8(%ebp)
  801f97:	6a 29                	push   $0x29
  801f99:	e8 fc fa ff ff       	call   801a9a <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa1:	90                   	nop
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <inctst>:

void inctst()
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 2a                	push   $0x2a
  801fb3:	e8 e2 fa ff ff       	call   801a9a <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbb:	90                   	nop
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <gettst>:
uint32 gettst()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 2b                	push   $0x2b
  801fcd:	e8 c8 fa ff ff       	call   801a9a <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 2c                	push   $0x2c
  801fe9:	e8 ac fa ff ff       	call   801a9a <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
  801ff1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ff4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ff8:	75 07                	jne    802001 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ffa:	b8 01 00 00 00       	mov    $0x1,%eax
  801fff:	eb 05                	jmp    802006 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 2c                	push   $0x2c
  80201a:	e8 7b fa ff ff       	call   801a9a <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
  802022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802025:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802029:	75 07                	jne    802032 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80202b:	b8 01 00 00 00       	mov    $0x1,%eax
  802030:	eb 05                	jmp    802037 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 2c                	push   $0x2c
  80204b:	e8 4a fa ff ff       	call   801a9a <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
  802053:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802056:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80205a:	75 07                	jne    802063 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80205c:	b8 01 00 00 00       	mov    $0x1,%eax
  802061:	eb 05                	jmp    802068 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 2c                	push   $0x2c
  80207c:	e8 19 fa ff ff       	call   801a9a <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
  802084:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802087:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80208b:	75 07                	jne    802094 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80208d:	b8 01 00 00 00       	mov    $0x1,%eax
  802092:	eb 05                	jmp    802099 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	ff 75 08             	pushl  0x8(%ebp)
  8020a9:	6a 2d                	push   $0x2d
  8020ab:	e8 ea f9 ff ff       	call   801a9a <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b3:	90                   	nop
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	6a 00                	push   $0x0
  8020c8:	53                   	push   %ebx
  8020c9:	51                   	push   %ecx
  8020ca:	52                   	push   %edx
  8020cb:	50                   	push   %eax
  8020cc:	6a 2e                	push   $0x2e
  8020ce:	e8 c7 f9 ff ff       	call   801a9a <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 2f                	push   $0x2f
  8020ee:	e8 a7 f9 ff ff       	call   801a9a <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <__udivdi3>:
  8020f8:	55                   	push   %ebp
  8020f9:	57                   	push   %edi
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 1c             	sub    $0x1c,%esp
  8020ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802103:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802107:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80210b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80210f:	89 ca                	mov    %ecx,%edx
  802111:	89 f8                	mov    %edi,%eax
  802113:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802117:	85 f6                	test   %esi,%esi
  802119:	75 2d                	jne    802148 <__udivdi3+0x50>
  80211b:	39 cf                	cmp    %ecx,%edi
  80211d:	77 65                	ja     802184 <__udivdi3+0x8c>
  80211f:	89 fd                	mov    %edi,%ebp
  802121:	85 ff                	test   %edi,%edi
  802123:	75 0b                	jne    802130 <__udivdi3+0x38>
  802125:	b8 01 00 00 00       	mov    $0x1,%eax
  80212a:	31 d2                	xor    %edx,%edx
  80212c:	f7 f7                	div    %edi
  80212e:	89 c5                	mov    %eax,%ebp
  802130:	31 d2                	xor    %edx,%edx
  802132:	89 c8                	mov    %ecx,%eax
  802134:	f7 f5                	div    %ebp
  802136:	89 c1                	mov    %eax,%ecx
  802138:	89 d8                	mov    %ebx,%eax
  80213a:	f7 f5                	div    %ebp
  80213c:	89 cf                	mov    %ecx,%edi
  80213e:	89 fa                	mov    %edi,%edx
  802140:	83 c4 1c             	add    $0x1c,%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5f                   	pop    %edi
  802146:	5d                   	pop    %ebp
  802147:	c3                   	ret    
  802148:	39 ce                	cmp    %ecx,%esi
  80214a:	77 28                	ja     802174 <__udivdi3+0x7c>
  80214c:	0f bd fe             	bsr    %esi,%edi
  80214f:	83 f7 1f             	xor    $0x1f,%edi
  802152:	75 40                	jne    802194 <__udivdi3+0x9c>
  802154:	39 ce                	cmp    %ecx,%esi
  802156:	72 0a                	jb     802162 <__udivdi3+0x6a>
  802158:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80215c:	0f 87 9e 00 00 00    	ja     802200 <__udivdi3+0x108>
  802162:	b8 01 00 00 00       	mov    $0x1,%eax
  802167:	89 fa                	mov    %edi,%edx
  802169:	83 c4 1c             	add    $0x1c,%esp
  80216c:	5b                   	pop    %ebx
  80216d:	5e                   	pop    %esi
  80216e:	5f                   	pop    %edi
  80216f:	5d                   	pop    %ebp
  802170:	c3                   	ret    
  802171:	8d 76 00             	lea    0x0(%esi),%esi
  802174:	31 ff                	xor    %edi,%edi
  802176:	31 c0                	xor    %eax,%eax
  802178:	89 fa                	mov    %edi,%edx
  80217a:	83 c4 1c             	add    $0x1c,%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5f                   	pop    %edi
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    
  802182:	66 90                	xchg   %ax,%ax
  802184:	89 d8                	mov    %ebx,%eax
  802186:	f7 f7                	div    %edi
  802188:	31 ff                	xor    %edi,%edi
  80218a:	89 fa                	mov    %edi,%edx
  80218c:	83 c4 1c             	add    $0x1c,%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    
  802194:	bd 20 00 00 00       	mov    $0x20,%ebp
  802199:	89 eb                	mov    %ebp,%ebx
  80219b:	29 fb                	sub    %edi,%ebx
  80219d:	89 f9                	mov    %edi,%ecx
  80219f:	d3 e6                	shl    %cl,%esi
  8021a1:	89 c5                	mov    %eax,%ebp
  8021a3:	88 d9                	mov    %bl,%cl
  8021a5:	d3 ed                	shr    %cl,%ebp
  8021a7:	89 e9                	mov    %ebp,%ecx
  8021a9:	09 f1                	or     %esi,%ecx
  8021ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021af:	89 f9                	mov    %edi,%ecx
  8021b1:	d3 e0                	shl    %cl,%eax
  8021b3:	89 c5                	mov    %eax,%ebp
  8021b5:	89 d6                	mov    %edx,%esi
  8021b7:	88 d9                	mov    %bl,%cl
  8021b9:	d3 ee                	shr    %cl,%esi
  8021bb:	89 f9                	mov    %edi,%ecx
  8021bd:	d3 e2                	shl    %cl,%edx
  8021bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021c3:	88 d9                	mov    %bl,%cl
  8021c5:	d3 e8                	shr    %cl,%eax
  8021c7:	09 c2                	or     %eax,%edx
  8021c9:	89 d0                	mov    %edx,%eax
  8021cb:	89 f2                	mov    %esi,%edx
  8021cd:	f7 74 24 0c          	divl   0xc(%esp)
  8021d1:	89 d6                	mov    %edx,%esi
  8021d3:	89 c3                	mov    %eax,%ebx
  8021d5:	f7 e5                	mul    %ebp
  8021d7:	39 d6                	cmp    %edx,%esi
  8021d9:	72 19                	jb     8021f4 <__udivdi3+0xfc>
  8021db:	74 0b                	je     8021e8 <__udivdi3+0xf0>
  8021dd:	89 d8                	mov    %ebx,%eax
  8021df:	31 ff                	xor    %edi,%edi
  8021e1:	e9 58 ff ff ff       	jmp    80213e <__udivdi3+0x46>
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021ec:	89 f9                	mov    %edi,%ecx
  8021ee:	d3 e2                	shl    %cl,%edx
  8021f0:	39 c2                	cmp    %eax,%edx
  8021f2:	73 e9                	jae    8021dd <__udivdi3+0xe5>
  8021f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021f7:	31 ff                	xor    %edi,%edi
  8021f9:	e9 40 ff ff ff       	jmp    80213e <__udivdi3+0x46>
  8021fe:	66 90                	xchg   %ax,%ax
  802200:	31 c0                	xor    %eax,%eax
  802202:	e9 37 ff ff ff       	jmp    80213e <__udivdi3+0x46>
  802207:	90                   	nop

00802208 <__umoddi3>:
  802208:	55                   	push   %ebp
  802209:	57                   	push   %edi
  80220a:	56                   	push   %esi
  80220b:	53                   	push   %ebx
  80220c:	83 ec 1c             	sub    $0x1c,%esp
  80220f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802213:	8b 74 24 34          	mov    0x34(%esp),%esi
  802217:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80221b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80221f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802223:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802227:	89 f3                	mov    %esi,%ebx
  802229:	89 fa                	mov    %edi,%edx
  80222b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80222f:	89 34 24             	mov    %esi,(%esp)
  802232:	85 c0                	test   %eax,%eax
  802234:	75 1a                	jne    802250 <__umoddi3+0x48>
  802236:	39 f7                	cmp    %esi,%edi
  802238:	0f 86 a2 00 00 00    	jbe    8022e0 <__umoddi3+0xd8>
  80223e:	89 c8                	mov    %ecx,%eax
  802240:	89 f2                	mov    %esi,%edx
  802242:	f7 f7                	div    %edi
  802244:	89 d0                	mov    %edx,%eax
  802246:	31 d2                	xor    %edx,%edx
  802248:	83 c4 1c             	add    $0x1c,%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5f                   	pop    %edi
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    
  802250:	39 f0                	cmp    %esi,%eax
  802252:	0f 87 ac 00 00 00    	ja     802304 <__umoddi3+0xfc>
  802258:	0f bd e8             	bsr    %eax,%ebp
  80225b:	83 f5 1f             	xor    $0x1f,%ebp
  80225e:	0f 84 ac 00 00 00    	je     802310 <__umoddi3+0x108>
  802264:	bf 20 00 00 00       	mov    $0x20,%edi
  802269:	29 ef                	sub    %ebp,%edi
  80226b:	89 fe                	mov    %edi,%esi
  80226d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802271:	89 e9                	mov    %ebp,%ecx
  802273:	d3 e0                	shl    %cl,%eax
  802275:	89 d7                	mov    %edx,%edi
  802277:	89 f1                	mov    %esi,%ecx
  802279:	d3 ef                	shr    %cl,%edi
  80227b:	09 c7                	or     %eax,%edi
  80227d:	89 e9                	mov    %ebp,%ecx
  80227f:	d3 e2                	shl    %cl,%edx
  802281:	89 14 24             	mov    %edx,(%esp)
  802284:	89 d8                	mov    %ebx,%eax
  802286:	d3 e0                	shl    %cl,%eax
  802288:	89 c2                	mov    %eax,%edx
  80228a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80228e:	d3 e0                	shl    %cl,%eax
  802290:	89 44 24 04          	mov    %eax,0x4(%esp)
  802294:	8b 44 24 08          	mov    0x8(%esp),%eax
  802298:	89 f1                	mov    %esi,%ecx
  80229a:	d3 e8                	shr    %cl,%eax
  80229c:	09 d0                	or     %edx,%eax
  80229e:	d3 eb                	shr    %cl,%ebx
  8022a0:	89 da                	mov    %ebx,%edx
  8022a2:	f7 f7                	div    %edi
  8022a4:	89 d3                	mov    %edx,%ebx
  8022a6:	f7 24 24             	mull   (%esp)
  8022a9:	89 c6                	mov    %eax,%esi
  8022ab:	89 d1                	mov    %edx,%ecx
  8022ad:	39 d3                	cmp    %edx,%ebx
  8022af:	0f 82 87 00 00 00    	jb     80233c <__umoddi3+0x134>
  8022b5:	0f 84 91 00 00 00    	je     80234c <__umoddi3+0x144>
  8022bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022bf:	29 f2                	sub    %esi,%edx
  8022c1:	19 cb                	sbb    %ecx,%ebx
  8022c3:	89 d8                	mov    %ebx,%eax
  8022c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022c9:	d3 e0                	shl    %cl,%eax
  8022cb:	89 e9                	mov    %ebp,%ecx
  8022cd:	d3 ea                	shr    %cl,%edx
  8022cf:	09 d0                	or     %edx,%eax
  8022d1:	89 e9                	mov    %ebp,%ecx
  8022d3:	d3 eb                	shr    %cl,%ebx
  8022d5:	89 da                	mov    %ebx,%edx
  8022d7:	83 c4 1c             	add    $0x1c,%esp
  8022da:	5b                   	pop    %ebx
  8022db:	5e                   	pop    %esi
  8022dc:	5f                   	pop    %edi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    
  8022df:	90                   	nop
  8022e0:	89 fd                	mov    %edi,%ebp
  8022e2:	85 ff                	test   %edi,%edi
  8022e4:	75 0b                	jne    8022f1 <__umoddi3+0xe9>
  8022e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	f7 f7                	div    %edi
  8022ef:	89 c5                	mov    %eax,%ebp
  8022f1:	89 f0                	mov    %esi,%eax
  8022f3:	31 d2                	xor    %edx,%edx
  8022f5:	f7 f5                	div    %ebp
  8022f7:	89 c8                	mov    %ecx,%eax
  8022f9:	f7 f5                	div    %ebp
  8022fb:	89 d0                	mov    %edx,%eax
  8022fd:	e9 44 ff ff ff       	jmp    802246 <__umoddi3+0x3e>
  802302:	66 90                	xchg   %ax,%ax
  802304:	89 c8                	mov    %ecx,%eax
  802306:	89 f2                	mov    %esi,%edx
  802308:	83 c4 1c             	add    $0x1c,%esp
  80230b:	5b                   	pop    %ebx
  80230c:	5e                   	pop    %esi
  80230d:	5f                   	pop    %edi
  80230e:	5d                   	pop    %ebp
  80230f:	c3                   	ret    
  802310:	3b 04 24             	cmp    (%esp),%eax
  802313:	72 06                	jb     80231b <__umoddi3+0x113>
  802315:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802319:	77 0f                	ja     80232a <__umoddi3+0x122>
  80231b:	89 f2                	mov    %esi,%edx
  80231d:	29 f9                	sub    %edi,%ecx
  80231f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802323:	89 14 24             	mov    %edx,(%esp)
  802326:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80232a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80232e:	8b 14 24             	mov    (%esp),%edx
  802331:	83 c4 1c             	add    $0x1c,%esp
  802334:	5b                   	pop    %ebx
  802335:	5e                   	pop    %esi
  802336:	5f                   	pop    %edi
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    
  802339:	8d 76 00             	lea    0x0(%esi),%esi
  80233c:	2b 04 24             	sub    (%esp),%eax
  80233f:	19 fa                	sbb    %edi,%edx
  802341:	89 d1                	mov    %edx,%ecx
  802343:	89 c6                	mov    %eax,%esi
  802345:	e9 71 ff ff ff       	jmp    8022bb <__umoddi3+0xb3>
  80234a:	66 90                	xchg   %ax,%ax
  80234c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802350:	72 ea                	jb     80233c <__umoddi3+0x134>
  802352:	89 d9                	mov    %ebx,%ecx
  802354:	e9 62 ff ff ff       	jmp    8022bb <__umoddi3+0xb3>
