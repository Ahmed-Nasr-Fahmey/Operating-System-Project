
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 fe 1d 00 00       	call   801e44 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 25 80 00       	push   $0x802540
  80004e:	e8 4b 0b 00 00       	call   800b9e <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 25 80 00       	push   $0x802542
  80005e:	e8 3b 0b 00 00       	call   800b9e <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 25 80 00       	push   $0x802558
  80006e:	e8 2b 0b 00 00       	call   800b9e <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 25 80 00       	push   $0x802542
  80007e:	e8 1b 0b 00 00       	call   800b9e <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 25 80 00       	push   $0x802540
  80008e:	e8 0b 0b 00 00       	call   800b9e <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 25 80 00       	push   $0x802570
  8000a5:	e8 76 11 00 00       	call   801220 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 c6 16 00 00       	call   801786 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 73 1a 00 00       	call   801b48 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 90 25 80 00       	push   $0x802590
  8000e3:	e8 b6 0a 00 00       	call   800b9e <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b2 25 80 00       	push   $0x8025b2
  8000f3:	e8 a6 0a 00 00       	call   800b9e <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c0 25 80 00       	push   $0x8025c0
  800103:	e8 96 0a 00 00       	call   800b9e <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 cf 25 80 00       	push   $0x8025cf
  800113:	e8 86 0a 00 00       	call   800b9e <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 df 25 80 00       	push   $0x8025df
  800123:	e8 76 0a 00 00       	call   800b9e <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 f7 1c 00 00       	call   801e5e <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 68 1c 00 00       	call   801e44 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 e8 25 80 00       	push   $0x8025e8
  8001e4:	e8 b5 09 00 00       	call   800b9e <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 6d 1c 00 00       	call   801e5e <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 1c 26 80 00       	push   $0x80261c
  800213:	6a 4a                	push   $0x4a
  800215:	68 3e 26 80 00       	push   $0x80263e
  80021a:	e8 cb 06 00 00       	call   8008ea <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 20 1c 00 00       	call   801e44 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 58 26 80 00       	push   $0x802658
  80022c:	e8 6d 09 00 00       	call   800b9e <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 8c 26 80 00       	push   $0x80268c
  80023c:	e8 5d 09 00 00       	call   800b9e <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 c0 26 80 00       	push   $0x8026c0
  80024c:	e8 4d 09 00 00       	call   800b9e <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 05 1c 00 00       	call   801e5e <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 e6 1b 00 00       	call   801e44 <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 f2 26 80 00       	push   $0x8026f2
  80026c:	e8 2d 09 00 00       	call   800b9e <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 a7 1b 00 00       	call   801e5e <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 40 25 80 00       	push   $0x802540
  80044b:	e8 4e 07 00 00       	call   800b9e <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 10 27 80 00       	push   $0x802710
  80046d:	e8 2c 07 00 00       	call   800b9e <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 15 27 80 00       	push   $0x802715
  80049b:	e8 fe 06 00 00       	call   800b9e <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 07 16 00 00       	call   801b48 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 f2 15 00 00       	call   801b48 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 64 17 00 00       	call   801e78 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 1f 17 00 00       	call   801e44 <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 40 17 00 00       	call   801e78 <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 1e 17 00 00       	call   801e5e <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 68 15 00 00       	call   801cbf <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 d4 16 00 00       	call   801e44 <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 41 15 00 00       	call   801cbf <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 d2 16 00 00       	call   801e5e <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 91 18 00 00       	call   802037 <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	01 c0                	add    %eax,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007b9:	01 c8                	add    %ecx,%eax
  8007bb:	c1 e0 02             	shl    $0x2,%eax
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007c7:	01 c8                	add    %ecx,%eax
  8007c9:	c1 e0 02             	shl    $0x2,%eax
  8007cc:	01 d0                	add    %edx,%eax
  8007ce:	c1 e0 02             	shl    $0x2,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	c1 e0 03             	shl    $0x3,%eax
  8007d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007db:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007e0:	a1 24 30 80 00       	mov    0x803024,%eax
  8007e5:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8007eb:	84 c0                	test   %al,%al
  8007ed:	74 0f                	je     8007fe <libmain+0x63>
		binaryname = myEnv->prog_name;
  8007ef:	a1 24 30 80 00       	mov    0x803024,%eax
  8007f4:	05 18 da 01 00       	add    $0x1da18,%eax
  8007f9:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800802:	7e 0a                	jle    80080e <libmain+0x73>
		binaryname = argv[0];
  800804:	8b 45 0c             	mov    0xc(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 08             	pushl  0x8(%ebp)
  800817:	e8 1c f8 ff ff       	call   800038 <_main>
  80081c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80081f:	e8 20 16 00 00       	call   801e44 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800824:	83 ec 0c             	sub    $0xc,%esp
  800827:	68 34 27 80 00       	push   $0x802734
  80082c:	e8 6d 03 00 00       	call   800b9e <cprintf>
  800831:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800834:	a1 24 30 80 00       	mov    0x803024,%eax
  800839:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80083f:	a1 24 30 80 00       	mov    0x803024,%eax
  800844:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80084a:	83 ec 04             	sub    $0x4,%esp
  80084d:	52                   	push   %edx
  80084e:	50                   	push   %eax
  80084f:	68 5c 27 80 00       	push   $0x80275c
  800854:	e8 45 03 00 00       	call   800b9e <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80085c:	a1 24 30 80 00       	mov    0x803024,%eax
  800861:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800867:	a1 24 30 80 00       	mov    0x803024,%eax
  80086c:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800872:	a1 24 30 80 00       	mov    0x803024,%eax
  800877:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80087d:	51                   	push   %ecx
  80087e:	52                   	push   %edx
  80087f:	50                   	push   %eax
  800880:	68 84 27 80 00       	push   $0x802784
  800885:	e8 14 03 00 00       	call   800b9e <cprintf>
  80088a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80088d:	a1 24 30 80 00       	mov    0x803024,%eax
  800892:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	50                   	push   %eax
  80089c:	68 dc 27 80 00       	push   $0x8027dc
  8008a1:	e8 f8 02 00 00       	call   800b9e <cprintf>
  8008a6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008a9:	83 ec 0c             	sub    $0xc,%esp
  8008ac:	68 34 27 80 00       	push   $0x802734
  8008b1:	e8 e8 02 00 00       	call   800b9e <cprintf>
  8008b6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008b9:	e8 a0 15 00 00       	call   801e5e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008be:	e8 19 00 00 00       	call   8008dc <exit>
}
  8008c3:	90                   	nop
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    

008008c6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	6a 00                	push   $0x0
  8008d1:	e8 2d 17 00 00       	call   802003 <sys_destroy_env>
  8008d6:	83 c4 10             	add    $0x10,%esp
}
  8008d9:	90                   	nop
  8008da:	c9                   	leave  
  8008db:	c3                   	ret    

008008dc <exit>:

void
exit(void)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008e2:	e8 82 17 00 00       	call   802069 <sys_exit_env>
}
  8008e7:	90                   	nop
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    

008008ea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f0:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f3:	83 c0 04             	add    $0x4,%eax
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008f9:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8008fe:	85 c0                	test   %eax,%eax
  800900:	74 16                	je     800918 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800902:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	50                   	push   %eax
  80090b:	68 f0 27 80 00       	push   $0x8027f0
  800910:	e8 89 02 00 00       	call   800b9e <cprintf>
  800915:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800918:	a1 00 30 80 00       	mov    0x803000,%eax
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	50                   	push   %eax
  800924:	68 f5 27 80 00       	push   $0x8027f5
  800929:	e8 70 02 00 00       	call   800b9e <cprintf>
  80092e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800931:	8b 45 10             	mov    0x10(%ebp),%eax
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 f4             	pushl  -0xc(%ebp)
  80093a:	50                   	push   %eax
  80093b:	e8 f3 01 00 00       	call   800b33 <vcprintf>
  800940:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	6a 00                	push   $0x0
  800948:	68 11 28 80 00       	push   $0x802811
  80094d:	e8 e1 01 00 00       	call   800b33 <vcprintf>
  800952:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800955:	e8 82 ff ff ff       	call   8008dc <exit>

	// should not return here
	while (1) ;
  80095a:	eb fe                	jmp    80095a <_panic+0x70>

0080095c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800962:	a1 24 30 80 00       	mov    0x803024,%eax
  800967:	8b 50 74             	mov    0x74(%eax),%edx
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	39 c2                	cmp    %eax,%edx
  80096f:	74 14                	je     800985 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800971:	83 ec 04             	sub    $0x4,%esp
  800974:	68 14 28 80 00       	push   $0x802814
  800979:	6a 26                	push   $0x26
  80097b:	68 60 28 80 00       	push   $0x802860
  800980:	e8 65 ff ff ff       	call   8008ea <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80098c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800993:	e9 c2 00 00 00       	jmp    800a5a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	01 d0                	add    %edx,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	85 c0                	test   %eax,%eax
  8009ab:	75 08                	jne    8009b5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009ad:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b0:	e9 a2 00 00 00       	jmp    800a57 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009c3:	eb 69                	jmp    800a2e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009c5:	a1 24 30 80 00       	mov    0x803024,%eax
  8009ca:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8009d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009d3:	89 d0                	mov    %edx,%eax
  8009d5:	01 c0                	add    %eax,%eax
  8009d7:	01 d0                	add    %edx,%eax
  8009d9:	c1 e0 03             	shl    $0x3,%eax
  8009dc:	01 c8                	add    %ecx,%eax
  8009de:	8a 40 04             	mov    0x4(%eax),%al
  8009e1:	84 c0                	test   %al,%al
  8009e3:	75 46                	jne    800a2b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009e5:	a1 24 30 80 00       	mov    0x803024,%eax
  8009ea:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8009f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f3:	89 d0                	mov    %edx,%eax
  8009f5:	01 c0                	add    %eax,%eax
  8009f7:	01 d0                	add    %edx,%eax
  8009f9:	c1 e0 03             	shl    $0x3,%eax
  8009fc:	01 c8                	add    %ecx,%eax
  8009fe:	8b 00                	mov    (%eax),%eax
  800a00:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a0b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a10:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	01 c8                	add    %ecx,%eax
  800a1c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a1e:	39 c2                	cmp    %eax,%edx
  800a20:	75 09                	jne    800a2b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a22:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a29:	eb 12                	jmp    800a3d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a2b:	ff 45 e8             	incl   -0x18(%ebp)
  800a2e:	a1 24 30 80 00       	mov    0x803024,%eax
  800a33:	8b 50 74             	mov    0x74(%eax),%edx
  800a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a39:	39 c2                	cmp    %eax,%edx
  800a3b:	77 88                	ja     8009c5 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a41:	75 14                	jne    800a57 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a43:	83 ec 04             	sub    $0x4,%esp
  800a46:	68 6c 28 80 00       	push   $0x80286c
  800a4b:	6a 3a                	push   $0x3a
  800a4d:	68 60 28 80 00       	push   $0x802860
  800a52:	e8 93 fe ff ff       	call   8008ea <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a57:	ff 45 f0             	incl   -0x10(%ebp)
  800a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a60:	0f 8c 32 ff ff ff    	jl     800998 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a74:	eb 26                	jmp    800a9c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a76:	a1 24 30 80 00       	mov    0x803024,%eax
  800a7b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800a81:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a84:	89 d0                	mov    %edx,%eax
  800a86:	01 c0                	add    %eax,%eax
  800a88:	01 d0                	add    %edx,%eax
  800a8a:	c1 e0 03             	shl    $0x3,%eax
  800a8d:	01 c8                	add    %ecx,%eax
  800a8f:	8a 40 04             	mov    0x4(%eax),%al
  800a92:	3c 01                	cmp    $0x1,%al
  800a94:	75 03                	jne    800a99 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a96:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a99:	ff 45 e0             	incl   -0x20(%ebp)
  800a9c:	a1 24 30 80 00       	mov    0x803024,%eax
  800aa1:	8b 50 74             	mov    0x74(%eax),%edx
  800aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa7:	39 c2                	cmp    %eax,%edx
  800aa9:	77 cb                	ja     800a76 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aae:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ab1:	74 14                	je     800ac7 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 c0 28 80 00       	push   $0x8028c0
  800abb:	6a 44                	push   $0x44
  800abd:	68 60 28 80 00       	push   $0x802860
  800ac2:	e8 23 fe ff ff       	call   8008ea <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ac7:	90                   	nop
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	8b 00                	mov    (%eax),%eax
  800ad5:	8d 48 01             	lea    0x1(%eax),%ecx
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	89 0a                	mov    %ecx,(%edx)
  800add:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae0:	88 d1                	mov    %dl,%cl
  800ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	3d ff 00 00 00       	cmp    $0xff,%eax
  800af3:	75 2c                	jne    800b21 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800af5:	a0 28 30 80 00       	mov    0x803028,%al
  800afa:	0f b6 c0             	movzbl %al,%eax
  800afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b00:	8b 12                	mov    (%edx),%edx
  800b02:	89 d1                	mov    %edx,%ecx
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	83 c2 08             	add    $0x8,%edx
  800b0a:	83 ec 04             	sub    $0x4,%esp
  800b0d:	50                   	push   %eax
  800b0e:	51                   	push   %ecx
  800b0f:	52                   	push   %edx
  800b10:	e8 81 11 00 00       	call   801c96 <sys_cputs>
  800b15:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 40 04             	mov    0x4(%eax),%eax
  800b27:	8d 50 01             	lea    0x1(%eax),%edx
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b30:	90                   	nop
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b3c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b43:	00 00 00 
	b.cnt = 0;
  800b46:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b4d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	ff 75 08             	pushl  0x8(%ebp)
  800b56:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b5c:	50                   	push   %eax
  800b5d:	68 ca 0a 80 00       	push   $0x800aca
  800b62:	e8 11 02 00 00       	call   800d78 <vprintfmt>
  800b67:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b6a:	a0 28 30 80 00       	mov    0x803028,%al
  800b6f:	0f b6 c0             	movzbl %al,%eax
  800b72:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b78:	83 ec 04             	sub    $0x4,%esp
  800b7b:	50                   	push   %eax
  800b7c:	52                   	push   %edx
  800b7d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b83:	83 c0 08             	add    $0x8,%eax
  800b86:	50                   	push   %eax
  800b87:	e8 0a 11 00 00       	call   801c96 <sys_cputs>
  800b8c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b8f:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800b96:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <cprintf>:

int cprintf(const char *fmt, ...) {
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ba4:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800bab:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bba:	50                   	push   %eax
  800bbb:	e8 73 ff ff ff       	call   800b33 <vcprintf>
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bd1:	e8 6e 12 00 00       	call   801e44 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bd6:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	50                   	push   %eax
  800be6:	e8 48 ff ff ff       	call   800b33 <vcprintf>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bf1:	e8 68 12 00 00       	call   801e5e <sys_enable_interrupt>
	return cnt;
  800bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	53                   	push   %ebx
  800bff:	83 ec 14             	sub    $0x14,%esp
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c08:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c0e:	8b 45 18             	mov    0x18(%ebp),%eax
  800c11:	ba 00 00 00 00       	mov    $0x0,%edx
  800c16:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c19:	77 55                	ja     800c70 <printnum+0x75>
  800c1b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c1e:	72 05                	jb     800c25 <printnum+0x2a>
  800c20:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c23:	77 4b                	ja     800c70 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c25:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c28:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c2b:	8b 45 18             	mov    0x18(%ebp),%eax
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	52                   	push   %edx
  800c34:	50                   	push   %eax
  800c35:	ff 75 f4             	pushl  -0xc(%ebp)
  800c38:	ff 75 f0             	pushl  -0x10(%ebp)
  800c3b:	e8 8c 16 00 00       	call   8022cc <__udivdi3>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	83 ec 04             	sub    $0x4,%esp
  800c46:	ff 75 20             	pushl  0x20(%ebp)
  800c49:	53                   	push   %ebx
  800c4a:	ff 75 18             	pushl  0x18(%ebp)
  800c4d:	52                   	push   %edx
  800c4e:	50                   	push   %eax
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 a1 ff ff ff       	call   800bfb <printnum>
  800c5a:	83 c4 20             	add    $0x20,%esp
  800c5d:	eb 1a                	jmp    800c79 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	ff 75 20             	pushl  0x20(%ebp)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	ff d0                	call   *%eax
  800c6d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c70:	ff 4d 1c             	decl   0x1c(%ebp)
  800c73:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c77:	7f e6                	jg     800c5f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c79:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c87:	53                   	push   %ebx
  800c88:	51                   	push   %ecx
  800c89:	52                   	push   %edx
  800c8a:	50                   	push   %eax
  800c8b:	e8 4c 17 00 00       	call   8023dc <__umoddi3>
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	05 34 2b 80 00       	add    $0x802b34,%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	0f be c0             	movsbl %al,%eax
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	50                   	push   %eax
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	ff d0                	call   *%eax
  800ca9:	83 c4 10             	add    $0x10,%esp
}
  800cac:	90                   	nop
  800cad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cb5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cb9:	7e 1c                	jle    800cd7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	8d 50 08             	lea    0x8(%eax),%edx
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	89 10                	mov    %edx,(%eax)
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	8b 00                	mov    (%eax),%eax
  800ccd:	83 e8 08             	sub    $0x8,%eax
  800cd0:	8b 50 04             	mov    0x4(%eax),%edx
  800cd3:	8b 00                	mov    (%eax),%eax
  800cd5:	eb 40                	jmp    800d17 <getuint+0x65>
	else if (lflag)
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	74 1e                	je     800cfb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 04             	lea    0x4(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 04             	sub    $0x4,%eax
  800cf2:	8b 00                	mov    (%eax),%eax
  800cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf9:	eb 1c                	jmp    800d17 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8b 00                	mov    (%eax),%eax
  800d00:	8d 50 04             	lea    0x4(%eax),%edx
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	89 10                	mov    %edx,(%eax)
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8b 00                	mov    (%eax),%eax
  800d0d:	83 e8 04             	sub    $0x4,%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d1c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d20:	7e 1c                	jle    800d3e <getint+0x25>
		return va_arg(*ap, long long);
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8b 00                	mov    (%eax),%eax
  800d27:	8d 50 08             	lea    0x8(%eax),%edx
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	89 10                	mov    %edx,(%eax)
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	83 e8 08             	sub    $0x8,%eax
  800d37:	8b 50 04             	mov    0x4(%eax),%edx
  800d3a:	8b 00                	mov    (%eax),%eax
  800d3c:	eb 38                	jmp    800d76 <getint+0x5d>
	else if (lflag)
  800d3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d42:	74 1a                	je     800d5e <getint+0x45>
		return va_arg(*ap, long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 04             	lea    0x4(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 04             	sub    $0x4,%eax
  800d59:	8b 00                	mov    (%eax),%eax
  800d5b:	99                   	cltd   
  800d5c:	eb 18                	jmp    800d76 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8b 00                	mov    (%eax),%eax
  800d63:	8d 50 04             	lea    0x4(%eax),%edx
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	89 10                	mov    %edx,(%eax)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8b 00                	mov    (%eax),%eax
  800d70:	83 e8 04             	sub    $0x4,%eax
  800d73:	8b 00                	mov    (%eax),%eax
  800d75:	99                   	cltd   
}
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d80:	eb 17                	jmp    800d99 <vprintfmt+0x21>
			if (ch == '\0')
  800d82:	85 db                	test   %ebx,%ebx
  800d84:	0f 84 af 03 00 00    	je     801139 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	53                   	push   %ebx
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	ff d0                	call   *%eax
  800d96:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d99:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9c:	8d 50 01             	lea    0x1(%eax),%edx
  800d9f:	89 55 10             	mov    %edx,0x10(%ebp)
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	0f b6 d8             	movzbl %al,%ebx
  800da7:	83 fb 25             	cmp    $0x25,%ebx
  800daa:	75 d6                	jne    800d82 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dac:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800db0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800db7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dbe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dc5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcf:	8d 50 01             	lea    0x1(%eax),%edx
  800dd2:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d8             	movzbl %al,%ebx
  800dda:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ddd:	83 f8 55             	cmp    $0x55,%eax
  800de0:	0f 87 2b 03 00 00    	ja     801111 <vprintfmt+0x399>
  800de6:	8b 04 85 58 2b 80 00 	mov    0x802b58(,%eax,4),%eax
  800ded:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800def:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800df3:	eb d7                	jmp    800dcc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800df5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800df9:	eb d1                	jmp    800dcc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dfb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e05:	89 d0                	mov    %edx,%eax
  800e07:	c1 e0 02             	shl    $0x2,%eax
  800e0a:	01 d0                	add    %edx,%eax
  800e0c:	01 c0                	add    %eax,%eax
  800e0e:	01 d8                	add    %ebx,%eax
  800e10:	83 e8 30             	sub    $0x30,%eax
  800e13:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e16:	8b 45 10             	mov    0x10(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e1e:	83 fb 2f             	cmp    $0x2f,%ebx
  800e21:	7e 3e                	jle    800e61 <vprintfmt+0xe9>
  800e23:	83 fb 39             	cmp    $0x39,%ebx
  800e26:	7f 39                	jg     800e61 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e28:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e2b:	eb d5                	jmp    800e02 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e30:	83 c0 04             	add    $0x4,%eax
  800e33:	89 45 14             	mov    %eax,0x14(%ebp)
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 e8 04             	sub    $0x4,%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e41:	eb 1f                	jmp    800e62 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e47:	79 83                	jns    800dcc <vprintfmt+0x54>
				width = 0;
  800e49:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e50:	e9 77 ff ff ff       	jmp    800dcc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e55:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e5c:	e9 6b ff ff ff       	jmp    800dcc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e61:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e66:	0f 89 60 ff ff ff    	jns    800dcc <vprintfmt+0x54>
				width = precision, precision = -1;
  800e6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e72:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e79:	e9 4e ff ff ff       	jmp    800dcc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e7e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e81:	e9 46 ff ff ff       	jmp    800dcc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 c0 04             	add    $0x4,%eax
  800e8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 e8 04             	sub    $0x4,%eax
  800e95:	8b 00                	mov    (%eax),%eax
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	50                   	push   %eax
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	ff d0                	call   *%eax
  800ea3:	83 c4 10             	add    $0x10,%esp
			break;
  800ea6:	e9 89 02 00 00       	jmp    801134 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eab:	8b 45 14             	mov    0x14(%ebp),%eax
  800eae:	83 c0 04             	add    $0x4,%eax
  800eb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 e8 04             	sub    $0x4,%eax
  800eba:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ebc:	85 db                	test   %ebx,%ebx
  800ebe:	79 02                	jns    800ec2 <vprintfmt+0x14a>
				err = -err;
  800ec0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ec2:	83 fb 64             	cmp    $0x64,%ebx
  800ec5:	7f 0b                	jg     800ed2 <vprintfmt+0x15a>
  800ec7:	8b 34 9d a0 29 80 00 	mov    0x8029a0(,%ebx,4),%esi
  800ece:	85 f6                	test   %esi,%esi
  800ed0:	75 19                	jne    800eeb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ed2:	53                   	push   %ebx
  800ed3:	68 45 2b 80 00       	push   $0x802b45
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	ff 75 08             	pushl  0x8(%ebp)
  800ede:	e8 5e 02 00 00       	call   801141 <printfmt>
  800ee3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ee6:	e9 49 02 00 00       	jmp    801134 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800eeb:	56                   	push   %esi
  800eec:	68 4e 2b 80 00       	push   $0x802b4e
  800ef1:	ff 75 0c             	pushl  0xc(%ebp)
  800ef4:	ff 75 08             	pushl  0x8(%ebp)
  800ef7:	e8 45 02 00 00       	call   801141 <printfmt>
  800efc:	83 c4 10             	add    $0x10,%esp
			break;
  800eff:	e9 30 02 00 00       	jmp    801134 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f04:	8b 45 14             	mov    0x14(%ebp),%eax
  800f07:	83 c0 04             	add    $0x4,%eax
  800f0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f10:	83 e8 04             	sub    $0x4,%eax
  800f13:	8b 30                	mov    (%eax),%esi
  800f15:	85 f6                	test   %esi,%esi
  800f17:	75 05                	jne    800f1e <vprintfmt+0x1a6>
				p = "(null)";
  800f19:	be 51 2b 80 00       	mov    $0x802b51,%esi
			if (width > 0 && padc != '-')
  800f1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f22:	7e 6d                	jle    800f91 <vprintfmt+0x219>
  800f24:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f28:	74 67                	je     800f91 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f2d:	83 ec 08             	sub    $0x8,%esp
  800f30:	50                   	push   %eax
  800f31:	56                   	push   %esi
  800f32:	e8 12 05 00 00       	call   801449 <strnlen>
  800f37:	83 c4 10             	add    $0x10,%esp
  800f3a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f3d:	eb 16                	jmp    800f55 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f3f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f43:	83 ec 08             	sub    $0x8,%esp
  800f46:	ff 75 0c             	pushl  0xc(%ebp)
  800f49:	50                   	push   %eax
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	ff d0                	call   *%eax
  800f4f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f52:	ff 4d e4             	decl   -0x1c(%ebp)
  800f55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f59:	7f e4                	jg     800f3f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f5b:	eb 34                	jmp    800f91 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f61:	74 1c                	je     800f7f <vprintfmt+0x207>
  800f63:	83 fb 1f             	cmp    $0x1f,%ebx
  800f66:	7e 05                	jle    800f6d <vprintfmt+0x1f5>
  800f68:	83 fb 7e             	cmp    $0x7e,%ebx
  800f6b:	7e 12                	jle    800f7f <vprintfmt+0x207>
					putch('?', putdat);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	6a 3f                	push   $0x3f
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	ff d0                	call   *%eax
  800f7a:	83 c4 10             	add    $0x10,%esp
  800f7d:	eb 0f                	jmp    800f8e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	53                   	push   %ebx
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	ff d0                	call   *%eax
  800f8b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800f91:	89 f0                	mov    %esi,%eax
  800f93:	8d 70 01             	lea    0x1(%eax),%esi
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	0f be d8             	movsbl %al,%ebx
  800f9b:	85 db                	test   %ebx,%ebx
  800f9d:	74 24                	je     800fc3 <vprintfmt+0x24b>
  800f9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fa3:	78 b8                	js     800f5d <vprintfmt+0x1e5>
  800fa5:	ff 4d e0             	decl   -0x20(%ebp)
  800fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fac:	79 af                	jns    800f5d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fae:	eb 13                	jmp    800fc3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fb0:	83 ec 08             	sub    $0x8,%esp
  800fb3:	ff 75 0c             	pushl  0xc(%ebp)
  800fb6:	6a 20                	push   $0x20
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc7:	7f e7                	jg     800fb0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fc9:	e9 66 01 00 00       	jmp    801134 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fce:	83 ec 08             	sub    $0x8,%esp
  800fd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800fd7:	50                   	push   %eax
  800fd8:	e8 3c fd ff ff       	call   800d19 <getint>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fec:	85 d2                	test   %edx,%edx
  800fee:	79 23                	jns    801013 <vprintfmt+0x29b>
				putch('-', putdat);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	6a 2d                	push   $0x2d
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	ff d0                	call   *%eax
  800ffd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801003:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801006:	f7 d8                	neg    %eax
  801008:	83 d2 00             	adc    $0x0,%edx
  80100b:	f7 da                	neg    %edx
  80100d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801010:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801013:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80101a:	e9 bc 00 00 00       	jmp    8010db <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 e8             	pushl  -0x18(%ebp)
  801025:	8d 45 14             	lea    0x14(%ebp),%eax
  801028:	50                   	push   %eax
  801029:	e8 84 fc ff ff       	call   800cb2 <getuint>
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801034:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801037:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80103e:	e9 98 00 00 00       	jmp    8010db <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	6a 58                	push   $0x58
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	ff d0                	call   *%eax
  801050:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801053:	83 ec 08             	sub    $0x8,%esp
  801056:	ff 75 0c             	pushl  0xc(%ebp)
  801059:	6a 58                	push   $0x58
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	ff d0                	call   *%eax
  801060:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801063:	83 ec 08             	sub    $0x8,%esp
  801066:	ff 75 0c             	pushl  0xc(%ebp)
  801069:	6a 58                	push   $0x58
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	ff d0                	call   *%eax
  801070:	83 c4 10             	add    $0x10,%esp
			break;
  801073:	e9 bc 00 00 00       	jmp    801134 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801078:	83 ec 08             	sub    $0x8,%esp
  80107b:	ff 75 0c             	pushl  0xc(%ebp)
  80107e:	6a 30                	push   $0x30
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	ff d0                	call   *%eax
  801085:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801088:	83 ec 08             	sub    $0x8,%esp
  80108b:	ff 75 0c             	pushl  0xc(%ebp)
  80108e:	6a 78                	push   $0x78
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	ff d0                	call   *%eax
  801095:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801098:	8b 45 14             	mov    0x14(%ebp),%eax
  80109b:	83 c0 04             	add    $0x4,%eax
  80109e:	89 45 14             	mov    %eax,0x14(%ebp)
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 e8 04             	sub    $0x4,%eax
  8010a7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010b3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010ba:	eb 1f                	jmp    8010db <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8010c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8010c5:	50                   	push   %eax
  8010c6:	e8 e7 fb ff ff       	call   800cb2 <getuint>
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010d4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010db:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	52                   	push   %edx
  8010e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e9:	50                   	push   %eax
  8010ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	ff 75 08             	pushl  0x8(%ebp)
  8010f6:	e8 00 fb ff ff       	call   800bfb <printnum>
  8010fb:	83 c4 20             	add    $0x20,%esp
			break;
  8010fe:	eb 34                	jmp    801134 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801100:	83 ec 08             	sub    $0x8,%esp
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	53                   	push   %ebx
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	ff d0                	call   *%eax
  80110c:	83 c4 10             	add    $0x10,%esp
			break;
  80110f:	eb 23                	jmp    801134 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801111:	83 ec 08             	sub    $0x8,%esp
  801114:	ff 75 0c             	pushl  0xc(%ebp)
  801117:	6a 25                	push   $0x25
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	ff d0                	call   *%eax
  80111e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801121:	ff 4d 10             	decl   0x10(%ebp)
  801124:	eb 03                	jmp    801129 <vprintfmt+0x3b1>
  801126:	ff 4d 10             	decl   0x10(%ebp)
  801129:	8b 45 10             	mov    0x10(%ebp),%eax
  80112c:	48                   	dec    %eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 25                	cmp    $0x25,%al
  801131:	75 f3                	jne    801126 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801133:	90                   	nop
		}
	}
  801134:	e9 47 fc ff ff       	jmp    800d80 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801139:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80113a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80113d:	5b                   	pop    %ebx
  80113e:	5e                   	pop    %esi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    

00801141 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801147:	8d 45 10             	lea    0x10(%ebp),%eax
  80114a:	83 c0 04             	add    $0x4,%eax
  80114d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	ff 75 f4             	pushl  -0xc(%ebp)
  801156:	50                   	push   %eax
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	ff 75 08             	pushl  0x8(%ebp)
  80115d:	e8 16 fc ff ff       	call   800d78 <vprintfmt>
  801162:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801165:	90                   	nop
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8b 40 08             	mov    0x8(%eax),%eax
  801171:	8d 50 01             	lea    0x1(%eax),%edx
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80117a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117d:	8b 10                	mov    (%eax),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	8b 40 04             	mov    0x4(%eax),%eax
  801185:	39 c2                	cmp    %eax,%edx
  801187:	73 12                	jae    80119b <sprintputch+0x33>
		*b->buf++ = ch;
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8b 00                	mov    (%eax),%eax
  80118e:	8d 48 01             	lea    0x1(%eax),%ecx
  801191:	8b 55 0c             	mov    0xc(%ebp),%edx
  801194:	89 0a                	mov    %ecx,(%edx)
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	88 10                	mov    %dl,(%eax)
}
  80119b:	90                   	nop
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 06                	je     8011cb <vsnprintf+0x2d>
  8011c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c9:	7f 07                	jg     8011d2 <vsnprintf+0x34>
		return -E_INVAL;
  8011cb:	b8 03 00 00 00       	mov    $0x3,%eax
  8011d0:	eb 20                	jmp    8011f2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011d2:	ff 75 14             	pushl  0x14(%ebp)
  8011d5:	ff 75 10             	pushl  0x10(%ebp)
  8011d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011db:	50                   	push   %eax
  8011dc:	68 68 11 80 00       	push   $0x801168
  8011e1:	e8 92 fb ff ff       	call   800d78 <vprintfmt>
  8011e6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011ec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8011fd:	83 c0 04             	add    $0x4,%eax
  801200:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801203:	8b 45 10             	mov    0x10(%ebp),%eax
  801206:	ff 75 f4             	pushl  -0xc(%ebp)
  801209:	50                   	push   %eax
  80120a:	ff 75 0c             	pushl  0xc(%ebp)
  80120d:	ff 75 08             	pushl  0x8(%ebp)
  801210:	e8 89 ff ff ff       	call   80119e <vsnprintf>
  801215:	83 c4 10             	add    $0x10,%esp
  801218:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80121b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80122a:	74 13                	je     80123f <readline+0x1f>
		cprintf("%s", prompt);
  80122c:	83 ec 08             	sub    $0x8,%esp
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	68 b0 2c 80 00       	push   $0x802cb0
  801237:	e8 62 f9 ff ff       	call   800b9e <cprintf>
  80123c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80123f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	6a 00                	push   $0x0
  80124b:	e8 41 f5 ff ff       	call   800791 <iscons>
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801256:	e8 e8 f4 ff ff       	call   800743 <getchar>
  80125b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80125e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801262:	79 22                	jns    801286 <readline+0x66>
			if (c != -E_EOF)
  801264:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801268:	0f 84 ad 00 00 00    	je     80131b <readline+0xfb>
				cprintf("read error: %e\n", c);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 ec             	pushl  -0x14(%ebp)
  801274:	68 b3 2c 80 00       	push   $0x802cb3
  801279:	e8 20 f9 ff ff       	call   800b9e <cprintf>
  80127e:	83 c4 10             	add    $0x10,%esp
			return;
  801281:	e9 95 00 00 00       	jmp    80131b <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801286:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80128a:	7e 34                	jle    8012c0 <readline+0xa0>
  80128c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801293:	7f 2b                	jg     8012c0 <readline+0xa0>
			if (echoing)
  801295:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801299:	74 0e                	je     8012a9 <readline+0x89>
				cputchar(c);
  80129b:	83 ec 0c             	sub    $0xc,%esp
  80129e:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a1:	e8 55 f4 ff ff       	call   8006fb <cputchar>
  8012a6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ac:	8d 50 01             	lea    0x1(%eax),%edx
  8012af:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012bc:	88 10                	mov    %dl,(%eax)
  8012be:	eb 56                	jmp    801316 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012c0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012c4:	75 1f                	jne    8012e5 <readline+0xc5>
  8012c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012ca:	7e 19                	jle    8012e5 <readline+0xc5>
			if (echoing)
  8012cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012d0:	74 0e                	je     8012e0 <readline+0xc0>
				cputchar(c);
  8012d2:	83 ec 0c             	sub    $0xc,%esp
  8012d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012d8:	e8 1e f4 ff ff       	call   8006fb <cputchar>
  8012dd:	83 c4 10             	add    $0x10,%esp

			i--;
  8012e0:	ff 4d f4             	decl   -0xc(%ebp)
  8012e3:	eb 31                	jmp    801316 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012e5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012e9:	74 0a                	je     8012f5 <readline+0xd5>
  8012eb:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012ef:	0f 85 61 ff ff ff    	jne    801256 <readline+0x36>
			if (echoing)
  8012f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012f9:	74 0e                	je     801309 <readline+0xe9>
				cputchar(c);
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801301:	e8 f5 f3 ff ff       	call   8006fb <cputchar>
  801306:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801309:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801314:	eb 06                	jmp    80131c <readline+0xfc>
		}
	}
  801316:	e9 3b ff ff ff       	jmp    801256 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  80131b:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801324:	e8 1b 0b 00 00       	call   801e44 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801329:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80132d:	74 13                	je     801342 <atomic_readline+0x24>
		cprintf("%s", prompt);
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	68 b0 2c 80 00       	push   $0x802cb0
  80133a:	e8 5f f8 ff ff       	call   800b9e <cprintf>
  80133f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801342:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801349:	83 ec 0c             	sub    $0xc,%esp
  80134c:	6a 00                	push   $0x0
  80134e:	e8 3e f4 ff ff       	call   800791 <iscons>
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801359:	e8 e5 f3 ff ff       	call   800743 <getchar>
  80135e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801361:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801365:	79 23                	jns    80138a <atomic_readline+0x6c>
			if (c != -E_EOF)
  801367:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80136b:	74 13                	je     801380 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80136d:	83 ec 08             	sub    $0x8,%esp
  801370:	ff 75 ec             	pushl  -0x14(%ebp)
  801373:	68 b3 2c 80 00       	push   $0x802cb3
  801378:	e8 21 f8 ff ff       	call   800b9e <cprintf>
  80137d:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801380:	e8 d9 0a 00 00       	call   801e5e <sys_enable_interrupt>
			return;
  801385:	e9 9a 00 00 00       	jmp    801424 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80138a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80138e:	7e 34                	jle    8013c4 <atomic_readline+0xa6>
  801390:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801397:	7f 2b                	jg     8013c4 <atomic_readline+0xa6>
			if (echoing)
  801399:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80139d:	74 0e                	je     8013ad <atomic_readline+0x8f>
				cputchar(c);
  80139f:	83 ec 0c             	sub    $0xc,%esp
  8013a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8013a5:	e8 51 f3 ff ff       	call   8006fb <cputchar>
  8013aa:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b0:	8d 50 01             	lea    0x1(%eax),%edx
  8013b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013b6:	89 c2                	mov    %eax,%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	01 d0                	add    %edx,%eax
  8013bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c0:	88 10                	mov    %dl,(%eax)
  8013c2:	eb 5b                	jmp    80141f <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013c4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013c8:	75 1f                	jne    8013e9 <atomic_readline+0xcb>
  8013ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013ce:	7e 19                	jle    8013e9 <atomic_readline+0xcb>
			if (echoing)
  8013d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013d4:	74 0e                	je     8013e4 <atomic_readline+0xc6>
				cputchar(c);
  8013d6:	83 ec 0c             	sub    $0xc,%esp
  8013d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013dc:	e8 1a f3 ff ff       	call   8006fb <cputchar>
  8013e1:	83 c4 10             	add    $0x10,%esp
			i--;
  8013e4:	ff 4d f4             	decl   -0xc(%ebp)
  8013e7:	eb 36                	jmp    80141f <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013e9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013ed:	74 0a                	je     8013f9 <atomic_readline+0xdb>
  8013ef:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013f3:	0f 85 60 ff ff ff    	jne    801359 <atomic_readline+0x3b>
			if (echoing)
  8013f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013fd:	74 0e                	je     80140d <atomic_readline+0xef>
				cputchar(c);
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	ff 75 ec             	pushl  -0x14(%ebp)
  801405:	e8 f1 f2 ff ff       	call   8006fb <cputchar>
  80140a:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  80140d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801418:	e8 41 0a 00 00       	call   801e5e <sys_enable_interrupt>
			return;
  80141d:	eb 05                	jmp    801424 <atomic_readline+0x106>
		}
	}
  80141f:	e9 35 ff ff ff       	jmp    801359 <atomic_readline+0x3b>
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80142c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801433:	eb 06                	jmp    80143b <strlen+0x15>
		n++;
  801435:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801438:	ff 45 08             	incl   0x8(%ebp)
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	84 c0                	test   %al,%al
  801442:	75 f1                	jne    801435 <strlen+0xf>
		n++;
	return n;
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80144f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801456:	eb 09                	jmp    801461 <strnlen+0x18>
		n++;
  801458:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80145b:	ff 45 08             	incl   0x8(%ebp)
  80145e:	ff 4d 0c             	decl   0xc(%ebp)
  801461:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801465:	74 09                	je     801470 <strnlen+0x27>
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	84 c0                	test   %al,%al
  80146e:	75 e8                	jne    801458 <strnlen+0xf>
		n++;
	return n;
  801470:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801481:	90                   	nop
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8d 50 01             	lea    0x1(%eax),%edx
  801488:	89 55 08             	mov    %edx,0x8(%ebp)
  80148b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801491:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801494:	8a 12                	mov    (%edx),%dl
  801496:	88 10                	mov    %dl,(%eax)
  801498:	8a 00                	mov    (%eax),%al
  80149a:	84 c0                	test   %al,%al
  80149c:	75 e4                	jne    801482 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80149e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b6:	eb 1f                	jmp    8014d7 <strncpy+0x34>
		*dst++ = *src;
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	8d 50 01             	lea    0x1(%eax),%edx
  8014be:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c4:	8a 12                	mov    (%edx),%dl
  8014c6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	84 c0                	test   %al,%al
  8014cf:	74 03                	je     8014d4 <strncpy+0x31>
			src++;
  8014d1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014d4:	ff 45 fc             	incl   -0x4(%ebp)
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014dd:	72 d9                	jb     8014b8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f4:	74 30                	je     801526 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014f6:	eb 16                	jmp    80150e <strlcpy+0x2a>
			*dst++ = *src++;
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 08             	mov    %edx,0x8(%ebp)
  801501:	8b 55 0c             	mov    0xc(%ebp),%edx
  801504:	8d 4a 01             	lea    0x1(%edx),%ecx
  801507:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80150a:	8a 12                	mov    (%edx),%dl
  80150c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80150e:	ff 4d 10             	decl   0x10(%ebp)
  801511:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801515:	74 09                	je     801520 <strlcpy+0x3c>
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	84 c0                	test   %al,%al
  80151e:	75 d8                	jne    8014f8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801526:	8b 55 08             	mov    0x8(%ebp),%edx
  801529:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152c:	29 c2                	sub    %eax,%edx
  80152e:	89 d0                	mov    %edx,%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801535:	eb 06                	jmp    80153d <strcmp+0xb>
		p++, q++;
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	84 c0                	test   %al,%al
  801544:	74 0e                	je     801554 <strcmp+0x22>
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 10                	mov    (%eax),%dl
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	38 c2                	cmp    %al,%dl
  801552:	74 e3                	je     801537 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	0f b6 d0             	movzbl %al,%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	0f b6 c0             	movzbl %al,%eax
  801564:	29 c2                	sub    %eax,%edx
  801566:	89 d0                	mov    %edx,%eax
}
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80156d:	eb 09                	jmp    801578 <strncmp+0xe>
		n--, p++, q++;
  80156f:	ff 4d 10             	decl   0x10(%ebp)
  801572:	ff 45 08             	incl   0x8(%ebp)
  801575:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801578:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80157c:	74 17                	je     801595 <strncmp+0x2b>
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	84 c0                	test   %al,%al
  801585:	74 0e                	je     801595 <strncmp+0x2b>
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 10                	mov    (%eax),%dl
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	38 c2                	cmp    %al,%dl
  801593:	74 da                	je     80156f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801595:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801599:	75 07                	jne    8015a2 <strncmp+0x38>
		return 0;
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a0:	eb 14                	jmp    8015b6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	0f b6 d0             	movzbl %al,%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	0f b6 c0             	movzbl %al,%eax
  8015b2:	29 c2                	sub    %eax,%edx
  8015b4:	89 d0                	mov    %edx,%eax
}
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015c4:	eb 12                	jmp    8015d8 <strchr+0x20>
		if (*s == c)
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015ce:	75 05                	jne    8015d5 <strchr+0x1d>
			return (char *) s;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	eb 11                	jmp    8015e6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015d5:	ff 45 08             	incl   0x8(%ebp)
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	8a 00                	mov    (%eax),%al
  8015dd:	84 c0                	test   %al,%al
  8015df:	75 e5                	jne    8015c6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015f4:	eb 0d                	jmp    801603 <strfind+0x1b>
		if (*s == c)
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8a 00                	mov    (%eax),%al
  8015fb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015fe:	74 0e                	je     80160e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801600:	ff 45 08             	incl   0x8(%ebp)
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	84 c0                	test   %al,%al
  80160a:	75 ea                	jne    8015f6 <strfind+0xe>
  80160c:	eb 01                	jmp    80160f <strfind+0x27>
		if (*s == c)
			break;
  80160e:	90                   	nop
	return (char *) s;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801620:	8b 45 10             	mov    0x10(%ebp),%eax
  801623:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801626:	eb 0e                	jmp    801636 <memset+0x22>
		*p++ = c;
  801628:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162b:	8d 50 01             	lea    0x1(%eax),%edx
  80162e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801631:	8b 55 0c             	mov    0xc(%ebp),%edx
  801634:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801636:	ff 4d f8             	decl   -0x8(%ebp)
  801639:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80163d:	79 e9                	jns    801628 <memset+0x14>
		*p++ = c;

	return v;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801656:	eb 16                	jmp    80166e <memcpy+0x2a>
		*d++ = *s++;
  801658:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165b:	8d 50 01             	lea    0x1(%eax),%edx
  80165e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801661:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801664:	8d 4a 01             	lea    0x1(%edx),%ecx
  801667:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80166a:	8a 12                	mov    (%edx),%dl
  80166c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80166e:	8b 45 10             	mov    0x10(%ebp),%eax
  801671:	8d 50 ff             	lea    -0x1(%eax),%edx
  801674:	89 55 10             	mov    %edx,0x10(%ebp)
  801677:	85 c0                	test   %eax,%eax
  801679:	75 dd                	jne    801658 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801686:	8b 45 0c             	mov    0xc(%ebp),%eax
  801689:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801692:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801695:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801698:	73 50                	jae    8016ea <memmove+0x6a>
  80169a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 d0                	add    %edx,%eax
  8016a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016a5:	76 43                	jbe    8016ea <memmove+0x6a>
		s += n;
  8016a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016aa:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016b3:	eb 10                	jmp    8016c5 <memmove+0x45>
			*--d = *--s;
  8016b5:	ff 4d f8             	decl   -0x8(%ebp)
  8016b8:	ff 4d fc             	decl   -0x4(%ebp)
  8016bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016be:	8a 10                	mov    (%eax),%dl
  8016c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	75 e3                	jne    8016b5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016d2:	eb 23                	jmp    8016f7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d7:	8d 50 01             	lea    0x1(%eax),%edx
  8016da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016e3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016e6:	8a 12                	mov    (%edx),%dl
  8016e8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	75 dd                	jne    8016d4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80170e:	eb 2a                	jmp    80173a <memcmp+0x3e>
		if (*s1 != *s2)
  801710:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801713:	8a 10                	mov    (%eax),%dl
  801715:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	38 c2                	cmp    %al,%dl
  80171c:	74 16                	je     801734 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80171e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	0f b6 d0             	movzbl %al,%edx
  801726:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 c0             	movzbl %al,%eax
  80172e:	29 c2                	sub    %eax,%edx
  801730:	89 d0                	mov    %edx,%eax
  801732:	eb 18                	jmp    80174c <memcmp+0x50>
		s1++, s2++;
  801734:	ff 45 fc             	incl   -0x4(%ebp)
  801737:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80173a:	8b 45 10             	mov    0x10(%ebp),%eax
  80173d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801740:	89 55 10             	mov    %edx,0x10(%ebp)
  801743:	85 c0                	test   %eax,%eax
  801745:	75 c9                	jne    801710 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801754:	8b 55 08             	mov    0x8(%ebp),%edx
  801757:	8b 45 10             	mov    0x10(%ebp),%eax
  80175a:	01 d0                	add    %edx,%eax
  80175c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80175f:	eb 15                	jmp    801776 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8a 00                	mov    (%eax),%al
  801766:	0f b6 d0             	movzbl %al,%edx
  801769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176c:	0f b6 c0             	movzbl %al,%eax
  80176f:	39 c2                	cmp    %eax,%edx
  801771:	74 0d                	je     801780 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801773:	ff 45 08             	incl   0x8(%ebp)
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80177c:	72 e3                	jb     801761 <memfind+0x13>
  80177e:	eb 01                	jmp    801781 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801780:	90                   	nop
	return (void *) s;
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80178c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801793:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80179a:	eb 03                	jmp    80179f <strtol+0x19>
		s++;
  80179c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 20                	cmp    $0x20,%al
  8017a6:	74 f4                	je     80179c <strtol+0x16>
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 09                	cmp    $0x9,%al
  8017af:	74 eb                	je     80179c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8a 00                	mov    (%eax),%al
  8017b6:	3c 2b                	cmp    $0x2b,%al
  8017b8:	75 05                	jne    8017bf <strtol+0x39>
		s++;
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	eb 13                	jmp    8017d2 <strtol+0x4c>
	else if (*s == '-')
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 2d                	cmp    $0x2d,%al
  8017c6:	75 0a                	jne    8017d2 <strtol+0x4c>
		s++, neg = 1;
  8017c8:	ff 45 08             	incl   0x8(%ebp)
  8017cb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d6:	74 06                	je     8017de <strtol+0x58>
  8017d8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017dc:	75 20                	jne    8017fe <strtol+0x78>
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	3c 30                	cmp    $0x30,%al
  8017e5:	75 17                	jne    8017fe <strtol+0x78>
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	40                   	inc    %eax
  8017eb:	8a 00                	mov    (%eax),%al
  8017ed:	3c 78                	cmp    $0x78,%al
  8017ef:	75 0d                	jne    8017fe <strtol+0x78>
		s += 2, base = 16;
  8017f1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017f5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017fc:	eb 28                	jmp    801826 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801802:	75 15                	jne    801819 <strtol+0x93>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 30                	cmp    $0x30,%al
  80180b:	75 0c                	jne    801819 <strtol+0x93>
		s++, base = 8;
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801817:	eb 0d                	jmp    801826 <strtol+0xa0>
	else if (base == 0)
  801819:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80181d:	75 07                	jne    801826 <strtol+0xa0>
		base = 10;
  80181f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 2f                	cmp    $0x2f,%al
  80182d:	7e 19                	jle    801848 <strtol+0xc2>
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 39                	cmp    $0x39,%al
  801836:	7f 10                	jg     801848 <strtol+0xc2>
			dig = *s - '0';
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	0f be c0             	movsbl %al,%eax
  801840:	83 e8 30             	sub    $0x30,%eax
  801843:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801846:	eb 42                	jmp    80188a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	8a 00                	mov    (%eax),%al
  80184d:	3c 60                	cmp    $0x60,%al
  80184f:	7e 19                	jle    80186a <strtol+0xe4>
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	8a 00                	mov    (%eax),%al
  801856:	3c 7a                	cmp    $0x7a,%al
  801858:	7f 10                	jg     80186a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8a 00                	mov    (%eax),%al
  80185f:	0f be c0             	movsbl %al,%eax
  801862:	83 e8 57             	sub    $0x57,%eax
  801865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801868:	eb 20                	jmp    80188a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	8a 00                	mov    (%eax),%al
  80186f:	3c 40                	cmp    $0x40,%al
  801871:	7e 39                	jle    8018ac <strtol+0x126>
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	8a 00                	mov    (%eax),%al
  801878:	3c 5a                	cmp    $0x5a,%al
  80187a:	7f 30                	jg     8018ac <strtol+0x126>
			dig = *s - 'A' + 10;
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	8a 00                	mov    (%eax),%al
  801881:	0f be c0             	movsbl %al,%eax
  801884:	83 e8 37             	sub    $0x37,%eax
  801887:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80188a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801890:	7d 19                	jge    8018ab <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801892:	ff 45 08             	incl   0x8(%ebp)
  801895:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801898:	0f af 45 10          	imul   0x10(%ebp),%eax
  80189c:	89 c2                	mov    %eax,%edx
  80189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a1:	01 d0                	add    %edx,%eax
  8018a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018a6:	e9 7b ff ff ff       	jmp    801826 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018ab:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018b0:	74 08                	je     8018ba <strtol+0x134>
		*endptr = (char *) s;
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018be:	74 07                	je     8018c7 <strtol+0x141>
  8018c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c3:	f7 d8                	neg    %eax
  8018c5:	eb 03                	jmp    8018ca <strtol+0x144>
  8018c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <ltostr>:

void
ltostr(long value, char *str)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018e4:	79 13                	jns    8018f9 <ltostr+0x2d>
	{
		neg = 1;
  8018e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018f3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018f6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801901:	99                   	cltd   
  801902:	f7 f9                	idiv   %ecx
  801904:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801907:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190a:	8d 50 01             	lea    0x1(%eax),%edx
  80190d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801910:	89 c2                	mov    %eax,%edx
  801912:	8b 45 0c             	mov    0xc(%ebp),%eax
  801915:	01 d0                	add    %edx,%eax
  801917:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80191a:	83 c2 30             	add    $0x30,%edx
  80191d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80191f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801922:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801927:	f7 e9                	imul   %ecx
  801929:	c1 fa 02             	sar    $0x2,%edx
  80192c:	89 c8                	mov    %ecx,%eax
  80192e:	c1 f8 1f             	sar    $0x1f,%eax
  801931:	29 c2                	sub    %eax,%edx
  801933:	89 d0                	mov    %edx,%eax
  801935:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801938:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801940:	f7 e9                	imul   %ecx
  801942:	c1 fa 02             	sar    $0x2,%edx
  801945:	89 c8                	mov    %ecx,%eax
  801947:	c1 f8 1f             	sar    $0x1f,%eax
  80194a:	29 c2                	sub    %eax,%edx
  80194c:	89 d0                	mov    %edx,%eax
  80194e:	c1 e0 02             	shl    $0x2,%eax
  801951:	01 d0                	add    %edx,%eax
  801953:	01 c0                	add    %eax,%eax
  801955:	29 c1                	sub    %eax,%ecx
  801957:	89 ca                	mov    %ecx,%edx
  801959:	85 d2                	test   %edx,%edx
  80195b:	75 9c                	jne    8018f9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80195d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801964:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801967:	48                   	dec    %eax
  801968:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80196b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80196f:	74 3d                	je     8019ae <ltostr+0xe2>
		start = 1 ;
  801971:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801978:	eb 34                	jmp    8019ae <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80197a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801980:	01 d0                	add    %edx,%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80198a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198d:	01 c2                	add    %eax,%edx
  80198f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801992:	8b 45 0c             	mov    0xc(%ebp),%eax
  801995:	01 c8                	add    %ecx,%eax
  801997:	8a 00                	mov    (%eax),%al
  801999:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80199b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80199e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a1:	01 c2                	add    %eax,%edx
  8019a3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019a6:	88 02                	mov    %al,(%edx)
		start++ ;
  8019a8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019ab:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019b4:	7c c4                	jl     80197a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bc:	01 d0                	add    %edx,%eax
  8019be:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019c1:	90                   	nop
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	e8 54 fa ff ff       	call   801426 <strlen>
  8019d2:	83 c4 04             	add    $0x4,%esp
  8019d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	e8 46 fa ff ff       	call   801426 <strlen>
  8019e0:	83 c4 04             	add    $0x4,%esp
  8019e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019f4:	eb 17                	jmp    801a0d <strcconcat+0x49>
		final[s] = str1[s] ;
  8019f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	01 c2                	add    %eax,%edx
  8019fe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	01 c8                	add    %ecx,%eax
  801a06:	8a 00                	mov    (%eax),%al
  801a08:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a0a:	ff 45 fc             	incl   -0x4(%ebp)
  801a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a10:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a13:	7c e1                	jl     8019f6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a15:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a1c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a23:	eb 1f                	jmp    801a44 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a28:	8d 50 01             	lea    0x1(%eax),%edx
  801a2b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a2e:	89 c2                	mov    %eax,%edx
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	01 c2                	add    %eax,%edx
  801a35:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3b:	01 c8                	add    %ecx,%eax
  801a3d:	8a 00                	mov    (%eax),%al
  801a3f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a41:	ff 45 f8             	incl   -0x8(%ebp)
  801a44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a4a:	7c d9                	jl     801a25 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a52:	01 d0                	add    %edx,%eax
  801a54:	c6 00 00             	movb   $0x0,(%eax)
}
  801a57:	90                   	nop
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a66:	8b 45 14             	mov    0x14(%ebp),%eax
  801a69:	8b 00                	mov    (%eax),%eax
  801a6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a72:	8b 45 10             	mov    0x10(%ebp),%eax
  801a75:	01 d0                	add    %edx,%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a7d:	eb 0c                	jmp    801a8b <strsplit+0x31>
			*string++ = 0;
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	8d 50 01             	lea    0x1(%eax),%edx
  801a85:	89 55 08             	mov    %edx,0x8(%ebp)
  801a88:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	8a 00                	mov    (%eax),%al
  801a90:	84 c0                	test   %al,%al
  801a92:	74 18                	je     801aac <strsplit+0x52>
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	0f be c0             	movsbl %al,%eax
  801a9c:	50                   	push   %eax
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	e8 13 fb ff ff       	call   8015b8 <strchr>
  801aa5:	83 c4 08             	add    $0x8,%esp
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	75 d3                	jne    801a7f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	8a 00                	mov    (%eax),%al
  801ab1:	84 c0                	test   %al,%al
  801ab3:	74 5a                	je     801b0f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab8:	8b 00                	mov    (%eax),%eax
  801aba:	83 f8 0f             	cmp    $0xf,%eax
  801abd:	75 07                	jne    801ac6 <strsplit+0x6c>
		{
			return 0;
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac4:	eb 66                	jmp    801b2c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac9:	8b 00                	mov    (%eax),%eax
  801acb:	8d 48 01             	lea    0x1(%eax),%ecx
  801ace:	8b 55 14             	mov    0x14(%ebp),%edx
  801ad1:	89 0a                	mov    %ecx,(%edx)
  801ad3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ada:	8b 45 10             	mov    0x10(%ebp),%eax
  801add:	01 c2                	add    %eax,%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ae4:	eb 03                	jmp    801ae9 <strsplit+0x8f>
			string++;
  801ae6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	8a 00                	mov    (%eax),%al
  801aee:	84 c0                	test   %al,%al
  801af0:	74 8b                	je     801a7d <strsplit+0x23>
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	0f be c0             	movsbl %al,%eax
  801afa:	50                   	push   %eax
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	e8 b5 fa ff ff       	call   8015b8 <strchr>
  801b03:	83 c4 08             	add    $0x8,%esp
  801b06:	85 c0                	test   %eax,%eax
  801b08:	74 dc                	je     801ae6 <strsplit+0x8c>
			string++;
	}
  801b0a:	e9 6e ff ff ff       	jmp    801a7d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b0f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b10:	8b 45 14             	mov    0x14(%ebp),%eax
  801b13:	8b 00                	mov    (%eax),%eax
  801b15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1f:	01 d0                	add    %edx,%eax
  801b21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b27:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	68 c4 2c 80 00       	push   $0x802cc4
  801b3c:	6a 0e                	push   $0xe
  801b3e:	68 fe 2c 80 00       	push   $0x802cfe
  801b43:	e8 a2 ed ff ff       	call   8008ea <_panic>

00801b48 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801b4e:	a1 04 30 80 00       	mov    0x803004,%eax
  801b53:	85 c0                	test   %eax,%eax
  801b55:	74 0f                	je     801b66 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801b57:	e8 d2 ff ff ff       	call   801b2e <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b5c:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801b63:	00 00 00 
	}
	if (size == 0) return NULL ;
  801b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b6a:	75 07                	jne    801b73 <malloc+0x2b>
  801b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b71:	eb 14                	jmp    801b87 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	68 0c 2d 80 00       	push   $0x802d0c
  801b7b:	6a 2e                	push   $0x2e
  801b7d:	68 fe 2c 80 00       	push   $0x802cfe
  801b82:	e8 63 ed ff ff       	call   8008ea <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b8f:	83 ec 04             	sub    $0x4,%esp
  801b92:	68 34 2d 80 00       	push   $0x802d34
  801b97:	6a 49                	push   $0x49
  801b99:	68 fe 2c 80 00       	push   $0x802cfe
  801b9e:	e8 47 ed ff ff       	call   8008ea <_panic>

00801ba3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 18             	sub    $0x18,%esp
  801ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bac:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	68 58 2d 80 00       	push   $0x802d58
  801bb7:	6a 57                	push   $0x57
  801bb9:	68 fe 2c 80 00       	push   $0x802cfe
  801bbe:	e8 27 ed ff ff       	call   8008ea <_panic>

00801bc3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	68 80 2d 80 00       	push   $0x802d80
  801bd1:	6a 60                	push   $0x60
  801bd3:	68 fe 2c 80 00       	push   $0x802cfe
  801bd8:	e8 0d ed ff ff       	call   8008ea <_panic>

00801bdd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	68 a4 2d 80 00       	push   $0x802da4
  801beb:	6a 7c                	push   $0x7c
  801bed:	68 fe 2c 80 00       	push   $0x802cfe
  801bf2:	e8 f3 ec ff ff       	call   8008ea <_panic>

00801bf7 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bfd:	83 ec 04             	sub    $0x4,%esp
  801c00:	68 cc 2d 80 00       	push   $0x802dcc
  801c05:	68 86 00 00 00       	push   $0x86
  801c0a:	68 fe 2c 80 00       	push   $0x802cfe
  801c0f:	e8 d6 ec ff ff       	call   8008ea <_panic>

00801c14 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	68 f0 2d 80 00       	push   $0x802df0
  801c22:	68 91 00 00 00       	push   $0x91
  801c27:	68 fe 2c 80 00       	push   $0x802cfe
  801c2c:	e8 b9 ec ff ff       	call   8008ea <_panic>

00801c31 <shrink>:

}
void shrink(uint32 newSize)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	68 f0 2d 80 00       	push   $0x802df0
  801c3f:	68 96 00 00 00       	push   $0x96
  801c44:	68 fe 2c 80 00       	push   $0x802cfe
  801c49:	e8 9c ec ff ff       	call   8008ea <_panic>

00801c4e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	68 f0 2d 80 00       	push   $0x802df0
  801c5c:	68 9b 00 00 00       	push   $0x9b
  801c61:	68 fe 2c 80 00       	push   $0x802cfe
  801c66:	e8 7f ec ff ff       	call   8008ea <_panic>

00801c6b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	57                   	push   %edi
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c80:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c83:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c86:	cd 30                	int    $0x30
  801c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	5b                   	pop    %ebx
  801c92:	5e                   	pop    %esi
  801c93:	5f                   	pop    %edi
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    

00801c96 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ca2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	52                   	push   %edx
  801cae:	ff 75 0c             	pushl  0xc(%ebp)
  801cb1:	50                   	push   %eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	e8 b2 ff ff ff       	call   801c6b <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	90                   	nop
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_cgetc>:

int
sys_cgetc(void)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 01                	push   $0x1
  801cce:	e8 98 ff ff ff       	call   801c6b <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	52                   	push   %edx
  801ce8:	50                   	push   %eax
  801ce9:	6a 05                	push   $0x5
  801ceb:	e8 7b ff ff ff       	call   801c6b <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	56                   	push   %esi
  801cf9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cfa:	8b 75 18             	mov    0x18(%ebp),%esi
  801cfd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	56                   	push   %esi
  801d0a:	53                   	push   %ebx
  801d0b:	51                   	push   %ecx
  801d0c:	52                   	push   %edx
  801d0d:	50                   	push   %eax
  801d0e:	6a 06                	push   $0x6
  801d10:	e8 56 ff ff ff       	call   801c6b <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5d                   	pop    %ebp
  801d1e:	c3                   	ret    

00801d1f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 07                	push   $0x7
  801d32:	e8 34 ff ff ff       	call   801c6b <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	ff 75 0c             	pushl  0xc(%ebp)
  801d48:	ff 75 08             	pushl  0x8(%ebp)
  801d4b:	6a 08                	push   $0x8
  801d4d:	e8 19 ff ff ff       	call   801c6b <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 09                	push   $0x9
  801d66:	e8 00 ff ff ff       	call   801c6b <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 0a                	push   $0xa
  801d7f:	e8 e7 fe ff ff       	call   801c6b <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 0b                	push   $0xb
  801d98:	e8 ce fe ff ff       	call   801c6b <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	ff 75 0c             	pushl  0xc(%ebp)
  801dae:	ff 75 08             	pushl  0x8(%ebp)
  801db1:	6a 0f                	push   $0xf
  801db3:	e8 b3 fe ff ff       	call   801c6b <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
	return;
  801dbb:	90                   	nop
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	6a 10                	push   $0x10
  801dcf:	e8 97 fe ff ff       	call   801c6b <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	ff 75 10             	pushl  0x10(%ebp)
  801de4:	ff 75 0c             	pushl  0xc(%ebp)
  801de7:	ff 75 08             	pushl  0x8(%ebp)
  801dea:	6a 11                	push   $0x11
  801dec:	e8 7a fe ff ff       	call   801c6b <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
	return ;
  801df4:	90                   	nop
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 0c                	push   $0xc
  801e06:	e8 60 fe ff ff       	call   801c6b <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	ff 75 08             	pushl  0x8(%ebp)
  801e1e:	6a 0d                	push   $0xd
  801e20:	e8 46 fe ff ff       	call   801c6b <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 0e                	push   $0xe
  801e39:	e8 2d fe ff ff       	call   801c6b <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	90                   	nop
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 13                	push   $0x13
  801e53:	e8 13 fe ff ff       	call   801c6b <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	90                   	nop
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 14                	push   $0x14
  801e6d:	e8 f9 fd ff ff       	call   801c6b <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	90                   	nop
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e84:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	50                   	push   %eax
  801e91:	6a 15                	push   $0x15
  801e93:	e8 d3 fd ff ff       	call   801c6b <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	90                   	nop
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 16                	push   $0x16
  801ead:	e8 b9 fd ff ff       	call   801c6b <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
}
  801eb5:	90                   	nop
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	ff 75 0c             	pushl  0xc(%ebp)
  801ec7:	50                   	push   %eax
  801ec8:	6a 17                	push   $0x17
  801eca:	e8 9c fd ff ff       	call   801c6b <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	52                   	push   %edx
  801ee4:	50                   	push   %eax
  801ee5:	6a 1a                	push   $0x1a
  801ee7:	e8 7f fd ff ff       	call   801c6b <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	52                   	push   %edx
  801f01:	50                   	push   %eax
  801f02:	6a 18                	push   $0x18
  801f04:	e8 62 fd ff ff       	call   801c6b <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	90                   	nop
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	52                   	push   %edx
  801f1f:	50                   	push   %eax
  801f20:	6a 19                	push   $0x19
  801f22:	e8 44 fd ff ff       	call   801c6b <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	90                   	nop
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	8b 45 10             	mov    0x10(%ebp),%eax
  801f36:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f39:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f3c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	6a 00                	push   $0x0
  801f45:	51                   	push   %ecx
  801f46:	52                   	push   %edx
  801f47:	ff 75 0c             	pushl  0xc(%ebp)
  801f4a:	50                   	push   %eax
  801f4b:	6a 1b                	push   $0x1b
  801f4d:	e8 19 fd ff ff       	call   801c6b <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	52                   	push   %edx
  801f67:	50                   	push   %eax
  801f68:	6a 1c                	push   $0x1c
  801f6a:	e8 fc fc ff ff       	call   801c6b <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f77:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	51                   	push   %ecx
  801f85:	52                   	push   %edx
  801f86:	50                   	push   %eax
  801f87:	6a 1d                	push   $0x1d
  801f89:	e8 dd fc ff ff       	call   801c6b <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	52                   	push   %edx
  801fa3:	50                   	push   %eax
  801fa4:	6a 1e                	push   $0x1e
  801fa6:	e8 c0 fc ff ff       	call   801c6b <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 1f                	push   $0x1f
  801fbf:	e8 a7 fc ff ff       	call   801c6b <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	ff 75 14             	pushl  0x14(%ebp)
  801fd4:	ff 75 10             	pushl  0x10(%ebp)
  801fd7:	ff 75 0c             	pushl  0xc(%ebp)
  801fda:	50                   	push   %eax
  801fdb:	6a 20                	push   $0x20
  801fdd:	e8 89 fc ff ff       	call   801c6b <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	50                   	push   %eax
  801ff6:	6a 21                	push   $0x21
  801ff8:	e8 6e fc ff ff       	call   801c6b <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	90                   	nop
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	50                   	push   %eax
  802012:	6a 22                	push   $0x22
  802014:	e8 52 fc ff ff       	call   801c6b <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 02                	push   $0x2
  80202d:	e8 39 fc ff ff       	call   801c6b <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 03                	push   $0x3
  802046:	e8 20 fc ff ff       	call   801c6b <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 04                	push   $0x4
  80205f:	e8 07 fc ff ff       	call   801c6b <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_exit_env>:


void sys_exit_env(void)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 23                	push   $0x23
  802078:	e8 ee fb ff ff       	call   801c6b <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
}
  802080:	90                   	nop
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802089:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80208c:	8d 50 04             	lea    0x4(%eax),%edx
  80208f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	52                   	push   %edx
  802099:	50                   	push   %eax
  80209a:	6a 24                	push   $0x24
  80209c:	e8 ca fb ff ff       	call   801c6b <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
	return result;
  8020a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020ad:	89 01                	mov    %eax,(%ecx)
  8020af:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	c9                   	leave  
  8020b6:	c2 04 00             	ret    $0x4

008020b9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	ff 75 10             	pushl  0x10(%ebp)
  8020c3:	ff 75 0c             	pushl  0xc(%ebp)
  8020c6:	ff 75 08             	pushl  0x8(%ebp)
  8020c9:	6a 12                	push   $0x12
  8020cb:	e8 9b fb ff ff       	call   801c6b <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d3:	90                   	nop
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 25                	push   $0x25
  8020e5:	e8 81 fb ff ff       	call   801c6b <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020fb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	50                   	push   %eax
  802108:	6a 26                	push   $0x26
  80210a:	e8 5c fb ff ff       	call   801c6b <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
	return ;
  802112:	90                   	nop
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <rsttst>:
void rsttst()
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 28                	push   $0x28
  802124:	e8 42 fb ff ff       	call   801c6b <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
	return ;
  80212c:	90                   	nop
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	8b 45 14             	mov    0x14(%ebp),%eax
  802138:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80213b:	8b 55 18             	mov    0x18(%ebp),%edx
  80213e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802142:	52                   	push   %edx
  802143:	50                   	push   %eax
  802144:	ff 75 10             	pushl  0x10(%ebp)
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	6a 27                	push   $0x27
  80214f:	e8 17 fb ff ff       	call   801c6b <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
	return ;
  802157:	90                   	nop
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <chktst>:
void chktst(uint32 n)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	ff 75 08             	pushl  0x8(%ebp)
  802168:	6a 29                	push   $0x29
  80216a:	e8 fc fa ff ff       	call   801c6b <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
	return ;
  802172:	90                   	nop
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <inctst>:

void inctst()
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 2a                	push   $0x2a
  802184:	e8 e2 fa ff ff       	call   801c6b <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
	return ;
  80218c:	90                   	nop
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <gettst>:
uint32 gettst()
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 2b                	push   $0x2b
  80219e:	e8 c8 fa ff ff       	call   801c6b <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 2c                	push   $0x2c
  8021ba:	e8 ac fa ff ff       	call   801c6b <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
  8021c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021c5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021c9:	75 07                	jne    8021d2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d0:	eb 05                	jmp    8021d7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 2c                	push   $0x2c
  8021eb:	e8 7b fa ff ff       	call   801c6b <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
  8021f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021f6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021fa:	75 07                	jne    802203 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802201:	eb 05                	jmp    802208 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 2c                	push   $0x2c
  80221c:	e8 4a fa ff ff       	call   801c6b <syscall>
  802221:	83 c4 18             	add    $0x18,%esp
  802224:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802227:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80222b:	75 07                	jne    802234 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80222d:	b8 01 00 00 00       	mov    $0x1,%eax
  802232:	eb 05                	jmp    802239 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802234:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 2c                	push   $0x2c
  80224d:	e8 19 fa ff ff       	call   801c6b <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
  802255:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802258:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80225c:	75 07                	jne    802265 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80225e:	b8 01 00 00 00       	mov    $0x1,%eax
  802263:	eb 05                	jmp    80226a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802265:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	ff 75 08             	pushl  0x8(%ebp)
  80227a:	6a 2d                	push   $0x2d
  80227c:	e8 ea f9 ff ff       	call   801c6b <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
	return ;
  802284:	90                   	nop
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80228b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80228e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802291:	8b 55 0c             	mov    0xc(%ebp),%edx
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	6a 00                	push   $0x0
  802299:	53                   	push   %ebx
  80229a:	51                   	push   %ecx
  80229b:	52                   	push   %edx
  80229c:	50                   	push   %eax
  80229d:	6a 2e                	push   $0x2e
  80229f:	e8 c7 f9 ff ff       	call   801c6b <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	52                   	push   %edx
  8022bc:	50                   	push   %eax
  8022bd:	6a 2f                	push   $0x2f
  8022bf:	e8 a7 f9 ff ff       	call   801c6b <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    
  8022c9:	66 90                	xchg   %ax,%ax
  8022cb:	90                   	nop

008022cc <__udivdi3>:
  8022cc:	55                   	push   %ebp
  8022cd:	57                   	push   %edi
  8022ce:	56                   	push   %esi
  8022cf:	53                   	push   %ebx
  8022d0:	83 ec 1c             	sub    $0x1c,%esp
  8022d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8022db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022e3:	89 ca                	mov    %ecx,%edx
  8022e5:	89 f8                	mov    %edi,%eax
  8022e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8022eb:	85 f6                	test   %esi,%esi
  8022ed:	75 2d                	jne    80231c <__udivdi3+0x50>
  8022ef:	39 cf                	cmp    %ecx,%edi
  8022f1:	77 65                	ja     802358 <__udivdi3+0x8c>
  8022f3:	89 fd                	mov    %edi,%ebp
  8022f5:	85 ff                	test   %edi,%edi
  8022f7:	75 0b                	jne    802304 <__udivdi3+0x38>
  8022f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fe:	31 d2                	xor    %edx,%edx
  802300:	f7 f7                	div    %edi
  802302:	89 c5                	mov    %eax,%ebp
  802304:	31 d2                	xor    %edx,%edx
  802306:	89 c8                	mov    %ecx,%eax
  802308:	f7 f5                	div    %ebp
  80230a:	89 c1                	mov    %eax,%ecx
  80230c:	89 d8                	mov    %ebx,%eax
  80230e:	f7 f5                	div    %ebp
  802310:	89 cf                	mov    %ecx,%edi
  802312:	89 fa                	mov    %edi,%edx
  802314:	83 c4 1c             	add    $0x1c,%esp
  802317:	5b                   	pop    %ebx
  802318:	5e                   	pop    %esi
  802319:	5f                   	pop    %edi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    
  80231c:	39 ce                	cmp    %ecx,%esi
  80231e:	77 28                	ja     802348 <__udivdi3+0x7c>
  802320:	0f bd fe             	bsr    %esi,%edi
  802323:	83 f7 1f             	xor    $0x1f,%edi
  802326:	75 40                	jne    802368 <__udivdi3+0x9c>
  802328:	39 ce                	cmp    %ecx,%esi
  80232a:	72 0a                	jb     802336 <__udivdi3+0x6a>
  80232c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802330:	0f 87 9e 00 00 00    	ja     8023d4 <__udivdi3+0x108>
  802336:	b8 01 00 00 00       	mov    $0x1,%eax
  80233b:	89 fa                	mov    %edi,%edx
  80233d:	83 c4 1c             	add    $0x1c,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5f                   	pop    %edi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	31 ff                	xor    %edi,%edi
  80234a:	31 c0                	xor    %eax,%eax
  80234c:	89 fa                	mov    %edi,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	66 90                	xchg   %ax,%ax
  802358:	89 d8                	mov    %ebx,%eax
  80235a:	f7 f7                	div    %edi
  80235c:	31 ff                	xor    %edi,%edi
  80235e:	89 fa                	mov    %edi,%edx
  802360:	83 c4 1c             	add    $0x1c,%esp
  802363:	5b                   	pop    %ebx
  802364:	5e                   	pop    %esi
  802365:	5f                   	pop    %edi
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    
  802368:	bd 20 00 00 00       	mov    $0x20,%ebp
  80236d:	89 eb                	mov    %ebp,%ebx
  80236f:	29 fb                	sub    %edi,%ebx
  802371:	89 f9                	mov    %edi,%ecx
  802373:	d3 e6                	shl    %cl,%esi
  802375:	89 c5                	mov    %eax,%ebp
  802377:	88 d9                	mov    %bl,%cl
  802379:	d3 ed                	shr    %cl,%ebp
  80237b:	89 e9                	mov    %ebp,%ecx
  80237d:	09 f1                	or     %esi,%ecx
  80237f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802383:	89 f9                	mov    %edi,%ecx
  802385:	d3 e0                	shl    %cl,%eax
  802387:	89 c5                	mov    %eax,%ebp
  802389:	89 d6                	mov    %edx,%esi
  80238b:	88 d9                	mov    %bl,%cl
  80238d:	d3 ee                	shr    %cl,%esi
  80238f:	89 f9                	mov    %edi,%ecx
  802391:	d3 e2                	shl    %cl,%edx
  802393:	8b 44 24 08          	mov    0x8(%esp),%eax
  802397:	88 d9                	mov    %bl,%cl
  802399:	d3 e8                	shr    %cl,%eax
  80239b:	09 c2                	or     %eax,%edx
  80239d:	89 d0                	mov    %edx,%eax
  80239f:	89 f2                	mov    %esi,%edx
  8023a1:	f7 74 24 0c          	divl   0xc(%esp)
  8023a5:	89 d6                	mov    %edx,%esi
  8023a7:	89 c3                	mov    %eax,%ebx
  8023a9:	f7 e5                	mul    %ebp
  8023ab:	39 d6                	cmp    %edx,%esi
  8023ad:	72 19                	jb     8023c8 <__udivdi3+0xfc>
  8023af:	74 0b                	je     8023bc <__udivdi3+0xf0>
  8023b1:	89 d8                	mov    %ebx,%eax
  8023b3:	31 ff                	xor    %edi,%edi
  8023b5:	e9 58 ff ff ff       	jmp    802312 <__udivdi3+0x46>
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8023c0:	89 f9                	mov    %edi,%ecx
  8023c2:	d3 e2                	shl    %cl,%edx
  8023c4:	39 c2                	cmp    %eax,%edx
  8023c6:	73 e9                	jae    8023b1 <__udivdi3+0xe5>
  8023c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023cb:	31 ff                	xor    %edi,%edi
  8023cd:	e9 40 ff ff ff       	jmp    802312 <__udivdi3+0x46>
  8023d2:	66 90                	xchg   %ax,%ax
  8023d4:	31 c0                	xor    %eax,%eax
  8023d6:	e9 37 ff ff ff       	jmp    802312 <__udivdi3+0x46>
  8023db:	90                   	nop

008023dc <__umoddi3>:
  8023dc:	55                   	push   %ebp
  8023dd:	57                   	push   %edi
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	83 ec 1c             	sub    $0x1c,%esp
  8023e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8023e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023fb:	89 f3                	mov    %esi,%ebx
  8023fd:	89 fa                	mov    %edi,%edx
  8023ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802403:	89 34 24             	mov    %esi,(%esp)
  802406:	85 c0                	test   %eax,%eax
  802408:	75 1a                	jne    802424 <__umoddi3+0x48>
  80240a:	39 f7                	cmp    %esi,%edi
  80240c:	0f 86 a2 00 00 00    	jbe    8024b4 <__umoddi3+0xd8>
  802412:	89 c8                	mov    %ecx,%eax
  802414:	89 f2                	mov    %esi,%edx
  802416:	f7 f7                	div    %edi
  802418:	89 d0                	mov    %edx,%eax
  80241a:	31 d2                	xor    %edx,%edx
  80241c:	83 c4 1c             	add    $0x1c,%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5f                   	pop    %edi
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    
  802424:	39 f0                	cmp    %esi,%eax
  802426:	0f 87 ac 00 00 00    	ja     8024d8 <__umoddi3+0xfc>
  80242c:	0f bd e8             	bsr    %eax,%ebp
  80242f:	83 f5 1f             	xor    $0x1f,%ebp
  802432:	0f 84 ac 00 00 00    	je     8024e4 <__umoddi3+0x108>
  802438:	bf 20 00 00 00       	mov    $0x20,%edi
  80243d:	29 ef                	sub    %ebp,%edi
  80243f:	89 fe                	mov    %edi,%esi
  802441:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802445:	89 e9                	mov    %ebp,%ecx
  802447:	d3 e0                	shl    %cl,%eax
  802449:	89 d7                	mov    %edx,%edi
  80244b:	89 f1                	mov    %esi,%ecx
  80244d:	d3 ef                	shr    %cl,%edi
  80244f:	09 c7                	or     %eax,%edi
  802451:	89 e9                	mov    %ebp,%ecx
  802453:	d3 e2                	shl    %cl,%edx
  802455:	89 14 24             	mov    %edx,(%esp)
  802458:	89 d8                	mov    %ebx,%eax
  80245a:	d3 e0                	shl    %cl,%eax
  80245c:	89 c2                	mov    %eax,%edx
  80245e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802462:	d3 e0                	shl    %cl,%eax
  802464:	89 44 24 04          	mov    %eax,0x4(%esp)
  802468:	8b 44 24 08          	mov    0x8(%esp),%eax
  80246c:	89 f1                	mov    %esi,%ecx
  80246e:	d3 e8                	shr    %cl,%eax
  802470:	09 d0                	or     %edx,%eax
  802472:	d3 eb                	shr    %cl,%ebx
  802474:	89 da                	mov    %ebx,%edx
  802476:	f7 f7                	div    %edi
  802478:	89 d3                	mov    %edx,%ebx
  80247a:	f7 24 24             	mull   (%esp)
  80247d:	89 c6                	mov    %eax,%esi
  80247f:	89 d1                	mov    %edx,%ecx
  802481:	39 d3                	cmp    %edx,%ebx
  802483:	0f 82 87 00 00 00    	jb     802510 <__umoddi3+0x134>
  802489:	0f 84 91 00 00 00    	je     802520 <__umoddi3+0x144>
  80248f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802493:	29 f2                	sub    %esi,%edx
  802495:	19 cb                	sbb    %ecx,%ebx
  802497:	89 d8                	mov    %ebx,%eax
  802499:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80249d:	d3 e0                	shl    %cl,%eax
  80249f:	89 e9                	mov    %ebp,%ecx
  8024a1:	d3 ea                	shr    %cl,%edx
  8024a3:	09 d0                	or     %edx,%eax
  8024a5:	89 e9                	mov    %ebp,%ecx
  8024a7:	d3 eb                	shr    %cl,%ebx
  8024a9:	89 da                	mov    %ebx,%edx
  8024ab:	83 c4 1c             	add    $0x1c,%esp
  8024ae:	5b                   	pop    %ebx
  8024af:	5e                   	pop    %esi
  8024b0:	5f                   	pop    %edi
  8024b1:	5d                   	pop    %ebp
  8024b2:	c3                   	ret    
  8024b3:	90                   	nop
  8024b4:	89 fd                	mov    %edi,%ebp
  8024b6:	85 ff                	test   %edi,%edi
  8024b8:	75 0b                	jne    8024c5 <__umoddi3+0xe9>
  8024ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bf:	31 d2                	xor    %edx,%edx
  8024c1:	f7 f7                	div    %edi
  8024c3:	89 c5                	mov    %eax,%ebp
  8024c5:	89 f0                	mov    %esi,%eax
  8024c7:	31 d2                	xor    %edx,%edx
  8024c9:	f7 f5                	div    %ebp
  8024cb:	89 c8                	mov    %ecx,%eax
  8024cd:	f7 f5                	div    %ebp
  8024cf:	89 d0                	mov    %edx,%eax
  8024d1:	e9 44 ff ff ff       	jmp    80241a <__umoddi3+0x3e>
  8024d6:	66 90                	xchg   %ax,%ax
  8024d8:	89 c8                	mov    %ecx,%eax
  8024da:	89 f2                	mov    %esi,%edx
  8024dc:	83 c4 1c             	add    $0x1c,%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	5f                   	pop    %edi
  8024e2:	5d                   	pop    %ebp
  8024e3:	c3                   	ret    
  8024e4:	3b 04 24             	cmp    (%esp),%eax
  8024e7:	72 06                	jb     8024ef <__umoddi3+0x113>
  8024e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8024ed:	77 0f                	ja     8024fe <__umoddi3+0x122>
  8024ef:	89 f2                	mov    %esi,%edx
  8024f1:	29 f9                	sub    %edi,%ecx
  8024f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8024f7:	89 14 24             	mov    %edx,(%esp)
  8024fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  802502:	8b 14 24             	mov    (%esp),%edx
  802505:	83 c4 1c             	add    $0x1c,%esp
  802508:	5b                   	pop    %ebx
  802509:	5e                   	pop    %esi
  80250a:	5f                   	pop    %edi
  80250b:	5d                   	pop    %ebp
  80250c:	c3                   	ret    
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	2b 04 24             	sub    (%esp),%eax
  802513:	19 fa                	sbb    %edi,%edx
  802515:	89 d1                	mov    %edx,%ecx
  802517:	89 c6                	mov    %eax,%esi
  802519:	e9 71 ff ff ff       	jmp    80248f <__umoddi3+0xb3>
  80251e:	66 90                	xchg   %ax,%ax
  802520:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802524:	72 ea                	jb     802510 <__umoddi3+0x134>
  802526:	89 d9                	mov    %ebx,%ecx
  802528:	e9 62 ff ff ff       	jmp    80248f <__umoddi3+0xb3>
