
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
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
  800041:	e8 a7 1c 00 00       	call   801ced <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 23 80 00       	push   $0x8023e0
  80004e:	e8 f4 09 00 00       	call   800a47 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 23 80 00       	push   $0x8023e2
  80005e:	e8 e4 09 00 00       	call   800a47 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 fb 23 80 00       	push   $0x8023fb
  80006e:	e8 d4 09 00 00       	call   800a47 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 23 80 00       	push   $0x8023e2
  80007e:	e8 c4 09 00 00       	call   800a47 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 23 80 00       	push   $0x8023e0
  80008e:	e8 b4 09 00 00       	call   800a47 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 14 24 80 00       	push   $0x802414
  8000a5:	e8 1f 10 00 00       	call   8010c9 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6f 15 00 00       	call   80162f <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 1c 19 00 00       	call   8019f1 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 34 24 80 00       	push   $0x802434
  8000e3:	e8 5f 09 00 00       	call   800a47 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 56 24 80 00       	push   $0x802456
  8000f3:	e8 4f 09 00 00       	call   800a47 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 64 24 80 00       	push   $0x802464
  800103:	e8 3f 09 00 00       	call   800a47 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 73 24 80 00       	push   $0x802473
  800113:	e8 2f 09 00 00       	call   800a47 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 83 24 80 00       	push   $0x802483
  800123:	e8 1f 09 00 00       	call   800a47 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 a0 1b 00 00       	call   801d07 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
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
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 13 1b 00 00       	call   801ced <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 8c 24 80 00       	push   $0x80248c
  8001e2:	e8 60 08 00 00       	call   800a47 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 18 1b 00 00       	call   801d07 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 c0 24 80 00       	push   $0x8024c0
  800211:	6a 49                	push   $0x49
  800213:	68 e2 24 80 00       	push   $0x8024e2
  800218:	e8 76 05 00 00       	call   800793 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 cb 1a 00 00       	call   801ced <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 00 25 80 00       	push   $0x802500
  80022a:	e8 18 08 00 00       	call   800a47 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 34 25 80 00       	push   $0x802534
  80023a:	e8 08 08 00 00       	call   800a47 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 68 25 80 00       	push   $0x802568
  80024a:	e8 f8 07 00 00       	call   800a47 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 b0 1a 00 00       	call   801d07 <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 d0 17 00 00       	call   801a32 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 83 1a 00 00       	call   801ced <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 9a 25 80 00       	push   $0x80259a
  800272:	e8 d0 07 00 00       	call   800a47 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 63 1a 00 00       	call   801d07 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 e0 23 80 00       	push   $0x8023e0
  800549:	e8 f9 04 00 00       	call   800a47 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 b8 25 80 00       	push   $0x8025b8
  80056b:	e8 d7 04 00 00       	call   800a47 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 bd 25 80 00       	push   $0x8025bd
  800599:	e8 a9 04 00 00       	call   800a47 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 64 17 00 00       	call   801d21 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 1f 17 00 00       	call   801ced <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 40 17 00 00       	call   801d21 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 1e 17 00 00       	call   801d07 <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 68 15 00 00       	call   801b68 <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 d4 16 00 00       	call   801ced <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 41 15 00 00       	call   801b68 <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 d2 16 00 00       	call   801d07 <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 91 18 00 00       	call   801ee0 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800662:	01 c8                	add    %ecx,%eax
  800664:	c1 e0 02             	shl    $0x2,%eax
  800667:	01 d0                	add    %edx,%eax
  800669:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800670:	01 c8                	add    %ecx,%eax
  800672:	c1 e0 02             	shl    $0x2,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	c1 e0 02             	shl    $0x2,%eax
  80067a:	01 d0                	add    %edx,%eax
  80067c:	c1 e0 03             	shl    $0x3,%eax
  80067f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800684:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800689:	a1 24 30 80 00       	mov    0x803024,%eax
  80068e:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800694:	84 c0                	test   %al,%al
  800696:	74 0f                	je     8006a7 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800698:	a1 24 30 80 00       	mov    0x803024,%eax
  80069d:	05 18 da 01 00       	add    $0x1da18,%eax
  8006a2:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006ab:	7e 0a                	jle    8006b7 <libmain+0x73>
		binaryname = argv[0];
  8006ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	ff 75 08             	pushl  0x8(%ebp)
  8006c0:	e8 73 f9 ff ff       	call   800038 <_main>
  8006c5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c8:	e8 20 16 00 00       	call   801ced <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	68 dc 25 80 00       	push   $0x8025dc
  8006d5:	e8 6d 03 00 00       	call   800a47 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006dd:	a1 24 30 80 00       	mov    0x803024,%eax
  8006e2:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8006e8:	a1 24 30 80 00       	mov    0x803024,%eax
  8006ed:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8006f3:	83 ec 04             	sub    $0x4,%esp
  8006f6:	52                   	push   %edx
  8006f7:	50                   	push   %eax
  8006f8:	68 04 26 80 00       	push   $0x802604
  8006fd:	e8 45 03 00 00       	call   800a47 <cprintf>
  800702:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800705:	a1 24 30 80 00       	mov    0x803024,%eax
  80070a:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800710:	a1 24 30 80 00       	mov    0x803024,%eax
  800715:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80071b:	a1 24 30 80 00       	mov    0x803024,%eax
  800720:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800726:	51                   	push   %ecx
  800727:	52                   	push   %edx
  800728:	50                   	push   %eax
  800729:	68 2c 26 80 00       	push   $0x80262c
  80072e:	e8 14 03 00 00       	call   800a47 <cprintf>
  800733:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800736:	a1 24 30 80 00       	mov    0x803024,%eax
  80073b:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	50                   	push   %eax
  800745:	68 84 26 80 00       	push   $0x802684
  80074a:	e8 f8 02 00 00       	call   800a47 <cprintf>
  80074f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800752:	83 ec 0c             	sub    $0xc,%esp
  800755:	68 dc 25 80 00       	push   $0x8025dc
  80075a:	e8 e8 02 00 00       	call   800a47 <cprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800762:	e8 a0 15 00 00       	call   801d07 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800767:	e8 19 00 00 00       	call   800785 <exit>
}
  80076c:	90                   	nop
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800775:	83 ec 0c             	sub    $0xc,%esp
  800778:	6a 00                	push   $0x0
  80077a:	e8 2d 17 00 00       	call   801eac <sys_destroy_env>
  80077f:	83 c4 10             	add    $0x10,%esp
}
  800782:	90                   	nop
  800783:	c9                   	leave  
  800784:	c3                   	ret    

00800785 <exit>:

void
exit(void)
{
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
  800788:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80078b:	e8 82 17 00 00       	call   801f12 <sys_exit_env>
}
  800790:	90                   	nop
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800799:	8d 45 10             	lea    0x10(%ebp),%eax
  80079c:	83 c0 04             	add    $0x4,%eax
  80079f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a2:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	74 16                	je     8007c1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007ab:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	50                   	push   %eax
  8007b4:	68 98 26 80 00       	push   $0x802698
  8007b9:	e8 89 02 00 00       	call   800a47 <cprintf>
  8007be:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c1:	a1 00 30 80 00       	mov    0x803000,%eax
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	50                   	push   %eax
  8007cd:	68 9d 26 80 00       	push   $0x80269d
  8007d2:	e8 70 02 00 00       	call   800a47 <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007da:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e3:	50                   	push   %eax
  8007e4:	e8 f3 01 00 00       	call   8009dc <vcprintf>
  8007e9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	6a 00                	push   $0x0
  8007f1:	68 b9 26 80 00       	push   $0x8026b9
  8007f6:	e8 e1 01 00 00       	call   8009dc <vcprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fe:	e8 82 ff ff ff       	call   800785 <exit>

	// should not return here
	while (1) ;
  800803:	eb fe                	jmp    800803 <_panic+0x70>

00800805 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80080b:	a1 24 30 80 00       	mov    0x803024,%eax
  800810:	8b 50 74             	mov    0x74(%eax),%edx
  800813:	8b 45 0c             	mov    0xc(%ebp),%eax
  800816:	39 c2                	cmp    %eax,%edx
  800818:	74 14                	je     80082e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	68 bc 26 80 00       	push   $0x8026bc
  800822:	6a 26                	push   $0x26
  800824:	68 08 27 80 00       	push   $0x802708
  800829:	e8 65 ff ff ff       	call   800793 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800835:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083c:	e9 c2 00 00 00       	jmp    800903 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 d0                	add    %edx,%eax
  800850:	8b 00                	mov    (%eax),%eax
  800852:	85 c0                	test   %eax,%eax
  800854:	75 08                	jne    80085e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800856:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800859:	e9 a2 00 00 00       	jmp    800900 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80085e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800865:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086c:	eb 69                	jmp    8008d7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086e:	a1 24 30 80 00       	mov    0x803024,%eax
  800873:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800879:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087c:	89 d0                	mov    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	c1 e0 03             	shl    $0x3,%eax
  800885:	01 c8                	add    %ecx,%eax
  800887:	8a 40 04             	mov    0x4(%eax),%al
  80088a:	84 c0                	test   %al,%al
  80088c:	75 46                	jne    8008d4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088e:	a1 24 30 80 00       	mov    0x803024,%eax
  800893:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800899:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089c:	89 d0                	mov    %edx,%eax
  80089e:	01 c0                	add    %eax,%eax
  8008a0:	01 d0                	add    %edx,%eax
  8008a2:	c1 e0 03             	shl    $0x3,%eax
  8008a5:	01 c8                	add    %ecx,%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	01 c8                	add    %ecx,%eax
  8008c5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c7:	39 c2                	cmp    %eax,%edx
  8008c9:	75 09                	jne    8008d4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008cb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d2:	eb 12                	jmp    8008e6 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d4:	ff 45 e8             	incl   -0x18(%ebp)
  8008d7:	a1 24 30 80 00       	mov    0x803024,%eax
  8008dc:	8b 50 74             	mov    0x74(%eax),%edx
  8008df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e2:	39 c2                	cmp    %eax,%edx
  8008e4:	77 88                	ja     80086e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008ea:	75 14                	jne    800900 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008ec:	83 ec 04             	sub    $0x4,%esp
  8008ef:	68 14 27 80 00       	push   $0x802714
  8008f4:	6a 3a                	push   $0x3a
  8008f6:	68 08 27 80 00       	push   $0x802708
  8008fb:	e8 93 fe ff ff       	call   800793 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800900:	ff 45 f0             	incl   -0x10(%ebp)
  800903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800906:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800909:	0f 8c 32 ff ff ff    	jl     800841 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800916:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091d:	eb 26                	jmp    800945 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091f:	a1 24 30 80 00       	mov    0x803024,%eax
  800924:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80092a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092d:	89 d0                	mov    %edx,%eax
  80092f:	01 c0                	add    %eax,%eax
  800931:	01 d0                	add    %edx,%eax
  800933:	c1 e0 03             	shl    $0x3,%eax
  800936:	01 c8                	add    %ecx,%eax
  800938:	8a 40 04             	mov    0x4(%eax),%al
  80093b:	3c 01                	cmp    $0x1,%al
  80093d:	75 03                	jne    800942 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80093f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800942:	ff 45 e0             	incl   -0x20(%ebp)
  800945:	a1 24 30 80 00       	mov    0x803024,%eax
  80094a:	8b 50 74             	mov    0x74(%eax),%edx
  80094d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800950:	39 c2                	cmp    %eax,%edx
  800952:	77 cb                	ja     80091f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800957:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80095a:	74 14                	je     800970 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 68 27 80 00       	push   $0x802768
  800964:	6a 44                	push   $0x44
  800966:	68 08 27 80 00       	push   $0x802708
  80096b:	e8 23 fe ff ff       	call   800793 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800970:	90                   	nop
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	8d 48 01             	lea    0x1(%eax),%ecx
  800981:	8b 55 0c             	mov    0xc(%ebp),%edx
  800984:	89 0a                	mov    %ecx,(%edx)
  800986:	8b 55 08             	mov    0x8(%ebp),%edx
  800989:	88 d1                	mov    %dl,%cl
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800992:	8b 45 0c             	mov    0xc(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099c:	75 2c                	jne    8009ca <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099e:	a0 28 30 80 00       	mov    0x803028,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	8b 12                	mov    (%edx),%edx
  8009ab:	89 d1                	mov    %edx,%ecx
  8009ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b0:	83 c2 08             	add    $0x8,%edx
  8009b3:	83 ec 04             	sub    $0x4,%esp
  8009b6:	50                   	push   %eax
  8009b7:	51                   	push   %ecx
  8009b8:	52                   	push   %edx
  8009b9:	e8 81 11 00 00       	call   801b3f <sys_cputs>
  8009be:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	8b 40 04             	mov    0x4(%eax),%eax
  8009d0:	8d 50 01             	lea    0x1(%eax),%edx
  8009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d9:	90                   	nop
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ec:	00 00 00 
	b.cnt = 0;
  8009ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	ff 75 08             	pushl  0x8(%ebp)
  8009ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a05:	50                   	push   %eax
  800a06:	68 73 09 80 00       	push   $0x800973
  800a0b:	e8 11 02 00 00       	call   800c21 <vprintfmt>
  800a10:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a13:	a0 28 30 80 00       	mov    0x803028,%al
  800a18:	0f b6 c0             	movzbl %al,%eax
  800a1b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a21:	83 ec 04             	sub    $0x4,%esp
  800a24:	50                   	push   %eax
  800a25:	52                   	push   %edx
  800a26:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2c:	83 c0 08             	add    $0x8,%eax
  800a2f:	50                   	push   %eax
  800a30:	e8 0a 11 00 00       	call   801b3f <sys_cputs>
  800a35:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a38:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800a3f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4d:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800a54:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 f4             	pushl  -0xc(%ebp)
  800a63:	50                   	push   %eax
  800a64:	e8 73 ff ff ff       	call   8009dc <vcprintf>
  800a69:	83 c4 10             	add    $0x10,%esp
  800a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a7a:	e8 6e 12 00 00       	call   801ced <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8e:	50                   	push   %eax
  800a8f:	e8 48 ff ff ff       	call   8009dc <vcprintf>
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a9a:	e8 68 12 00 00       	call   801d07 <sys_enable_interrupt>
	return cnt;
  800a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa2:	c9                   	leave  
  800aa3:	c3                   	ret    

00800aa4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	53                   	push   %ebx
  800aa8:	83 ec 14             	sub    $0x14,%esp
  800aab:	8b 45 10             	mov    0x10(%ebp),%eax
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab7:	8b 45 18             	mov    0x18(%ebp),%eax
  800aba:	ba 00 00 00 00       	mov    $0x0,%edx
  800abf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac2:	77 55                	ja     800b19 <printnum+0x75>
  800ac4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac7:	72 05                	jb     800ace <printnum+0x2a>
  800ac9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800acc:	77 4b                	ja     800b19 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ace:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad4:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  800adc:	52                   	push   %edx
  800add:	50                   	push   %eax
  800ade:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae4:	e8 8b 16 00 00       	call   802174 <__udivdi3>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	83 ec 04             	sub    $0x4,%esp
  800aef:	ff 75 20             	pushl  0x20(%ebp)
  800af2:	53                   	push   %ebx
  800af3:	ff 75 18             	pushl  0x18(%ebp)
  800af6:	52                   	push   %edx
  800af7:	50                   	push   %eax
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 08             	pushl  0x8(%ebp)
  800afe:	e8 a1 ff ff ff       	call   800aa4 <printnum>
  800b03:	83 c4 20             	add    $0x20,%esp
  800b06:	eb 1a                	jmp    800b22 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	ff 75 20             	pushl  0x20(%ebp)
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b19:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b20:	7f e6                	jg     800b08 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b22:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b30:	53                   	push   %ebx
  800b31:	51                   	push   %ecx
  800b32:	52                   	push   %edx
  800b33:	50                   	push   %eax
  800b34:	e8 4b 17 00 00       	call   802284 <__umoddi3>
  800b39:	83 c4 10             	add    $0x10,%esp
  800b3c:	05 d4 29 80 00       	add    $0x8029d4,%eax
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	0f be c0             	movsbl %al,%eax
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	50                   	push   %eax
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
}
  800b55:	90                   	nop
  800b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b62:	7e 1c                	jle    800b80 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8b 00                	mov    (%eax),%eax
  800b69:	8d 50 08             	lea    0x8(%eax),%edx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 10                	mov    %edx,(%eax)
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8b 00                	mov    (%eax),%eax
  800b76:	83 e8 08             	sub    $0x8,%eax
  800b79:	8b 50 04             	mov    0x4(%eax),%edx
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	eb 40                	jmp    800bc0 <getuint+0x65>
	else if (lflag)
  800b80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b84:	74 1e                	je     800ba4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8b 00                	mov    (%eax),%eax
  800b8b:	8d 50 04             	lea    0x4(%eax),%edx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	89 10                	mov    %edx,(%eax)
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	8b 00                	mov    (%eax),%eax
  800b98:	83 e8 04             	sub    $0x4,%eax
  800b9b:	8b 00                	mov    (%eax),%eax
  800b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba2:	eb 1c                	jmp    800bc0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	8d 50 04             	lea    0x4(%eax),%edx
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	89 10                	mov    %edx,(%eax)
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    

00800bc2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc9:	7e 1c                	jle    800be7 <getint+0x25>
		return va_arg(*ap, long long);
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8b 00                	mov    (%eax),%eax
  800bd0:	8d 50 08             	lea    0x8(%eax),%edx
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	89 10                	mov    %edx,(%eax)
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8b 00                	mov    (%eax),%eax
  800bdd:	83 e8 08             	sub    $0x8,%eax
  800be0:	8b 50 04             	mov    0x4(%eax),%edx
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	eb 38                	jmp    800c1f <getint+0x5d>
	else if (lflag)
  800be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800beb:	74 1a                	je     800c07 <getint+0x45>
		return va_arg(*ap, long);
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8b 00                	mov    (%eax),%eax
  800bf2:	8d 50 04             	lea    0x4(%eax),%edx
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	89 10                	mov    %edx,(%eax)
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8b 00                	mov    (%eax),%eax
  800bff:	83 e8 04             	sub    $0x4,%eax
  800c02:	8b 00                	mov    (%eax),%eax
  800c04:	99                   	cltd   
  800c05:	eb 18                	jmp    800c1f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	8d 50 04             	lea    0x4(%eax),%edx
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	89 10                	mov    %edx,(%eax)
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8b 00                	mov    (%eax),%eax
  800c19:	83 e8 04             	sub    $0x4,%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	99                   	cltd   
}
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
  800c26:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c29:	eb 17                	jmp    800c42 <vprintfmt+0x21>
			if (ch == '\0')
  800c2b:	85 db                	test   %ebx,%ebx
  800c2d:	0f 84 af 03 00 00    	je     800fe2 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	53                   	push   %ebx
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c42:	8b 45 10             	mov    0x10(%ebp),%eax
  800c45:	8d 50 01             	lea    0x1(%eax),%edx
  800c48:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f b6 d8             	movzbl %al,%ebx
  800c50:	83 fb 25             	cmp    $0x25,%ebx
  800c53:	75 d6                	jne    800c2b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c55:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c59:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c60:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c67:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	8d 50 01             	lea    0x1(%eax),%edx
  800c7b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	0f b6 d8             	movzbl %al,%ebx
  800c83:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c86:	83 f8 55             	cmp    $0x55,%eax
  800c89:	0f 87 2b 03 00 00    	ja     800fba <vprintfmt+0x399>
  800c8f:	8b 04 85 f8 29 80 00 	mov    0x8029f8(,%eax,4),%eax
  800c96:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c98:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9c:	eb d7                	jmp    800c75 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca2:	eb d1                	jmp    800c75 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cae:	89 d0                	mov    %edx,%eax
  800cb0:	c1 e0 02             	shl    $0x2,%eax
  800cb3:	01 d0                	add    %edx,%eax
  800cb5:	01 c0                	add    %eax,%eax
  800cb7:	01 d8                	add    %ebx,%eax
  800cb9:	83 e8 30             	sub    $0x30,%eax
  800cbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc7:	83 fb 2f             	cmp    $0x2f,%ebx
  800cca:	7e 3e                	jle    800d0a <vprintfmt+0xe9>
  800ccc:	83 fb 39             	cmp    $0x39,%ebx
  800ccf:	7f 39                	jg     800d0a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd4:	eb d5                	jmp    800cab <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 c0 04             	add    $0x4,%eax
  800cdc:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 e8 04             	sub    $0x4,%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cea:	eb 1f                	jmp    800d0b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf0:	79 83                	jns    800c75 <vprintfmt+0x54>
				width = 0;
  800cf2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf9:	e9 77 ff ff ff       	jmp    800c75 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfe:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d05:	e9 6b ff ff ff       	jmp    800c75 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d0a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0f:	0f 89 60 ff ff ff    	jns    800c75 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d1b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d22:	e9 4e ff ff ff       	jmp    800c75 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d27:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d2a:	e9 46 ff ff ff       	jmp    800c75 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d32:	83 c0 04             	add    $0x4,%eax
  800d35:	89 45 14             	mov    %eax,0x14(%ebp)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 e8 04             	sub    $0x4,%eax
  800d3e:	8b 00                	mov    (%eax),%eax
  800d40:	83 ec 08             	sub    $0x8,%esp
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	50                   	push   %eax
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	ff d0                	call   *%eax
  800d4c:	83 c4 10             	add    $0x10,%esp
			break;
  800d4f:	e9 89 02 00 00       	jmp    800fdd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d54:	8b 45 14             	mov    0x14(%ebp),%eax
  800d57:	83 c0 04             	add    $0x4,%eax
  800d5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 e8 04             	sub    $0x4,%eax
  800d63:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d65:	85 db                	test   %ebx,%ebx
  800d67:	79 02                	jns    800d6b <vprintfmt+0x14a>
				err = -err;
  800d69:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d6b:	83 fb 64             	cmp    $0x64,%ebx
  800d6e:	7f 0b                	jg     800d7b <vprintfmt+0x15a>
  800d70:	8b 34 9d 40 28 80 00 	mov    0x802840(,%ebx,4),%esi
  800d77:	85 f6                	test   %esi,%esi
  800d79:	75 19                	jne    800d94 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d7b:	53                   	push   %ebx
  800d7c:	68 e5 29 80 00       	push   $0x8029e5
  800d81:	ff 75 0c             	pushl  0xc(%ebp)
  800d84:	ff 75 08             	pushl  0x8(%ebp)
  800d87:	e8 5e 02 00 00       	call   800fea <printfmt>
  800d8c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8f:	e9 49 02 00 00       	jmp    800fdd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d94:	56                   	push   %esi
  800d95:	68 ee 29 80 00       	push   $0x8029ee
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 45 02 00 00       	call   800fea <printfmt>
  800da5:	83 c4 10             	add    $0x10,%esp
			break;
  800da8:	e9 30 02 00 00       	jmp    800fdd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dad:	8b 45 14             	mov    0x14(%ebp),%eax
  800db0:	83 c0 04             	add    $0x4,%eax
  800db3:	89 45 14             	mov    %eax,0x14(%ebp)
  800db6:	8b 45 14             	mov    0x14(%ebp),%eax
  800db9:	83 e8 04             	sub    $0x4,%eax
  800dbc:	8b 30                	mov    (%eax),%esi
  800dbe:	85 f6                	test   %esi,%esi
  800dc0:	75 05                	jne    800dc7 <vprintfmt+0x1a6>
				p = "(null)";
  800dc2:	be f1 29 80 00       	mov    $0x8029f1,%esi
			if (width > 0 && padc != '-')
  800dc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dcb:	7e 6d                	jle    800e3a <vprintfmt+0x219>
  800dcd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd1:	74 67                	je     800e3a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	50                   	push   %eax
  800dda:	56                   	push   %esi
  800ddb:	e8 12 05 00 00       	call   8012f2 <strnlen>
  800de0:	83 c4 10             	add    $0x10,%esp
  800de3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de6:	eb 16                	jmp    800dfe <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	50                   	push   %eax
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	ff d0                	call   *%eax
  800df8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfb:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e02:	7f e4                	jg     800de8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e04:	eb 34                	jmp    800e3a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e06:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e0a:	74 1c                	je     800e28 <vprintfmt+0x207>
  800e0c:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0f:	7e 05                	jle    800e16 <vprintfmt+0x1f5>
  800e11:	83 fb 7e             	cmp    $0x7e,%ebx
  800e14:	7e 12                	jle    800e28 <vprintfmt+0x207>
					putch('?', putdat);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	6a 3f                	push   $0x3f
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	ff d0                	call   *%eax
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	eb 0f                	jmp    800e37 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	53                   	push   %ebx
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	ff d0                	call   *%eax
  800e34:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e37:	ff 4d e4             	decl   -0x1c(%ebp)
  800e3a:	89 f0                	mov    %esi,%eax
  800e3c:	8d 70 01             	lea    0x1(%eax),%esi
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	0f be d8             	movsbl %al,%ebx
  800e44:	85 db                	test   %ebx,%ebx
  800e46:	74 24                	je     800e6c <vprintfmt+0x24b>
  800e48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4c:	78 b8                	js     800e06 <vprintfmt+0x1e5>
  800e4e:	ff 4d e0             	decl   -0x20(%ebp)
  800e51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e55:	79 af                	jns    800e06 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e57:	eb 13                	jmp    800e6c <vprintfmt+0x24b>
				putch(' ', putdat);
  800e59:	83 ec 08             	sub    $0x8,%esp
  800e5c:	ff 75 0c             	pushl  0xc(%ebp)
  800e5f:	6a 20                	push   $0x20
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	ff d0                	call   *%eax
  800e66:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e69:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e70:	7f e7                	jg     800e59 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e72:	e9 66 01 00 00       	jmp    800fdd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e80:	50                   	push   %eax
  800e81:	e8 3c fd ff ff       	call   800bc2 <getint>
  800e86:	83 c4 10             	add    $0x10,%esp
  800e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e95:	85 d2                	test   %edx,%edx
  800e97:	79 23                	jns    800ebc <vprintfmt+0x29b>
				putch('-', putdat);
  800e99:	83 ec 08             	sub    $0x8,%esp
  800e9c:	ff 75 0c             	pushl  0xc(%ebp)
  800e9f:	6a 2d                	push   $0x2d
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	ff d0                	call   *%eax
  800ea6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eaf:	f7 d8                	neg    %eax
  800eb1:	83 d2 00             	adc    $0x0,%edx
  800eb4:	f7 da                	neg    %edx
  800eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ebc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec3:	e9 bc 00 00 00       	jmp    800f84 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec8:	83 ec 08             	sub    $0x8,%esp
  800ecb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ece:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed1:	50                   	push   %eax
  800ed2:	e8 84 fc ff ff       	call   800b5b <getuint>
  800ed7:	83 c4 10             	add    $0x10,%esp
  800eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee7:	e9 98 00 00 00       	jmp    800f84 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eec:	83 ec 08             	sub    $0x8,%esp
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	6a 58                	push   $0x58
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	ff d0                	call   *%eax
  800ef9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efc:	83 ec 08             	sub    $0x8,%esp
  800eff:	ff 75 0c             	pushl  0xc(%ebp)
  800f02:	6a 58                	push   $0x58
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	ff d0                	call   *%eax
  800f09:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 0c             	pushl  0xc(%ebp)
  800f12:	6a 58                	push   $0x58
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	ff d0                	call   *%eax
  800f19:	83 c4 10             	add    $0x10,%esp
			break;
  800f1c:	e9 bc 00 00 00       	jmp    800fdd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f21:	83 ec 08             	sub    $0x8,%esp
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	6a 30                	push   $0x30
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	ff d0                	call   *%eax
  800f2e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f31:	83 ec 08             	sub    $0x8,%esp
  800f34:	ff 75 0c             	pushl  0xc(%ebp)
  800f37:	6a 78                	push   $0x78
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f41:	8b 45 14             	mov    0x14(%ebp),%eax
  800f44:	83 c0 04             	add    $0x4,%eax
  800f47:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4d:	83 e8 04             	sub    $0x4,%eax
  800f50:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f63:	eb 1f                	jmp    800f84 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 e8             	pushl  -0x18(%ebp)
  800f6b:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6e:	50                   	push   %eax
  800f6f:	e8 e7 fb ff ff       	call   800b5b <getuint>
  800f74:	83 c4 10             	add    $0x10,%esp
  800f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f84:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f8b:	83 ec 04             	sub    $0x4,%esp
  800f8e:	52                   	push   %edx
  800f8f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f92:	50                   	push   %eax
  800f93:	ff 75 f4             	pushl  -0xc(%ebp)
  800f96:	ff 75 f0             	pushl  -0x10(%ebp)
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	ff 75 08             	pushl  0x8(%ebp)
  800f9f:	e8 00 fb ff ff       	call   800aa4 <printnum>
  800fa4:	83 c4 20             	add    $0x20,%esp
			break;
  800fa7:	eb 34                	jmp    800fdd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa9:	83 ec 08             	sub    $0x8,%esp
  800fac:	ff 75 0c             	pushl  0xc(%ebp)
  800faf:	53                   	push   %ebx
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	ff d0                	call   *%eax
  800fb5:	83 c4 10             	add    $0x10,%esp
			break;
  800fb8:	eb 23                	jmp    800fdd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fba:	83 ec 08             	sub    $0x8,%esp
  800fbd:	ff 75 0c             	pushl  0xc(%ebp)
  800fc0:	6a 25                	push   $0x25
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fca:	ff 4d 10             	decl   0x10(%ebp)
  800fcd:	eb 03                	jmp    800fd2 <vprintfmt+0x3b1>
  800fcf:	ff 4d 10             	decl   0x10(%ebp)
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	48                   	dec    %eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	3c 25                	cmp    $0x25,%al
  800fda:	75 f3                	jne    800fcf <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fdc:	90                   	nop
		}
	}
  800fdd:	e9 47 fc ff ff       	jmp    800c29 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff3:	83 c0 04             	add    $0x4,%eax
  800ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fff:	50                   	push   %eax
  801000:	ff 75 0c             	pushl  0xc(%ebp)
  801003:	ff 75 08             	pushl  0x8(%ebp)
  801006:	e8 16 fc ff ff       	call   800c21 <vprintfmt>
  80100b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100e:	90                   	nop
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	8b 40 08             	mov    0x8(%eax),%eax
  80101a:	8d 50 01             	lea    0x1(%eax),%edx
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	8b 10                	mov    (%eax),%edx
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	8b 40 04             	mov    0x4(%eax),%eax
  80102e:	39 c2                	cmp    %eax,%edx
  801030:	73 12                	jae    801044 <sprintputch+0x33>
		*b->buf++ = ch;
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	8b 00                	mov    (%eax),%eax
  801037:	8d 48 01             	lea    0x1(%eax),%ecx
  80103a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103d:	89 0a                	mov    %ecx,(%edx)
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	88 10                	mov    %dl,(%eax)
}
  801044:	90                   	nop
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    

00801047 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	8d 50 ff             	lea    -0x1(%eax),%edx
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	01 d0                	add    %edx,%eax
  80105e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801061:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106c:	74 06                	je     801074 <vsnprintf+0x2d>
  80106e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801072:	7f 07                	jg     80107b <vsnprintf+0x34>
		return -E_INVAL;
  801074:	b8 03 00 00 00       	mov    $0x3,%eax
  801079:	eb 20                	jmp    80109b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80107b:	ff 75 14             	pushl  0x14(%ebp)
  80107e:	ff 75 10             	pushl  0x10(%ebp)
  801081:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801084:	50                   	push   %eax
  801085:	68 11 10 80 00       	push   $0x801011
  80108a:	e8 92 fb ff ff       	call   800c21 <vprintfmt>
  80108f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801095:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801098:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a6:	83 c0 04             	add    $0x4,%eax
  8010a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8010af:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b2:	50                   	push   %eax
  8010b3:	ff 75 0c             	pushl  0xc(%ebp)
  8010b6:	ff 75 08             	pushl  0x8(%ebp)
  8010b9:	e8 89 ff ff ff       	call   801047 <vsnprintf>
  8010be:	83 c4 10             	add    $0x10,%esp
  8010c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d3:	74 13                	je     8010e8 <readline+0x1f>
		cprintf("%s", prompt);
  8010d5:	83 ec 08             	sub    $0x8,%esp
  8010d8:	ff 75 08             	pushl  0x8(%ebp)
  8010db:	68 50 2b 80 00       	push   $0x802b50
  8010e0:	e8 62 f9 ff ff       	call   800a47 <cprintf>
  8010e5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ef:	83 ec 0c             	sub    $0xc,%esp
  8010f2:	6a 00                	push   $0x0
  8010f4:	e8 41 f5 ff ff       	call   80063a <iscons>
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ff:	e8 e8 f4 ff ff       	call   8005ec <getchar>
  801104:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801107:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80110b:	79 22                	jns    80112f <readline+0x66>
			if (c != -E_EOF)
  80110d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801111:	0f 84 ad 00 00 00    	je     8011c4 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 ec             	pushl  -0x14(%ebp)
  80111d:	68 53 2b 80 00       	push   $0x802b53
  801122:	e8 20 f9 ff ff       	call   800a47 <cprintf>
  801127:	83 c4 10             	add    $0x10,%esp
			return;
  80112a:	e9 95 00 00 00       	jmp    8011c4 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801133:	7e 34                	jle    801169 <readline+0xa0>
  801135:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80113c:	7f 2b                	jg     801169 <readline+0xa0>
			if (echoing)
  80113e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801142:	74 0e                	je     801152 <readline+0x89>
				cputchar(c);
  801144:	83 ec 0c             	sub    $0xc,%esp
  801147:	ff 75 ec             	pushl  -0x14(%ebp)
  80114a:	e8 55 f4 ff ff       	call   8005a4 <cputchar>
  80114f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801155:	8d 50 01             	lea    0x1(%eax),%edx
  801158:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80115b:	89 c2                	mov    %eax,%edx
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	01 d0                	add    %edx,%eax
  801162:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801165:	88 10                	mov    %dl,(%eax)
  801167:	eb 56                	jmp    8011bf <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801169:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80116d:	75 1f                	jne    80118e <readline+0xc5>
  80116f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801173:	7e 19                	jle    80118e <readline+0xc5>
			if (echoing)
  801175:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801179:	74 0e                	je     801189 <readline+0xc0>
				cputchar(c);
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	ff 75 ec             	pushl  -0x14(%ebp)
  801181:	e8 1e f4 ff ff       	call   8005a4 <cputchar>
  801186:	83 c4 10             	add    $0x10,%esp

			i--;
  801189:	ff 4d f4             	decl   -0xc(%ebp)
  80118c:	eb 31                	jmp    8011bf <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80118e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801192:	74 0a                	je     80119e <readline+0xd5>
  801194:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801198:	0f 85 61 ff ff ff    	jne    8010ff <readline+0x36>
			if (echoing)
  80119e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a2:	74 0e                	je     8011b2 <readline+0xe9>
				cputchar(c);
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8011aa:	e8 f5 f3 ff ff       	call   8005a4 <cputchar>
  8011af:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	01 d0                	add    %edx,%eax
  8011ba:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011bd:	eb 06                	jmp    8011c5 <readline+0xfc>
		}
	}
  8011bf:	e9 3b ff ff ff       	jmp    8010ff <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011c4:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011cd:	e8 1b 0b 00 00       	call   801ced <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d6:	74 13                	je     8011eb <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	ff 75 08             	pushl  0x8(%ebp)
  8011de:	68 50 2b 80 00       	push   $0x802b50
  8011e3:	e8 5f f8 ff ff       	call   800a47 <cprintf>
  8011e8:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f2:	83 ec 0c             	sub    $0xc,%esp
  8011f5:	6a 00                	push   $0x0
  8011f7:	e8 3e f4 ff ff       	call   80063a <iscons>
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801202:	e8 e5 f3 ff ff       	call   8005ec <getchar>
  801207:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80120a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120e:	79 23                	jns    801233 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801210:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801214:	74 13                	je     801229 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	ff 75 ec             	pushl  -0x14(%ebp)
  80121c:	68 53 2b 80 00       	push   $0x802b53
  801221:	e8 21 f8 ff ff       	call   800a47 <cprintf>
  801226:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801229:	e8 d9 0a 00 00       	call   801d07 <sys_enable_interrupt>
			return;
  80122e:	e9 9a 00 00 00       	jmp    8012cd <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801233:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801237:	7e 34                	jle    80126d <atomic_readline+0xa6>
  801239:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801240:	7f 2b                	jg     80126d <atomic_readline+0xa6>
			if (echoing)
  801242:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801246:	74 0e                	je     801256 <atomic_readline+0x8f>
				cputchar(c);
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	ff 75 ec             	pushl  -0x14(%ebp)
  80124e:	e8 51 f3 ff ff       	call   8005a4 <cputchar>
  801253:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125f:	89 c2                	mov    %eax,%edx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801269:	88 10                	mov    %dl,(%eax)
  80126b:	eb 5b                	jmp    8012c8 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80126d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801271:	75 1f                	jne    801292 <atomic_readline+0xcb>
  801273:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801277:	7e 19                	jle    801292 <atomic_readline+0xcb>
			if (echoing)
  801279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127d:	74 0e                	je     80128d <atomic_readline+0xc6>
				cputchar(c);
  80127f:	83 ec 0c             	sub    $0xc,%esp
  801282:	ff 75 ec             	pushl  -0x14(%ebp)
  801285:	e8 1a f3 ff ff       	call   8005a4 <cputchar>
  80128a:	83 c4 10             	add    $0x10,%esp
			i--;
  80128d:	ff 4d f4             	decl   -0xc(%ebp)
  801290:	eb 36                	jmp    8012c8 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801292:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801296:	74 0a                	je     8012a2 <atomic_readline+0xdb>
  801298:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129c:	0f 85 60 ff ff ff    	jne    801202 <atomic_readline+0x3b>
			if (echoing)
  8012a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a6:	74 0e                	je     8012b6 <atomic_readline+0xef>
				cputchar(c);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ae:	e8 f1 f2 ff ff       	call   8005a4 <cputchar>
  8012b3:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bc:	01 d0                	add    %edx,%eax
  8012be:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012c1:	e8 41 0a 00 00       	call   801d07 <sys_enable_interrupt>
			return;
  8012c6:	eb 05                	jmp    8012cd <atomic_readline+0x106>
		}
	}
  8012c8:	e9 35 ff ff ff       	jmp    801202 <atomic_readline+0x3b>
}
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012dc:	eb 06                	jmp    8012e4 <strlen+0x15>
		n++;
  8012de:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e1:	ff 45 08             	incl   0x8(%ebp)
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	75 f1                	jne    8012de <strlen+0xf>
		n++;
	return n;
  8012ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ff:	eb 09                	jmp    80130a <strnlen+0x18>
		n++;
  801301:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801304:	ff 45 08             	incl   0x8(%ebp)
  801307:	ff 4d 0c             	decl   0xc(%ebp)
  80130a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130e:	74 09                	je     801319 <strnlen+0x27>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	84 c0                	test   %al,%al
  801317:	75 e8                	jne    801301 <strnlen+0xf>
		n++;
	return n;
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80132a:	90                   	nop
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8d 50 01             	lea    0x1(%eax),%edx
  801331:	89 55 08             	mov    %edx,0x8(%ebp)
  801334:	8b 55 0c             	mov    0xc(%ebp),%edx
  801337:	8d 4a 01             	lea    0x1(%edx),%ecx
  80133a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133d:	8a 12                	mov    (%edx),%dl
  80133f:	88 10                	mov    %dl,(%eax)
  801341:	8a 00                	mov    (%eax),%al
  801343:	84 c0                	test   %al,%al
  801345:	75 e4                	jne    80132b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801347:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801358:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135f:	eb 1f                	jmp    801380 <strncpy+0x34>
		*dst++ = *src;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 08             	mov    %edx,0x8(%ebp)
  80136a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136d:	8a 12                	mov    (%edx),%dl
  80136f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	84 c0                	test   %al,%al
  801378:	74 03                	je     80137d <strncpy+0x31>
			src++;
  80137a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137d:	ff 45 fc             	incl   -0x4(%ebp)
  801380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801383:	3b 45 10             	cmp    0x10(%ebp),%eax
  801386:	72 d9                	jb     801361 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801388:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139d:	74 30                	je     8013cf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139f:	eb 16                	jmp    8013b7 <strlcpy+0x2a>
			*dst++ = *src++;
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8d 50 01             	lea    0x1(%eax),%edx
  8013a7:	89 55 08             	mov    %edx,0x8(%ebp)
  8013aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013b0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b3:	8a 12                	mov    (%edx),%dl
  8013b5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b7:	ff 4d 10             	decl   0x10(%ebp)
  8013ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013be:	74 09                	je     8013c9 <strlcpy+0x3c>
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	84 c0                	test   %al,%al
  8013c7:	75 d8                	jne    8013a1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d5:	29 c2                	sub    %eax,%edx
  8013d7:	89 d0                	mov    %edx,%eax
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013de:	eb 06                	jmp    8013e6 <strcmp+0xb>
		p++, q++;
  8013e0:	ff 45 08             	incl   0x8(%ebp)
  8013e3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	84 c0                	test   %al,%al
  8013ed:	74 0e                	je     8013fd <strcmp+0x22>
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 10                	mov    (%eax),%dl
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	38 c2                	cmp    %al,%dl
  8013fb:	74 e3                	je     8013e0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8a 00                	mov    (%eax),%al
  801402:	0f b6 d0             	movzbl %al,%edx
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	0f b6 c0             	movzbl %al,%eax
  80140d:	29 c2                	sub    %eax,%edx
  80140f:	89 d0                	mov    %edx,%eax
}
  801411:	5d                   	pop    %ebp
  801412:	c3                   	ret    

00801413 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801416:	eb 09                	jmp    801421 <strncmp+0xe>
		n--, p++, q++;
  801418:	ff 4d 10             	decl   0x10(%ebp)
  80141b:	ff 45 08             	incl   0x8(%ebp)
  80141e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801421:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801425:	74 17                	je     80143e <strncmp+0x2b>
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	84 c0                	test   %al,%al
  80142e:	74 0e                	je     80143e <strncmp+0x2b>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 10                	mov    (%eax),%dl
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	38 c2                	cmp    %al,%dl
  80143c:	74 da                	je     801418 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80143e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801442:	75 07                	jne    80144b <strncmp+0x38>
		return 0;
  801444:	b8 00 00 00 00       	mov    $0x0,%eax
  801449:	eb 14                	jmp    80145f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f b6 d0             	movzbl %al,%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	0f b6 c0             	movzbl %al,%eax
  80145b:	29 c2                	sub    %eax,%edx
  80145d:	89 d0                	mov    %edx,%eax
}
  80145f:	5d                   	pop    %ebp
  801460:	c3                   	ret    

00801461 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146d:	eb 12                	jmp    801481 <strchr+0x20>
		if (*s == c)
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801477:	75 05                	jne    80147e <strchr+0x1d>
			return (char *) s;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	eb 11                	jmp    80148f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147e:	ff 45 08             	incl   0x8(%ebp)
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	84 c0                	test   %al,%al
  801488:	75 e5                	jne    80146f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 04             	sub    $0x4,%esp
  801497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149d:	eb 0d                	jmp    8014ac <strfind+0x1b>
		if (*s == c)
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a7:	74 0e                	je     8014b7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 ea                	jne    80149f <strfind+0xe>
  8014b5:	eb 01                	jmp    8014b8 <strfind+0x27>
		if (*s == c)
			break;
  8014b7:	90                   	nop
	return (char *) s;
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014cf:	eb 0e                	jmp    8014df <memset+0x22>
		*p++ = c;
  8014d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d4:	8d 50 01             	lea    0x1(%eax),%edx
  8014d7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014dd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014df:	ff 4d f8             	decl   -0x8(%ebp)
  8014e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e6:	79 e9                	jns    8014d1 <memset+0x14>
		*p++ = c;

	return v;
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014ff:	eb 16                	jmp    801517 <memcpy+0x2a>
		*d++ = *s++;
  801501:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801504:	8d 50 01             	lea    0x1(%eax),%edx
  801507:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80150a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801510:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801513:	8a 12                	mov    (%edx),%dl
  801515:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801517:	8b 45 10             	mov    0x10(%ebp),%eax
  80151a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151d:	89 55 10             	mov    %edx,0x10(%ebp)
  801520:	85 c0                	test   %eax,%eax
  801522:	75 dd                	jne    801501 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801532:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80153b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801541:	73 50                	jae    801593 <memmove+0x6a>
  801543:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801546:	8b 45 10             	mov    0x10(%ebp),%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154e:	76 43                	jbe    801593 <memmove+0x6a>
		s += n;
  801550:	8b 45 10             	mov    0x10(%ebp),%eax
  801553:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80155c:	eb 10                	jmp    80156e <memmove+0x45>
			*--d = *--s;
  80155e:	ff 4d f8             	decl   -0x8(%ebp)
  801561:	ff 4d fc             	decl   -0x4(%ebp)
  801564:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801567:	8a 10                	mov    (%eax),%dl
  801569:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80156e:	8b 45 10             	mov    0x10(%ebp),%eax
  801571:	8d 50 ff             	lea    -0x1(%eax),%edx
  801574:	89 55 10             	mov    %edx,0x10(%ebp)
  801577:	85 c0                	test   %eax,%eax
  801579:	75 e3                	jne    80155e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80157b:	eb 23                	jmp    8015a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80157d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801580:	8d 50 01             	lea    0x1(%eax),%edx
  801583:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801586:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801589:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158f:	8a 12                	mov    (%edx),%dl
  801591:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	8d 50 ff             	lea    -0x1(%eax),%edx
  801599:	89 55 10             	mov    %edx,0x10(%ebp)
  80159c:	85 c0                	test   %eax,%eax
  80159e:	75 dd                	jne    80157d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b7:	eb 2a                	jmp    8015e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8015b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bc:	8a 10                	mov    (%eax),%dl
  8015be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	38 c2                	cmp    %al,%dl
  8015c5:	74 16                	je     8015dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	0f b6 d0             	movzbl %al,%edx
  8015cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	0f b6 c0             	movzbl %al,%eax
  8015d7:	29 c2                	sub    %eax,%edx
  8015d9:	89 d0                	mov    %edx,%eax
  8015db:	eb 18                	jmp    8015f5 <memcmp+0x50>
		s1++, s2++;
  8015dd:	ff 45 fc             	incl   -0x4(%ebp)
  8015e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	75 c9                	jne    8015b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801600:	8b 45 10             	mov    0x10(%ebp),%eax
  801603:	01 d0                	add    %edx,%eax
  801605:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801608:	eb 15                	jmp    80161f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	0f b6 d0             	movzbl %al,%edx
  801612:	8b 45 0c             	mov    0xc(%ebp),%eax
  801615:	0f b6 c0             	movzbl %al,%eax
  801618:	39 c2                	cmp    %eax,%edx
  80161a:	74 0d                	je     801629 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161c:	ff 45 08             	incl   0x8(%ebp)
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801625:	72 e3                	jb     80160a <memfind+0x13>
  801627:	eb 01                	jmp    80162a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801629:	90                   	nop
	return (void *) s;
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801635:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80163c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801643:	eb 03                	jmp    801648 <strtol+0x19>
		s++;
  801645:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8a 00                	mov    (%eax),%al
  80164d:	3c 20                	cmp    $0x20,%al
  80164f:	74 f4                	je     801645 <strtol+0x16>
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	8a 00                	mov    (%eax),%al
  801656:	3c 09                	cmp    $0x9,%al
  801658:	74 eb                	je     801645 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	3c 2b                	cmp    $0x2b,%al
  801661:	75 05                	jne    801668 <strtol+0x39>
		s++;
  801663:	ff 45 08             	incl   0x8(%ebp)
  801666:	eb 13                	jmp    80167b <strtol+0x4c>
	else if (*s == '-')
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	3c 2d                	cmp    $0x2d,%al
  80166f:	75 0a                	jne    80167b <strtol+0x4c>
		s++, neg = 1;
  801671:	ff 45 08             	incl   0x8(%ebp)
  801674:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80167b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167f:	74 06                	je     801687 <strtol+0x58>
  801681:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801685:	75 20                	jne    8016a7 <strtol+0x78>
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	8a 00                	mov    (%eax),%al
  80168c:	3c 30                	cmp    $0x30,%al
  80168e:	75 17                	jne    8016a7 <strtol+0x78>
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	40                   	inc    %eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	3c 78                	cmp    $0x78,%al
  801698:	75 0d                	jne    8016a7 <strtol+0x78>
		s += 2, base = 16;
  80169a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80169e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a5:	eb 28                	jmp    8016cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ab:	75 15                	jne    8016c2 <strtol+0x93>
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8a 00                	mov    (%eax),%al
  8016b2:	3c 30                	cmp    $0x30,%al
  8016b4:	75 0c                	jne    8016c2 <strtol+0x93>
		s++, base = 8;
  8016b6:	ff 45 08             	incl   0x8(%ebp)
  8016b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016c0:	eb 0d                	jmp    8016cf <strtol+0xa0>
	else if (base == 0)
  8016c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c6:	75 07                	jne    8016cf <strtol+0xa0>
		base = 10;
  8016c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	3c 2f                	cmp    $0x2f,%al
  8016d6:	7e 19                	jle    8016f1 <strtol+0xc2>
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	8a 00                	mov    (%eax),%al
  8016dd:	3c 39                	cmp    $0x39,%al
  8016df:	7f 10                	jg     8016f1 <strtol+0xc2>
			dig = *s - '0';
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	0f be c0             	movsbl %al,%eax
  8016e9:	83 e8 30             	sub    $0x30,%eax
  8016ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ef:	eb 42                	jmp    801733 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	8a 00                	mov    (%eax),%al
  8016f6:	3c 60                	cmp    $0x60,%al
  8016f8:	7e 19                	jle    801713 <strtol+0xe4>
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	8a 00                	mov    (%eax),%al
  8016ff:	3c 7a                	cmp    $0x7a,%al
  801701:	7f 10                	jg     801713 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	8a 00                	mov    (%eax),%al
  801708:	0f be c0             	movsbl %al,%eax
  80170b:	83 e8 57             	sub    $0x57,%eax
  80170e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801711:	eb 20                	jmp    801733 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	3c 40                	cmp    $0x40,%al
  80171a:	7e 39                	jle    801755 <strtol+0x126>
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8a 00                	mov    (%eax),%al
  801721:	3c 5a                	cmp    $0x5a,%al
  801723:	7f 30                	jg     801755 <strtol+0x126>
			dig = *s - 'A' + 10;
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	8a 00                	mov    (%eax),%al
  80172a:	0f be c0             	movsbl %al,%eax
  80172d:	83 e8 37             	sub    $0x37,%eax
  801730:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801736:	3b 45 10             	cmp    0x10(%ebp),%eax
  801739:	7d 19                	jge    801754 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801741:	0f af 45 10          	imul   0x10(%ebp),%eax
  801745:	89 c2                	mov    %eax,%edx
  801747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174a:	01 d0                	add    %edx,%eax
  80174c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174f:	e9 7b ff ff ff       	jmp    8016cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801754:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801755:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801759:	74 08                	je     801763 <strtol+0x134>
		*endptr = (char *) s;
  80175b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801763:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801767:	74 07                	je     801770 <strtol+0x141>
  801769:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176c:	f7 d8                	neg    %eax
  80176e:	eb 03                	jmp    801773 <strtol+0x144>
  801770:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <ltostr>:

void
ltostr(long value, char *str)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80177b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801782:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801789:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178d:	79 13                	jns    8017a2 <ltostr+0x2d>
	{
		neg = 1;
  80178f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801796:	8b 45 0c             	mov    0xc(%ebp),%eax
  801799:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80179c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017aa:	99                   	cltd   
  8017ab:	f7 f9                	idiv   %ecx
  8017ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b3:	8d 50 01             	lea    0x1(%eax),%edx
  8017b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b9:	89 c2                	mov    %eax,%edx
  8017bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017be:	01 d0                	add    %edx,%eax
  8017c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c3:	83 c2 30             	add    $0x30,%edx
  8017c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d0:	f7 e9                	imul   %ecx
  8017d2:	c1 fa 02             	sar    $0x2,%edx
  8017d5:	89 c8                	mov    %ecx,%eax
  8017d7:	c1 f8 1f             	sar    $0x1f,%eax
  8017da:	29 c2                	sub    %eax,%edx
  8017dc:	89 d0                	mov    %edx,%eax
  8017de:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e9:	f7 e9                	imul   %ecx
  8017eb:	c1 fa 02             	sar    $0x2,%edx
  8017ee:	89 c8                	mov    %ecx,%eax
  8017f0:	c1 f8 1f             	sar    $0x1f,%eax
  8017f3:	29 c2                	sub    %eax,%edx
  8017f5:	89 d0                	mov    %edx,%eax
  8017f7:	c1 e0 02             	shl    $0x2,%eax
  8017fa:	01 d0                	add    %edx,%eax
  8017fc:	01 c0                	add    %eax,%eax
  8017fe:	29 c1                	sub    %eax,%ecx
  801800:	89 ca                	mov    %ecx,%edx
  801802:	85 d2                	test   %edx,%edx
  801804:	75 9c                	jne    8017a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80180d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801810:	48                   	dec    %eax
  801811:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801814:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801818:	74 3d                	je     801857 <ltostr+0xe2>
		start = 1 ;
  80181a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801821:	eb 34                	jmp    801857 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	01 d0                	add    %edx,%eax
  80182b:	8a 00                	mov    (%eax),%al
  80182d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801830:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801833:	8b 45 0c             	mov    0xc(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801844:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	01 c2                	add    %eax,%edx
  80184c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184f:	88 02                	mov    %al,(%edx)
		start++ ;
  801851:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801854:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80185d:	7c c4                	jl     801823 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801862:	8b 45 0c             	mov    0xc(%ebp),%eax
  801865:	01 d0                	add    %edx,%eax
  801867:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80186a:	90                   	nop
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801873:	ff 75 08             	pushl  0x8(%ebp)
  801876:	e8 54 fa ff ff       	call   8012cf <strlen>
  80187b:	83 c4 04             	add    $0x4,%esp
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	e8 46 fa ff ff       	call   8012cf <strlen>
  801889:	83 c4 04             	add    $0x4,%esp
  80188c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801896:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80189d:	eb 17                	jmp    8018b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	01 c2                	add    %eax,%edx
  8018a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	01 c8                	add    %ecx,%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018b3:	ff 45 fc             	incl   -0x4(%ebp)
  8018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018bc:	7c e1                	jl     80189f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018cc:	eb 1f                	jmp    8018ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d1:	8d 50 01             	lea    0x1(%eax),%edx
  8018d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d7:	89 c2                	mov    %eax,%edx
  8018d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018dc:	01 c2                	add    %eax,%edx
  8018de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e4:	01 c8                	add    %ecx,%eax
  8018e6:	8a 00                	mov    (%eax),%al
  8018e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018ea:	ff 45 f8             	incl   -0x8(%ebp)
  8018ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f3:	7c d9                	jl     8018ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801906:	8b 45 14             	mov    0x14(%ebp),%eax
  801909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190f:	8b 45 14             	mov    0x14(%ebp),%eax
  801912:	8b 00                	mov    (%eax),%eax
  801914:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191b:	8b 45 10             	mov    0x10(%ebp),%eax
  80191e:	01 d0                	add    %edx,%eax
  801920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801926:	eb 0c                	jmp    801934 <strsplit+0x31>
			*string++ = 0;
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	8d 50 01             	lea    0x1(%eax),%edx
  80192e:	89 55 08             	mov    %edx,0x8(%ebp)
  801931:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	84 c0                	test   %al,%al
  80193b:	74 18                	je     801955 <strsplit+0x52>
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8a 00                	mov    (%eax),%al
  801942:	0f be c0             	movsbl %al,%eax
  801945:	50                   	push   %eax
  801946:	ff 75 0c             	pushl  0xc(%ebp)
  801949:	e8 13 fb ff ff       	call   801461 <strchr>
  80194e:	83 c4 08             	add    $0x8,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	75 d3                	jne    801928 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	84 c0                	test   %al,%al
  80195c:	74 5a                	je     8019b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80195e:	8b 45 14             	mov    0x14(%ebp),%eax
  801961:	8b 00                	mov    (%eax),%eax
  801963:	83 f8 0f             	cmp    $0xf,%eax
  801966:	75 07                	jne    80196f <strsplit+0x6c>
		{
			return 0;
  801968:	b8 00 00 00 00       	mov    $0x0,%eax
  80196d:	eb 66                	jmp    8019d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196f:	8b 45 14             	mov    0x14(%ebp),%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	8d 48 01             	lea    0x1(%eax),%ecx
  801977:	8b 55 14             	mov    0x14(%ebp),%edx
  80197a:	89 0a                	mov    %ecx,(%edx)
  80197c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801983:	8b 45 10             	mov    0x10(%ebp),%eax
  801986:	01 c2                	add    %eax,%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198d:	eb 03                	jmp    801992 <strsplit+0x8f>
			string++;
  80198f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8a 00                	mov    (%eax),%al
  801997:	84 c0                	test   %al,%al
  801999:	74 8b                	je     801926 <strsplit+0x23>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	0f be c0             	movsbl %al,%eax
  8019a3:	50                   	push   %eax
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	e8 b5 fa ff ff       	call   801461 <strchr>
  8019ac:	83 c4 08             	add    $0x8,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	74 dc                	je     80198f <strsplit+0x8c>
			string++;
	}
  8019b3:	e9 6e ff ff ff       	jmp    801926 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bc:	8b 00                	mov    (%eax),%eax
  8019be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c8:	01 d0                	add    %edx,%eax
  8019ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8019dd:	83 ec 04             	sub    $0x4,%esp
  8019e0:	68 64 2b 80 00       	push   $0x802b64
  8019e5:	6a 0e                	push   $0xe
  8019e7:	68 9e 2b 80 00       	push   $0x802b9e
  8019ec:	e8 a2 ed ff ff       	call   800793 <_panic>

008019f1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8019f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	74 0f                	je     801a0f <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801a00:	e8 d2 ff ff ff       	call   8019d7 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a05:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801a0c:	00 00 00 
	}
	if (size == 0) return NULL ;
  801a0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a13:	75 07                	jne    801a1c <malloc+0x2b>
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	eb 14                	jmp    801a30 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	68 ac 2b 80 00       	push   $0x802bac
  801a24:	6a 2e                	push   $0x2e
  801a26:	68 9e 2b 80 00       	push   $0x802b9e
  801a2b:	e8 63 ed ff ff       	call   800793 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a38:	83 ec 04             	sub    $0x4,%esp
  801a3b:	68 d4 2b 80 00       	push   $0x802bd4
  801a40:	6a 49                	push   $0x49
  801a42:	68 9e 2b 80 00       	push   $0x802b9e
  801a47:	e8 47 ed ff ff       	call   800793 <_panic>

00801a4c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 18             	sub    $0x18,%esp
  801a52:	8b 45 10             	mov    0x10(%ebp),%eax
  801a55:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	68 f8 2b 80 00       	push   $0x802bf8
  801a60:	6a 57                	push   $0x57
  801a62:	68 9e 2b 80 00       	push   $0x802b9e
  801a67:	e8 27 ed ff ff       	call   800793 <_panic>

00801a6c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	68 20 2c 80 00       	push   $0x802c20
  801a7a:	6a 60                	push   $0x60
  801a7c:	68 9e 2b 80 00       	push   $0x802b9e
  801a81:	e8 0d ed ff ff       	call   800793 <_panic>

00801a86 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 44 2c 80 00       	push   $0x802c44
  801a94:	6a 7c                	push   $0x7c
  801a96:	68 9e 2b 80 00       	push   $0x802b9e
  801a9b:	e8 f3 ec ff ff       	call   800793 <_panic>

00801aa0 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 6c 2c 80 00       	push   $0x802c6c
  801aae:	68 86 00 00 00       	push   $0x86
  801ab3:	68 9e 2b 80 00       	push   $0x802b9e
  801ab8:	e8 d6 ec ff ff       	call   800793 <_panic>

00801abd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	68 90 2c 80 00       	push   $0x802c90
  801acb:	68 91 00 00 00       	push   $0x91
  801ad0:	68 9e 2b 80 00       	push   $0x802b9e
  801ad5:	e8 b9 ec ff ff       	call   800793 <_panic>

00801ada <shrink>:

}
void shrink(uint32 newSize)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	68 90 2c 80 00       	push   $0x802c90
  801ae8:	68 96 00 00 00       	push   $0x96
  801aed:	68 9e 2b 80 00       	push   $0x802b9e
  801af2:	e8 9c ec ff ff       	call   800793 <_panic>

00801af7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	68 90 2c 80 00       	push   $0x802c90
  801b05:	68 9b 00 00 00       	push   $0x9b
  801b0a:	68 9e 2b 80 00       	push   $0x802b9e
  801b0f:	e8 7f ec ff ff       	call   800793 <_panic>

00801b14 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	57                   	push   %edi
  801b18:	56                   	push   %esi
  801b19:	53                   	push   %ebx
  801b1a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b29:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b2c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b2f:	cd 30                	int    $0x30
  801b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5f                   	pop    %edi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    

00801b3f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	8b 45 10             	mov    0x10(%ebp),%eax
  801b48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b4b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	52                   	push   %edx
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	50                   	push   %eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	e8 b2 ff ff ff       	call   801b14 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	90                   	nop
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 01                	push   $0x1
  801b77:	e8 98 ff ff ff       	call   801b14 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 05                	push   $0x5
  801b94:	e8 7b ff ff ff       	call   801b14 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	56                   	push   %esi
  801ba2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ba3:	8b 75 18             	mov    0x18(%ebp),%esi
  801ba6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	56                   	push   %esi
  801bb3:	53                   	push   %ebx
  801bb4:	51                   	push   %ecx
  801bb5:	52                   	push   %edx
  801bb6:	50                   	push   %eax
  801bb7:	6a 06                	push   $0x6
  801bb9:	e8 56 ff ff ff       	call   801b14 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    

00801bc8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	6a 07                	push   $0x7
  801bdb:	e8 34 ff ff ff       	call   801b14 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 08                	push   $0x8
  801bf6:	e8 19 ff ff ff       	call   801b14 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 09                	push   $0x9
  801c0f:	e8 00 ff ff ff       	call   801b14 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 0a                	push   $0xa
  801c28:	e8 e7 fe ff ff       	call   801b14 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 0b                	push   $0xb
  801c41:	e8 ce fe ff ff       	call   801b14 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	6a 0f                	push   $0xf
  801c5c:	e8 b3 fe ff ff       	call   801b14 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
	return;
  801c64:	90                   	nop
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	6a 10                	push   $0x10
  801c78:	e8 97 fe ff ff       	call   801b14 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c80:	90                   	nop
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	ff 75 10             	pushl  0x10(%ebp)
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 11                	push   $0x11
  801c95:	e8 7a fe ff ff       	call   801b14 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 0c                	push   $0xc
  801caf:	e8 60 fe ff ff       	call   801b14 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	6a 0d                	push   $0xd
  801cc9:	e8 46 fe ff ff       	call   801b14 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 0e                	push   $0xe
  801ce2:	e8 2d fe ff ff       	call   801b14 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	90                   	nop
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 13                	push   $0x13
  801cfc:	e8 13 fe ff ff       	call   801b14 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	90                   	nop
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 14                	push   $0x14
  801d16:	e8 f9 fd ff ff       	call   801b14 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	90                   	nop
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	50                   	push   %eax
  801d3a:	6a 15                	push   $0x15
  801d3c:	e8 d3 fd ff ff       	call   801b14 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	90                   	nop
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 16                	push   $0x16
  801d56:	e8 b9 fd ff ff       	call   801b14 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	90                   	nop
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	ff 75 0c             	pushl  0xc(%ebp)
  801d70:	50                   	push   %eax
  801d71:	6a 17                	push   $0x17
  801d73:	e8 9c fd ff ff       	call   801b14 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	52                   	push   %edx
  801d8d:	50                   	push   %eax
  801d8e:	6a 1a                	push   $0x1a
  801d90:	e8 7f fd ff ff       	call   801b14 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	6a 18                	push   $0x18
  801dad:	e8 62 fd ff ff       	call   801b14 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	90                   	nop
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	52                   	push   %edx
  801dc8:	50                   	push   %eax
  801dc9:	6a 19                	push   $0x19
  801dcb:	e8 44 fd ff ff       	call   801b14 <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
}
  801dd3:	90                   	nop
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801de2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	51                   	push   %ecx
  801def:	52                   	push   %edx
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	50                   	push   %eax
  801df4:	6a 1b                	push   $0x1b
  801df6:	e8 19 fd ff ff       	call   801b14 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	52                   	push   %edx
  801e10:	50                   	push   %eax
  801e11:	6a 1c                	push   $0x1c
  801e13:	e8 fc fc ff ff       	call   801b14 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	51                   	push   %ecx
  801e2e:	52                   	push   %edx
  801e2f:	50                   	push   %eax
  801e30:	6a 1d                	push   $0x1d
  801e32:	e8 dd fc ff ff       	call   801b14 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	52                   	push   %edx
  801e4c:	50                   	push   %eax
  801e4d:	6a 1e                	push   $0x1e
  801e4f:	e8 c0 fc ff ff       	call   801b14 <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 1f                	push   $0x1f
  801e68:	e8 a7 fc ff ff       	call   801b14 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	ff 75 14             	pushl  0x14(%ebp)
  801e7d:	ff 75 10             	pushl  0x10(%ebp)
  801e80:	ff 75 0c             	pushl  0xc(%ebp)
  801e83:	50                   	push   %eax
  801e84:	6a 20                	push   $0x20
  801e86:	e8 89 fc ff ff       	call   801b14 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	50                   	push   %eax
  801e9f:	6a 21                	push   $0x21
  801ea1:	e8 6e fc ff ff       	call   801b14 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	90                   	nop
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	50                   	push   %eax
  801ebb:	6a 22                	push   $0x22
  801ebd:	e8 52 fc ff ff       	call   801b14 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 02                	push   $0x2
  801ed6:	e8 39 fc ff ff       	call   801b14 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 03                	push   $0x3
  801eef:	e8 20 fc ff ff       	call   801b14 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 04                	push   $0x4
  801f08:	e8 07 fc ff ff       	call   801b14 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_exit_env>:


void sys_exit_env(void)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 23                	push   $0x23
  801f21:	e8 ee fb ff ff       	call   801b14 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	90                   	nop
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f35:	8d 50 04             	lea    0x4(%eax),%edx
  801f38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	52                   	push   %edx
  801f42:	50                   	push   %eax
  801f43:	6a 24                	push   $0x24
  801f45:	e8 ca fb ff ff       	call   801b14 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
	return result;
  801f4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f56:	89 01                	mov    %eax,(%ecx)
  801f58:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	c9                   	leave  
  801f5f:	c2 04 00             	ret    $0x4

00801f62 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	ff 75 10             	pushl  0x10(%ebp)
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	6a 12                	push   $0x12
  801f74:	e8 9b fb ff ff       	call   801b14 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7c:	90                   	nop
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_rcr2>:
uint32 sys_rcr2()
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 25                	push   $0x25
  801f8e:	e8 81 fb ff ff       	call   801b14 <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 04             	sub    $0x4,%esp
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fa4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	50                   	push   %eax
  801fb1:	6a 26                	push   $0x26
  801fb3:	e8 5c fb ff ff       	call   801b14 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbb:	90                   	nop
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <rsttst>:
void rsttst()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 28                	push   $0x28
  801fcd:	e8 42 fb ff ff       	call   801b14 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd5:	90                   	nop
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fe4:	8b 55 18             	mov    0x18(%ebp),%edx
  801fe7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	ff 75 10             	pushl  0x10(%ebp)
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	ff 75 08             	pushl  0x8(%ebp)
  801ff6:	6a 27                	push   $0x27
  801ff8:	e8 17 fb ff ff       	call   801b14 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
	return ;
  802000:	90                   	nop
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <chktst>:
void chktst(uint32 n)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	6a 29                	push   $0x29
  802013:	e8 fc fa ff ff       	call   801b14 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
	return ;
  80201b:	90                   	nop
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <inctst>:

void inctst()
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 2a                	push   $0x2a
  80202d:	e8 e2 fa ff ff       	call   801b14 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
	return ;
  802035:	90                   	nop
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <gettst>:
uint32 gettst()
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 2b                	push   $0x2b
  802047:	e8 c8 fa ff ff       	call   801b14 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 2c                	push   $0x2c
  802063:	e8 ac fa ff ff       	call   801b14 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
  80206b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80206e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802072:	75 07                	jne    80207b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802074:	b8 01 00 00 00       	mov    $0x1,%eax
  802079:	eb 05                	jmp    802080 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 2c                	push   $0x2c
  802094:	e8 7b fa ff ff       	call   801b14 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
  80209c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80209f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020a3:	75 07                	jne    8020ac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020aa:	eb 05                	jmp    8020b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 2c                	push   $0x2c
  8020c5:	e8 4a fa ff ff       	call   801b14 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
  8020cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020d0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020d4:	75 07                	jne    8020dd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020db:	eb 05                	jmp    8020e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 2c                	push   $0x2c
  8020f6:	e8 19 fa ff ff       	call   801b14 <syscall>
  8020fb:	83 c4 18             	add    $0x18,%esp
  8020fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802101:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802105:	75 07                	jne    80210e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802107:	b8 01 00 00 00       	mov    $0x1,%eax
  80210c:	eb 05                	jmp    802113 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	ff 75 08             	pushl  0x8(%ebp)
  802123:	6a 2d                	push   $0x2d
  802125:	e8 ea f9 ff ff       	call   801b14 <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
	return ;
  80212d:	90                   	nop
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802134:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802137:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	6a 00                	push   $0x0
  802142:	53                   	push   %ebx
  802143:	51                   	push   %ecx
  802144:	52                   	push   %edx
  802145:	50                   	push   %eax
  802146:	6a 2e                	push   $0x2e
  802148:	e8 c7 f9 ff ff       	call   801b14 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	6a 2f                	push   $0x2f
  802168:	e8 a7 f9 ff ff       	call   801b14 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    
  802172:	66 90                	xchg   %ax,%ax

00802174 <__udivdi3>:
  802174:	55                   	push   %ebp
  802175:	57                   	push   %edi
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
  802178:	83 ec 1c             	sub    $0x1c,%esp
  80217b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80217f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802187:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80218b:	89 ca                	mov    %ecx,%edx
  80218d:	89 f8                	mov    %edi,%eax
  80218f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802193:	85 f6                	test   %esi,%esi
  802195:	75 2d                	jne    8021c4 <__udivdi3+0x50>
  802197:	39 cf                	cmp    %ecx,%edi
  802199:	77 65                	ja     802200 <__udivdi3+0x8c>
  80219b:	89 fd                	mov    %edi,%ebp
  80219d:	85 ff                	test   %edi,%edi
  80219f:	75 0b                	jne    8021ac <__udivdi3+0x38>
  8021a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a6:	31 d2                	xor    %edx,%edx
  8021a8:	f7 f7                	div    %edi
  8021aa:	89 c5                	mov    %eax,%ebp
  8021ac:	31 d2                	xor    %edx,%edx
  8021ae:	89 c8                	mov    %ecx,%eax
  8021b0:	f7 f5                	div    %ebp
  8021b2:	89 c1                	mov    %eax,%ecx
  8021b4:	89 d8                	mov    %ebx,%eax
  8021b6:	f7 f5                	div    %ebp
  8021b8:	89 cf                	mov    %ecx,%edi
  8021ba:	89 fa                	mov    %edi,%edx
  8021bc:	83 c4 1c             	add    $0x1c,%esp
  8021bf:	5b                   	pop    %ebx
  8021c0:	5e                   	pop    %esi
  8021c1:	5f                   	pop    %edi
  8021c2:	5d                   	pop    %ebp
  8021c3:	c3                   	ret    
  8021c4:	39 ce                	cmp    %ecx,%esi
  8021c6:	77 28                	ja     8021f0 <__udivdi3+0x7c>
  8021c8:	0f bd fe             	bsr    %esi,%edi
  8021cb:	83 f7 1f             	xor    $0x1f,%edi
  8021ce:	75 40                	jne    802210 <__udivdi3+0x9c>
  8021d0:	39 ce                	cmp    %ecx,%esi
  8021d2:	72 0a                	jb     8021de <__udivdi3+0x6a>
  8021d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8021d8:	0f 87 9e 00 00 00    	ja     80227c <__udivdi3+0x108>
  8021de:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e3:	89 fa                	mov    %edi,%edx
  8021e5:	83 c4 1c             	add    $0x1c,%esp
  8021e8:	5b                   	pop    %ebx
  8021e9:	5e                   	pop    %esi
  8021ea:	5f                   	pop    %edi
  8021eb:	5d                   	pop    %ebp
  8021ec:	c3                   	ret    
  8021ed:	8d 76 00             	lea    0x0(%esi),%esi
  8021f0:	31 ff                	xor    %edi,%edi
  8021f2:	31 c0                	xor    %eax,%eax
  8021f4:	89 fa                	mov    %edi,%edx
  8021f6:	83 c4 1c             	add    $0x1c,%esp
  8021f9:	5b                   	pop    %ebx
  8021fa:	5e                   	pop    %esi
  8021fb:	5f                   	pop    %edi
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    
  8021fe:	66 90                	xchg   %ax,%ax
  802200:	89 d8                	mov    %ebx,%eax
  802202:	f7 f7                	div    %edi
  802204:	31 ff                	xor    %edi,%edi
  802206:	89 fa                	mov    %edi,%edx
  802208:	83 c4 1c             	add    $0x1c,%esp
  80220b:	5b                   	pop    %ebx
  80220c:	5e                   	pop    %esi
  80220d:	5f                   	pop    %edi
  80220e:	5d                   	pop    %ebp
  80220f:	c3                   	ret    
  802210:	bd 20 00 00 00       	mov    $0x20,%ebp
  802215:	89 eb                	mov    %ebp,%ebx
  802217:	29 fb                	sub    %edi,%ebx
  802219:	89 f9                	mov    %edi,%ecx
  80221b:	d3 e6                	shl    %cl,%esi
  80221d:	89 c5                	mov    %eax,%ebp
  80221f:	88 d9                	mov    %bl,%cl
  802221:	d3 ed                	shr    %cl,%ebp
  802223:	89 e9                	mov    %ebp,%ecx
  802225:	09 f1                	or     %esi,%ecx
  802227:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80222b:	89 f9                	mov    %edi,%ecx
  80222d:	d3 e0                	shl    %cl,%eax
  80222f:	89 c5                	mov    %eax,%ebp
  802231:	89 d6                	mov    %edx,%esi
  802233:	88 d9                	mov    %bl,%cl
  802235:	d3 ee                	shr    %cl,%esi
  802237:	89 f9                	mov    %edi,%ecx
  802239:	d3 e2                	shl    %cl,%edx
  80223b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80223f:	88 d9                	mov    %bl,%cl
  802241:	d3 e8                	shr    %cl,%eax
  802243:	09 c2                	or     %eax,%edx
  802245:	89 d0                	mov    %edx,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 74 24 0c          	divl   0xc(%esp)
  80224d:	89 d6                	mov    %edx,%esi
  80224f:	89 c3                	mov    %eax,%ebx
  802251:	f7 e5                	mul    %ebp
  802253:	39 d6                	cmp    %edx,%esi
  802255:	72 19                	jb     802270 <__udivdi3+0xfc>
  802257:	74 0b                	je     802264 <__udivdi3+0xf0>
  802259:	89 d8                	mov    %ebx,%eax
  80225b:	31 ff                	xor    %edi,%edi
  80225d:	e9 58 ff ff ff       	jmp    8021ba <__udivdi3+0x46>
  802262:	66 90                	xchg   %ax,%ax
  802264:	8b 54 24 08          	mov    0x8(%esp),%edx
  802268:	89 f9                	mov    %edi,%ecx
  80226a:	d3 e2                	shl    %cl,%edx
  80226c:	39 c2                	cmp    %eax,%edx
  80226e:	73 e9                	jae    802259 <__udivdi3+0xe5>
  802270:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802273:	31 ff                	xor    %edi,%edi
  802275:	e9 40 ff ff ff       	jmp    8021ba <__udivdi3+0x46>
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	e9 37 ff ff ff       	jmp    8021ba <__udivdi3+0x46>
  802283:	90                   	nop

00802284 <__umoddi3>:
  802284:	55                   	push   %ebp
  802285:	57                   	push   %edi
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
  802288:	83 ec 1c             	sub    $0x1c,%esp
  80228b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80228f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802297:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80229b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80229f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022a3:	89 f3                	mov    %esi,%ebx
  8022a5:	89 fa                	mov    %edi,%edx
  8022a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022ab:	89 34 24             	mov    %esi,(%esp)
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	75 1a                	jne    8022cc <__umoddi3+0x48>
  8022b2:	39 f7                	cmp    %esi,%edi
  8022b4:	0f 86 a2 00 00 00    	jbe    80235c <__umoddi3+0xd8>
  8022ba:	89 c8                	mov    %ecx,%eax
  8022bc:	89 f2                	mov    %esi,%edx
  8022be:	f7 f7                	div    %edi
  8022c0:	89 d0                	mov    %edx,%eax
  8022c2:	31 d2                	xor    %edx,%edx
  8022c4:	83 c4 1c             	add    $0x1c,%esp
  8022c7:	5b                   	pop    %ebx
  8022c8:	5e                   	pop    %esi
  8022c9:	5f                   	pop    %edi
  8022ca:	5d                   	pop    %ebp
  8022cb:	c3                   	ret    
  8022cc:	39 f0                	cmp    %esi,%eax
  8022ce:	0f 87 ac 00 00 00    	ja     802380 <__umoddi3+0xfc>
  8022d4:	0f bd e8             	bsr    %eax,%ebp
  8022d7:	83 f5 1f             	xor    $0x1f,%ebp
  8022da:	0f 84 ac 00 00 00    	je     80238c <__umoddi3+0x108>
  8022e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8022e5:	29 ef                	sub    %ebp,%edi
  8022e7:	89 fe                	mov    %edi,%esi
  8022e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022ed:	89 e9                	mov    %ebp,%ecx
  8022ef:	d3 e0                	shl    %cl,%eax
  8022f1:	89 d7                	mov    %edx,%edi
  8022f3:	89 f1                	mov    %esi,%ecx
  8022f5:	d3 ef                	shr    %cl,%edi
  8022f7:	09 c7                	or     %eax,%edi
  8022f9:	89 e9                	mov    %ebp,%ecx
  8022fb:	d3 e2                	shl    %cl,%edx
  8022fd:	89 14 24             	mov    %edx,(%esp)
  802300:	89 d8                	mov    %ebx,%eax
  802302:	d3 e0                	shl    %cl,%eax
  802304:	89 c2                	mov    %eax,%edx
  802306:	8b 44 24 08          	mov    0x8(%esp),%eax
  80230a:	d3 e0                	shl    %cl,%eax
  80230c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802310:	8b 44 24 08          	mov    0x8(%esp),%eax
  802314:	89 f1                	mov    %esi,%ecx
  802316:	d3 e8                	shr    %cl,%eax
  802318:	09 d0                	or     %edx,%eax
  80231a:	d3 eb                	shr    %cl,%ebx
  80231c:	89 da                	mov    %ebx,%edx
  80231e:	f7 f7                	div    %edi
  802320:	89 d3                	mov    %edx,%ebx
  802322:	f7 24 24             	mull   (%esp)
  802325:	89 c6                	mov    %eax,%esi
  802327:	89 d1                	mov    %edx,%ecx
  802329:	39 d3                	cmp    %edx,%ebx
  80232b:	0f 82 87 00 00 00    	jb     8023b8 <__umoddi3+0x134>
  802331:	0f 84 91 00 00 00    	je     8023c8 <__umoddi3+0x144>
  802337:	8b 54 24 04          	mov    0x4(%esp),%edx
  80233b:	29 f2                	sub    %esi,%edx
  80233d:	19 cb                	sbb    %ecx,%ebx
  80233f:	89 d8                	mov    %ebx,%eax
  802341:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802345:	d3 e0                	shl    %cl,%eax
  802347:	89 e9                	mov    %ebp,%ecx
  802349:	d3 ea                	shr    %cl,%edx
  80234b:	09 d0                	or     %edx,%eax
  80234d:	89 e9                	mov    %ebp,%ecx
  80234f:	d3 eb                	shr    %cl,%ebx
  802351:	89 da                	mov    %ebx,%edx
  802353:	83 c4 1c             	add    $0x1c,%esp
  802356:	5b                   	pop    %ebx
  802357:	5e                   	pop    %esi
  802358:	5f                   	pop    %edi
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    
  80235b:	90                   	nop
  80235c:	89 fd                	mov    %edi,%ebp
  80235e:	85 ff                	test   %edi,%edi
  802360:	75 0b                	jne    80236d <__umoddi3+0xe9>
  802362:	b8 01 00 00 00       	mov    $0x1,%eax
  802367:	31 d2                	xor    %edx,%edx
  802369:	f7 f7                	div    %edi
  80236b:	89 c5                	mov    %eax,%ebp
  80236d:	89 f0                	mov    %esi,%eax
  80236f:	31 d2                	xor    %edx,%edx
  802371:	f7 f5                	div    %ebp
  802373:	89 c8                	mov    %ecx,%eax
  802375:	f7 f5                	div    %ebp
  802377:	89 d0                	mov    %edx,%eax
  802379:	e9 44 ff ff ff       	jmp    8022c2 <__umoddi3+0x3e>
  80237e:	66 90                	xchg   %ax,%ax
  802380:	89 c8                	mov    %ecx,%eax
  802382:	89 f2                	mov    %esi,%edx
  802384:	83 c4 1c             	add    $0x1c,%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5f                   	pop    %edi
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    
  80238c:	3b 04 24             	cmp    (%esp),%eax
  80238f:	72 06                	jb     802397 <__umoddi3+0x113>
  802391:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802395:	77 0f                	ja     8023a6 <__umoddi3+0x122>
  802397:	89 f2                	mov    %esi,%edx
  802399:	29 f9                	sub    %edi,%ecx
  80239b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80239f:	89 14 24             	mov    %edx,(%esp)
  8023a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023aa:	8b 14 24             	mov    (%esp),%edx
  8023ad:	83 c4 1c             	add    $0x1c,%esp
  8023b0:	5b                   	pop    %ebx
  8023b1:	5e                   	pop    %esi
  8023b2:	5f                   	pop    %edi
  8023b3:	5d                   	pop    %ebp
  8023b4:	c3                   	ret    
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	2b 04 24             	sub    (%esp),%eax
  8023bb:	19 fa                	sbb    %edi,%edx
  8023bd:	89 d1                	mov    %edx,%ecx
  8023bf:	89 c6                	mov    %eax,%esi
  8023c1:	e9 71 ff ff ff       	jmp    802337 <__umoddi3+0xb3>
  8023c6:	66 90                	xchg   %ax,%ax
  8023c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8023cc:	72 ea                	jb     8023b8 <__umoddi3+0x134>
  8023ce:	89 d9                	mov    %ebx,%ecx
  8023d0:	e9 62 ff ff ff       	jmp    802337 <__umoddi3+0xb3>
