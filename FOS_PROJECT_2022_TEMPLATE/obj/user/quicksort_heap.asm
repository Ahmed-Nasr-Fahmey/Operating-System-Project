
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
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
  800041:	e8 b8 1c 00 00       	call   801cfe <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 24 80 00       	push   $0x802400
  80004e:	e8 05 0a 00 00       	call   800a58 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 24 80 00       	push   $0x802402
  80005e:	e8 f5 09 00 00       	call   800a58 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 24 80 00       	push   $0x80241b
  80006e:	e8 e5 09 00 00       	call   800a58 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 24 80 00       	push   $0x802402
  80007e:	e8 d5 09 00 00       	call   800a58 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 24 80 00       	push   $0x802400
  80008e:	e8 c5 09 00 00       	call   800a58 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 24 80 00       	push   $0x802434
  8000a5:	e8 30 10 00 00       	call   8010da <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 80 15 00 00       	call   801640 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 2d 19 00 00       	call   801a02 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 54 24 80 00       	push   $0x802454
  8000e3:	e8 70 09 00 00       	call   800a58 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 76 24 80 00       	push   $0x802476
  8000f3:	e8 60 09 00 00       	call   800a58 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 84 24 80 00       	push   $0x802484
  800103:	e8 50 09 00 00       	call   800a58 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 93 24 80 00       	push   $0x802493
  800113:	e8 40 09 00 00       	call   800a58 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 a3 24 80 00       	push   $0x8024a3
  800123:	e8 30 09 00 00       	call   800a58 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
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
  800162:	e8 b1 1b 00 00       	call   801d18 <sys_enable_interrupt>

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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 24 1b 00 00       	call   801cfe <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 24 80 00       	push   $0x8024ac
  8001e2:	e8 71 08 00 00       	call   800a58 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 29 1b 00 00       	call   801d18 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 e0 24 80 00       	push   $0x8024e0
  800211:	6a 48                	push   $0x48
  800213:	68 02 25 80 00       	push   $0x802502
  800218:	e8 87 05 00 00       	call   8007a4 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 dc 1a 00 00       	call   801cfe <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 18 25 80 00       	push   $0x802518
  80022a:	e8 29 08 00 00       	call   800a58 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 4c 25 80 00       	push   $0x80254c
  80023a:	e8 19 08 00 00       	call   800a58 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 80 25 80 00       	push   $0x802580
  80024a:	e8 09 08 00 00       	call   800a58 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 c1 1a 00 00       	call   801d18 <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 a2 1a 00 00       	call   801cfe <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 b2 25 80 00       	push   $0x8025b2
  80026a:	e8 e9 07 00 00       	call   800a58 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 63 1a 00 00       	call   801d18 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 00 24 80 00       	push   $0x802400
  80055a:	e8 f9 04 00 00       	call   800a58 <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 d0 25 80 00       	push   $0x8025d0
  80057c:	e8 d7 04 00 00       	call   800a58 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 d5 25 80 00       	push   $0x8025d5
  8005aa:	e8 a9 04 00 00       	call   800a58 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 64 17 00 00       	call   801d32 <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 1f 17 00 00       	call   801cfe <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 40 17 00 00       	call   801d32 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 1e 17 00 00       	call   801d18 <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 68 15 00 00       	call   801b79 <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 d4 16 00 00       	call   801cfe <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 41 15 00 00       	call   801b79 <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 d2 16 00 00       	call   801d18 <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 91 18 00 00       	call   801ef1 <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	01 c0                	add    %eax,%eax
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800673:	01 c8                	add    %ecx,%eax
  800675:	c1 e0 02             	shl    $0x2,%eax
  800678:	01 d0                	add    %edx,%eax
  80067a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800681:	01 c8                	add    %ecx,%eax
  800683:	c1 e0 02             	shl    $0x2,%eax
  800686:	01 d0                	add    %edx,%eax
  800688:	c1 e0 02             	shl    $0x2,%eax
  80068b:	01 d0                	add    %edx,%eax
  80068d:	c1 e0 03             	shl    $0x3,%eax
  800690:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800695:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80069a:	a1 24 30 80 00       	mov    0x803024,%eax
  80069f:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8006a5:	84 c0                	test   %al,%al
  8006a7:	74 0f                	je     8006b8 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8006a9:	a1 24 30 80 00       	mov    0x803024,%eax
  8006ae:	05 18 da 01 00       	add    $0x1da18,%eax
  8006b3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006bc:	7e 0a                	jle    8006c8 <libmain+0x73>
		binaryname = argv[0];
  8006be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	ff 75 08             	pushl  0x8(%ebp)
  8006d1:	e8 62 f9 ff ff       	call   800038 <_main>
  8006d6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d9:	e8 20 16 00 00       	call   801cfe <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006de:	83 ec 0c             	sub    $0xc,%esp
  8006e1:	68 f4 25 80 00       	push   $0x8025f4
  8006e6:	e8 6d 03 00 00       	call   800a58 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ee:	a1 24 30 80 00       	mov    0x803024,%eax
  8006f3:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8006f9:	a1 24 30 80 00       	mov    0x803024,%eax
  8006fe:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800704:	83 ec 04             	sub    $0x4,%esp
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	68 1c 26 80 00       	push   $0x80261c
  80070e:	e8 45 03 00 00       	call   800a58 <cprintf>
  800713:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800716:	a1 24 30 80 00       	mov    0x803024,%eax
  80071b:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800721:	a1 24 30 80 00       	mov    0x803024,%eax
  800726:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80072c:	a1 24 30 80 00       	mov    0x803024,%eax
  800731:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800737:	51                   	push   %ecx
  800738:	52                   	push   %edx
  800739:	50                   	push   %eax
  80073a:	68 44 26 80 00       	push   $0x802644
  80073f:	e8 14 03 00 00       	call   800a58 <cprintf>
  800744:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800747:	a1 24 30 80 00       	mov    0x803024,%eax
  80074c:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	50                   	push   %eax
  800756:	68 9c 26 80 00       	push   $0x80269c
  80075b:	e8 f8 02 00 00       	call   800a58 <cprintf>
  800760:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 f4 25 80 00       	push   $0x8025f4
  80076b:	e8 e8 02 00 00       	call   800a58 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800773:	e8 a0 15 00 00       	call   801d18 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800778:	e8 19 00 00 00       	call   800796 <exit>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800786:	83 ec 0c             	sub    $0xc,%esp
  800789:	6a 00                	push   $0x0
  80078b:	e8 2d 17 00 00       	call   801ebd <sys_destroy_env>
  800790:	83 c4 10             	add    $0x10,%esp
}
  800793:	90                   	nop
  800794:	c9                   	leave  
  800795:	c3                   	ret    

00800796 <exit>:

void
exit(void)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80079c:	e8 82 17 00 00       	call   801f23 <sys_exit_env>
}
  8007a1:	90                   	nop
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8007ad:	83 c0 04             	add    $0x4,%eax
  8007b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007b3:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8007b8:	85 c0                	test   %eax,%eax
  8007ba:	74 16                	je     8007d2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007bc:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	50                   	push   %eax
  8007c5:	68 b0 26 80 00       	push   $0x8026b0
  8007ca:	e8 89 02 00 00       	call   800a58 <cprintf>
  8007cf:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	ff 75 08             	pushl  0x8(%ebp)
  8007dd:	50                   	push   %eax
  8007de:	68 b5 26 80 00       	push   $0x8026b5
  8007e3:	e8 70 02 00 00       	call   800a58 <cprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f4:	50                   	push   %eax
  8007f5:	e8 f3 01 00 00       	call   8009ed <vcprintf>
  8007fa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	6a 00                	push   $0x0
  800802:	68 d1 26 80 00       	push   $0x8026d1
  800807:	e8 e1 01 00 00       	call   8009ed <vcprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80080f:	e8 82 ff ff ff       	call   800796 <exit>

	// should not return here
	while (1) ;
  800814:	eb fe                	jmp    800814 <_panic+0x70>

00800816 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80081c:	a1 24 30 80 00       	mov    0x803024,%eax
  800821:	8b 50 74             	mov    0x74(%eax),%edx
  800824:	8b 45 0c             	mov    0xc(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 14                	je     80083f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 d4 26 80 00       	push   $0x8026d4
  800833:	6a 26                	push   $0x26
  800835:	68 20 27 80 00       	push   $0x802720
  80083a:	e8 65 ff ff ff       	call   8007a4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80083f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800846:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80084d:	e9 c2 00 00 00       	jmp    800914 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	01 d0                	add    %edx,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	85 c0                	test   %eax,%eax
  800865:	75 08                	jne    80086f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800867:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80086a:	e9 a2 00 00 00       	jmp    800911 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80086f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800876:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80087d:	eb 69                	jmp    8008e8 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80087f:	a1 24 30 80 00       	mov    0x803024,%eax
  800884:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80088a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80088d:	89 d0                	mov    %edx,%eax
  80088f:	01 c0                	add    %eax,%eax
  800891:	01 d0                	add    %edx,%eax
  800893:	c1 e0 03             	shl    $0x3,%eax
  800896:	01 c8                	add    %ecx,%eax
  800898:	8a 40 04             	mov    0x4(%eax),%al
  80089b:	84 c0                	test   %al,%al
  80089d:	75 46                	jne    8008e5 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80089f:	a1 24 30 80 00       	mov    0x803024,%eax
  8008a4:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8008aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ad:	89 d0                	mov    %edx,%eax
  8008af:	01 c0                	add    %eax,%eax
  8008b1:	01 d0                	add    %edx,%eax
  8008b3:	c1 e0 03             	shl    $0x3,%eax
  8008b6:	01 c8                	add    %ecx,%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008c5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	01 c8                	add    %ecx,%eax
  8008d6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008d8:	39 c2                	cmp    %eax,%edx
  8008da:	75 09                	jne    8008e5 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008dc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008e3:	eb 12                	jmp    8008f7 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008e5:	ff 45 e8             	incl   -0x18(%ebp)
  8008e8:	a1 24 30 80 00       	mov    0x803024,%eax
  8008ed:	8b 50 74             	mov    0x74(%eax),%edx
  8008f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f3:	39 c2                	cmp    %eax,%edx
  8008f5:	77 88                	ja     80087f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008fb:	75 14                	jne    800911 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008fd:	83 ec 04             	sub    $0x4,%esp
  800900:	68 2c 27 80 00       	push   $0x80272c
  800905:	6a 3a                	push   $0x3a
  800907:	68 20 27 80 00       	push   $0x802720
  80090c:	e8 93 fe ff ff       	call   8007a4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800911:	ff 45 f0             	incl   -0x10(%ebp)
  800914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800917:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80091a:	0f 8c 32 ff ff ff    	jl     800852 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800920:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800927:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80092e:	eb 26                	jmp    800956 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800930:	a1 24 30 80 00       	mov    0x803024,%eax
  800935:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80093b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80093e:	89 d0                	mov    %edx,%eax
  800940:	01 c0                	add    %eax,%eax
  800942:	01 d0                	add    %edx,%eax
  800944:	c1 e0 03             	shl    $0x3,%eax
  800947:	01 c8                	add    %ecx,%eax
  800949:	8a 40 04             	mov    0x4(%eax),%al
  80094c:	3c 01                	cmp    $0x1,%al
  80094e:	75 03                	jne    800953 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800950:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800953:	ff 45 e0             	incl   -0x20(%ebp)
  800956:	a1 24 30 80 00       	mov    0x803024,%eax
  80095b:	8b 50 74             	mov    0x74(%eax),%edx
  80095e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800961:	39 c2                	cmp    %eax,%edx
  800963:	77 cb                	ja     800930 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800968:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80096b:	74 14                	je     800981 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80096d:	83 ec 04             	sub    $0x4,%esp
  800970:	68 80 27 80 00       	push   $0x802780
  800975:	6a 44                	push   $0x44
  800977:	68 20 27 80 00       	push   $0x802720
  80097c:	e8 23 fe ff ff       	call   8007a4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800981:	90                   	nop
  800982:	c9                   	leave  
  800983:	c3                   	ret    

00800984 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	8d 48 01             	lea    0x1(%eax),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
  800995:	89 0a                	mov    %ecx,(%edx)
  800997:	8b 55 08             	mov    0x8(%ebp),%edx
  80099a:	88 d1                	mov    %dl,%cl
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009ad:	75 2c                	jne    8009db <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009af:	a0 28 30 80 00       	mov    0x803028,%al
  8009b4:	0f b6 c0             	movzbl %al,%eax
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	8b 12                	mov    (%edx),%edx
  8009bc:	89 d1                	mov    %edx,%ecx
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	83 c2 08             	add    $0x8,%edx
  8009c4:	83 ec 04             	sub    $0x4,%esp
  8009c7:	50                   	push   %eax
  8009c8:	51                   	push   %ecx
  8009c9:	52                   	push   %edx
  8009ca:	e8 81 11 00 00       	call   801b50 <sys_cputs>
  8009cf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	8b 40 04             	mov    0x4(%eax),%eax
  8009e1:	8d 50 01             	lea    0x1(%eax),%edx
  8009e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009ea:	90                   	nop
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009fd:	00 00 00 
	b.cnt = 0;
  800a00:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a07:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	ff 75 08             	pushl  0x8(%ebp)
  800a10:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a16:	50                   	push   %eax
  800a17:	68 84 09 80 00       	push   $0x800984
  800a1c:	e8 11 02 00 00       	call   800c32 <vprintfmt>
  800a21:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a24:	a0 28 30 80 00       	mov    0x803028,%al
  800a29:	0f b6 c0             	movzbl %al,%eax
  800a2c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a32:	83 ec 04             	sub    $0x4,%esp
  800a35:	50                   	push   %eax
  800a36:	52                   	push   %edx
  800a37:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a3d:	83 c0 08             	add    $0x8,%eax
  800a40:	50                   	push   %eax
  800a41:	e8 0a 11 00 00       	call   801b50 <sys_cputs>
  800a46:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a49:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800a50:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a56:	c9                   	leave  
  800a57:	c3                   	ret    

00800a58 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a5e:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800a65:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	50                   	push   %eax
  800a75:	e8 73 ff ff ff       	call   8009ed <vcprintf>
  800a7a:	83 c4 10             	add    $0x10,%esp
  800a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a8b:	e8 6e 12 00 00       	call   801cfe <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a90:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	83 ec 08             	sub    $0x8,%esp
  800a9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9f:	50                   	push   %eax
  800aa0:	e8 48 ff ff ff       	call   8009ed <vcprintf>
  800aa5:	83 c4 10             	add    $0x10,%esp
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aab:	e8 68 12 00 00       	call   801d18 <sys_enable_interrupt>
	return cnt;
  800ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	53                   	push   %ebx
  800ab9:	83 ec 14             	sub    $0x14,%esp
  800abc:	8b 45 10             	mov    0x10(%ebp),%eax
  800abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ac8:	8b 45 18             	mov    0x18(%ebp),%eax
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ad3:	77 55                	ja     800b2a <printnum+0x75>
  800ad5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ad8:	72 05                	jb     800adf <printnum+0x2a>
  800ada:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800add:	77 4b                	ja     800b2a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800adf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ae2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ae5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae8:	ba 00 00 00 00       	mov    $0x0,%edx
  800aed:	52                   	push   %edx
  800aee:	50                   	push   %eax
  800aef:	ff 75 f4             	pushl  -0xc(%ebp)
  800af2:	ff 75 f0             	pushl  -0x10(%ebp)
  800af5:	e8 8a 16 00 00       	call   802184 <__udivdi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	83 ec 04             	sub    $0x4,%esp
  800b00:	ff 75 20             	pushl  0x20(%ebp)
  800b03:	53                   	push   %ebx
  800b04:	ff 75 18             	pushl  0x18(%ebp)
  800b07:	52                   	push   %edx
  800b08:	50                   	push   %eax
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 08             	pushl  0x8(%ebp)
  800b0f:	e8 a1 ff ff ff       	call   800ab5 <printnum>
  800b14:	83 c4 20             	add    $0x20,%esp
  800b17:	eb 1a                	jmp    800b33 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	ff 75 20             	pushl  0x20(%ebp)
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	ff d0                	call   *%eax
  800b27:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b2a:	ff 4d 1c             	decl   0x1c(%ebp)
  800b2d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b31:	7f e6                	jg     800b19 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b33:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b41:	53                   	push   %ebx
  800b42:	51                   	push   %ecx
  800b43:	52                   	push   %edx
  800b44:	50                   	push   %eax
  800b45:	e8 4a 17 00 00       	call   802294 <__umoddi3>
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	05 f4 29 80 00       	add    $0x8029f4,%eax
  800b52:	8a 00                	mov    (%eax),%al
  800b54:	0f be c0             	movsbl %al,%eax
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	50                   	push   %eax
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	ff d0                	call   *%eax
  800b63:	83 c4 10             	add    $0x10,%esp
}
  800b66:	90                   	nop
  800b67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b6f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b73:	7e 1c                	jle    800b91 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	8d 50 08             	lea    0x8(%eax),%edx
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	89 10                	mov    %edx,(%eax)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	83 e8 08             	sub    $0x8,%eax
  800b8a:	8b 50 04             	mov    0x4(%eax),%edx
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	eb 40                	jmp    800bd1 <getuint+0x65>
	else if (lflag)
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	74 1e                	je     800bb5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 00                	mov    (%eax),%eax
  800b9c:	8d 50 04             	lea    0x4(%eax),%edx
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	89 10                	mov    %edx,(%eax)
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	83 e8 04             	sub    $0x4,%eax
  800bac:	8b 00                	mov    (%eax),%eax
  800bae:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb3:	eb 1c                	jmp    800bd1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8b 00                	mov    (%eax),%eax
  800bba:	8d 50 04             	lea    0x4(%eax),%edx
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	89 10                	mov    %edx,(%eax)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8b 00                	mov    (%eax),%eax
  800bc7:	83 e8 04             	sub    $0x4,%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bd6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bda:	7e 1c                	jle    800bf8 <getint+0x25>
		return va_arg(*ap, long long);
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8b 00                	mov    (%eax),%eax
  800be1:	8d 50 08             	lea    0x8(%eax),%edx
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	89 10                	mov    %edx,(%eax)
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 00                	mov    (%eax),%eax
  800bee:	83 e8 08             	sub    $0x8,%eax
  800bf1:	8b 50 04             	mov    0x4(%eax),%edx
  800bf4:	8b 00                	mov    (%eax),%eax
  800bf6:	eb 38                	jmp    800c30 <getint+0x5d>
	else if (lflag)
  800bf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfc:	74 1a                	je     800c18 <getint+0x45>
		return va_arg(*ap, long);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	8d 50 04             	lea    0x4(%eax),%edx
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	89 10                	mov    %edx,(%eax)
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8b 00                	mov    (%eax),%eax
  800c10:	83 e8 04             	sub    $0x4,%eax
  800c13:	8b 00                	mov    (%eax),%eax
  800c15:	99                   	cltd   
  800c16:	eb 18                	jmp    800c30 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	8d 50 04             	lea    0x4(%eax),%edx
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	89 10                	mov    %edx,(%eax)
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8b 00                	mov    (%eax),%eax
  800c2a:	83 e8 04             	sub    $0x4,%eax
  800c2d:	8b 00                	mov    (%eax),%eax
  800c2f:	99                   	cltd   
}
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c3a:	eb 17                	jmp    800c53 <vprintfmt+0x21>
			if (ch == '\0')
  800c3c:	85 db                	test   %ebx,%ebx
  800c3e:	0f 84 af 03 00 00    	je     800ff3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c53:	8b 45 10             	mov    0x10(%ebp),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	89 55 10             	mov    %edx,0x10(%ebp)
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	0f b6 d8             	movzbl %al,%ebx
  800c61:	83 fb 25             	cmp    $0x25,%ebx
  800c64:	75 d6                	jne    800c3c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c66:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c6a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c71:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c78:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c7f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c86:	8b 45 10             	mov    0x10(%ebp),%eax
  800c89:	8d 50 01             	lea    0x1(%eax),%edx
  800c8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	0f b6 d8             	movzbl %al,%ebx
  800c94:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c97:	83 f8 55             	cmp    $0x55,%eax
  800c9a:	0f 87 2b 03 00 00    	ja     800fcb <vprintfmt+0x399>
  800ca0:	8b 04 85 18 2a 80 00 	mov    0x802a18(,%eax,4),%eax
  800ca7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cad:	eb d7                	jmp    800c86 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800caf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cb3:	eb d1                	jmp    800c86 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cbf:	89 d0                	mov    %edx,%eax
  800cc1:	c1 e0 02             	shl    $0x2,%eax
  800cc4:	01 d0                	add    %edx,%eax
  800cc6:	01 c0                	add    %eax,%eax
  800cc8:	01 d8                	add    %ebx,%eax
  800cca:	83 e8 30             	sub    $0x30,%eax
  800ccd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd8:	83 fb 2f             	cmp    $0x2f,%ebx
  800cdb:	7e 3e                	jle    800d1b <vprintfmt+0xe9>
  800cdd:	83 fb 39             	cmp    $0x39,%ebx
  800ce0:	7f 39                	jg     800d1b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce5:	eb d5                	jmp    800cbc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 e8 04             	sub    $0x4,%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cfb:	eb 1f                	jmp    800d1c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d01:	79 83                	jns    800c86 <vprintfmt+0x54>
				width = 0;
  800d03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d0a:	e9 77 ff ff ff       	jmp    800c86 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d0f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d16:	e9 6b ff ff ff       	jmp    800c86 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d1b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d20:	0f 89 60 ff ff ff    	jns    800c86 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d2c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d33:	e9 4e ff ff ff       	jmp    800c86 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d38:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d3b:	e9 46 ff ff ff       	jmp    800c86 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 c0 04             	add    $0x4,%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 e8 04             	sub    $0x4,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	83 ec 08             	sub    $0x8,%esp
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	50                   	push   %eax
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	ff d0                	call   *%eax
  800d5d:	83 c4 10             	add    $0x10,%esp
			break;
  800d60:	e9 89 02 00 00       	jmp    800fee <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 c0 04             	add    $0x4,%eax
  800d6b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d71:	83 e8 04             	sub    $0x4,%eax
  800d74:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d76:	85 db                	test   %ebx,%ebx
  800d78:	79 02                	jns    800d7c <vprintfmt+0x14a>
				err = -err;
  800d7a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d7c:	83 fb 64             	cmp    $0x64,%ebx
  800d7f:	7f 0b                	jg     800d8c <vprintfmt+0x15a>
  800d81:	8b 34 9d 60 28 80 00 	mov    0x802860(,%ebx,4),%esi
  800d88:	85 f6                	test   %esi,%esi
  800d8a:	75 19                	jne    800da5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d8c:	53                   	push   %ebx
  800d8d:	68 05 2a 80 00       	push   $0x802a05
  800d92:	ff 75 0c             	pushl  0xc(%ebp)
  800d95:	ff 75 08             	pushl  0x8(%ebp)
  800d98:	e8 5e 02 00 00       	call   800ffb <printfmt>
  800d9d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800da0:	e9 49 02 00 00       	jmp    800fee <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800da5:	56                   	push   %esi
  800da6:	68 0e 2a 80 00       	push   $0x802a0e
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	ff 75 08             	pushl  0x8(%ebp)
  800db1:	e8 45 02 00 00       	call   800ffb <printfmt>
  800db6:	83 c4 10             	add    $0x10,%esp
			break;
  800db9:	e9 30 02 00 00       	jmp    800fee <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 c0 04             	add    $0x4,%eax
  800dc4:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dca:	83 e8 04             	sub    $0x4,%eax
  800dcd:	8b 30                	mov    (%eax),%esi
  800dcf:	85 f6                	test   %esi,%esi
  800dd1:	75 05                	jne    800dd8 <vprintfmt+0x1a6>
				p = "(null)";
  800dd3:	be 11 2a 80 00       	mov    $0x802a11,%esi
			if (width > 0 && padc != '-')
  800dd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ddc:	7e 6d                	jle    800e4b <vprintfmt+0x219>
  800dde:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800de2:	74 67                	je     800e4b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	50                   	push   %eax
  800deb:	56                   	push   %esi
  800dec:	e8 12 05 00 00       	call   801303 <strnlen>
  800df1:	83 c4 10             	add    $0x10,%esp
  800df4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800df7:	eb 16                	jmp    800e0f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dfd:	83 ec 08             	sub    $0x8,%esp
  800e00:	ff 75 0c             	pushl  0xc(%ebp)
  800e03:	50                   	push   %eax
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	ff d0                	call   *%eax
  800e09:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0c:	ff 4d e4             	decl   -0x1c(%ebp)
  800e0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e13:	7f e4                	jg     800df9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e15:	eb 34                	jmp    800e4b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e17:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e1b:	74 1c                	je     800e39 <vprintfmt+0x207>
  800e1d:	83 fb 1f             	cmp    $0x1f,%ebx
  800e20:	7e 05                	jle    800e27 <vprintfmt+0x1f5>
  800e22:	83 fb 7e             	cmp    $0x7e,%ebx
  800e25:	7e 12                	jle    800e39 <vprintfmt+0x207>
					putch('?', putdat);
  800e27:	83 ec 08             	sub    $0x8,%esp
  800e2a:	ff 75 0c             	pushl  0xc(%ebp)
  800e2d:	6a 3f                	push   $0x3f
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	ff d0                	call   *%eax
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	eb 0f                	jmp    800e48 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e39:	83 ec 08             	sub    $0x8,%esp
  800e3c:	ff 75 0c             	pushl  0xc(%ebp)
  800e3f:	53                   	push   %ebx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e48:	ff 4d e4             	decl   -0x1c(%ebp)
  800e4b:	89 f0                	mov    %esi,%eax
  800e4d:	8d 70 01             	lea    0x1(%eax),%esi
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	0f be d8             	movsbl %al,%ebx
  800e55:	85 db                	test   %ebx,%ebx
  800e57:	74 24                	je     800e7d <vprintfmt+0x24b>
  800e59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5d:	78 b8                	js     800e17 <vprintfmt+0x1e5>
  800e5f:	ff 4d e0             	decl   -0x20(%ebp)
  800e62:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e66:	79 af                	jns    800e17 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e68:	eb 13                	jmp    800e7d <vprintfmt+0x24b>
				putch(' ', putdat);
  800e6a:	83 ec 08             	sub    $0x8,%esp
  800e6d:	ff 75 0c             	pushl  0xc(%ebp)
  800e70:	6a 20                	push   $0x20
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	ff d0                	call   *%eax
  800e77:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e81:	7f e7                	jg     800e6a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e83:	e9 66 01 00 00       	jmp    800fee <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e88:	83 ec 08             	sub    $0x8,%esp
  800e8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e91:	50                   	push   %eax
  800e92:	e8 3c fd ff ff       	call   800bd3 <getint>
  800e97:	83 c4 10             	add    $0x10,%esp
  800e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea6:	85 d2                	test   %edx,%edx
  800ea8:	79 23                	jns    800ecd <vprintfmt+0x29b>
				putch('-', putdat);
  800eaa:	83 ec 08             	sub    $0x8,%esp
  800ead:	ff 75 0c             	pushl  0xc(%ebp)
  800eb0:	6a 2d                	push   $0x2d
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	ff d0                	call   *%eax
  800eb7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec0:	f7 d8                	neg    %eax
  800ec2:	83 d2 00             	adc    $0x0,%edx
  800ec5:	f7 da                	neg    %edx
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed4:	e9 bc 00 00 00       	jmp    800f95 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 e8             	pushl  -0x18(%ebp)
  800edf:	8d 45 14             	lea    0x14(%ebp),%eax
  800ee2:	50                   	push   %eax
  800ee3:	e8 84 fc ff ff       	call   800b6c <getuint>
  800ee8:	83 c4 10             	add    $0x10,%esp
  800eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ef1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ef8:	e9 98 00 00 00       	jmp    800f95 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800efd:	83 ec 08             	sub    $0x8,%esp
  800f00:	ff 75 0c             	pushl  0xc(%ebp)
  800f03:	6a 58                	push   $0x58
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	ff d0                	call   *%eax
  800f0a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0d:	83 ec 08             	sub    $0x8,%esp
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	6a 58                	push   $0x58
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	ff d0                	call   *%eax
  800f1a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f1d:	83 ec 08             	sub    $0x8,%esp
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	6a 58                	push   $0x58
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	ff d0                	call   *%eax
  800f2a:	83 c4 10             	add    $0x10,%esp
			break;
  800f2d:	e9 bc 00 00 00       	jmp    800fee <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	6a 30                	push   $0x30
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	ff d0                	call   *%eax
  800f3f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	ff 75 0c             	pushl  0xc(%ebp)
  800f48:	6a 78                	push   $0x78
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	ff d0                	call   *%eax
  800f4f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 c0 04             	add    $0x4,%eax
  800f58:	89 45 14             	mov    %eax,0x14(%ebp)
  800f5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5e:	83 e8 04             	sub    $0x4,%eax
  800f61:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f6d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f74:	eb 1f                	jmp    800f95 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7c:	8d 45 14             	lea    0x14(%ebp),%eax
  800f7f:	50                   	push   %eax
  800f80:	e8 e7 fb ff ff       	call   800b6c <getuint>
  800f85:	83 c4 10             	add    $0x10,%esp
  800f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f8e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f95:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f9c:	83 ec 04             	sub    $0x4,%esp
  800f9f:	52                   	push   %edx
  800fa0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fa3:	50                   	push   %eax
  800fa4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa7:	ff 75 f0             	pushl  -0x10(%ebp)
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	ff 75 08             	pushl  0x8(%ebp)
  800fb0:	e8 00 fb ff ff       	call   800ab5 <printnum>
  800fb5:	83 c4 20             	add    $0x20,%esp
			break;
  800fb8:	eb 34                	jmp    800fee <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fba:	83 ec 08             	sub    $0x8,%esp
  800fbd:	ff 75 0c             	pushl  0xc(%ebp)
  800fc0:	53                   	push   %ebx
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			break;
  800fc9:	eb 23                	jmp    800fee <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fcb:	83 ec 08             	sub    $0x8,%esp
  800fce:	ff 75 0c             	pushl  0xc(%ebp)
  800fd1:	6a 25                	push   $0x25
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	ff d0                	call   *%eax
  800fd8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fdb:	ff 4d 10             	decl   0x10(%ebp)
  800fde:	eb 03                	jmp    800fe3 <vprintfmt+0x3b1>
  800fe0:	ff 4d 10             	decl   0x10(%ebp)
  800fe3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe6:	48                   	dec    %eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 25                	cmp    $0x25,%al
  800feb:	75 f3                	jne    800fe0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fed:	90                   	nop
		}
	}
  800fee:	e9 47 fc ff ff       	jmp    800c3a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ff3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ff4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801001:	8d 45 10             	lea    0x10(%ebp),%eax
  801004:	83 c0 04             	add    $0x4,%eax
  801007:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80100a:	8b 45 10             	mov    0x10(%ebp),%eax
  80100d:	ff 75 f4             	pushl  -0xc(%ebp)
  801010:	50                   	push   %eax
  801011:	ff 75 0c             	pushl  0xc(%ebp)
  801014:	ff 75 08             	pushl  0x8(%ebp)
  801017:	e8 16 fc ff ff       	call   800c32 <vprintfmt>
  80101c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80101f:	90                   	nop
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	8b 40 08             	mov    0x8(%eax),%eax
  80102b:	8d 50 01             	lea    0x1(%eax),%edx
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	8b 10                	mov    (%eax),%edx
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	8b 40 04             	mov    0x4(%eax),%eax
  80103f:	39 c2                	cmp    %eax,%edx
  801041:	73 12                	jae    801055 <sprintputch+0x33>
		*b->buf++ = ch;
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	8b 00                	mov    (%eax),%eax
  801048:	8d 48 01             	lea    0x1(%eax),%ecx
  80104b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104e:	89 0a                	mov    %ecx,(%edx)
  801050:	8b 55 08             	mov    0x8(%ebp),%edx
  801053:	88 10                	mov    %dl,(%eax)
}
  801055:	90                   	nop
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	01 d0                	add    %edx,%eax
  80106f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801072:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801079:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80107d:	74 06                	je     801085 <vsnprintf+0x2d>
  80107f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801083:	7f 07                	jg     80108c <vsnprintf+0x34>
		return -E_INVAL;
  801085:	b8 03 00 00 00       	mov    $0x3,%eax
  80108a:	eb 20                	jmp    8010ac <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80108c:	ff 75 14             	pushl  0x14(%ebp)
  80108f:	ff 75 10             	pushl  0x10(%ebp)
  801092:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801095:	50                   	push   %eax
  801096:	68 22 10 80 00       	push   $0x801022
  80109b:	e8 92 fb ff ff       	call   800c32 <vprintfmt>
  8010a0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010a6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8010b7:	83 c0 04             	add    $0x4,%eax
  8010ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	e8 89 ff ff ff       	call   801058 <vsnprintf>
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e4:	74 13                	je     8010f9 <readline+0x1f>
		cprintf("%s", prompt);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	ff 75 08             	pushl  0x8(%ebp)
  8010ec:	68 70 2b 80 00       	push   $0x802b70
  8010f1:	e8 62 f9 ff ff       	call   800a58 <cprintf>
  8010f6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	6a 00                	push   $0x0
  801105:	e8 41 f5 ff ff       	call   80064b <iscons>
  80110a:	83 c4 10             	add    $0x10,%esp
  80110d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801110:	e8 e8 f4 ff ff       	call   8005fd <getchar>
  801115:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801118:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80111c:	79 22                	jns    801140 <readline+0x66>
			if (c != -E_EOF)
  80111e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801122:	0f 84 ad 00 00 00    	je     8011d5 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 ec             	pushl  -0x14(%ebp)
  80112e:	68 73 2b 80 00       	push   $0x802b73
  801133:	e8 20 f9 ff ff       	call   800a58 <cprintf>
  801138:	83 c4 10             	add    $0x10,%esp
			return;
  80113b:	e9 95 00 00 00       	jmp    8011d5 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801140:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801144:	7e 34                	jle    80117a <readline+0xa0>
  801146:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80114d:	7f 2b                	jg     80117a <readline+0xa0>
			if (echoing)
  80114f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801153:	74 0e                	je     801163 <readline+0x89>
				cputchar(c);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	ff 75 ec             	pushl  -0x14(%ebp)
  80115b:	e8 55 f4 ff ff       	call   8005b5 <cputchar>
  801160:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80116c:	89 c2                	mov    %eax,%edx
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	01 d0                	add    %edx,%eax
  801173:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801176:	88 10                	mov    %dl,(%eax)
  801178:	eb 56                	jmp    8011d0 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80117a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80117e:	75 1f                	jne    80119f <readline+0xc5>
  801180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801184:	7e 19                	jle    80119f <readline+0xc5>
			if (echoing)
  801186:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118a:	74 0e                	je     80119a <readline+0xc0>
				cputchar(c);
  80118c:	83 ec 0c             	sub    $0xc,%esp
  80118f:	ff 75 ec             	pushl  -0x14(%ebp)
  801192:	e8 1e f4 ff ff       	call   8005b5 <cputchar>
  801197:	83 c4 10             	add    $0x10,%esp

			i--;
  80119a:	ff 4d f4             	decl   -0xc(%ebp)
  80119d:	eb 31                	jmp    8011d0 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80119f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011a3:	74 0a                	je     8011af <readline+0xd5>
  8011a5:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011a9:	0f 85 61 ff ff ff    	jne    801110 <readline+0x36>
			if (echoing)
  8011af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011b3:	74 0e                	je     8011c3 <readline+0xe9>
				cputchar(c);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8011bb:	e8 f5 f3 ff ff       	call   8005b5 <cputchar>
  8011c0:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	01 d0                	add    %edx,%eax
  8011cb:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011ce:	eb 06                	jmp    8011d6 <readline+0xfc>
		}
	}
  8011d0:	e9 3b ff ff ff       	jmp    801110 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011d5:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011de:	e8 1b 0b 00 00       	call   801cfe <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e7:	74 13                	je     8011fc <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	ff 75 08             	pushl  0x8(%ebp)
  8011ef:	68 70 2b 80 00       	push   $0x802b70
  8011f4:	e8 5f f8 ff ff       	call   800a58 <cprintf>
  8011f9:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801203:	83 ec 0c             	sub    $0xc,%esp
  801206:	6a 00                	push   $0x0
  801208:	e8 3e f4 ff ff       	call   80064b <iscons>
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801213:	e8 e5 f3 ff ff       	call   8005fd <getchar>
  801218:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80121b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80121f:	79 23                	jns    801244 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801221:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801225:	74 13                	je     80123a <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	ff 75 ec             	pushl  -0x14(%ebp)
  80122d:	68 73 2b 80 00       	push   $0x802b73
  801232:	e8 21 f8 ff ff       	call   800a58 <cprintf>
  801237:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80123a:	e8 d9 0a 00 00       	call   801d18 <sys_enable_interrupt>
			return;
  80123f:	e9 9a 00 00 00       	jmp    8012de <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801244:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801248:	7e 34                	jle    80127e <atomic_readline+0xa6>
  80124a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801251:	7f 2b                	jg     80127e <atomic_readline+0xa6>
			if (echoing)
  801253:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801257:	74 0e                	je     801267 <atomic_readline+0x8f>
				cputchar(c);
  801259:	83 ec 0c             	sub    $0xc,%esp
  80125c:	ff 75 ec             	pushl  -0x14(%ebp)
  80125f:	e8 51 f3 ff ff       	call   8005b5 <cputchar>
  801264:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126a:	8d 50 01             	lea    0x1(%eax),%edx
  80126d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801270:	89 c2                	mov    %eax,%edx
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80127a:	88 10                	mov    %dl,(%eax)
  80127c:	eb 5b                	jmp    8012d9 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80127e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801282:	75 1f                	jne    8012a3 <atomic_readline+0xcb>
  801284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801288:	7e 19                	jle    8012a3 <atomic_readline+0xcb>
			if (echoing)
  80128a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128e:	74 0e                	je     80129e <atomic_readline+0xc6>
				cputchar(c);
  801290:	83 ec 0c             	sub    $0xc,%esp
  801293:	ff 75 ec             	pushl  -0x14(%ebp)
  801296:	e8 1a f3 ff ff       	call   8005b5 <cputchar>
  80129b:	83 c4 10             	add    $0x10,%esp
			i--;
  80129e:	ff 4d f4             	decl   -0xc(%ebp)
  8012a1:	eb 36                	jmp    8012d9 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8012a3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012a7:	74 0a                	je     8012b3 <atomic_readline+0xdb>
  8012a9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012ad:	0f 85 60 ff ff ff    	jne    801213 <atomic_readline+0x3b>
			if (echoing)
  8012b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b7:	74 0e                	je     8012c7 <atomic_readline+0xef>
				cputchar(c);
  8012b9:	83 ec 0c             	sub    $0xc,%esp
  8012bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8012bf:	e8 f1 f2 ff ff       	call   8005b5 <cputchar>
  8012c4:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cd:	01 d0                	add    %edx,%eax
  8012cf:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012d2:	e8 41 0a 00 00       	call   801d18 <sys_enable_interrupt>
			return;
  8012d7:	eb 05                	jmp    8012de <atomic_readline+0x106>
		}
	}
  8012d9:	e9 35 ff ff ff       	jmp    801213 <atomic_readline+0x3b>
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ed:	eb 06                	jmp    8012f5 <strlen+0x15>
		n++;
  8012ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f2:	ff 45 08             	incl   0x8(%ebp)
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	84 c0                	test   %al,%al
  8012fc:	75 f1                	jne    8012ef <strlen+0xf>
		n++;
	return n;
  8012fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801309:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801310:	eb 09                	jmp    80131b <strnlen+0x18>
		n++;
  801312:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801315:	ff 45 08             	incl   0x8(%ebp)
  801318:	ff 4d 0c             	decl   0xc(%ebp)
  80131b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131f:	74 09                	je     80132a <strnlen+0x27>
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	84 c0                	test   %al,%al
  801328:	75 e8                	jne    801312 <strnlen+0xf>
		n++;
	return n;
  80132a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80133b:	90                   	nop
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8d 50 01             	lea    0x1(%eax),%edx
  801342:	89 55 08             	mov    %edx,0x8(%ebp)
  801345:	8b 55 0c             	mov    0xc(%ebp),%edx
  801348:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80134e:	8a 12                	mov    (%edx),%dl
  801350:	88 10                	mov    %dl,(%eax)
  801352:	8a 00                	mov    (%eax),%al
  801354:	84 c0                	test   %al,%al
  801356:	75 e4                	jne    80133c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801369:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801370:	eb 1f                	jmp    801391 <strncpy+0x34>
		*dst++ = *src;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8d 50 01             	lea    0x1(%eax),%edx
  801378:	89 55 08             	mov    %edx,0x8(%ebp)
  80137b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137e:	8a 12                	mov    (%edx),%dl
  801380:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801382:	8b 45 0c             	mov    0xc(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	84 c0                	test   %al,%al
  801389:	74 03                	je     80138e <strncpy+0x31>
			src++;
  80138b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80138e:	ff 45 fc             	incl   -0x4(%ebp)
  801391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801394:	3b 45 10             	cmp    0x10(%ebp),%eax
  801397:	72 d9                	jb     801372 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801399:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ae:	74 30                	je     8013e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013b0:	eb 16                	jmp    8013c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8d 50 01             	lea    0x1(%eax),%edx
  8013b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8013bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013c4:	8a 12                	mov    (%edx),%dl
  8013c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013c8:	ff 4d 10             	decl   0x10(%ebp)
  8013cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cf:	74 09                	je     8013da <strlcpy+0x3c>
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	84 c0                	test   %al,%al
  8013d8:	75 d8                	jne    8013b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e6:	29 c2                	sub    %eax,%edx
  8013e8:	89 d0                	mov    %edx,%eax
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013ef:	eb 06                	jmp    8013f7 <strcmp+0xb>
		p++, q++;
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	84 c0                	test   %al,%al
  8013fe:	74 0e                	je     80140e <strcmp+0x22>
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 10                	mov    (%eax),%dl
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	38 c2                	cmp    %al,%dl
  80140c:	74 e3                	je     8013f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	0f b6 d0             	movzbl %al,%edx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	0f b6 c0             	movzbl %al,%eax
  80141e:	29 c2                	sub    %eax,%edx
  801420:	89 d0                	mov    %edx,%eax
}
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    

00801424 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801427:	eb 09                	jmp    801432 <strncmp+0xe>
		n--, p++, q++;
  801429:	ff 4d 10             	decl   0x10(%ebp)
  80142c:	ff 45 08             	incl   0x8(%ebp)
  80142f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801432:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801436:	74 17                	je     80144f <strncmp+0x2b>
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	84 c0                	test   %al,%al
  80143f:	74 0e                	je     80144f <strncmp+0x2b>
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8a 10                	mov    (%eax),%dl
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	8a 00                	mov    (%eax),%al
  80144b:	38 c2                	cmp    %al,%dl
  80144d:	74 da                	je     801429 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80144f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801453:	75 07                	jne    80145c <strncmp+0x38>
		return 0;
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
  80145a:	eb 14                	jmp    801470 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	0f b6 d0             	movzbl %al,%edx
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	0f b6 c0             	movzbl %al,%eax
  80146c:	29 c2                	sub    %eax,%edx
  80146e:	89 d0                	mov    %edx,%eax
}
  801470:	5d                   	pop    %ebp
  801471:	c3                   	ret    

00801472 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80147e:	eb 12                	jmp    801492 <strchr+0x20>
		if (*s == c)
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	8a 00                	mov    (%eax),%al
  801485:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801488:	75 05                	jne    80148f <strchr+0x1d>
			return (char *) s;
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	eb 11                	jmp    8014a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80148f:	ff 45 08             	incl   0x8(%ebp)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	75 e5                	jne    801480 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 04             	sub    $0x4,%esp
  8014a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014ae:	eb 0d                	jmp    8014bd <strfind+0x1b>
		if (*s == c)
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014b8:	74 0e                	je     8014c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014ba:	ff 45 08             	incl   0x8(%ebp)
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	84 c0                	test   %al,%al
  8014c4:	75 ea                	jne    8014b0 <strfind+0xe>
  8014c6:	eb 01                	jmp    8014c9 <strfind+0x27>
		if (*s == c)
			break;
  8014c8:	90                   	nop
	return (char *) s;
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014da:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014e0:	eb 0e                	jmp    8014f0 <memset+0x22>
		*p++ = c;
  8014e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e5:	8d 50 01             	lea    0x1(%eax),%edx
  8014e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014f0:	ff 4d f8             	decl   -0x8(%ebp)
  8014f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014f7:	79 e9                	jns    8014e2 <memset+0x14>
		*p++ = c;

	return v;
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801510:	eb 16                	jmp    801528 <memcpy+0x2a>
		*d++ = *s++;
  801512:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801515:	8d 50 01             	lea    0x1(%eax),%edx
  801518:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80151b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801521:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801524:	8a 12                	mov    (%edx),%dl
  801526:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801528:	8b 45 10             	mov    0x10(%ebp),%eax
  80152b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152e:	89 55 10             	mov    %edx,0x10(%ebp)
  801531:	85 c0                	test   %eax,%eax
  801533:	75 dd                	jne    801512 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801552:	73 50                	jae    8015a4 <memmove+0x6a>
  801554:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	01 d0                	add    %edx,%eax
  80155c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80155f:	76 43                	jbe    8015a4 <memmove+0x6a>
		s += n;
  801561:	8b 45 10             	mov    0x10(%ebp),%eax
  801564:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80156d:	eb 10                	jmp    80157f <memmove+0x45>
			*--d = *--s;
  80156f:	ff 4d f8             	decl   -0x8(%ebp)
  801572:	ff 4d fc             	decl   -0x4(%ebp)
  801575:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801578:	8a 10                	mov    (%eax),%dl
  80157a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80157f:	8b 45 10             	mov    0x10(%ebp),%eax
  801582:	8d 50 ff             	lea    -0x1(%eax),%edx
  801585:	89 55 10             	mov    %edx,0x10(%ebp)
  801588:	85 c0                	test   %eax,%eax
  80158a:	75 e3                	jne    80156f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80158c:	eb 23                	jmp    8015b1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80158e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801591:	8d 50 01             	lea    0x1(%eax),%edx
  801594:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801597:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015a0:	8a 12                	mov    (%edx),%dl
  8015a2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	75 dd                	jne    80158e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015c8:	eb 2a                	jmp    8015f4 <memcmp+0x3e>
		if (*s1 != *s2)
  8015ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cd:	8a 10                	mov    (%eax),%dl
  8015cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	38 c2                	cmp    %al,%dl
  8015d6:	74 16                	je     8015ee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015db:	8a 00                	mov    (%eax),%al
  8015dd:	0f b6 d0             	movzbl %al,%edx
  8015e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e3:	8a 00                	mov    (%eax),%al
  8015e5:	0f b6 c0             	movzbl %al,%eax
  8015e8:	29 c2                	sub    %eax,%edx
  8015ea:	89 d0                	mov    %edx,%eax
  8015ec:	eb 18                	jmp    801606 <memcmp+0x50>
		s1++, s2++;
  8015ee:	ff 45 fc             	incl   -0x4(%ebp)
  8015f1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	75 c9                	jne    8015ca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80160e:	8b 55 08             	mov    0x8(%ebp),%edx
  801611:	8b 45 10             	mov    0x10(%ebp),%eax
  801614:	01 d0                	add    %edx,%eax
  801616:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801619:	eb 15                	jmp    801630 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	0f b6 d0             	movzbl %al,%edx
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	0f b6 c0             	movzbl %al,%eax
  801629:	39 c2                	cmp    %eax,%edx
  80162b:	74 0d                	je     80163a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80162d:	ff 45 08             	incl   0x8(%ebp)
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801636:	72 e3                	jb     80161b <memfind+0x13>
  801638:	eb 01                	jmp    80163b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80163a:	90                   	nop
	return (void *) s;
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80164d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801654:	eb 03                	jmp    801659 <strtol+0x19>
		s++;
  801656:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8a 00                	mov    (%eax),%al
  80165e:	3c 20                	cmp    $0x20,%al
  801660:	74 f4                	je     801656 <strtol+0x16>
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 09                	cmp    $0x9,%al
  801669:	74 eb                	je     801656 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 2b                	cmp    $0x2b,%al
  801672:	75 05                	jne    801679 <strtol+0x39>
		s++;
  801674:	ff 45 08             	incl   0x8(%ebp)
  801677:	eb 13                	jmp    80168c <strtol+0x4c>
	else if (*s == '-')
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	8a 00                	mov    (%eax),%al
  80167e:	3c 2d                	cmp    $0x2d,%al
  801680:	75 0a                	jne    80168c <strtol+0x4c>
		s++, neg = 1;
  801682:	ff 45 08             	incl   0x8(%ebp)
  801685:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80168c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801690:	74 06                	je     801698 <strtol+0x58>
  801692:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801696:	75 20                	jne    8016b8 <strtol+0x78>
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	3c 30                	cmp    $0x30,%al
  80169f:	75 17                	jne    8016b8 <strtol+0x78>
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	40                   	inc    %eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	3c 78                	cmp    $0x78,%al
  8016a9:	75 0d                	jne    8016b8 <strtol+0x78>
		s += 2, base = 16;
  8016ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016b6:	eb 28                	jmp    8016e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016bc:	75 15                	jne    8016d3 <strtol+0x93>
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	3c 30                	cmp    $0x30,%al
  8016c5:	75 0c                	jne    8016d3 <strtol+0x93>
		s++, base = 8;
  8016c7:	ff 45 08             	incl   0x8(%ebp)
  8016ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016d1:	eb 0d                	jmp    8016e0 <strtol+0xa0>
	else if (base == 0)
  8016d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d7:	75 07                	jne    8016e0 <strtol+0xa0>
		base = 10;
  8016d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	3c 2f                	cmp    $0x2f,%al
  8016e7:	7e 19                	jle    801702 <strtol+0xc2>
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8a 00                	mov    (%eax),%al
  8016ee:	3c 39                	cmp    $0x39,%al
  8016f0:	7f 10                	jg     801702 <strtol+0xc2>
			dig = *s - '0';
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8a 00                	mov    (%eax),%al
  8016f7:	0f be c0             	movsbl %al,%eax
  8016fa:	83 e8 30             	sub    $0x30,%eax
  8016fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801700:	eb 42                	jmp    801744 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 60                	cmp    $0x60,%al
  801709:	7e 19                	jle    801724 <strtol+0xe4>
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	3c 7a                	cmp    $0x7a,%al
  801712:	7f 10                	jg     801724 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f be c0             	movsbl %al,%eax
  80171c:	83 e8 57             	sub    $0x57,%eax
  80171f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801722:	eb 20                	jmp    801744 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	8a 00                	mov    (%eax),%al
  801729:	3c 40                	cmp    $0x40,%al
  80172b:	7e 39                	jle    801766 <strtol+0x126>
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	8a 00                	mov    (%eax),%al
  801732:	3c 5a                	cmp    $0x5a,%al
  801734:	7f 30                	jg     801766 <strtol+0x126>
			dig = *s - 'A' + 10;
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	0f be c0             	movsbl %al,%eax
  80173e:	83 e8 37             	sub    $0x37,%eax
  801741:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801747:	3b 45 10             	cmp    0x10(%ebp),%eax
  80174a:	7d 19                	jge    801765 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80174c:	ff 45 08             	incl   0x8(%ebp)
  80174f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801752:	0f af 45 10          	imul   0x10(%ebp),%eax
  801756:	89 c2                	mov    %eax,%edx
  801758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175b:	01 d0                	add    %edx,%eax
  80175d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801760:	e9 7b ff ff ff       	jmp    8016e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801765:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801766:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176a:	74 08                	je     801774 <strtol+0x134>
		*endptr = (char *) s;
  80176c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176f:	8b 55 08             	mov    0x8(%ebp),%edx
  801772:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801774:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801778:	74 07                	je     801781 <strtol+0x141>
  80177a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177d:	f7 d8                	neg    %eax
  80177f:	eb 03                	jmp    801784 <strtol+0x144>
  801781:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <ltostr>:

void
ltostr(long value, char *str)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80178c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801793:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80179a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179e:	79 13                	jns    8017b3 <ltostr+0x2d>
	{
		neg = 1;
  8017a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017bb:	99                   	cltd   
  8017bc:	f7 f9                	idiv   %ecx
  8017be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c4:	8d 50 01             	lea    0x1(%eax),%edx
  8017c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ca:	89 c2                	mov    %eax,%edx
  8017cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cf:	01 d0                	add    %edx,%eax
  8017d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017d4:	83 c2 30             	add    $0x30,%edx
  8017d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e1:	f7 e9                	imul   %ecx
  8017e3:	c1 fa 02             	sar    $0x2,%edx
  8017e6:	89 c8                	mov    %ecx,%eax
  8017e8:	c1 f8 1f             	sar    $0x1f,%eax
  8017eb:	29 c2                	sub    %eax,%edx
  8017ed:	89 d0                	mov    %edx,%eax
  8017ef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017fa:	f7 e9                	imul   %ecx
  8017fc:	c1 fa 02             	sar    $0x2,%edx
  8017ff:	89 c8                	mov    %ecx,%eax
  801801:	c1 f8 1f             	sar    $0x1f,%eax
  801804:	29 c2                	sub    %eax,%edx
  801806:	89 d0                	mov    %edx,%eax
  801808:	c1 e0 02             	shl    $0x2,%eax
  80180b:	01 d0                	add    %edx,%eax
  80180d:	01 c0                	add    %eax,%eax
  80180f:	29 c1                	sub    %eax,%ecx
  801811:	89 ca                	mov    %ecx,%edx
  801813:	85 d2                	test   %edx,%edx
  801815:	75 9c                	jne    8017b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801817:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80181e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801821:	48                   	dec    %eax
  801822:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801825:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801829:	74 3d                	je     801868 <ltostr+0xe2>
		start = 1 ;
  80182b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801832:	eb 34                	jmp    801868 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183a:	01 d0                	add    %edx,%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801844:	8b 45 0c             	mov    0xc(%ebp),%eax
  801847:	01 c2                	add    %eax,%edx
  801849:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80184c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184f:	01 c8                	add    %ecx,%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801855:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185b:	01 c2                	add    %eax,%edx
  80185d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801860:	88 02                	mov    %al,(%edx)
		start++ ;
  801862:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801865:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80186e:	7c c4                	jl     801834 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801870:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	01 d0                	add    %edx,%eax
  801878:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80187b:	90                   	nop
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	e8 54 fa ff ff       	call   8012e0 <strlen>
  80188c:	83 c4 04             	add    $0x4,%esp
  80188f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	e8 46 fa ff ff       	call   8012e0 <strlen>
  80189a:	83 c4 04             	add    $0x4,%esp
  80189d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ae:	eb 17                	jmp    8018c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8018b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b6:	01 c2                	add    %eax,%edx
  8018b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	01 c8                	add    %ecx,%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018c4:	ff 45 fc             	incl   -0x4(%ebp)
  8018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018cd:	7c e1                	jl     8018b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018dd:	eb 1f                	jmp    8018fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e2:	8d 50 01             	lea    0x1(%eax),%edx
  8018e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018e8:	89 c2                	mov    %eax,%edx
  8018ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ed:	01 c2                	add    %eax,%edx
  8018ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f5:	01 c8                	add    %ecx,%eax
  8018f7:	8a 00                	mov    (%eax),%al
  8018f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018fb:	ff 45 f8             	incl   -0x8(%ebp)
  8018fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801901:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801904:	7c d9                	jl     8018df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801906:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801909:	8b 45 10             	mov    0x10(%ebp),%eax
  80190c:	01 d0                	add    %edx,%eax
  80190e:	c6 00 00             	movb   $0x0,(%eax)
}
  801911:	90                   	nop
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801917:	8b 45 14             	mov    0x14(%ebp),%eax
  80191a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801920:	8b 45 14             	mov    0x14(%ebp),%eax
  801923:	8b 00                	mov    (%eax),%eax
  801925:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80192c:	8b 45 10             	mov    0x10(%ebp),%eax
  80192f:	01 d0                	add    %edx,%eax
  801931:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801937:	eb 0c                	jmp    801945 <strsplit+0x31>
			*string++ = 0;
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	8d 50 01             	lea    0x1(%eax),%edx
  80193f:	89 55 08             	mov    %edx,0x8(%ebp)
  801942:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	8a 00                	mov    (%eax),%al
  80194a:	84 c0                	test   %al,%al
  80194c:	74 18                	je     801966 <strsplit+0x52>
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	8a 00                	mov    (%eax),%al
  801953:	0f be c0             	movsbl %al,%eax
  801956:	50                   	push   %eax
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	e8 13 fb ff ff       	call   801472 <strchr>
  80195f:	83 c4 08             	add    $0x8,%esp
  801962:	85 c0                	test   %eax,%eax
  801964:	75 d3                	jne    801939 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	8a 00                	mov    (%eax),%al
  80196b:	84 c0                	test   %al,%al
  80196d:	74 5a                	je     8019c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80196f:	8b 45 14             	mov    0x14(%ebp),%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	83 f8 0f             	cmp    $0xf,%eax
  801977:	75 07                	jne    801980 <strsplit+0x6c>
		{
			return 0;
  801979:	b8 00 00 00 00       	mov    $0x0,%eax
  80197e:	eb 66                	jmp    8019e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801980:	8b 45 14             	mov    0x14(%ebp),%eax
  801983:	8b 00                	mov    (%eax),%eax
  801985:	8d 48 01             	lea    0x1(%eax),%ecx
  801988:	8b 55 14             	mov    0x14(%ebp),%edx
  80198b:	89 0a                	mov    %ecx,(%edx)
  80198d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801994:	8b 45 10             	mov    0x10(%ebp),%eax
  801997:	01 c2                	add    %eax,%edx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80199e:	eb 03                	jmp    8019a3 <strsplit+0x8f>
			string++;
  8019a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	8a 00                	mov    (%eax),%al
  8019a8:	84 c0                	test   %al,%al
  8019aa:	74 8b                	je     801937 <strsplit+0x23>
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	0f be c0             	movsbl %al,%eax
  8019b4:	50                   	push   %eax
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	e8 b5 fa ff ff       	call   801472 <strchr>
  8019bd:	83 c4 08             	add    $0x8,%esp
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	74 dc                	je     8019a0 <strsplit+0x8c>
			string++;
	}
  8019c4:	e9 6e ff ff ff       	jmp    801937 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cd:	8b 00                	mov    (%eax),%eax
  8019cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d9:	01 d0                	add    %edx,%eax
  8019db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	68 84 2b 80 00       	push   $0x802b84
  8019f6:	6a 0e                	push   $0xe
  8019f8:	68 be 2b 80 00       	push   $0x802bbe
  8019fd:	e8 a2 ed ff ff       	call   8007a4 <_panic>

00801a02 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801a08:	a1 04 30 80 00       	mov    0x803004,%eax
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	74 0f                	je     801a20 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801a11:	e8 d2 ff ff ff       	call   8019e8 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a16:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801a1d:	00 00 00 
	}
	if (size == 0) return NULL ;
  801a20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a24:	75 07                	jne    801a2d <malloc+0x2b>
  801a26:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2b:	eb 14                	jmp    801a41 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	68 cc 2b 80 00       	push   $0x802bcc
  801a35:	6a 2e                	push   $0x2e
  801a37:	68 be 2b 80 00       	push   $0x802bbe
  801a3c:	e8 63 ed ff ff       	call   8007a4 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 f4 2b 80 00       	push   $0x802bf4
  801a51:	6a 49                	push   $0x49
  801a53:	68 be 2b 80 00       	push   $0x802bbe
  801a58:	e8 47 ed ff ff       	call   8007a4 <_panic>

00801a5d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 18             	sub    $0x18,%esp
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 18 2c 80 00       	push   $0x802c18
  801a71:	6a 57                	push   $0x57
  801a73:	68 be 2b 80 00       	push   $0x802bbe
  801a78:	e8 27 ed ff ff       	call   8007a4 <_panic>

00801a7d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 40 2c 80 00       	push   $0x802c40
  801a8b:	6a 60                	push   $0x60
  801a8d:	68 be 2b 80 00       	push   $0x802bbe
  801a92:	e8 0d ed ff ff       	call   8007a4 <_panic>

00801a97 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	68 64 2c 80 00       	push   $0x802c64
  801aa5:	6a 7c                	push   $0x7c
  801aa7:	68 be 2b 80 00       	push   $0x802bbe
  801aac:	e8 f3 ec ff ff       	call   8007a4 <_panic>

00801ab1 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	68 8c 2c 80 00       	push   $0x802c8c
  801abf:	68 86 00 00 00       	push   $0x86
  801ac4:	68 be 2b 80 00       	push   $0x802bbe
  801ac9:	e8 d6 ec ff ff       	call   8007a4 <_panic>

00801ace <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	68 b0 2c 80 00       	push   $0x802cb0
  801adc:	68 91 00 00 00       	push   $0x91
  801ae1:	68 be 2b 80 00       	push   $0x802bbe
  801ae6:	e8 b9 ec ff ff       	call   8007a4 <_panic>

00801aeb <shrink>:

}
void shrink(uint32 newSize)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801af1:	83 ec 04             	sub    $0x4,%esp
  801af4:	68 b0 2c 80 00       	push   $0x802cb0
  801af9:	68 96 00 00 00       	push   $0x96
  801afe:	68 be 2b 80 00       	push   $0x802bbe
  801b03:	e8 9c ec ff ff       	call   8007a4 <_panic>

00801b08 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	68 b0 2c 80 00       	push   $0x802cb0
  801b16:	68 9b 00 00 00       	push   $0x9b
  801b1b:	68 be 2b 80 00       	push   $0x802bbe
  801b20:	e8 7f ec ff ff       	call   8007a4 <_panic>

00801b25 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	57                   	push   %edi
  801b29:	56                   	push   %esi
  801b2a:	53                   	push   %ebx
  801b2b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b37:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b3a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b3d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b40:	cd 30                	int    $0x30
  801b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	5b                   	pop    %ebx
  801b4c:	5e                   	pop    %esi
  801b4d:	5f                   	pop    %edi
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 04             	sub    $0x4,%esp
  801b56:	8b 45 10             	mov    0x10(%ebp),%eax
  801b59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b5c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	52                   	push   %edx
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	50                   	push   %eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	e8 b2 ff ff ff       	call   801b25 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	90                   	nop
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 01                	push   $0x1
  801b88:	e8 98 ff ff ff       	call   801b25 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 05                	push   $0x5
  801ba5:	e8 7b ff ff ff       	call   801b25 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	56                   	push   %esi
  801bb3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bb4:	8b 75 18             	mov    0x18(%ebp),%esi
  801bb7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	51                   	push   %ecx
  801bc6:	52                   	push   %edx
  801bc7:	50                   	push   %eax
  801bc8:	6a 06                	push   $0x6
  801bca:	e8 56 ff ff ff       	call   801b25 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd5:	5b                   	pop    %ebx
  801bd6:	5e                   	pop    %esi
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    

00801bd9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	52                   	push   %edx
  801be9:	50                   	push   %eax
  801bea:	6a 07                	push   $0x7
  801bec:	e8 34 ff ff ff       	call   801b25 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	6a 08                	push   $0x8
  801c07:	e8 19 ff ff ff       	call   801b25 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 09                	push   $0x9
  801c20:	e8 00 ff ff ff       	call   801b25 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 0a                	push   $0xa
  801c39:	e8 e7 fe ff ff       	call   801b25 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 0b                	push   $0xb
  801c52:	e8 ce fe ff ff       	call   801b25 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 0c             	pushl  0xc(%ebp)
  801c68:	ff 75 08             	pushl  0x8(%ebp)
  801c6b:	6a 0f                	push   $0xf
  801c6d:	e8 b3 fe ff ff       	call   801b25 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
	return;
  801c75:	90                   	nop
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	ff 75 0c             	pushl  0xc(%ebp)
  801c84:	ff 75 08             	pushl  0x8(%ebp)
  801c87:	6a 10                	push   $0x10
  801c89:	e8 97 fe ff ff       	call   801b25 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c91:	90                   	nop
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	ff 75 10             	pushl  0x10(%ebp)
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	ff 75 08             	pushl  0x8(%ebp)
  801ca4:	6a 11                	push   $0x11
  801ca6:	e8 7a fe ff ff       	call   801b25 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
	return ;
  801cae:	90                   	nop
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 0c                	push   $0xc
  801cc0:	e8 60 fe ff ff       	call   801b25 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	6a 0d                	push   $0xd
  801cda:	e8 46 fe ff ff       	call   801b25 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 0e                	push   $0xe
  801cf3:	e8 2d fe ff ff       	call   801b25 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	90                   	nop
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 13                	push   $0x13
  801d0d:	e8 13 fe ff ff       	call   801b25 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	90                   	nop
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 14                	push   $0x14
  801d27:	e8 f9 fd ff ff       	call   801b25 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	90                   	nop
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 04             	sub    $0x4,%esp
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d3e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	50                   	push   %eax
  801d4b:	6a 15                	push   $0x15
  801d4d:	e8 d3 fd ff ff       	call   801b25 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	90                   	nop
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 16                	push   $0x16
  801d67:	e8 b9 fd ff ff       	call   801b25 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	90                   	nop
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	ff 75 0c             	pushl  0xc(%ebp)
  801d81:	50                   	push   %eax
  801d82:	6a 17                	push   $0x17
  801d84:	e8 9c fd ff ff       	call   801b25 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	6a 1a                	push   $0x1a
  801da1:	e8 7f fd ff ff       	call   801b25 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	52                   	push   %edx
  801dbb:	50                   	push   %eax
  801dbc:	6a 18                	push   $0x18
  801dbe:	e8 62 fd ff ff       	call   801b25 <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
}
  801dc6:	90                   	nop
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	6a 19                	push   $0x19
  801ddc:	e8 44 fd ff ff       	call   801b25 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	90                   	nop
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 04             	sub    $0x4,%esp
  801ded:	8b 45 10             	mov    0x10(%ebp),%eax
  801df0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801df3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801df6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	6a 00                	push   $0x0
  801dff:	51                   	push   %ecx
  801e00:	52                   	push   %edx
  801e01:	ff 75 0c             	pushl  0xc(%ebp)
  801e04:	50                   	push   %eax
  801e05:	6a 1b                	push   $0x1b
  801e07:	e8 19 fd ff ff       	call   801b25 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	52                   	push   %edx
  801e21:	50                   	push   %eax
  801e22:	6a 1c                	push   $0x1c
  801e24:	e8 fc fc ff ff       	call   801b25 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	51                   	push   %ecx
  801e3f:	52                   	push   %edx
  801e40:	50                   	push   %eax
  801e41:	6a 1d                	push   $0x1d
  801e43:	e8 dd fc ff ff       	call   801b25 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	52                   	push   %edx
  801e5d:	50                   	push   %eax
  801e5e:	6a 1e                	push   $0x1e
  801e60:	e8 c0 fc ff ff       	call   801b25 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 1f                	push   $0x1f
  801e79:	e8 a7 fc ff ff       	call   801b25 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	6a 00                	push   $0x0
  801e8b:	ff 75 14             	pushl  0x14(%ebp)
  801e8e:	ff 75 10             	pushl  0x10(%ebp)
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	50                   	push   %eax
  801e95:	6a 20                	push   $0x20
  801e97:	e8 89 fc ff ff       	call   801b25 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	50                   	push   %eax
  801eb0:	6a 21                	push   $0x21
  801eb2:	e8 6e fc ff ff       	call   801b25 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
}
  801eba:	90                   	nop
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	50                   	push   %eax
  801ecc:	6a 22                	push   $0x22
  801ece:	e8 52 fc ff ff       	call   801b25 <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 02                	push   $0x2
  801ee7:	e8 39 fc ff ff       	call   801b25 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 03                	push   $0x3
  801f00:	e8 20 fc ff ff       	call   801b25 <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 04                	push   $0x4
  801f19:	e8 07 fc ff ff       	call   801b25 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_exit_env>:


void sys_exit_env(void)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 23                	push   $0x23
  801f32:	e8 ee fb ff ff       	call   801b25 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	90                   	nop
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f43:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f46:	8d 50 04             	lea    0x4(%eax),%edx
  801f49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	52                   	push   %edx
  801f53:	50                   	push   %eax
  801f54:	6a 24                	push   $0x24
  801f56:	e8 ca fb ff ff       	call   801b25 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
	return result;
  801f5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f67:	89 01                	mov    %eax,(%ecx)
  801f69:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	c9                   	leave  
  801f70:	c2 04 00             	ret    $0x4

00801f73 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	ff 75 10             	pushl  0x10(%ebp)
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	6a 12                	push   $0x12
  801f85:	e8 9b fb ff ff       	call   801b25 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8d:	90                   	nop
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 25                	push   $0x25
  801f9f:	e8 81 fb ff ff       	call   801b25 <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fb5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	50                   	push   %eax
  801fc2:	6a 26                	push   $0x26
  801fc4:	e8 5c fb ff ff       	call   801b25 <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcc:	90                   	nop
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <rsttst>:
void rsttst()
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 28                	push   $0x28
  801fde:	e8 42 fb ff ff       	call   801b25 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe6:	90                   	nop
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ff5:	8b 55 18             	mov    0x18(%ebp),%edx
  801ff8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ffc:	52                   	push   %edx
  801ffd:	50                   	push   %eax
  801ffe:	ff 75 10             	pushl  0x10(%ebp)
  802001:	ff 75 0c             	pushl  0xc(%ebp)
  802004:	ff 75 08             	pushl  0x8(%ebp)
  802007:	6a 27                	push   $0x27
  802009:	e8 17 fb ff ff       	call   801b25 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
	return ;
  802011:	90                   	nop
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <chktst>:
void chktst(uint32 n)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	ff 75 08             	pushl  0x8(%ebp)
  802022:	6a 29                	push   $0x29
  802024:	e8 fc fa ff ff       	call   801b25 <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
	return ;
  80202c:	90                   	nop
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <inctst>:

void inctst()
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 2a                	push   $0x2a
  80203e:	e8 e2 fa ff ff       	call   801b25 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
	return ;
  802046:	90                   	nop
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <gettst>:
uint32 gettst()
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 2b                	push   $0x2b
  802058:	e8 c8 fa ff ff       	call   801b25 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 2c                	push   $0x2c
  802074:	e8 ac fa ff ff       	call   801b25 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
  80207c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80207f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802083:	75 07                	jne    80208c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802085:	b8 01 00 00 00       	mov    $0x1,%eax
  80208a:	eb 05                	jmp    802091 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 2c                	push   $0x2c
  8020a5:	e8 7b fa ff ff       	call   801b25 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
  8020ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020b0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020b4:	75 07                	jne    8020bd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bb:	eb 05                	jmp    8020c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 2c                	push   $0x2c
  8020d6:	e8 4a fa ff ff       	call   801b25 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
  8020de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020e1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020e5:	75 07                	jne    8020ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ec:	eb 05                	jmp    8020f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 2c                	push   $0x2c
  802107:	e8 19 fa ff ff       	call   801b25 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
  80210f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802112:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802116:	75 07                	jne    80211f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802118:	b8 01 00 00 00       	mov    $0x1,%eax
  80211d:	eb 05                	jmp    802124 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	6a 2d                	push   $0x2d
  802136:	e8 ea f9 ff ff       	call   801b25 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
	return ;
  80213e:	90                   	nop
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802145:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802148:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80214b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	53                   	push   %ebx
  802154:	51                   	push   %ecx
  802155:	52                   	push   %edx
  802156:	50                   	push   %eax
  802157:	6a 2e                	push   $0x2e
  802159:	e8 c7 f9 ff ff       	call   801b25 <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	52                   	push   %edx
  802176:	50                   	push   %eax
  802177:	6a 2f                	push   $0x2f
  802179:	e8 a7 f9 ff ff       	call   801b25 <syscall>
  80217e:	83 c4 18             	add    $0x18,%esp
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    
  802183:	90                   	nop

00802184 <__udivdi3>:
  802184:	55                   	push   %ebp
  802185:	57                   	push   %edi
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	83 ec 1c             	sub    $0x1c,%esp
  80218b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80218f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802197:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80219b:	89 ca                	mov    %ecx,%edx
  80219d:	89 f8                	mov    %edi,%eax
  80219f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021a3:	85 f6                	test   %esi,%esi
  8021a5:	75 2d                	jne    8021d4 <__udivdi3+0x50>
  8021a7:	39 cf                	cmp    %ecx,%edi
  8021a9:	77 65                	ja     802210 <__udivdi3+0x8c>
  8021ab:	89 fd                	mov    %edi,%ebp
  8021ad:	85 ff                	test   %edi,%edi
  8021af:	75 0b                	jne    8021bc <__udivdi3+0x38>
  8021b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b6:	31 d2                	xor    %edx,%edx
  8021b8:	f7 f7                	div    %edi
  8021ba:	89 c5                	mov    %eax,%ebp
  8021bc:	31 d2                	xor    %edx,%edx
  8021be:	89 c8                	mov    %ecx,%eax
  8021c0:	f7 f5                	div    %ebp
  8021c2:	89 c1                	mov    %eax,%ecx
  8021c4:	89 d8                	mov    %ebx,%eax
  8021c6:	f7 f5                	div    %ebp
  8021c8:	89 cf                	mov    %ecx,%edi
  8021ca:	89 fa                	mov    %edi,%edx
  8021cc:	83 c4 1c             	add    $0x1c,%esp
  8021cf:	5b                   	pop    %ebx
  8021d0:	5e                   	pop    %esi
  8021d1:	5f                   	pop    %edi
  8021d2:	5d                   	pop    %ebp
  8021d3:	c3                   	ret    
  8021d4:	39 ce                	cmp    %ecx,%esi
  8021d6:	77 28                	ja     802200 <__udivdi3+0x7c>
  8021d8:	0f bd fe             	bsr    %esi,%edi
  8021db:	83 f7 1f             	xor    $0x1f,%edi
  8021de:	75 40                	jne    802220 <__udivdi3+0x9c>
  8021e0:	39 ce                	cmp    %ecx,%esi
  8021e2:	72 0a                	jb     8021ee <__udivdi3+0x6a>
  8021e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8021e8:	0f 87 9e 00 00 00    	ja     80228c <__udivdi3+0x108>
  8021ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f3:	89 fa                	mov    %edi,%edx
  8021f5:	83 c4 1c             	add    $0x1c,%esp
  8021f8:	5b                   	pop    %ebx
  8021f9:	5e                   	pop    %esi
  8021fa:	5f                   	pop    %edi
  8021fb:	5d                   	pop    %ebp
  8021fc:	c3                   	ret    
  8021fd:	8d 76 00             	lea    0x0(%esi),%esi
  802200:	31 ff                	xor    %edi,%edi
  802202:	31 c0                	xor    %eax,%eax
  802204:	89 fa                	mov    %edi,%edx
  802206:	83 c4 1c             	add    $0x1c,%esp
  802209:	5b                   	pop    %ebx
  80220a:	5e                   	pop    %esi
  80220b:	5f                   	pop    %edi
  80220c:	5d                   	pop    %ebp
  80220d:	c3                   	ret    
  80220e:	66 90                	xchg   %ax,%ax
  802210:	89 d8                	mov    %ebx,%eax
  802212:	f7 f7                	div    %edi
  802214:	31 ff                	xor    %edi,%edi
  802216:	89 fa                	mov    %edi,%edx
  802218:	83 c4 1c             	add    $0x1c,%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5e                   	pop    %esi
  80221d:	5f                   	pop    %edi
  80221e:	5d                   	pop    %ebp
  80221f:	c3                   	ret    
  802220:	bd 20 00 00 00       	mov    $0x20,%ebp
  802225:	89 eb                	mov    %ebp,%ebx
  802227:	29 fb                	sub    %edi,%ebx
  802229:	89 f9                	mov    %edi,%ecx
  80222b:	d3 e6                	shl    %cl,%esi
  80222d:	89 c5                	mov    %eax,%ebp
  80222f:	88 d9                	mov    %bl,%cl
  802231:	d3 ed                	shr    %cl,%ebp
  802233:	89 e9                	mov    %ebp,%ecx
  802235:	09 f1                	or     %esi,%ecx
  802237:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80223b:	89 f9                	mov    %edi,%ecx
  80223d:	d3 e0                	shl    %cl,%eax
  80223f:	89 c5                	mov    %eax,%ebp
  802241:	89 d6                	mov    %edx,%esi
  802243:	88 d9                	mov    %bl,%cl
  802245:	d3 ee                	shr    %cl,%esi
  802247:	89 f9                	mov    %edi,%ecx
  802249:	d3 e2                	shl    %cl,%edx
  80224b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80224f:	88 d9                	mov    %bl,%cl
  802251:	d3 e8                	shr    %cl,%eax
  802253:	09 c2                	or     %eax,%edx
  802255:	89 d0                	mov    %edx,%eax
  802257:	89 f2                	mov    %esi,%edx
  802259:	f7 74 24 0c          	divl   0xc(%esp)
  80225d:	89 d6                	mov    %edx,%esi
  80225f:	89 c3                	mov    %eax,%ebx
  802261:	f7 e5                	mul    %ebp
  802263:	39 d6                	cmp    %edx,%esi
  802265:	72 19                	jb     802280 <__udivdi3+0xfc>
  802267:	74 0b                	je     802274 <__udivdi3+0xf0>
  802269:	89 d8                	mov    %ebx,%eax
  80226b:	31 ff                	xor    %edi,%edi
  80226d:	e9 58 ff ff ff       	jmp    8021ca <__udivdi3+0x46>
  802272:	66 90                	xchg   %ax,%ax
  802274:	8b 54 24 08          	mov    0x8(%esp),%edx
  802278:	89 f9                	mov    %edi,%ecx
  80227a:	d3 e2                	shl    %cl,%edx
  80227c:	39 c2                	cmp    %eax,%edx
  80227e:	73 e9                	jae    802269 <__udivdi3+0xe5>
  802280:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802283:	31 ff                	xor    %edi,%edi
  802285:	e9 40 ff ff ff       	jmp    8021ca <__udivdi3+0x46>
  80228a:	66 90                	xchg   %ax,%ax
  80228c:	31 c0                	xor    %eax,%eax
  80228e:	e9 37 ff ff ff       	jmp    8021ca <__udivdi3+0x46>
  802293:	90                   	nop

00802294 <__umoddi3>:
  802294:	55                   	push   %ebp
  802295:	57                   	push   %edi
  802296:	56                   	push   %esi
  802297:	53                   	push   %ebx
  802298:	83 ec 1c             	sub    $0x1c,%esp
  80229b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80229f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022b3:	89 f3                	mov    %esi,%ebx
  8022b5:	89 fa                	mov    %edi,%edx
  8022b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022bb:	89 34 24             	mov    %esi,(%esp)
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	75 1a                	jne    8022dc <__umoddi3+0x48>
  8022c2:	39 f7                	cmp    %esi,%edi
  8022c4:	0f 86 a2 00 00 00    	jbe    80236c <__umoddi3+0xd8>
  8022ca:	89 c8                	mov    %ecx,%eax
  8022cc:	89 f2                	mov    %esi,%edx
  8022ce:	f7 f7                	div    %edi
  8022d0:	89 d0                	mov    %edx,%eax
  8022d2:	31 d2                	xor    %edx,%edx
  8022d4:	83 c4 1c             	add    $0x1c,%esp
  8022d7:	5b                   	pop    %ebx
  8022d8:	5e                   	pop    %esi
  8022d9:	5f                   	pop    %edi
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    
  8022dc:	39 f0                	cmp    %esi,%eax
  8022de:	0f 87 ac 00 00 00    	ja     802390 <__umoddi3+0xfc>
  8022e4:	0f bd e8             	bsr    %eax,%ebp
  8022e7:	83 f5 1f             	xor    $0x1f,%ebp
  8022ea:	0f 84 ac 00 00 00    	je     80239c <__umoddi3+0x108>
  8022f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8022f5:	29 ef                	sub    %ebp,%edi
  8022f7:	89 fe                	mov    %edi,%esi
  8022f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022fd:	89 e9                	mov    %ebp,%ecx
  8022ff:	d3 e0                	shl    %cl,%eax
  802301:	89 d7                	mov    %edx,%edi
  802303:	89 f1                	mov    %esi,%ecx
  802305:	d3 ef                	shr    %cl,%edi
  802307:	09 c7                	or     %eax,%edi
  802309:	89 e9                	mov    %ebp,%ecx
  80230b:	d3 e2                	shl    %cl,%edx
  80230d:	89 14 24             	mov    %edx,(%esp)
  802310:	89 d8                	mov    %ebx,%eax
  802312:	d3 e0                	shl    %cl,%eax
  802314:	89 c2                	mov    %eax,%edx
  802316:	8b 44 24 08          	mov    0x8(%esp),%eax
  80231a:	d3 e0                	shl    %cl,%eax
  80231c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802320:	8b 44 24 08          	mov    0x8(%esp),%eax
  802324:	89 f1                	mov    %esi,%ecx
  802326:	d3 e8                	shr    %cl,%eax
  802328:	09 d0                	or     %edx,%eax
  80232a:	d3 eb                	shr    %cl,%ebx
  80232c:	89 da                	mov    %ebx,%edx
  80232e:	f7 f7                	div    %edi
  802330:	89 d3                	mov    %edx,%ebx
  802332:	f7 24 24             	mull   (%esp)
  802335:	89 c6                	mov    %eax,%esi
  802337:	89 d1                	mov    %edx,%ecx
  802339:	39 d3                	cmp    %edx,%ebx
  80233b:	0f 82 87 00 00 00    	jb     8023c8 <__umoddi3+0x134>
  802341:	0f 84 91 00 00 00    	je     8023d8 <__umoddi3+0x144>
  802347:	8b 54 24 04          	mov    0x4(%esp),%edx
  80234b:	29 f2                	sub    %esi,%edx
  80234d:	19 cb                	sbb    %ecx,%ebx
  80234f:	89 d8                	mov    %ebx,%eax
  802351:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802355:	d3 e0                	shl    %cl,%eax
  802357:	89 e9                	mov    %ebp,%ecx
  802359:	d3 ea                	shr    %cl,%edx
  80235b:	09 d0                	or     %edx,%eax
  80235d:	89 e9                	mov    %ebp,%ecx
  80235f:	d3 eb                	shr    %cl,%ebx
  802361:	89 da                	mov    %ebx,%edx
  802363:	83 c4 1c             	add    $0x1c,%esp
  802366:	5b                   	pop    %ebx
  802367:	5e                   	pop    %esi
  802368:	5f                   	pop    %edi
  802369:	5d                   	pop    %ebp
  80236a:	c3                   	ret    
  80236b:	90                   	nop
  80236c:	89 fd                	mov    %edi,%ebp
  80236e:	85 ff                	test   %edi,%edi
  802370:	75 0b                	jne    80237d <__umoddi3+0xe9>
  802372:	b8 01 00 00 00       	mov    $0x1,%eax
  802377:	31 d2                	xor    %edx,%edx
  802379:	f7 f7                	div    %edi
  80237b:	89 c5                	mov    %eax,%ebp
  80237d:	89 f0                	mov    %esi,%eax
  80237f:	31 d2                	xor    %edx,%edx
  802381:	f7 f5                	div    %ebp
  802383:	89 c8                	mov    %ecx,%eax
  802385:	f7 f5                	div    %ebp
  802387:	89 d0                	mov    %edx,%eax
  802389:	e9 44 ff ff ff       	jmp    8022d2 <__umoddi3+0x3e>
  80238e:	66 90                	xchg   %ax,%ax
  802390:	89 c8                	mov    %ecx,%eax
  802392:	89 f2                	mov    %esi,%edx
  802394:	83 c4 1c             	add    $0x1c,%esp
  802397:	5b                   	pop    %ebx
  802398:	5e                   	pop    %esi
  802399:	5f                   	pop    %edi
  80239a:	5d                   	pop    %ebp
  80239b:	c3                   	ret    
  80239c:	3b 04 24             	cmp    (%esp),%eax
  80239f:	72 06                	jb     8023a7 <__umoddi3+0x113>
  8023a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8023a5:	77 0f                	ja     8023b6 <__umoddi3+0x122>
  8023a7:	89 f2                	mov    %esi,%edx
  8023a9:	29 f9                	sub    %edi,%ecx
  8023ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023af:	89 14 24             	mov    %edx,(%esp)
  8023b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023ba:	8b 14 24             	mov    (%esp),%edx
  8023bd:	83 c4 1c             	add    $0x1c,%esp
  8023c0:	5b                   	pop    %ebx
  8023c1:	5e                   	pop    %esi
  8023c2:	5f                   	pop    %edi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	2b 04 24             	sub    (%esp),%eax
  8023cb:	19 fa                	sbb    %edi,%edx
  8023cd:	89 d1                	mov    %edx,%ecx
  8023cf:	89 c6                	mov    %eax,%esi
  8023d1:	e9 71 ff ff ff       	jmp    802347 <__umoddi3+0xb3>
  8023d6:	66 90                	xchg   %ax,%ax
  8023d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8023dc:	72 ea                	jb     8023c8 <__umoddi3+0x134>
  8023de:	89 d9                	mov    %ebx,%ecx
  8023e0:	e9 62 ff ff ff       	jmp    802347 <__umoddi3+0xb3>
