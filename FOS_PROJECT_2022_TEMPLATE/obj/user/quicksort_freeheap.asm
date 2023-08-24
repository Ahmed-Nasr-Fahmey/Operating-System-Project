
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 b4 05 00 00       	call   8005ea <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 58 1b 00 00       	call   801ba6 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 6a 1b 00 00       	call   801bbf <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_disable_interrupt();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 80 23 80 00       	push   $0x802380
  80006c:	e8 fe 0f 00 00       	call   80106f <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 4e 15 00 00       	call   8015d5 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 fb 18 00 00       	call   801997 <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 a0 23 80 00       	push   $0x8023a0
  8000aa:	e8 3e 09 00 00       	call   8009ed <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 c3 23 80 00       	push   $0x8023c3
  8000ba:	e8 2e 09 00 00       	call   8009ed <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 d1 23 80 00       	push   $0x8023d1
  8000ca:	e8 1e 09 00 00       	call   8009ed <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 e0 23 80 00       	push   $0x8023e0
  8000da:	e8 0e 09 00 00       	call   8009ed <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 f0 23 80 00       	push   $0x8023f0
  8000ea:	e8 fe 08 00 00       	call   8009ed <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 9b 04 00 00       	call   800592 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 43 04 00 00       	call   80054a <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 36 04 00 00       	call   80054a <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeDescending>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 fc 23 80 00       	push   $0x8023fc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 1e 24 80 00       	push   $0x80241e
  8001c0:	e8 74 05 00 00       	call   800739 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 38 24 80 00       	push   $0x802438
  8001cd:	e8 1b 08 00 00       	call   8009ed <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 6c 24 80 00       	push   $0x80246c
  8001dd:	e8 0b 08 00 00       	call   8009ed <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 a0 24 80 00       	push   $0x8024a0
  8001ed:	e8 fb 07 00 00       	call   8009ed <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d2 24 80 00       	push   $0x8024d2
  8001fd:	e8 eb 07 00 00       	call   8009ed <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 e8 24 80 00       	push   $0x8024e8
  80020d:	e8 db 07 00 00       	call   8009ed <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 78 03 00 00       	call   800592 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 20 03 00 00       	call   80054a <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 13 03 00 00       	call   80054a <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 06 03 00 00       	call   80054a <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800499:	eb 1e                	jmp    8004b9 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ae:	99                   	cltd   
  8004af:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b6:	ff 45 fc             	incl   -0x4(%ebp)
  8004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bf:	7c da                	jl     80049b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004ca:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004d8:	eb 42                	jmp    80051c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	99                   	cltd   
  8004de:	f7 7d f0             	idivl  -0x10(%ebp)
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <PrintElements+0x33>
			cprintf("\n");
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	68 06 25 80 00       	push   $0x802506
  8004ef:	e8 f9 04 00 00       	call   8009ed <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8004f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	50                   	push   %eax
  80050c:	68 08 25 80 00       	push   $0x802508
  800511:	e8 d7 04 00 00       	call   8009ed <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	ff 45 f4             	incl   -0xc(%ebp)
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	48                   	dec    %eax
  800520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800523:	7f b5                	jg     8004da <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	50                   	push   %eax
  80053a:	68 0d 25 80 00       	push   $0x80250d
  80053f:	e8 a9 04 00 00       	call   8009ed <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800556:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	50                   	push   %eax
  80055e:	e8 64 17 00 00       	call   801cc7 <sys_cputc>
  800563:	83 c4 10             	add    $0x10,%esp
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056f:	e8 1f 17 00 00       	call   801c93 <sys_disable_interrupt>
	char c = ch;
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80057a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	50                   	push   %eax
  800582:	e8 40 17 00 00       	call   801cc7 <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 1e 17 00 00       	call   801cad <sys_enable_interrupt>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <getchar>:

int
getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80059f:	eb 08                	jmp    8005a9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005a1:	e8 68 15 00 00       	call   801b0e <sys_cgetc>
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005ad:	74 f2                	je     8005a1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ba:	e8 d4 16 00 00       	call   801c93 <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 41 15 00 00       	call   801b0e <sys_cgetc>
  8005cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d4:	74 f2                	je     8005c8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005d6:	e8 d2 16 00 00       	call   801cad <sys_enable_interrupt>
	return c;
  8005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <iscons>:

int iscons(int fdnum)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f0:	e8 91 18 00 00       	call   801e86 <sys_getenvindex>
  8005f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800608:	01 c8                	add    %ecx,%eax
  80060a:	c1 e0 02             	shl    $0x2,%eax
  80060d:	01 d0                	add    %edx,%eax
  80060f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800616:	01 c8                	add    %ecx,%eax
  800618:	c1 e0 02             	shl    $0x2,%eax
  80061b:	01 d0                	add    %edx,%eax
  80061d:	c1 e0 02             	shl    $0x2,%eax
  800620:	01 d0                	add    %edx,%eax
  800622:	c1 e0 03             	shl    $0x3,%eax
  800625:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80062a:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80062f:	a1 24 30 80 00       	mov    0x803024,%eax
  800634:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80063a:	84 c0                	test   %al,%al
  80063c:	74 0f                	je     80064d <libmain+0x63>
		binaryname = myEnv->prog_name;
  80063e:	a1 24 30 80 00       	mov    0x803024,%eax
  800643:	05 18 da 01 00       	add    $0x1da18,%eax
  800648:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80064d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800651:	7e 0a                	jle    80065d <libmain+0x73>
		binaryname = argv[0];
  800653:	8b 45 0c             	mov    0xc(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 08             	pushl  0x8(%ebp)
  800666:	e8 cd f9 ff ff       	call   800038 <_main>
  80066b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80066e:	e8 20 16 00 00       	call   801c93 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800673:	83 ec 0c             	sub    $0xc,%esp
  800676:	68 2c 25 80 00       	push   $0x80252c
  80067b:	e8 6d 03 00 00       	call   8009ed <cprintf>
  800680:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800683:	a1 24 30 80 00       	mov    0x803024,%eax
  800688:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80068e:	a1 24 30 80 00       	mov    0x803024,%eax
  800693:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800699:	83 ec 04             	sub    $0x4,%esp
  80069c:	52                   	push   %edx
  80069d:	50                   	push   %eax
  80069e:	68 54 25 80 00       	push   $0x802554
  8006a3:	e8 45 03 00 00       	call   8009ed <cprintf>
  8006a8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006ab:	a1 24 30 80 00       	mov    0x803024,%eax
  8006b0:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8006b6:	a1 24 30 80 00       	mov    0x803024,%eax
  8006bb:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8006c1:	a1 24 30 80 00       	mov    0x803024,%eax
  8006c6:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8006cc:	51                   	push   %ecx
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	68 7c 25 80 00       	push   $0x80257c
  8006d4:	e8 14 03 00 00       	call   8009ed <cprintf>
  8006d9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006dc:	a1 24 30 80 00       	mov    0x803024,%eax
  8006e1:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	50                   	push   %eax
  8006eb:	68 d4 25 80 00       	push   $0x8025d4
  8006f0:	e8 f8 02 00 00       	call   8009ed <cprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	68 2c 25 80 00       	push   $0x80252c
  800700:	e8 e8 02 00 00       	call   8009ed <cprintf>
  800705:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800708:	e8 a0 15 00 00       	call   801cad <sys_enable_interrupt>

	// exit gracefully
	exit();
  80070d:	e8 19 00 00 00       	call   80072b <exit>
}
  800712:	90                   	nop
  800713:	c9                   	leave  
  800714:	c3                   	ret    

00800715 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800715:	55                   	push   %ebp
  800716:	89 e5                	mov    %esp,%ebp
  800718:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80071b:	83 ec 0c             	sub    $0xc,%esp
  80071e:	6a 00                	push   $0x0
  800720:	e8 2d 17 00 00       	call   801e52 <sys_destroy_env>
  800725:	83 c4 10             	add    $0x10,%esp
}
  800728:	90                   	nop
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <exit>:

void
exit(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800731:	e8 82 17 00 00       	call   801eb8 <sys_exit_env>
}
  800736:	90                   	nop
  800737:	c9                   	leave  
  800738:	c3                   	ret    

00800739 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800739:	55                   	push   %ebp
  80073a:	89 e5                	mov    %esp,%ebp
  80073c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80073f:	8d 45 10             	lea    0x10(%ebp),%eax
  800742:	83 c0 04             	add    $0x4,%eax
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800748:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80074d:	85 c0                	test   %eax,%eax
  80074f:	74 16                	je     800767 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800751:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	50                   	push   %eax
  80075a:	68 e8 25 80 00       	push   $0x8025e8
  80075f:	e8 89 02 00 00       	call   8009ed <cprintf>
  800764:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800767:	a1 00 30 80 00       	mov    0x803000,%eax
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 08             	pushl  0x8(%ebp)
  800772:	50                   	push   %eax
  800773:	68 ed 25 80 00       	push   $0x8025ed
  800778:	e8 70 02 00 00       	call   8009ed <cprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 f4             	pushl  -0xc(%ebp)
  800789:	50                   	push   %eax
  80078a:	e8 f3 01 00 00       	call   800982 <vcprintf>
  80078f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	6a 00                	push   $0x0
  800797:	68 09 26 80 00       	push   $0x802609
  80079c:	e8 e1 01 00 00       	call   800982 <vcprintf>
  8007a1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007a4:	e8 82 ff ff ff       	call   80072b <exit>

	// should not return here
	while (1) ;
  8007a9:	eb fe                	jmp    8007a9 <_panic+0x70>

008007ab <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007b1:	a1 24 30 80 00       	mov    0x803024,%eax
  8007b6:	8b 50 74             	mov    0x74(%eax),%edx
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bc:	39 c2                	cmp    %eax,%edx
  8007be:	74 14                	je     8007d4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007c0:	83 ec 04             	sub    $0x4,%esp
  8007c3:	68 0c 26 80 00       	push   $0x80260c
  8007c8:	6a 26                	push   $0x26
  8007ca:	68 58 26 80 00       	push   $0x802658
  8007cf:	e8 65 ff ff ff       	call   800739 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007e2:	e9 c2 00 00 00       	jmp    8008a9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	01 d0                	add    %edx,%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	85 c0                	test   %eax,%eax
  8007fa:	75 08                	jne    800804 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007fc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ff:	e9 a2 00 00 00       	jmp    8008a6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800804:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80080b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800812:	eb 69                	jmp    80087d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800814:	a1 24 30 80 00       	mov    0x803024,%eax
  800819:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80081f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800822:	89 d0                	mov    %edx,%eax
  800824:	01 c0                	add    %eax,%eax
  800826:	01 d0                	add    %edx,%eax
  800828:	c1 e0 03             	shl    $0x3,%eax
  80082b:	01 c8                	add    %ecx,%eax
  80082d:	8a 40 04             	mov    0x4(%eax),%al
  800830:	84 c0                	test   %al,%al
  800832:	75 46                	jne    80087a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800834:	a1 24 30 80 00       	mov    0x803024,%eax
  800839:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	01 c0                	add    %eax,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	c1 e0 03             	shl    $0x3,%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800852:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800855:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80085a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80085c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	01 c8                	add    %ecx,%eax
  80086b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	75 09                	jne    80087a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800871:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800878:	eb 12                	jmp    80088c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087a:	ff 45 e8             	incl   -0x18(%ebp)
  80087d:	a1 24 30 80 00       	mov    0x803024,%eax
  800882:	8b 50 74             	mov    0x74(%eax),%edx
  800885:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800888:	39 c2                	cmp    %eax,%edx
  80088a:	77 88                	ja     800814 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80088c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800890:	75 14                	jne    8008a6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800892:	83 ec 04             	sub    $0x4,%esp
  800895:	68 64 26 80 00       	push   $0x802664
  80089a:	6a 3a                	push   $0x3a
  80089c:	68 58 26 80 00       	push   $0x802658
  8008a1:	e8 93 fe ff ff       	call   800739 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008a6:	ff 45 f0             	incl   -0x10(%ebp)
  8008a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008af:	0f 8c 32 ff ff ff    	jl     8007e7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008c3:	eb 26                	jmp    8008eb <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008c5:	a1 24 30 80 00       	mov    0x803024,%eax
  8008ca:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8008d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008d3:	89 d0                	mov    %edx,%eax
  8008d5:	01 c0                	add    %eax,%eax
  8008d7:	01 d0                	add    %edx,%eax
  8008d9:	c1 e0 03             	shl    $0x3,%eax
  8008dc:	01 c8                	add    %ecx,%eax
  8008de:	8a 40 04             	mov    0x4(%eax),%al
  8008e1:	3c 01                	cmp    $0x1,%al
  8008e3:	75 03                	jne    8008e8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008e5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008e8:	ff 45 e0             	incl   -0x20(%ebp)
  8008eb:	a1 24 30 80 00       	mov    0x803024,%eax
  8008f0:	8b 50 74             	mov    0x74(%eax),%edx
  8008f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f6:	39 c2                	cmp    %eax,%edx
  8008f8:	77 cb                	ja     8008c5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008fd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800900:	74 14                	je     800916 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	68 b8 26 80 00       	push   $0x8026b8
  80090a:	6a 44                	push   $0x44
  80090c:	68 58 26 80 00       	push   $0x802658
  800911:	e8 23 fe ff ff       	call   800739 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800916:	90                   	nop
  800917:	c9                   	leave  
  800918:	c3                   	ret    

00800919 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80091f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	8d 48 01             	lea    0x1(%eax),%ecx
  800927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092a:	89 0a                	mov    %ecx,(%edx)
  80092c:	8b 55 08             	mov    0x8(%ebp),%edx
  80092f:	88 d1                	mov    %dl,%cl
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800942:	75 2c                	jne    800970 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800944:	a0 28 30 80 00       	mov    0x803028,%al
  800949:	0f b6 c0             	movzbl %al,%eax
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	8b 12                	mov    (%edx),%edx
  800951:	89 d1                	mov    %edx,%ecx
  800953:	8b 55 0c             	mov    0xc(%ebp),%edx
  800956:	83 c2 08             	add    $0x8,%edx
  800959:	83 ec 04             	sub    $0x4,%esp
  80095c:	50                   	push   %eax
  80095d:	51                   	push   %ecx
  80095e:	52                   	push   %edx
  80095f:	e8 81 11 00 00       	call   801ae5 <sys_cputs>
  800964:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	8b 40 04             	mov    0x4(%eax),%eax
  800976:	8d 50 01             	lea    0x1(%eax),%edx
  800979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80097f:	90                   	nop
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80098b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800992:	00 00 00 
	b.cnt = 0;
  800995:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80099c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	ff 75 08             	pushl  0x8(%ebp)
  8009a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009ab:	50                   	push   %eax
  8009ac:	68 19 09 80 00       	push   $0x800919
  8009b1:	e8 11 02 00 00       	call   800bc7 <vprintfmt>
  8009b6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009b9:	a0 28 30 80 00       	mov    0x803028,%al
  8009be:	0f b6 c0             	movzbl %al,%eax
  8009c1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	50                   	push   %eax
  8009cb:	52                   	push   %edx
  8009cc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009d2:	83 c0 08             	add    $0x8,%eax
  8009d5:	50                   	push   %eax
  8009d6:	e8 0a 11 00 00       	call   801ae5 <sys_cputs>
  8009db:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009de:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  8009e5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <cprintf>:

int cprintf(const char *fmt, ...) {
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009f3:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  8009fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 f4             	pushl  -0xc(%ebp)
  800a09:	50                   	push   %eax
  800a0a:	e8 73 ff ff ff       	call   800982 <vcprintf>
  800a0f:	83 c4 10             	add    $0x10,%esp
  800a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a20:	e8 6e 12 00 00       	call   801c93 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a25:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 f4             	pushl  -0xc(%ebp)
  800a34:	50                   	push   %eax
  800a35:	e8 48 ff ff ff       	call   800982 <vcprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a40:	e8 68 12 00 00       	call   801cad <sys_enable_interrupt>
	return cnt;
  800a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	53                   	push   %ebx
  800a4e:	83 ec 14             	sub    $0x14,%esp
  800a51:	8b 45 10             	mov    0x10(%ebp),%eax
  800a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a5d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a60:	ba 00 00 00 00       	mov    $0x0,%edx
  800a65:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a68:	77 55                	ja     800abf <printnum+0x75>
  800a6a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a6d:	72 05                	jb     800a74 <printnum+0x2a>
  800a6f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a72:	77 4b                	ja     800abf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a74:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a77:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a7a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a82:	52                   	push   %edx
  800a83:	50                   	push   %eax
  800a84:	ff 75 f4             	pushl  -0xc(%ebp)
  800a87:	ff 75 f0             	pushl  -0x10(%ebp)
  800a8a:	e8 89 16 00 00       	call   802118 <__udivdi3>
  800a8f:	83 c4 10             	add    $0x10,%esp
  800a92:	83 ec 04             	sub    $0x4,%esp
  800a95:	ff 75 20             	pushl  0x20(%ebp)
  800a98:	53                   	push   %ebx
  800a99:	ff 75 18             	pushl  0x18(%ebp)
  800a9c:	52                   	push   %edx
  800a9d:	50                   	push   %eax
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 08             	pushl  0x8(%ebp)
  800aa4:	e8 a1 ff ff ff       	call   800a4a <printnum>
  800aa9:	83 c4 20             	add    $0x20,%esp
  800aac:	eb 1a                	jmp    800ac8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	ff 75 20             	pushl  0x20(%ebp)
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800abf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ac2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ac6:	7f e6                	jg     800aae <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ac8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800acb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad6:	53                   	push   %ebx
  800ad7:	51                   	push   %ecx
  800ad8:	52                   	push   %edx
  800ad9:	50                   	push   %eax
  800ada:	e8 49 17 00 00       	call   802228 <__umoddi3>
  800adf:	83 c4 10             	add    $0x10,%esp
  800ae2:	05 34 29 80 00       	add    $0x802934,%eax
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	0f be c0             	movsbl %al,%eax
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	50                   	push   %eax
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	ff d0                	call   *%eax
  800af8:	83 c4 10             	add    $0x10,%esp
}
  800afb:	90                   	nop
  800afc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b04:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b08:	7e 1c                	jle    800b26 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8b 00                	mov    (%eax),%eax
  800b0f:	8d 50 08             	lea    0x8(%eax),%edx
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	89 10                	mov    %edx,(%eax)
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	83 e8 08             	sub    $0x8,%eax
  800b1f:	8b 50 04             	mov    0x4(%eax),%edx
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	eb 40                	jmp    800b66 <getuint+0x65>
	else if (lflag)
  800b26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2a:	74 1e                	je     800b4a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	8d 50 04             	lea    0x4(%eax),%edx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	89 10                	mov    %edx,(%eax)
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	83 e8 04             	sub    $0x4,%eax
  800b41:	8b 00                	mov    (%eax),%eax
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
  800b48:	eb 1c                	jmp    800b66 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8b 00                	mov    (%eax),%eax
  800b4f:	8d 50 04             	lea    0x4(%eax),%edx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	89 10                	mov    %edx,(%eax)
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	83 e8 04             	sub    $0x4,%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b6b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b6f:	7e 1c                	jle    800b8d <getint+0x25>
		return va_arg(*ap, long long);
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8b 00                	mov    (%eax),%eax
  800b76:	8d 50 08             	lea    0x8(%eax),%edx
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	89 10                	mov    %edx,(%eax)
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8b 00                	mov    (%eax),%eax
  800b83:	83 e8 08             	sub    $0x8,%eax
  800b86:	8b 50 04             	mov    0x4(%eax),%edx
  800b89:	8b 00                	mov    (%eax),%eax
  800b8b:	eb 38                	jmp    800bc5 <getint+0x5d>
	else if (lflag)
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	74 1a                	je     800bad <getint+0x45>
		return va_arg(*ap, long);
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	8b 00                	mov    (%eax),%eax
  800b98:	8d 50 04             	lea    0x4(%eax),%edx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	89 10                	mov    %edx,(%eax)
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	83 e8 04             	sub    $0x4,%eax
  800ba8:	8b 00                	mov    (%eax),%eax
  800baa:	99                   	cltd   
  800bab:	eb 18                	jmp    800bc5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 00                	mov    (%eax),%eax
  800bb2:	8d 50 04             	lea    0x4(%eax),%edx
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	89 10                	mov    %edx,(%eax)
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	83 e8 04             	sub    $0x4,%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	99                   	cltd   
}
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
  800bcc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcf:	eb 17                	jmp    800be8 <vprintfmt+0x21>
			if (ch == '\0')
  800bd1:	85 db                	test   %ebx,%ebx
  800bd3:	0f 84 af 03 00 00    	je     800f88 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	53                   	push   %ebx
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be8:	8b 45 10             	mov    0x10(%ebp),%eax
  800beb:	8d 50 01             	lea    0x1(%eax),%edx
  800bee:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	0f b6 d8             	movzbl %al,%ebx
  800bf6:	83 fb 25             	cmp    $0x25,%ebx
  800bf9:	75 d6                	jne    800bd1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bfb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bff:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c06:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c14:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1e:	8d 50 01             	lea    0x1(%eax),%edx
  800c21:	89 55 10             	mov    %edx,0x10(%ebp)
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	0f b6 d8             	movzbl %al,%ebx
  800c29:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c2c:	83 f8 55             	cmp    $0x55,%eax
  800c2f:	0f 87 2b 03 00 00    	ja     800f60 <vprintfmt+0x399>
  800c35:	8b 04 85 58 29 80 00 	mov    0x802958(,%eax,4),%eax
  800c3c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c3e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c42:	eb d7                	jmp    800c1b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c44:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c48:	eb d1                	jmp    800c1b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c4a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c54:	89 d0                	mov    %edx,%eax
  800c56:	c1 e0 02             	shl    $0x2,%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	01 c0                	add    %eax,%eax
  800c5d:	01 d8                	add    %ebx,%eax
  800c5f:	83 e8 30             	sub    $0x30,%eax
  800c62:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c65:	8b 45 10             	mov    0x10(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c6d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c70:	7e 3e                	jle    800cb0 <vprintfmt+0xe9>
  800c72:	83 fb 39             	cmp    $0x39,%ebx
  800c75:	7f 39                	jg     800cb0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c77:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c7a:	eb d5                	jmp    800c51 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7f:	83 c0 04             	add    $0x4,%eax
  800c82:	89 45 14             	mov    %eax,0x14(%ebp)
  800c85:	8b 45 14             	mov    0x14(%ebp),%eax
  800c88:	83 e8 04             	sub    $0x4,%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c90:	eb 1f                	jmp    800cb1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c96:	79 83                	jns    800c1b <vprintfmt+0x54>
				width = 0;
  800c98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c9f:	e9 77 ff ff ff       	jmp    800c1b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ca4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cab:	e9 6b ff ff ff       	jmp    800c1b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cb0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb5:	0f 89 60 ff ff ff    	jns    800c1b <vprintfmt+0x54>
				width = precision, precision = -1;
  800cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cc1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cc8:	e9 4e ff ff ff       	jmp    800c1b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ccd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cd0:	e9 46 ff ff ff       	jmp    800c1b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd8:	83 c0 04             	add    $0x4,%eax
  800cdb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 e8 04             	sub    $0x4,%eax
  800ce4:	8b 00                	mov    (%eax),%eax
  800ce6:	83 ec 08             	sub    $0x8,%esp
  800ce9:	ff 75 0c             	pushl  0xc(%ebp)
  800cec:	50                   	push   %eax
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
			break;
  800cf5:	e9 89 02 00 00       	jmp    800f83 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfd:	83 c0 04             	add    $0x4,%eax
  800d00:	89 45 14             	mov    %eax,0x14(%ebp)
  800d03:	8b 45 14             	mov    0x14(%ebp),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d0b:	85 db                	test   %ebx,%ebx
  800d0d:	79 02                	jns    800d11 <vprintfmt+0x14a>
				err = -err;
  800d0f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d11:	83 fb 64             	cmp    $0x64,%ebx
  800d14:	7f 0b                	jg     800d21 <vprintfmt+0x15a>
  800d16:	8b 34 9d a0 27 80 00 	mov    0x8027a0(,%ebx,4),%esi
  800d1d:	85 f6                	test   %esi,%esi
  800d1f:	75 19                	jne    800d3a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d21:	53                   	push   %ebx
  800d22:	68 45 29 80 00       	push   $0x802945
  800d27:	ff 75 0c             	pushl  0xc(%ebp)
  800d2a:	ff 75 08             	pushl  0x8(%ebp)
  800d2d:	e8 5e 02 00 00       	call   800f90 <printfmt>
  800d32:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d35:	e9 49 02 00 00       	jmp    800f83 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d3a:	56                   	push   %esi
  800d3b:	68 4e 29 80 00       	push   $0x80294e
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	ff 75 08             	pushl  0x8(%ebp)
  800d46:	e8 45 02 00 00       	call   800f90 <printfmt>
  800d4b:	83 c4 10             	add    $0x10,%esp
			break;
  800d4e:	e9 30 02 00 00       	jmp    800f83 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d53:	8b 45 14             	mov    0x14(%ebp),%eax
  800d56:	83 c0 04             	add    $0x4,%eax
  800d59:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 30                	mov    (%eax),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 05                	jne    800d6d <vprintfmt+0x1a6>
				p = "(null)";
  800d68:	be 51 29 80 00       	mov    $0x802951,%esi
			if (width > 0 && padc != '-')
  800d6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d71:	7e 6d                	jle    800de0 <vprintfmt+0x219>
  800d73:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d77:	74 67                	je     800de0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d7c:	83 ec 08             	sub    $0x8,%esp
  800d7f:	50                   	push   %eax
  800d80:	56                   	push   %esi
  800d81:	e8 12 05 00 00       	call   801298 <strnlen>
  800d86:	83 c4 10             	add    $0x10,%esp
  800d89:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d8c:	eb 16                	jmp    800da4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d8e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d92:	83 ec 08             	sub    $0x8,%esp
  800d95:	ff 75 0c             	pushl  0xc(%ebp)
  800d98:	50                   	push   %eax
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	ff d0                	call   *%eax
  800d9e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da1:	ff 4d e4             	decl   -0x1c(%ebp)
  800da4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da8:	7f e4                	jg     800d8e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800daa:	eb 34                	jmp    800de0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800db0:	74 1c                	je     800dce <vprintfmt+0x207>
  800db2:	83 fb 1f             	cmp    $0x1f,%ebx
  800db5:	7e 05                	jle    800dbc <vprintfmt+0x1f5>
  800db7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dba:	7e 12                	jle    800dce <vprintfmt+0x207>
					putch('?', putdat);
  800dbc:	83 ec 08             	sub    $0x8,%esp
  800dbf:	ff 75 0c             	pushl  0xc(%ebp)
  800dc2:	6a 3f                	push   $0x3f
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	ff d0                	call   *%eax
  800dc9:	83 c4 10             	add    $0x10,%esp
  800dcc:	eb 0f                	jmp    800ddd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dce:	83 ec 08             	sub    $0x8,%esp
  800dd1:	ff 75 0c             	pushl  0xc(%ebp)
  800dd4:	53                   	push   %ebx
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	ff d0                	call   *%eax
  800dda:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ddd:	ff 4d e4             	decl   -0x1c(%ebp)
  800de0:	89 f0                	mov    %esi,%eax
  800de2:	8d 70 01             	lea    0x1(%eax),%esi
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f be d8             	movsbl %al,%ebx
  800dea:	85 db                	test   %ebx,%ebx
  800dec:	74 24                	je     800e12 <vprintfmt+0x24b>
  800dee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df2:	78 b8                	js     800dac <vprintfmt+0x1e5>
  800df4:	ff 4d e0             	decl   -0x20(%ebp)
  800df7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dfb:	79 af                	jns    800dac <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfd:	eb 13                	jmp    800e12 <vprintfmt+0x24b>
				putch(' ', putdat);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	ff 75 0c             	pushl  0xc(%ebp)
  800e05:	6a 20                	push   $0x20
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	ff d0                	call   *%eax
  800e0c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e16:	7f e7                	jg     800dff <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e18:	e9 66 01 00 00       	jmp    800f83 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e1d:	83 ec 08             	sub    $0x8,%esp
  800e20:	ff 75 e8             	pushl  -0x18(%ebp)
  800e23:	8d 45 14             	lea    0x14(%ebp),%eax
  800e26:	50                   	push   %eax
  800e27:	e8 3c fd ff ff       	call   800b68 <getint>
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3b:	85 d2                	test   %edx,%edx
  800e3d:	79 23                	jns    800e62 <vprintfmt+0x29b>
				putch('-', putdat);
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	6a 2d                	push   $0x2d
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e55:	f7 d8                	neg    %eax
  800e57:	83 d2 00             	adc    $0x0,%edx
  800e5a:	f7 da                	neg    %edx
  800e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e69:	e9 bc 00 00 00       	jmp    800f2a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e6e:	83 ec 08             	sub    $0x8,%esp
  800e71:	ff 75 e8             	pushl  -0x18(%ebp)
  800e74:	8d 45 14             	lea    0x14(%ebp),%eax
  800e77:	50                   	push   %eax
  800e78:	e8 84 fc ff ff       	call   800b01 <getuint>
  800e7d:	83 c4 10             	add    $0x10,%esp
  800e80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e83:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e86:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e8d:	e9 98 00 00 00       	jmp    800f2a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e92:	83 ec 08             	sub    $0x8,%esp
  800e95:	ff 75 0c             	pushl  0xc(%ebp)
  800e98:	6a 58                	push   $0x58
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	ff d0                	call   *%eax
  800e9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ea2:	83 ec 08             	sub    $0x8,%esp
  800ea5:	ff 75 0c             	pushl  0xc(%ebp)
  800ea8:	6a 58                	push   $0x58
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	ff d0                	call   *%eax
  800eaf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			break;
  800ec2:	e9 bc 00 00 00       	jmp    800f83 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	6a 30                	push   $0x30
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	ff d0                	call   *%eax
  800ed4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	ff 75 0c             	pushl  0xc(%ebp)
  800edd:	6a 78                	push   $0x78
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	ff d0                	call   *%eax
  800ee4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ee7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eea:	83 c0 04             	add    $0x4,%eax
  800eed:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef3:	83 e8 04             	sub    $0x4,%eax
  800ef6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f02:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f09:	eb 1f                	jmp    800f2a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f0b:	83 ec 08             	sub    $0x8,%esp
  800f0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f11:	8d 45 14             	lea    0x14(%ebp),%eax
  800f14:	50                   	push   %eax
  800f15:	e8 e7 fb ff ff       	call   800b01 <getuint>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f23:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f2a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f31:	83 ec 04             	sub    $0x4,%esp
  800f34:	52                   	push   %edx
  800f35:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f38:	50                   	push   %eax
  800f39:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	ff 75 08             	pushl  0x8(%ebp)
  800f45:	e8 00 fb ff ff       	call   800a4a <printnum>
  800f4a:	83 c4 20             	add    $0x20,%esp
			break;
  800f4d:	eb 34                	jmp    800f83 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	53                   	push   %ebx
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	eb 23                	jmp    800f83 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f60:	83 ec 08             	sub    $0x8,%esp
  800f63:	ff 75 0c             	pushl  0xc(%ebp)
  800f66:	6a 25                	push   $0x25
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	ff d0                	call   *%eax
  800f6d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f70:	ff 4d 10             	decl   0x10(%ebp)
  800f73:	eb 03                	jmp    800f78 <vprintfmt+0x3b1>
  800f75:	ff 4d 10             	decl   0x10(%ebp)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	48                   	dec    %eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	3c 25                	cmp    $0x25,%al
  800f80:	75 f3                	jne    800f75 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f82:	90                   	nop
		}
	}
  800f83:	e9 47 fc ff ff       	jmp    800bcf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f88:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f96:	8d 45 10             	lea    0x10(%ebp),%eax
  800f99:	83 c0 04             	add    $0x4,%eax
  800f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	ff 75 08             	pushl  0x8(%ebp)
  800fac:	e8 16 fc ff ff       	call   800bc7 <vprintfmt>
  800fb1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fb4:	90                   	nop
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbd:	8b 40 08             	mov    0x8(%eax),%eax
  800fc0:	8d 50 01             	lea    0x1(%eax),%edx
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcc:	8b 10                	mov    (%eax),%edx
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	8b 40 04             	mov    0x4(%eax),%eax
  800fd4:	39 c2                	cmp    %eax,%edx
  800fd6:	73 12                	jae    800fea <sprintputch+0x33>
		*b->buf++ = ch;
  800fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdb:	8b 00                	mov    (%eax),%eax
  800fdd:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe3:	89 0a                	mov    %ecx,(%edx)
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	88 10                	mov    %dl,(%eax)
}
  800fea:	90                   	nop
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	01 d0                	add    %edx,%eax
  801004:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80100e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801012:	74 06                	je     80101a <vsnprintf+0x2d>
  801014:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801018:	7f 07                	jg     801021 <vsnprintf+0x34>
		return -E_INVAL;
  80101a:	b8 03 00 00 00       	mov    $0x3,%eax
  80101f:	eb 20                	jmp    801041 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801021:	ff 75 14             	pushl  0x14(%ebp)
  801024:	ff 75 10             	pushl  0x10(%ebp)
  801027:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80102a:	50                   	push   %eax
  80102b:	68 b7 0f 80 00       	push   $0x800fb7
  801030:	e8 92 fb ff ff       	call   800bc7 <vprintfmt>
  801035:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80103b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801049:	8d 45 10             	lea    0x10(%ebp),%eax
  80104c:	83 c0 04             	add    $0x4,%eax
  80104f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	ff 75 f4             	pushl  -0xc(%ebp)
  801058:	50                   	push   %eax
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	e8 89 ff ff ff       	call   800fed <vsnprintf>
  801064:	83 c4 10             	add    $0x10,%esp
  801067:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80106a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801075:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801079:	74 13                	je     80108e <readline+0x1f>
		cprintf("%s", prompt);
  80107b:	83 ec 08             	sub    $0x8,%esp
  80107e:	ff 75 08             	pushl  0x8(%ebp)
  801081:	68 b0 2a 80 00       	push   $0x802ab0
  801086:	e8 62 f9 ff ff       	call   8009ed <cprintf>
  80108b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80108e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	6a 00                	push   $0x0
  80109a:	e8 41 f5 ff ff       	call   8005e0 <iscons>
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010a5:	e8 e8 f4 ff ff       	call   800592 <getchar>
  8010aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010b1:	79 22                	jns    8010d5 <readline+0x66>
			if (c != -E_EOF)
  8010b3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010b7:	0f 84 ad 00 00 00    	je     80116a <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 ec             	pushl  -0x14(%ebp)
  8010c3:	68 b3 2a 80 00       	push   $0x802ab3
  8010c8:	e8 20 f9 ff ff       	call   8009ed <cprintf>
  8010cd:	83 c4 10             	add    $0x10,%esp
			return;
  8010d0:	e9 95 00 00 00       	jmp    80116a <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010d5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010d9:	7e 34                	jle    80110f <readline+0xa0>
  8010db:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010e2:	7f 2b                	jg     80110f <readline+0xa0>
			if (echoing)
  8010e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010e8:	74 0e                	je     8010f8 <readline+0x89>
				cputchar(c);
  8010ea:	83 ec 0c             	sub    $0xc,%esp
  8010ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8010f0:	e8 55 f4 ff ff       	call   80054a <cputchar>
  8010f5:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fb:	8d 50 01             	lea    0x1(%eax),%edx
  8010fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801101:	89 c2                	mov    %eax,%edx
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80110b:	88 10                	mov    %dl,(%eax)
  80110d:	eb 56                	jmp    801165 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80110f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801113:	75 1f                	jne    801134 <readline+0xc5>
  801115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801119:	7e 19                	jle    801134 <readline+0xc5>
			if (echoing)
  80111b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80111f:	74 0e                	je     80112f <readline+0xc0>
				cputchar(c);
  801121:	83 ec 0c             	sub    $0xc,%esp
  801124:	ff 75 ec             	pushl  -0x14(%ebp)
  801127:	e8 1e f4 ff ff       	call   80054a <cputchar>
  80112c:	83 c4 10             	add    $0x10,%esp

			i--;
  80112f:	ff 4d f4             	decl   -0xc(%ebp)
  801132:	eb 31                	jmp    801165 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801134:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801138:	74 0a                	je     801144 <readline+0xd5>
  80113a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80113e:	0f 85 61 ff ff ff    	jne    8010a5 <readline+0x36>
			if (echoing)
  801144:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801148:	74 0e                	je     801158 <readline+0xe9>
				cputchar(c);
  80114a:	83 ec 0c             	sub    $0xc,%esp
  80114d:	ff 75 ec             	pushl  -0x14(%ebp)
  801150:	e8 f5 f3 ff ff       	call   80054a <cputchar>
  801155:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801163:	eb 06                	jmp    80116b <readline+0xfc>
		}
	}
  801165:	e9 3b ff ff ff       	jmp    8010a5 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  80116a:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801173:	e8 1b 0b 00 00       	call   801c93 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801178:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117c:	74 13                	je     801191 <atomic_readline+0x24>
		cprintf("%s", prompt);
  80117e:	83 ec 08             	sub    $0x8,%esp
  801181:	ff 75 08             	pushl  0x8(%ebp)
  801184:	68 b0 2a 80 00       	push   $0x802ab0
  801189:	e8 5f f8 ff ff       	call   8009ed <cprintf>
  80118e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	6a 00                	push   $0x0
  80119d:	e8 3e f4 ff ff       	call   8005e0 <iscons>
  8011a2:	83 c4 10             	add    $0x10,%esp
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011a8:	e8 e5 f3 ff ff       	call   800592 <getchar>
  8011ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011b4:	79 23                	jns    8011d9 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011b6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011ba:	74 13                	je     8011cf <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011bc:	83 ec 08             	sub    $0x8,%esp
  8011bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8011c2:	68 b3 2a 80 00       	push   $0x802ab3
  8011c7:	e8 21 f8 ff ff       	call   8009ed <cprintf>
  8011cc:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011cf:	e8 d9 0a 00 00       	call   801cad <sys_enable_interrupt>
			return;
  8011d4:	e9 9a 00 00 00       	jmp    801273 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011d9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011dd:	7e 34                	jle    801213 <atomic_readline+0xa6>
  8011df:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011e6:	7f 2b                	jg     801213 <atomic_readline+0xa6>
			if (echoing)
  8011e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011ec:	74 0e                	je     8011fc <atomic_readline+0x8f>
				cputchar(c);
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8011f4:	e8 51 f3 ff ff       	call   80054a <cputchar>
  8011f9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ff:	8d 50 01             	lea    0x1(%eax),%edx
  801202:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801205:	89 c2                	mov    %eax,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	01 d0                	add    %edx,%eax
  80120c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80120f:	88 10                	mov    %dl,(%eax)
  801211:	eb 5b                	jmp    80126e <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801213:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801217:	75 1f                	jne    801238 <atomic_readline+0xcb>
  801219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80121d:	7e 19                	jle    801238 <atomic_readline+0xcb>
			if (echoing)
  80121f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801223:	74 0e                	je     801233 <atomic_readline+0xc6>
				cputchar(c);
  801225:	83 ec 0c             	sub    $0xc,%esp
  801228:	ff 75 ec             	pushl  -0x14(%ebp)
  80122b:	e8 1a f3 ff ff       	call   80054a <cputchar>
  801230:	83 c4 10             	add    $0x10,%esp
			i--;
  801233:	ff 4d f4             	decl   -0xc(%ebp)
  801236:	eb 36                	jmp    80126e <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801238:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80123c:	74 0a                	je     801248 <atomic_readline+0xdb>
  80123e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801242:	0f 85 60 ff ff ff    	jne    8011a8 <atomic_readline+0x3b>
			if (echoing)
  801248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124c:	74 0e                	je     80125c <atomic_readline+0xef>
				cputchar(c);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 ec             	pushl  -0x14(%ebp)
  801254:	e8 f1 f2 ff ff       	call   80054a <cputchar>
  801259:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801267:	e8 41 0a 00 00       	call   801cad <sys_enable_interrupt>
			return;
  80126c:	eb 05                	jmp    801273 <atomic_readline+0x106>
		}
	}
  80126e:	e9 35 ff ff ff       	jmp    8011a8 <atomic_readline+0x3b>
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801282:	eb 06                	jmp    80128a <strlen+0x15>
		n++;
  801284:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	75 f1                	jne    801284 <strlen+0xf>
		n++;
	return n;
  801293:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80129e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a5:	eb 09                	jmp    8012b0 <strnlen+0x18>
		n++;
  8012a7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012aa:	ff 45 08             	incl   0x8(%ebp)
  8012ad:	ff 4d 0c             	decl   0xc(%ebp)
  8012b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b4:	74 09                	je     8012bf <strnlen+0x27>
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	75 e8                	jne    8012a7 <strnlen+0xf>
		n++;
	return n;
  8012bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012d0:	90                   	nop
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8d 50 01             	lea    0x1(%eax),%edx
  8012d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8012da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012e3:	8a 12                	mov    (%edx),%dl
  8012e5:	88 10                	mov    %dl,(%eax)
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	75 e4                	jne    8012d1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801305:	eb 1f                	jmp    801326 <strncpy+0x34>
		*dst++ = *src;
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8d 50 01             	lea    0x1(%eax),%edx
  80130d:	89 55 08             	mov    %edx,0x8(%ebp)
  801310:	8b 55 0c             	mov    0xc(%ebp),%edx
  801313:	8a 12                	mov    (%edx),%dl
  801315:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	84 c0                	test   %al,%al
  80131e:	74 03                	je     801323 <strncpy+0x31>
			src++;
  801320:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801323:	ff 45 fc             	incl   -0x4(%ebp)
  801326:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801329:	3b 45 10             	cmp    0x10(%ebp),%eax
  80132c:	72 d9                	jb     801307 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80132e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80133f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801343:	74 30                	je     801375 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801345:	eb 16                	jmp    80135d <strlcpy+0x2a>
			*dst++ = *src++;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8d 50 01             	lea    0x1(%eax),%edx
  80134d:	89 55 08             	mov    %edx,0x8(%ebp)
  801350:	8b 55 0c             	mov    0xc(%ebp),%edx
  801353:	8d 4a 01             	lea    0x1(%edx),%ecx
  801356:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801359:	8a 12                	mov    (%edx),%dl
  80135b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80135d:	ff 4d 10             	decl   0x10(%ebp)
  801360:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801364:	74 09                	je     80136f <strlcpy+0x3c>
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	8a 00                	mov    (%eax),%al
  80136b:	84 c0                	test   %al,%al
  80136d:	75 d8                	jne    801347 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801375:	8b 55 08             	mov    0x8(%ebp),%edx
  801378:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137b:	29 c2                	sub    %eax,%edx
  80137d:	89 d0                	mov    %edx,%eax
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801384:	eb 06                	jmp    80138c <strcmp+0xb>
		p++, q++;
  801386:	ff 45 08             	incl   0x8(%ebp)
  801389:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	84 c0                	test   %al,%al
  801393:	74 0e                	je     8013a3 <strcmp+0x22>
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 10                	mov    (%eax),%dl
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	38 c2                	cmp    %al,%dl
  8013a1:	74 e3                	je     801386 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 00                	mov    (%eax),%al
  8013a8:	0f b6 d0             	movzbl %al,%edx
  8013ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	0f b6 c0             	movzbl %al,%eax
  8013b3:	29 c2                	sub    %eax,%edx
  8013b5:	89 d0                	mov    %edx,%eax
}
  8013b7:	5d                   	pop    %ebp
  8013b8:	c3                   	ret    

008013b9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013bc:	eb 09                	jmp    8013c7 <strncmp+0xe>
		n--, p++, q++;
  8013be:	ff 4d 10             	decl   0x10(%ebp)
  8013c1:	ff 45 08             	incl   0x8(%ebp)
  8013c4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cb:	74 17                	je     8013e4 <strncmp+0x2b>
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	84 c0                	test   %al,%al
  8013d4:	74 0e                	je     8013e4 <strncmp+0x2b>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 10                	mov    (%eax),%dl
  8013db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	38 c2                	cmp    %al,%dl
  8013e2:	74 da                	je     8013be <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e8:	75 07                	jne    8013f1 <strncmp+0x38>
		return 0;
  8013ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ef:	eb 14                	jmp    801405 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	0f b6 d0             	movzbl %al,%edx
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	0f b6 c0             	movzbl %al,%eax
  801401:	29 c2                	sub    %eax,%edx
  801403:	89 d0                	mov    %edx,%eax
}
  801405:	5d                   	pop    %ebp
  801406:	c3                   	ret    

00801407 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	83 ec 04             	sub    $0x4,%esp
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801413:	eb 12                	jmp    801427 <strchr+0x20>
		if (*s == c)
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8a 00                	mov    (%eax),%al
  80141a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141d:	75 05                	jne    801424 <strchr+0x1d>
			return (char *) s;
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	eb 11                	jmp    801435 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801424:	ff 45 08             	incl   0x8(%ebp)
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	84 c0                	test   %al,%al
  80142e:	75 e5                	jne    801415 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801440:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801443:	eb 0d                	jmp    801452 <strfind+0x1b>
		if (*s == c)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80144d:	74 0e                	je     80145d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	84 c0                	test   %al,%al
  801459:	75 ea                	jne    801445 <strfind+0xe>
  80145b:	eb 01                	jmp    80145e <strfind+0x27>
		if (*s == c)
			break;
  80145d:	90                   	nop
	return (char *) s;
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80146f:	8b 45 10             	mov    0x10(%ebp),%eax
  801472:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801475:	eb 0e                	jmp    801485 <memset+0x22>
		*p++ = c;
  801477:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147a:	8d 50 01             	lea    0x1(%eax),%edx
  80147d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801480:	8b 55 0c             	mov    0xc(%ebp),%edx
  801483:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801485:	ff 4d f8             	decl   -0x8(%ebp)
  801488:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80148c:	79 e9                	jns    801477 <memset+0x14>
		*p++ = c;

	return v;
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014a5:	eb 16                	jmp    8014bd <memcpy+0x2a>
		*d++ = *s++;
  8014a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014aa:	8d 50 01             	lea    0x1(%eax),%edx
  8014ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014b6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014b9:	8a 12                	mov    (%edx),%dl
  8014bb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	75 dd                	jne    8014a7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e7:	73 50                	jae    801539 <memmove+0x6a>
  8014e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ef:	01 d0                	add    %edx,%eax
  8014f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014f4:	76 43                	jbe    801539 <memmove+0x6a>
		s += n;
  8014f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ff:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801502:	eb 10                	jmp    801514 <memmove+0x45>
			*--d = *--s;
  801504:	ff 4d f8             	decl   -0x8(%ebp)
  801507:	ff 4d fc             	decl   -0x4(%ebp)
  80150a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80150d:	8a 10                	mov    (%eax),%dl
  80150f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801512:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801514:	8b 45 10             	mov    0x10(%ebp),%eax
  801517:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151a:	89 55 10             	mov    %edx,0x10(%ebp)
  80151d:	85 c0                	test   %eax,%eax
  80151f:	75 e3                	jne    801504 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801521:	eb 23                	jmp    801546 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801523:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801526:	8d 50 01             	lea    0x1(%eax),%edx
  801529:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80152c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80152f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801532:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801535:	8a 12                	mov    (%edx),%dl
  801537:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801539:	8b 45 10             	mov    0x10(%ebp),%eax
  80153c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80153f:	89 55 10             	mov    %edx,0x10(%ebp)
  801542:	85 c0                	test   %eax,%eax
  801544:	75 dd                	jne    801523 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80155d:	eb 2a                	jmp    801589 <memcmp+0x3e>
		if (*s1 != *s2)
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8a 10                	mov    (%eax),%dl
  801564:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	38 c2                	cmp    %al,%dl
  80156b:	74 16                	je     801583 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80156d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801570:	8a 00                	mov    (%eax),%al
  801572:	0f b6 d0             	movzbl %al,%edx
  801575:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801578:	8a 00                	mov    (%eax),%al
  80157a:	0f b6 c0             	movzbl %al,%eax
  80157d:	29 c2                	sub    %eax,%edx
  80157f:	89 d0                	mov    %edx,%eax
  801581:	eb 18                	jmp    80159b <memcmp+0x50>
		s1++, s2++;
  801583:	ff 45 fc             	incl   -0x4(%ebp)
  801586:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801589:	8b 45 10             	mov    0x10(%ebp),%eax
  80158c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80158f:	89 55 10             	mov    %edx,0x10(%ebp)
  801592:	85 c0                	test   %eax,%eax
  801594:	75 c9                	jne    80155f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801596:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a9:	01 d0                	add    %edx,%eax
  8015ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015ae:	eb 15                	jmp    8015c5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8a 00                	mov    (%eax),%al
  8015b5:	0f b6 d0             	movzbl %al,%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	0f b6 c0             	movzbl %al,%eax
  8015be:	39 c2                	cmp    %eax,%edx
  8015c0:	74 0d                	je     8015cf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015cb:	72 e3                	jb     8015b0 <memfind+0x13>
  8015cd:	eb 01                	jmp    8015d0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015cf:	90                   	nop
	return (void *) s;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e9:	eb 03                	jmp    8015ee <strtol+0x19>
		s++;
  8015eb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8a 00                	mov    (%eax),%al
  8015f3:	3c 20                	cmp    $0x20,%al
  8015f5:	74 f4                	je     8015eb <strtol+0x16>
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	3c 09                	cmp    $0x9,%al
  8015fe:	74 eb                	je     8015eb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	8a 00                	mov    (%eax),%al
  801605:	3c 2b                	cmp    $0x2b,%al
  801607:	75 05                	jne    80160e <strtol+0x39>
		s++;
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	eb 13                	jmp    801621 <strtol+0x4c>
	else if (*s == '-')
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	8a 00                	mov    (%eax),%al
  801613:	3c 2d                	cmp    $0x2d,%al
  801615:	75 0a                	jne    801621 <strtol+0x4c>
		s++, neg = 1;
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801621:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801625:	74 06                	je     80162d <strtol+0x58>
  801627:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80162b:	75 20                	jne    80164d <strtol+0x78>
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8a 00                	mov    (%eax),%al
  801632:	3c 30                	cmp    $0x30,%al
  801634:	75 17                	jne    80164d <strtol+0x78>
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	40                   	inc    %eax
  80163a:	8a 00                	mov    (%eax),%al
  80163c:	3c 78                	cmp    $0x78,%al
  80163e:	75 0d                	jne    80164d <strtol+0x78>
		s += 2, base = 16;
  801640:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801644:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80164b:	eb 28                	jmp    801675 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	75 15                	jne    801668 <strtol+0x93>
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8a 00                	mov    (%eax),%al
  801658:	3c 30                	cmp    $0x30,%al
  80165a:	75 0c                	jne    801668 <strtol+0x93>
		s++, base = 8;
  80165c:	ff 45 08             	incl   0x8(%ebp)
  80165f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801666:	eb 0d                	jmp    801675 <strtol+0xa0>
	else if (base == 0)
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	75 07                	jne    801675 <strtol+0xa0>
		base = 10;
  80166e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	3c 2f                	cmp    $0x2f,%al
  80167c:	7e 19                	jle    801697 <strtol+0xc2>
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 39                	cmp    $0x39,%al
  801685:	7f 10                	jg     801697 <strtol+0xc2>
			dig = *s - '0';
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	8a 00                	mov    (%eax),%al
  80168c:	0f be c0             	movsbl %al,%eax
  80168f:	83 e8 30             	sub    $0x30,%eax
  801692:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801695:	eb 42                	jmp    8016d9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8a 00                	mov    (%eax),%al
  80169c:	3c 60                	cmp    $0x60,%al
  80169e:	7e 19                	jle    8016b9 <strtol+0xe4>
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	8a 00                	mov    (%eax),%al
  8016a5:	3c 7a                	cmp    $0x7a,%al
  8016a7:	7f 10                	jg     8016b9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	8a 00                	mov    (%eax),%al
  8016ae:	0f be c0             	movsbl %al,%eax
  8016b1:	83 e8 57             	sub    $0x57,%eax
  8016b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b7:	eb 20                	jmp    8016d9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	3c 40                	cmp    $0x40,%al
  8016c0:	7e 39                	jle    8016fb <strtol+0x126>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	3c 5a                	cmp    $0x5a,%al
  8016c9:	7f 30                	jg     8016fb <strtol+0x126>
			dig = *s - 'A' + 10;
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	8a 00                	mov    (%eax),%al
  8016d0:	0f be c0             	movsbl %al,%eax
  8016d3:	83 e8 37             	sub    $0x37,%eax
  8016d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016df:	7d 19                	jge    8016fa <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016e1:	ff 45 08             	incl   0x8(%ebp)
  8016e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016eb:	89 c2                	mov    %eax,%edx
  8016ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016f5:	e9 7b ff ff ff       	jmp    801675 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016fa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ff:	74 08                	je     801709 <strtol+0x134>
		*endptr = (char *) s;
  801701:	8b 45 0c             	mov    0xc(%ebp),%eax
  801704:	8b 55 08             	mov    0x8(%ebp),%edx
  801707:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801709:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80170d:	74 07                	je     801716 <strtol+0x141>
  80170f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801712:	f7 d8                	neg    %eax
  801714:	eb 03                	jmp    801719 <strtol+0x144>
  801716:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <ltostr>:

void
ltostr(long value, char *str)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801721:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801728:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80172f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801733:	79 13                	jns    801748 <ltostr+0x2d>
	{
		neg = 1;
  801735:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80173c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801742:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801745:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801750:	99                   	cltd   
  801751:	f7 f9                	idiv   %ecx
  801753:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	8d 50 01             	lea    0x1(%eax),%edx
  80175c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80175f:	89 c2                	mov    %eax,%edx
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	01 d0                	add    %edx,%eax
  801766:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801769:	83 c2 30             	add    $0x30,%edx
  80176c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80176e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801771:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801776:	f7 e9                	imul   %ecx
  801778:	c1 fa 02             	sar    $0x2,%edx
  80177b:	89 c8                	mov    %ecx,%eax
  80177d:	c1 f8 1f             	sar    $0x1f,%eax
  801780:	29 c2                	sub    %eax,%edx
  801782:	89 d0                	mov    %edx,%eax
  801784:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801787:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80178a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80178f:	f7 e9                	imul   %ecx
  801791:	c1 fa 02             	sar    $0x2,%edx
  801794:	89 c8                	mov    %ecx,%eax
  801796:	c1 f8 1f             	sar    $0x1f,%eax
  801799:	29 c2                	sub    %eax,%edx
  80179b:	89 d0                	mov    %edx,%eax
  80179d:	c1 e0 02             	shl    $0x2,%eax
  8017a0:	01 d0                	add    %edx,%eax
  8017a2:	01 c0                	add    %eax,%eax
  8017a4:	29 c1                	sub    %eax,%ecx
  8017a6:	89 ca                	mov    %ecx,%edx
  8017a8:	85 d2                	test   %edx,%edx
  8017aa:	75 9c                	jne    801748 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b6:	48                   	dec    %eax
  8017b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017be:	74 3d                	je     8017fd <ltostr+0xe2>
		start = 1 ;
  8017c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017c7:	eb 34                	jmp    8017fd <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cf:	01 d0                	add    %edx,%eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dc:	01 c2                	add    %eax,%edx
  8017de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	01 c8                	add    %ecx,%eax
  8017e6:	8a 00                	mov    (%eax),%al
  8017e8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	01 c2                	add    %eax,%edx
  8017f2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017f5:	88 02                	mov    %al,(%edx)
		start++ ;
  8017f7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017fa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801800:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801803:	7c c4                	jl     8017c9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801805:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180b:	01 d0                	add    %edx,%eax
  80180d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801819:	ff 75 08             	pushl  0x8(%ebp)
  80181c:	e8 54 fa ff ff       	call   801275 <strlen>
  801821:	83 c4 04             	add    $0x4,%esp
  801824:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	e8 46 fa ff ff       	call   801275 <strlen>
  80182f:	83 c4 04             	add    $0x4,%esp
  801832:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80183c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801843:	eb 17                	jmp    80185c <strcconcat+0x49>
		final[s] = str1[s] ;
  801845:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801848:	8b 45 10             	mov    0x10(%ebp),%eax
  80184b:	01 c2                	add    %eax,%edx
  80184d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	01 c8                	add    %ecx,%eax
  801855:	8a 00                	mov    (%eax),%al
  801857:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801859:	ff 45 fc             	incl   -0x4(%ebp)
  80185c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801862:	7c e1                	jl     801845 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801864:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80186b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801872:	eb 1f                	jmp    801893 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801874:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801877:	8d 50 01             	lea    0x1(%eax),%edx
  80187a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80187d:	89 c2                	mov    %eax,%edx
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	01 c2                	add    %eax,%edx
  801884:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188a:	01 c8                	add    %ecx,%eax
  80188c:	8a 00                	mov    (%eax),%al
  80188e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801890:	ff 45 f8             	incl   -0x8(%ebp)
  801893:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801896:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801899:	7c d9                	jl     801874 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80189b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189e:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a1:	01 d0                	add    %edx,%eax
  8018a3:	c6 00 00             	movb   $0x0,(%eax)
}
  8018a6:	90                   	nop
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8018af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b8:	8b 00                	mov    (%eax),%eax
  8018ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c4:	01 d0                	add    %edx,%eax
  8018c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018cc:	eb 0c                	jmp    8018da <strsplit+0x31>
			*string++ = 0;
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	8d 50 01             	lea    0x1(%eax),%edx
  8018d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	8a 00                	mov    (%eax),%al
  8018df:	84 c0                	test   %al,%al
  8018e1:	74 18                	je     8018fb <strsplit+0x52>
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	8a 00                	mov    (%eax),%al
  8018e8:	0f be c0             	movsbl %al,%eax
  8018eb:	50                   	push   %eax
  8018ec:	ff 75 0c             	pushl  0xc(%ebp)
  8018ef:	e8 13 fb ff ff       	call   801407 <strchr>
  8018f4:	83 c4 08             	add    $0x8,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	75 d3                	jne    8018ce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	8a 00                	mov    (%eax),%al
  801900:	84 c0                	test   %al,%al
  801902:	74 5a                	je     80195e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	8b 00                	mov    (%eax),%eax
  801909:	83 f8 0f             	cmp    $0xf,%eax
  80190c:	75 07                	jne    801915 <strsplit+0x6c>
		{
			return 0;
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax
  801913:	eb 66                	jmp    80197b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801915:	8b 45 14             	mov    0x14(%ebp),%eax
  801918:	8b 00                	mov    (%eax),%eax
  80191a:	8d 48 01             	lea    0x1(%eax),%ecx
  80191d:	8b 55 14             	mov    0x14(%ebp),%edx
  801920:	89 0a                	mov    %ecx,(%edx)
  801922:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801929:	8b 45 10             	mov    0x10(%ebp),%eax
  80192c:	01 c2                	add    %eax,%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801933:	eb 03                	jmp    801938 <strsplit+0x8f>
			string++;
  801935:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	8a 00                	mov    (%eax),%al
  80193d:	84 c0                	test   %al,%al
  80193f:	74 8b                	je     8018cc <strsplit+0x23>
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	8a 00                	mov    (%eax),%al
  801946:	0f be c0             	movsbl %al,%eax
  801949:	50                   	push   %eax
  80194a:	ff 75 0c             	pushl  0xc(%ebp)
  80194d:	e8 b5 fa ff ff       	call   801407 <strchr>
  801952:	83 c4 08             	add    $0x8,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	74 dc                	je     801935 <strsplit+0x8c>
			string++;
	}
  801959:	e9 6e ff ff ff       	jmp    8018cc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80195e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80195f:	8b 45 14             	mov    0x14(%ebp),%eax
  801962:	8b 00                	mov    (%eax),%eax
  801964:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	01 d0                	add    %edx,%eax
  801970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801976:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	68 c4 2a 80 00       	push   $0x802ac4
  80198b:	6a 0e                	push   $0xe
  80198d:	68 fe 2a 80 00       	push   $0x802afe
  801992:	e8 a2 ed ff ff       	call   800739 <_panic>

00801997 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80199d:	a1 04 30 80 00       	mov    0x803004,%eax
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	74 0f                	je     8019b5 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8019a6:	e8 d2 ff ff ff       	call   80197d <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019ab:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8019b2:	00 00 00 
	}
	if (size == 0) return NULL ;
  8019b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019b9:	75 07                	jne    8019c2 <malloc+0x2b>
  8019bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c0:	eb 14                	jmp    8019d6 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	68 0c 2b 80 00       	push   $0x802b0c
  8019ca:	6a 2e                	push   $0x2e
  8019cc:	68 fe 2a 80 00       	push   $0x802afe
  8019d1:	e8 63 ed ff ff       	call   800739 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	68 34 2b 80 00       	push   $0x802b34
  8019e6:	6a 49                	push   $0x49
  8019e8:	68 fe 2a 80 00       	push   $0x802afe
  8019ed:	e8 47 ed ff ff       	call   800739 <_panic>

008019f2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 18             	sub    $0x18,%esp
  8019f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fb:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	68 58 2b 80 00       	push   $0x802b58
  801a06:	6a 57                	push   $0x57
  801a08:	68 fe 2a 80 00       	push   $0x802afe
  801a0d:	e8 27 ed ff ff       	call   800739 <_panic>

00801a12 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a18:	83 ec 04             	sub    $0x4,%esp
  801a1b:	68 80 2b 80 00       	push   $0x802b80
  801a20:	6a 60                	push   $0x60
  801a22:	68 fe 2a 80 00       	push   $0x802afe
  801a27:	e8 0d ed ff ff       	call   800739 <_panic>

00801a2c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	68 a4 2b 80 00       	push   $0x802ba4
  801a3a:	6a 7c                	push   $0x7c
  801a3c:	68 fe 2a 80 00       	push   $0x802afe
  801a41:	e8 f3 ec ff ff       	call   800739 <_panic>

00801a46 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	68 cc 2b 80 00       	push   $0x802bcc
  801a54:	68 86 00 00 00       	push   $0x86
  801a59:	68 fe 2a 80 00       	push   $0x802afe
  801a5e:	e8 d6 ec ff ff       	call   800739 <_panic>

00801a63 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 f0 2b 80 00       	push   $0x802bf0
  801a71:	68 91 00 00 00       	push   $0x91
  801a76:	68 fe 2a 80 00       	push   $0x802afe
  801a7b:	e8 b9 ec ff ff       	call   800739 <_panic>

00801a80 <shrink>:

}
void shrink(uint32 newSize)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	68 f0 2b 80 00       	push   $0x802bf0
  801a8e:	68 96 00 00 00       	push   $0x96
  801a93:	68 fe 2a 80 00       	push   $0x802afe
  801a98:	e8 9c ec ff ff       	call   800739 <_panic>

00801a9d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	68 f0 2b 80 00       	push   $0x802bf0
  801aab:	68 9b 00 00 00       	push   $0x9b
  801ab0:	68 fe 2a 80 00       	push   $0x802afe
  801ab5:	e8 7f ec ff ff       	call   800739 <_panic>

00801aba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	57                   	push   %edi
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801acc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801acf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ad2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ad5:	cd 30                	int    $0x30
  801ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5e                   	pop    %esi
  801ae2:	5f                   	pop    %edi
  801ae3:	5d                   	pop    %ebp
  801ae4:	c3                   	ret    

00801ae5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  801aee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801af1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	52                   	push   %edx
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	50                   	push   %eax
  801b01:	6a 00                	push   $0x0
  801b03:	e8 b2 ff ff ff       	call   801aba <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	90                   	nop
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_cgetc>:

int
sys_cgetc(void)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 01                	push   $0x1
  801b1d:	e8 98 ff ff ff       	call   801aba <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	52                   	push   %edx
  801b37:	50                   	push   %eax
  801b38:	6a 05                	push   $0x5
  801b3a:	e8 7b ff ff ff       	call   801aba <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	56                   	push   %esi
  801b48:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b49:	8b 75 18             	mov    0x18(%ebp),%esi
  801b4c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	56                   	push   %esi
  801b59:	53                   	push   %ebx
  801b5a:	51                   	push   %ecx
  801b5b:	52                   	push   %edx
  801b5c:	50                   	push   %eax
  801b5d:	6a 06                	push   $0x6
  801b5f:	e8 56 ff ff ff       	call   801aba <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6a:	5b                   	pop    %ebx
  801b6b:	5e                   	pop    %esi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    

00801b6e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	52                   	push   %edx
  801b7e:	50                   	push   %eax
  801b7f:	6a 07                	push   $0x7
  801b81:	e8 34 ff ff ff       	call   801aba <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 0c             	pushl  0xc(%ebp)
  801b97:	ff 75 08             	pushl  0x8(%ebp)
  801b9a:	6a 08                	push   $0x8
  801b9c:	e8 19 ff ff ff       	call   801aba <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 09                	push   $0x9
  801bb5:	e8 00 ff ff ff       	call   801aba <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 0a                	push   $0xa
  801bce:	e8 e7 fe ff ff       	call   801aba <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 0b                	push   $0xb
  801be7:	e8 ce fe ff ff       	call   801aba <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	ff 75 08             	pushl  0x8(%ebp)
  801c00:	6a 0f                	push   $0xf
  801c02:	e8 b3 fe ff ff       	call   801aba <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
	return;
  801c0a:	90                   	nop
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	ff 75 08             	pushl  0x8(%ebp)
  801c1c:	6a 10                	push   $0x10
  801c1e:	e8 97 fe ff ff       	call   801aba <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return ;
  801c26:	90                   	nop
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	ff 75 10             	pushl  0x10(%ebp)
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	ff 75 08             	pushl  0x8(%ebp)
  801c39:	6a 11                	push   $0x11
  801c3b:	e8 7a fe ff ff       	call   801aba <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
	return ;
  801c43:	90                   	nop
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 0c                	push   $0xc
  801c55:	e8 60 fe ff ff       	call   801aba <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	ff 75 08             	pushl  0x8(%ebp)
  801c6d:	6a 0d                	push   $0xd
  801c6f:	e8 46 fe ff ff       	call   801aba <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 0e                	push   $0xe
  801c88:	e8 2d fe ff ff       	call   801aba <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	90                   	nop
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 13                	push   $0x13
  801ca2:	e8 13 fe ff ff       	call   801aba <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	90                   	nop
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 14                	push   $0x14
  801cbc:	e8 f9 fd ff ff       	call   801aba <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cd3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	50                   	push   %eax
  801ce0:	6a 15                	push   $0x15
  801ce2:	e8 d3 fd ff ff       	call   801aba <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	90                   	nop
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 16                	push   $0x16
  801cfc:	e8 b9 fd ff ff       	call   801aba <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	90                   	nop
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	50                   	push   %eax
  801d17:	6a 17                	push   $0x17
  801d19:	e8 9c fd ff ff       	call   801aba <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	52                   	push   %edx
  801d33:	50                   	push   %eax
  801d34:	6a 1a                	push   $0x1a
  801d36:	e8 7f fd ff ff       	call   801aba <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	52                   	push   %edx
  801d50:	50                   	push   %eax
  801d51:	6a 18                	push   $0x18
  801d53:	e8 62 fd ff ff       	call   801aba <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	90                   	nop
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 19                	push   $0x19
  801d71:	e8 44 fd ff ff       	call   801aba <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	90                   	nop
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	8b 45 10             	mov    0x10(%ebp),%eax
  801d85:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d88:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d8b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	6a 00                	push   $0x0
  801d94:	51                   	push   %ecx
  801d95:	52                   	push   %edx
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	50                   	push   %eax
  801d9a:	6a 1b                	push   $0x1b
  801d9c:	e8 19 fd ff ff       	call   801aba <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	52                   	push   %edx
  801db6:	50                   	push   %eax
  801db7:	6a 1c                	push   $0x1c
  801db9:	e8 fc fc ff ff       	call   801aba <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	51                   	push   %ecx
  801dd4:	52                   	push   %edx
  801dd5:	50                   	push   %eax
  801dd6:	6a 1d                	push   $0x1d
  801dd8:	e8 dd fc ff ff       	call   801aba <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	52                   	push   %edx
  801df2:	50                   	push   %eax
  801df3:	6a 1e                	push   $0x1e
  801df5:	e8 c0 fc ff ff       	call   801aba <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 1f                	push   $0x1f
  801e0e:	e8 a7 fc ff ff       	call   801aba <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	ff 75 14             	pushl  0x14(%ebp)
  801e23:	ff 75 10             	pushl  0x10(%ebp)
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	50                   	push   %eax
  801e2a:	6a 20                	push   $0x20
  801e2c:	e8 89 fc ff ff       	call   801aba <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	50                   	push   %eax
  801e45:	6a 21                	push   $0x21
  801e47:	e8 6e fc ff ff       	call   801aba <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	50                   	push   %eax
  801e61:	6a 22                	push   $0x22
  801e63:	e8 52 fc ff ff       	call   801aba <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 02                	push   $0x2
  801e7c:	e8 39 fc ff ff       	call   801aba <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 03                	push   $0x3
  801e95:	e8 20 fc ff ff       	call   801aba <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 04                	push   $0x4
  801eae:	e8 07 fc ff ff       	call   801aba <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_exit_env>:


void sys_exit_env(void)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 23                	push   $0x23
  801ec7:	e8 ee fb ff ff       	call   801aba <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ed8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801edb:	8d 50 04             	lea    0x4(%eax),%edx
  801ede:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 24                	push   $0x24
  801eeb:	e8 ca fb ff ff       	call   801aba <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
	return result;
  801ef3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ef9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801efc:	89 01                	mov    %eax,(%ecx)
  801efe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	c9                   	leave  
  801f05:	c2 04 00             	ret    $0x4

00801f08 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	ff 75 10             	pushl  0x10(%ebp)
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	ff 75 08             	pushl  0x8(%ebp)
  801f18:	6a 12                	push   $0x12
  801f1a:	e8 9b fb ff ff       	call   801aba <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f22:	90                   	nop
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 25                	push   $0x25
  801f34:	e8 81 fb ff ff       	call   801aba <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 04             	sub    $0x4,%esp
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f4a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	50                   	push   %eax
  801f57:	6a 26                	push   $0x26
  801f59:	e8 5c fb ff ff       	call   801aba <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f61:	90                   	nop
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <rsttst>:
void rsttst()
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 28                	push   $0x28
  801f73:	e8 42 fb ff ff       	call   801aba <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7b:	90                   	nop
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	8b 45 14             	mov    0x14(%ebp),%eax
  801f87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f8a:	8b 55 18             	mov    0x18(%ebp),%edx
  801f8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f91:	52                   	push   %edx
  801f92:	50                   	push   %eax
  801f93:	ff 75 10             	pushl  0x10(%ebp)
  801f96:	ff 75 0c             	pushl  0xc(%ebp)
  801f99:	ff 75 08             	pushl  0x8(%ebp)
  801f9c:	6a 27                	push   $0x27
  801f9e:	e8 17 fb ff ff       	call   801aba <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa6:	90                   	nop
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <chktst>:
void chktst(uint32 n)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	ff 75 08             	pushl  0x8(%ebp)
  801fb7:	6a 29                	push   $0x29
  801fb9:	e8 fc fa ff ff       	call   801aba <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc1:	90                   	nop
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <inctst>:

void inctst()
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 2a                	push   $0x2a
  801fd3:	e8 e2 fa ff ff       	call   801aba <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdb:	90                   	nop
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <gettst>:
uint32 gettst()
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 2b                	push   $0x2b
  801fed:	e8 c8 fa ff ff       	call   801aba <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 2c                	push   $0x2c
  802009:	e8 ac fa ff ff       	call   801aba <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
  802011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802014:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802018:	75 07                	jne    802021 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80201a:	b8 01 00 00 00       	mov    $0x1,%eax
  80201f:	eb 05                	jmp    802026 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 2c                	push   $0x2c
  80203a:	e8 7b fa ff ff       	call   801aba <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
  802042:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802045:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802049:	75 07                	jne    802052 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80204b:	b8 01 00 00 00       	mov    $0x1,%eax
  802050:	eb 05                	jmp    802057 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 2c                	push   $0x2c
  80206b:	e8 4a fa ff ff       	call   801aba <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
  802073:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802076:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80207a:	75 07                	jne    802083 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80207c:	b8 01 00 00 00       	mov    $0x1,%eax
  802081:	eb 05                	jmp    802088 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 2c                	push   $0x2c
  80209c:	e8 19 fa ff ff       	call   801aba <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
  8020a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020a7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020ab:	75 07                	jne    8020b4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b2:	eb 05                	jmp    8020b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	ff 75 08             	pushl  0x8(%ebp)
  8020c9:	6a 2d                	push   $0x2d
  8020cb:	e8 ea f9 ff ff       	call   801aba <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d3:	90                   	nop
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	53                   	push   %ebx
  8020e9:	51                   	push   %ecx
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 2e                	push   $0x2e
  8020ee:	e8 c7 f9 ff ff       	call   801aba <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	52                   	push   %edx
  80210b:	50                   	push   %eax
  80210c:	6a 2f                	push   $0x2f
  80210e:	e8 a7 f9 ff ff       	call   801aba <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <__udivdi3>:
  802118:	55                   	push   %ebp
  802119:	57                   	push   %edi
  80211a:	56                   	push   %esi
  80211b:	53                   	push   %ebx
  80211c:	83 ec 1c             	sub    $0x1c,%esp
  80211f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802123:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802127:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80212b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80212f:	89 ca                	mov    %ecx,%edx
  802131:	89 f8                	mov    %edi,%eax
  802133:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802137:	85 f6                	test   %esi,%esi
  802139:	75 2d                	jne    802168 <__udivdi3+0x50>
  80213b:	39 cf                	cmp    %ecx,%edi
  80213d:	77 65                	ja     8021a4 <__udivdi3+0x8c>
  80213f:	89 fd                	mov    %edi,%ebp
  802141:	85 ff                	test   %edi,%edi
  802143:	75 0b                	jne    802150 <__udivdi3+0x38>
  802145:	b8 01 00 00 00       	mov    $0x1,%eax
  80214a:	31 d2                	xor    %edx,%edx
  80214c:	f7 f7                	div    %edi
  80214e:	89 c5                	mov    %eax,%ebp
  802150:	31 d2                	xor    %edx,%edx
  802152:	89 c8                	mov    %ecx,%eax
  802154:	f7 f5                	div    %ebp
  802156:	89 c1                	mov    %eax,%ecx
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	f7 f5                	div    %ebp
  80215c:	89 cf                	mov    %ecx,%edi
  80215e:	89 fa                	mov    %edi,%edx
  802160:	83 c4 1c             	add    $0x1c,%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5f                   	pop    %edi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    
  802168:	39 ce                	cmp    %ecx,%esi
  80216a:	77 28                	ja     802194 <__udivdi3+0x7c>
  80216c:	0f bd fe             	bsr    %esi,%edi
  80216f:	83 f7 1f             	xor    $0x1f,%edi
  802172:	75 40                	jne    8021b4 <__udivdi3+0x9c>
  802174:	39 ce                	cmp    %ecx,%esi
  802176:	72 0a                	jb     802182 <__udivdi3+0x6a>
  802178:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80217c:	0f 87 9e 00 00 00    	ja     802220 <__udivdi3+0x108>
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	89 fa                	mov    %edi,%edx
  802189:	83 c4 1c             	add    $0x1c,%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5f                   	pop    %edi
  80218f:	5d                   	pop    %ebp
  802190:	c3                   	ret    
  802191:	8d 76 00             	lea    0x0(%esi),%esi
  802194:	31 ff                	xor    %edi,%edi
  802196:	31 c0                	xor    %eax,%eax
  802198:	89 fa                	mov    %edi,%edx
  80219a:	83 c4 1c             	add    $0x1c,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5f                   	pop    %edi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    
  8021a2:	66 90                	xchg   %ax,%ax
  8021a4:	89 d8                	mov    %ebx,%eax
  8021a6:	f7 f7                	div    %edi
  8021a8:	31 ff                	xor    %edi,%edi
  8021aa:	89 fa                	mov    %edi,%edx
  8021ac:	83 c4 1c             	add    $0x1c,%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    
  8021b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8021b9:	89 eb                	mov    %ebp,%ebx
  8021bb:	29 fb                	sub    %edi,%ebx
  8021bd:	89 f9                	mov    %edi,%ecx
  8021bf:	d3 e6                	shl    %cl,%esi
  8021c1:	89 c5                	mov    %eax,%ebp
  8021c3:	88 d9                	mov    %bl,%cl
  8021c5:	d3 ed                	shr    %cl,%ebp
  8021c7:	89 e9                	mov    %ebp,%ecx
  8021c9:	09 f1                	or     %esi,%ecx
  8021cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021cf:	89 f9                	mov    %edi,%ecx
  8021d1:	d3 e0                	shl    %cl,%eax
  8021d3:	89 c5                	mov    %eax,%ebp
  8021d5:	89 d6                	mov    %edx,%esi
  8021d7:	88 d9                	mov    %bl,%cl
  8021d9:	d3 ee                	shr    %cl,%esi
  8021db:	89 f9                	mov    %edi,%ecx
  8021dd:	d3 e2                	shl    %cl,%edx
  8021df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021e3:	88 d9                	mov    %bl,%cl
  8021e5:	d3 e8                	shr    %cl,%eax
  8021e7:	09 c2                	or     %eax,%edx
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	89 f2                	mov    %esi,%edx
  8021ed:	f7 74 24 0c          	divl   0xc(%esp)
  8021f1:	89 d6                	mov    %edx,%esi
  8021f3:	89 c3                	mov    %eax,%ebx
  8021f5:	f7 e5                	mul    %ebp
  8021f7:	39 d6                	cmp    %edx,%esi
  8021f9:	72 19                	jb     802214 <__udivdi3+0xfc>
  8021fb:	74 0b                	je     802208 <__udivdi3+0xf0>
  8021fd:	89 d8                	mov    %ebx,%eax
  8021ff:	31 ff                	xor    %edi,%edi
  802201:	e9 58 ff ff ff       	jmp    80215e <__udivdi3+0x46>
  802206:	66 90                	xchg   %ax,%ax
  802208:	8b 54 24 08          	mov    0x8(%esp),%edx
  80220c:	89 f9                	mov    %edi,%ecx
  80220e:	d3 e2                	shl    %cl,%edx
  802210:	39 c2                	cmp    %eax,%edx
  802212:	73 e9                	jae    8021fd <__udivdi3+0xe5>
  802214:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802217:	31 ff                	xor    %edi,%edi
  802219:	e9 40 ff ff ff       	jmp    80215e <__udivdi3+0x46>
  80221e:	66 90                	xchg   %ax,%ax
  802220:	31 c0                	xor    %eax,%eax
  802222:	e9 37 ff ff ff       	jmp    80215e <__udivdi3+0x46>
  802227:	90                   	nop

00802228 <__umoddi3>:
  802228:	55                   	push   %ebp
  802229:	57                   	push   %edi
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	83 ec 1c             	sub    $0x1c,%esp
  80222f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80223b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80223f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802243:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802247:	89 f3                	mov    %esi,%ebx
  802249:	89 fa                	mov    %edi,%edx
  80224b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80224f:	89 34 24             	mov    %esi,(%esp)
  802252:	85 c0                	test   %eax,%eax
  802254:	75 1a                	jne    802270 <__umoddi3+0x48>
  802256:	39 f7                	cmp    %esi,%edi
  802258:	0f 86 a2 00 00 00    	jbe    802300 <__umoddi3+0xd8>
  80225e:	89 c8                	mov    %ecx,%eax
  802260:	89 f2                	mov    %esi,%edx
  802262:	f7 f7                	div    %edi
  802264:	89 d0                	mov    %edx,%eax
  802266:	31 d2                	xor    %edx,%edx
  802268:	83 c4 1c             	add    $0x1c,%esp
  80226b:	5b                   	pop    %ebx
  80226c:	5e                   	pop    %esi
  80226d:	5f                   	pop    %edi
  80226e:	5d                   	pop    %ebp
  80226f:	c3                   	ret    
  802270:	39 f0                	cmp    %esi,%eax
  802272:	0f 87 ac 00 00 00    	ja     802324 <__umoddi3+0xfc>
  802278:	0f bd e8             	bsr    %eax,%ebp
  80227b:	83 f5 1f             	xor    $0x1f,%ebp
  80227e:	0f 84 ac 00 00 00    	je     802330 <__umoddi3+0x108>
  802284:	bf 20 00 00 00       	mov    $0x20,%edi
  802289:	29 ef                	sub    %ebp,%edi
  80228b:	89 fe                	mov    %edi,%esi
  80228d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802291:	89 e9                	mov    %ebp,%ecx
  802293:	d3 e0                	shl    %cl,%eax
  802295:	89 d7                	mov    %edx,%edi
  802297:	89 f1                	mov    %esi,%ecx
  802299:	d3 ef                	shr    %cl,%edi
  80229b:	09 c7                	or     %eax,%edi
  80229d:	89 e9                	mov    %ebp,%ecx
  80229f:	d3 e2                	shl    %cl,%edx
  8022a1:	89 14 24             	mov    %edx,(%esp)
  8022a4:	89 d8                	mov    %ebx,%eax
  8022a6:	d3 e0                	shl    %cl,%eax
  8022a8:	89 c2                	mov    %eax,%edx
  8022aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022ae:	d3 e0                	shl    %cl,%eax
  8022b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022b8:	89 f1                	mov    %esi,%ecx
  8022ba:	d3 e8                	shr    %cl,%eax
  8022bc:	09 d0                	or     %edx,%eax
  8022be:	d3 eb                	shr    %cl,%ebx
  8022c0:	89 da                	mov    %ebx,%edx
  8022c2:	f7 f7                	div    %edi
  8022c4:	89 d3                	mov    %edx,%ebx
  8022c6:	f7 24 24             	mull   (%esp)
  8022c9:	89 c6                	mov    %eax,%esi
  8022cb:	89 d1                	mov    %edx,%ecx
  8022cd:	39 d3                	cmp    %edx,%ebx
  8022cf:	0f 82 87 00 00 00    	jb     80235c <__umoddi3+0x134>
  8022d5:	0f 84 91 00 00 00    	je     80236c <__umoddi3+0x144>
  8022db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022df:	29 f2                	sub    %esi,%edx
  8022e1:	19 cb                	sbb    %ecx,%ebx
  8022e3:	89 d8                	mov    %ebx,%eax
  8022e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022e9:	d3 e0                	shl    %cl,%eax
  8022eb:	89 e9                	mov    %ebp,%ecx
  8022ed:	d3 ea                	shr    %cl,%edx
  8022ef:	09 d0                	or     %edx,%eax
  8022f1:	89 e9                	mov    %ebp,%ecx
  8022f3:	d3 eb                	shr    %cl,%ebx
  8022f5:	89 da                	mov    %ebx,%edx
  8022f7:	83 c4 1c             	add    $0x1c,%esp
  8022fa:	5b                   	pop    %ebx
  8022fb:	5e                   	pop    %esi
  8022fc:	5f                   	pop    %edi
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    
  8022ff:	90                   	nop
  802300:	89 fd                	mov    %edi,%ebp
  802302:	85 ff                	test   %edi,%edi
  802304:	75 0b                	jne    802311 <__umoddi3+0xe9>
  802306:	b8 01 00 00 00       	mov    $0x1,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f7                	div    %edi
  80230f:	89 c5                	mov    %eax,%ebp
  802311:	89 f0                	mov    %esi,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f5                	div    %ebp
  802317:	89 c8                	mov    %ecx,%eax
  802319:	f7 f5                	div    %ebp
  80231b:	89 d0                	mov    %edx,%eax
  80231d:	e9 44 ff ff ff       	jmp    802266 <__umoddi3+0x3e>
  802322:	66 90                	xchg   %ax,%ax
  802324:	89 c8                	mov    %ecx,%eax
  802326:	89 f2                	mov    %esi,%edx
  802328:	83 c4 1c             	add    $0x1c,%esp
  80232b:	5b                   	pop    %ebx
  80232c:	5e                   	pop    %esi
  80232d:	5f                   	pop    %edi
  80232e:	5d                   	pop    %ebp
  80232f:	c3                   	ret    
  802330:	3b 04 24             	cmp    (%esp),%eax
  802333:	72 06                	jb     80233b <__umoddi3+0x113>
  802335:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802339:	77 0f                	ja     80234a <__umoddi3+0x122>
  80233b:	89 f2                	mov    %esi,%edx
  80233d:	29 f9                	sub    %edi,%ecx
  80233f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802343:	89 14 24             	mov    %edx,(%esp)
  802346:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80234a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80234e:	8b 14 24             	mov    (%esp),%edx
  802351:	83 c4 1c             	add    $0x1c,%esp
  802354:	5b                   	pop    %ebx
  802355:	5e                   	pop    %esi
  802356:	5f                   	pop    %edi
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    
  802359:	8d 76 00             	lea    0x0(%esi),%esi
  80235c:	2b 04 24             	sub    (%esp),%eax
  80235f:	19 fa                	sbb    %edi,%edx
  802361:	89 d1                	mov    %edx,%ecx
  802363:	89 c6                	mov    %eax,%esi
  802365:	e9 71 ff ff ff       	jmp    8022db <__umoddi3+0xb3>
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802370:	72 ea                	jb     80235c <__umoddi3+0x134>
  802372:	89 d9                	mov    %ebx,%ecx
  802374:	e9 62 ff ff ff       	jmp    8022db <__umoddi3+0xb3>
