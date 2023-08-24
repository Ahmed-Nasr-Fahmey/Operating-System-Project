
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
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
  800041:	e8 14 1c 00 00       	call   801c5a <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 23 80 00       	push   $0x802360
  80004e:	e8 67 0b 00 00       	call   800bba <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 23 80 00       	push   $0x802362
  80005e:	e8 57 0b 00 00       	call   800bba <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 23 80 00       	push   $0x802378
  80006e:	e8 47 0b 00 00       	call   800bba <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 23 80 00       	push   $0x802362
  80007e:	e8 37 0b 00 00       	call   800bba <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 23 80 00       	push   $0x802360
  80008e:	e8 27 0b 00 00       	call   800bba <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 90 23 80 00       	push   $0x802390
  80009e:	e8 17 0b 00 00       	call   800bba <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 af 23 80 00       	push   $0x8023af
  8000b8:	e8 fd 0a 00 00       	call   800bba <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 8f 18 00 00       	call   80195e <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 b4 23 80 00       	push   $0x8023b4
  8000dd:	e8 d8 0a 00 00       	call   800bba <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 d6 23 80 00       	push   $0x8023d6
  8000ed:	e8 c8 0a 00 00       	call   800bba <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 e4 23 80 00       	push   $0x8023e4
  8000fd:	e8 b8 0a 00 00       	call   800bba <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 f3 23 80 00       	push   $0x8023f3
  80010d:	e8 a8 0a 00 00       	call   800bba <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 03 24 80 00       	push   $0x802403
  80011d:	e8 98 0a 00 00       	call   800bba <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 e1 05 00 00       	call   800717 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 d4 05 00 00       	call   800717 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800158:	e8 17 1b 00 00       	call   801c74 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f0 01 00 00       	call   80036e <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 0e 02 00 00       	call   80039f <InitializeDescending>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 30 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 1d 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 dc 02 00 00       	call   8004a6 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001cd:	e8 88 1a 00 00       	call   801c5a <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 0c 24 80 00       	push   $0x80240c
  8001da:	e8 db 09 00 00       	call   800bba <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 8d 1a 00 00       	call   801c74 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 cf 00 00 00       	call   8002c4 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 40 24 80 00       	push   $0x802440
  800209:	6a 4e                	push   $0x4e
  80020b:	68 62 24 80 00       	push   $0x802462
  800210:	e8 f1 06 00 00       	call   800906 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 40 1a 00 00       	call   801c5a <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 80 24 80 00       	push   $0x802480
  800222:	e8 93 09 00 00       	call   800bba <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 b4 24 80 00       	push   $0x8024b4
  800232:	e8 83 09 00 00       	call   800bba <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 e8 24 80 00       	push   $0x8024e8
  800242:	e8 73 09 00 00       	call   800bba <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 25 1a 00 00       	call   801c74 <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 45 17 00 00       	call   80199f <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 f8 19 00 00       	call   801c5a <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 1a 25 80 00       	push   $0x80251a
  800270:	e8 45 09 00 00       	call   800bba <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 8e 04 00 00       	call   800717 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 81 04 00 00       	call   800717 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 74 04 00 00       	call   800717 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 bd 19 00 00       	call   801c74 <sys_enable_interrupt>

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
  800446:	68 60 23 80 00       	push   $0x802360
  80044b:	e8 6a 07 00 00       	call   800bba <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 38 25 80 00       	push   $0x802538
  80046d:	e8 48 07 00 00       	call   800bba <cprintf>
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
  800496:	68 af 23 80 00       	push   $0x8023af
  80049b:	e8 1a 07 00 00       	call   800bba <cprintf>
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
  80053c:	e8 1d 14 00 00       	call   80195e <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 08 14 00 00       	call   80195e <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

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
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

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

	free(Left);
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	e8 9c 12 00 00       	call   80199f <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 8e 12 00 00       	call   80199f <free>
  800711:	83 c4 10             	add    $0x10,%esp

}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800723:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	50                   	push   %eax
  80072b:	e8 5e 15 00 00       	call   801c8e <sys_cputc>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80073c:	e8 19 15 00 00       	call   801c5a <sys_disable_interrupt>
	char c = ch;
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800747:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	50                   	push   %eax
  80074f:	e8 3a 15 00 00       	call   801c8e <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 18 15 00 00       	call   801c74 <sys_enable_interrupt>
}
  80075c:	90                   	nop
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <getchar>:

int
getchar(void)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80076c:	eb 08                	jmp    800776 <getchar+0x17>
	{
		c = sys_cgetc();
  80076e:	e8 62 13 00 00       	call   801ad5 <sys_cgetc>
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077a:	74 f2                	je     80076e <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_getchar>:

int
atomic_getchar(void)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800787:	e8 ce 14 00 00       	call   801c5a <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 3b 13 00 00       	call   801ad5 <sys_cgetc>
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80079d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007a1:	74 f2                	je     800795 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007a3:	e8 cc 14 00 00       	call   801c74 <sys_enable_interrupt>
	return c;
  8007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <iscons>:

int iscons(int fdnum)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007bd:	e8 8b 16 00 00       	call   801e4d <sys_getenvindex>
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	01 c0                	add    %eax,%eax
  8007cc:	01 d0                	add    %edx,%eax
  8007ce:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007d5:	01 c8                	add    %ecx,%eax
  8007d7:	c1 e0 02             	shl    $0x2,%eax
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	c1 e0 02             	shl    $0x2,%eax
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	01 d0                	add    %edx,%eax
  8007ef:	c1 e0 03             	shl    $0x3,%eax
  8007f2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f7:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007fc:	a1 24 30 80 00       	mov    0x803024,%eax
  800801:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800807:	84 c0                	test   %al,%al
  800809:	74 0f                	je     80081a <libmain+0x63>
		binaryname = myEnv->prog_name;
  80080b:	a1 24 30 80 00       	mov    0x803024,%eax
  800810:	05 18 da 01 00       	add    $0x1da18,%eax
  800815:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80081a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80081e:	7e 0a                	jle    80082a <libmain+0x73>
		binaryname = argv[0];
  800820:	8b 45 0c             	mov    0xc(%ebp),%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	ff 75 08             	pushl  0x8(%ebp)
  800833:	e8 00 f8 ff ff       	call   800038 <_main>
  800838:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80083b:	e8 1a 14 00 00       	call   801c5a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800840:	83 ec 0c             	sub    $0xc,%esp
  800843:	68 58 25 80 00       	push   $0x802558
  800848:	e8 6d 03 00 00       	call   800bba <cprintf>
  80084d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800850:	a1 24 30 80 00       	mov    0x803024,%eax
  800855:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80085b:	a1 24 30 80 00       	mov    0x803024,%eax
  800860:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800866:	83 ec 04             	sub    $0x4,%esp
  800869:	52                   	push   %edx
  80086a:	50                   	push   %eax
  80086b:	68 80 25 80 00       	push   $0x802580
  800870:	e8 45 03 00 00       	call   800bba <cprintf>
  800875:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800878:	a1 24 30 80 00       	mov    0x803024,%eax
  80087d:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800883:	a1 24 30 80 00       	mov    0x803024,%eax
  800888:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80088e:	a1 24 30 80 00       	mov    0x803024,%eax
  800893:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800899:	51                   	push   %ecx
  80089a:	52                   	push   %edx
  80089b:	50                   	push   %eax
  80089c:	68 a8 25 80 00       	push   $0x8025a8
  8008a1:	e8 14 03 00 00       	call   800bba <cprintf>
  8008a6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a9:	a1 24 30 80 00       	mov    0x803024,%eax
  8008ae:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	50                   	push   %eax
  8008b8:	68 00 26 80 00       	push   $0x802600
  8008bd:	e8 f8 02 00 00       	call   800bba <cprintf>
  8008c2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c5:	83 ec 0c             	sub    $0xc,%esp
  8008c8:	68 58 25 80 00       	push   $0x802558
  8008cd:	e8 e8 02 00 00       	call   800bba <cprintf>
  8008d2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d5:	e8 9a 13 00 00       	call   801c74 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008da:	e8 19 00 00 00       	call   8008f8 <exit>
}
  8008df:	90                   	nop
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e8:	83 ec 0c             	sub    $0xc,%esp
  8008eb:	6a 00                	push   $0x0
  8008ed:	e8 27 15 00 00       	call   801e19 <sys_destroy_env>
  8008f2:	83 c4 10             	add    $0x10,%esp
}
  8008f5:	90                   	nop
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <exit>:

void
exit(void)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008fe:	e8 7c 15 00 00       	call   801e7f <sys_exit_env>
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80090c:	8d 45 10             	lea    0x10(%ebp),%eax
  80090f:	83 c0 04             	add    $0x4,%eax
  800912:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800915:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80091a:	85 c0                	test   %eax,%eax
  80091c:	74 16                	je     800934 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80091e:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	50                   	push   %eax
  800927:	68 14 26 80 00       	push   $0x802614
  80092c:	e8 89 02 00 00       	call   800bba <cprintf>
  800931:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800934:	a1 00 30 80 00       	mov    0x803000,%eax
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	ff 75 08             	pushl  0x8(%ebp)
  80093f:	50                   	push   %eax
  800940:	68 19 26 80 00       	push   $0x802619
  800945:	e8 70 02 00 00       	call   800bba <cprintf>
  80094a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80094d:	8b 45 10             	mov    0x10(%ebp),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	ff 75 f4             	pushl  -0xc(%ebp)
  800956:	50                   	push   %eax
  800957:	e8 f3 01 00 00       	call   800b4f <vcprintf>
  80095c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	6a 00                	push   $0x0
  800964:	68 35 26 80 00       	push   $0x802635
  800969:	e8 e1 01 00 00       	call   800b4f <vcprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800971:	e8 82 ff ff ff       	call   8008f8 <exit>

	// should not return here
	while (1) ;
  800976:	eb fe                	jmp    800976 <_panic+0x70>

00800978 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80097e:	a1 24 30 80 00       	mov    0x803024,%eax
  800983:	8b 50 74             	mov    0x74(%eax),%edx
  800986:	8b 45 0c             	mov    0xc(%ebp),%eax
  800989:	39 c2                	cmp    %eax,%edx
  80098b:	74 14                	je     8009a1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80098d:	83 ec 04             	sub    $0x4,%esp
  800990:	68 38 26 80 00       	push   $0x802638
  800995:	6a 26                	push   $0x26
  800997:	68 84 26 80 00       	push   $0x802684
  80099c:	e8 65 ff ff ff       	call   800906 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009af:	e9 c2 00 00 00       	jmp    800a76 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	01 d0                	add    %edx,%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	75 08                	jne    8009d1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009c9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009cc:	e9 a2 00 00 00       	jmp    800a73 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009df:	eb 69                	jmp    800a4a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e1:	a1 24 30 80 00       	mov    0x803024,%eax
  8009e6:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8009ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ef:	89 d0                	mov    %edx,%eax
  8009f1:	01 c0                	add    %eax,%eax
  8009f3:	01 d0                	add    %edx,%eax
  8009f5:	c1 e0 03             	shl    $0x3,%eax
  8009f8:	01 c8                	add    %ecx,%eax
  8009fa:	8a 40 04             	mov    0x4(%eax),%al
  8009fd:	84 c0                	test   %al,%al
  8009ff:	75 46                	jne    800a47 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a01:	a1 24 30 80 00       	mov    0x803024,%eax
  800a06:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800a0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0f:	89 d0                	mov    %edx,%eax
  800a11:	01 c0                	add    %eax,%eax
  800a13:	01 d0                	add    %edx,%eax
  800a15:	c1 e0 03             	shl    $0x3,%eax
  800a18:	01 c8                	add    %ecx,%eax
  800a1a:	8b 00                	mov    (%eax),%eax
  800a1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a27:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	01 c8                	add    %ecx,%eax
  800a38:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a3a:	39 c2                	cmp    %eax,%edx
  800a3c:	75 09                	jne    800a47 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a3e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a45:	eb 12                	jmp    800a59 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a47:	ff 45 e8             	incl   -0x18(%ebp)
  800a4a:	a1 24 30 80 00       	mov    0x803024,%eax
  800a4f:	8b 50 74             	mov    0x74(%eax),%edx
  800a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a55:	39 c2                	cmp    %eax,%edx
  800a57:	77 88                	ja     8009e1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a5d:	75 14                	jne    800a73 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a5f:	83 ec 04             	sub    $0x4,%esp
  800a62:	68 90 26 80 00       	push   $0x802690
  800a67:	6a 3a                	push   $0x3a
  800a69:	68 84 26 80 00       	push   $0x802684
  800a6e:	e8 93 fe ff ff       	call   800906 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a73:	ff 45 f0             	incl   -0x10(%ebp)
  800a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a79:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a7c:	0f 8c 32 ff ff ff    	jl     8009b4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a90:	eb 26                	jmp    800ab8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a92:	a1 24 30 80 00       	mov    0x803024,%eax
  800a97:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800a9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa0:	89 d0                	mov    %edx,%eax
  800aa2:	01 c0                	add    %eax,%eax
  800aa4:	01 d0                	add    %edx,%eax
  800aa6:	c1 e0 03             	shl    $0x3,%eax
  800aa9:	01 c8                	add    %ecx,%eax
  800aab:	8a 40 04             	mov    0x4(%eax),%al
  800aae:	3c 01                	cmp    $0x1,%al
  800ab0:	75 03                	jne    800ab5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ab2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab5:	ff 45 e0             	incl   -0x20(%ebp)
  800ab8:	a1 24 30 80 00       	mov    0x803024,%eax
  800abd:	8b 50 74             	mov    0x74(%eax),%edx
  800ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac3:	39 c2                	cmp    %eax,%edx
  800ac5:	77 cb                	ja     800a92 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800acd:	74 14                	je     800ae3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800acf:	83 ec 04             	sub    $0x4,%esp
  800ad2:	68 e4 26 80 00       	push   $0x8026e4
  800ad7:	6a 44                	push   $0x44
  800ad9:	68 84 26 80 00       	push   $0x802684
  800ade:	e8 23 fe ff ff       	call   800906 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	8d 48 01             	lea    0x1(%eax),%ecx
  800af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af7:	89 0a                	mov    %ecx,(%edx)
  800af9:	8b 55 08             	mov    0x8(%ebp),%edx
  800afc:	88 d1                	mov    %dl,%cl
  800afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b01:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0f:	75 2c                	jne    800b3d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b11:	a0 28 30 80 00       	mov    0x803028,%al
  800b16:	0f b6 c0             	movzbl %al,%eax
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	8b 12                	mov    (%edx),%edx
  800b1e:	89 d1                	mov    %edx,%ecx
  800b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b23:	83 c2 08             	add    $0x8,%edx
  800b26:	83 ec 04             	sub    $0x4,%esp
  800b29:	50                   	push   %eax
  800b2a:	51                   	push   %ecx
  800b2b:	52                   	push   %edx
  800b2c:	e8 7b 0f 00 00       	call   801aac <sys_cputs>
  800b31:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	8b 40 04             	mov    0x4(%eax),%eax
  800b43:	8d 50 01             	lea    0x1(%eax),%edx
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b4c:	90                   	nop
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b58:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5f:	00 00 00 
	b.cnt = 0;
  800b62:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b69:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	68 e6 0a 80 00       	push   $0x800ae6
  800b7e:	e8 11 02 00 00       	call   800d94 <vprintfmt>
  800b83:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b86:	a0 28 30 80 00       	mov    0x803028,%al
  800b8b:	0f b6 c0             	movzbl %al,%eax
  800b8e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b94:	83 ec 04             	sub    $0x4,%esp
  800b97:	50                   	push   %eax
  800b98:	52                   	push   %edx
  800b99:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9f:	83 c0 08             	add    $0x8,%eax
  800ba2:	50                   	push   %eax
  800ba3:	e8 04 0f 00 00       	call   801aac <sys_cputs>
  800ba8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bab:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800bb2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <cprintf>:

int cprintf(const char *fmt, ...) {
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc0:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800bc7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	83 ec 08             	sub    $0x8,%esp
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	e8 73 ff ff ff       	call   800b4f <vcprintf>
  800bdc:	83 c4 10             	add    $0x10,%esp
  800bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    

00800be7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bed:	e8 68 10 00 00       	call   801c5a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 f4             	pushl  -0xc(%ebp)
  800c01:	50                   	push   %eax
  800c02:	e8 48 ff ff ff       	call   800b4f <vcprintf>
  800c07:	83 c4 10             	add    $0x10,%esp
  800c0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c0d:	e8 62 10 00 00       	call   801c74 <sys_enable_interrupt>
	return cnt;
  800c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	53                   	push   %ebx
  800c1b:	83 ec 14             	sub    $0x14,%esp
  800c1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c2a:	8b 45 18             	mov    0x18(%ebp),%eax
  800c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c35:	77 55                	ja     800c8c <printnum+0x75>
  800c37:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c3a:	72 05                	jb     800c41 <printnum+0x2a>
  800c3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3f:	77 4b                	ja     800c8c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c41:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c44:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c47:	8b 45 18             	mov    0x18(%ebp),%eax
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	52                   	push   %edx
  800c50:	50                   	push   %eax
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	ff 75 f0             	pushl  -0x10(%ebp)
  800c57:	e8 84 14 00 00       	call   8020e0 <__udivdi3>
  800c5c:	83 c4 10             	add    $0x10,%esp
  800c5f:	83 ec 04             	sub    $0x4,%esp
  800c62:	ff 75 20             	pushl  0x20(%ebp)
  800c65:	53                   	push   %ebx
  800c66:	ff 75 18             	pushl  0x18(%ebp)
  800c69:	52                   	push   %edx
  800c6a:	50                   	push   %eax
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	ff 75 08             	pushl  0x8(%ebp)
  800c71:	e8 a1 ff ff ff       	call   800c17 <printnum>
  800c76:	83 c4 20             	add    $0x20,%esp
  800c79:	eb 1a                	jmp    800c95 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	ff 75 0c             	pushl  0xc(%ebp)
  800c81:	ff 75 20             	pushl  0x20(%ebp)
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	ff d0                	call   *%eax
  800c89:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c8c:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c93:	7f e6                	jg     800c7b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c95:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca3:	53                   	push   %ebx
  800ca4:	51                   	push   %ecx
  800ca5:	52                   	push   %edx
  800ca6:	50                   	push   %eax
  800ca7:	e8 44 15 00 00       	call   8021f0 <__umoddi3>
  800cac:	83 c4 10             	add    $0x10,%esp
  800caf:	05 54 29 80 00       	add    $0x802954,%eax
  800cb4:	8a 00                	mov    (%eax),%al
  800cb6:	0f be c0             	movsbl %al,%eax
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	50                   	push   %eax
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	ff d0                	call   *%eax
  800cc5:	83 c4 10             	add    $0x10,%esp
}
  800cc8:	90                   	nop
  800cc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd5:	7e 1c                	jle    800cf3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	8d 50 08             	lea    0x8(%eax),%edx
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 10                	mov    %edx,(%eax)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8b 00                	mov    (%eax),%eax
  800ce9:	83 e8 08             	sub    $0x8,%eax
  800cec:	8b 50 04             	mov    0x4(%eax),%edx
  800cef:	8b 00                	mov    (%eax),%eax
  800cf1:	eb 40                	jmp    800d33 <getuint+0x65>
	else if (lflag)
  800cf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf7:	74 1e                	je     800d17 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8b 00                	mov    (%eax),%eax
  800cfe:	8d 50 04             	lea    0x4(%eax),%edx
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	89 10                	mov    %edx,(%eax)
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	ba 00 00 00 00       	mov    $0x0,%edx
  800d15:	eb 1c                	jmp    800d33 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8b 00                	mov    (%eax),%eax
  800d1c:	8d 50 04             	lea    0x4(%eax),%edx
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	89 10                	mov    %edx,(%eax)
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	83 e8 04             	sub    $0x4,%eax
  800d2c:	8b 00                	mov    (%eax),%eax
  800d2e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d38:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d3c:	7e 1c                	jle    800d5a <getint+0x25>
		return va_arg(*ap, long long);
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	8d 50 08             	lea    0x8(%eax),%edx
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	89 10                	mov    %edx,(%eax)
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	83 e8 08             	sub    $0x8,%eax
  800d53:	8b 50 04             	mov    0x4(%eax),%edx
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	eb 38                	jmp    800d92 <getint+0x5d>
	else if (lflag)
  800d5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5e:	74 1a                	je     800d7a <getint+0x45>
		return va_arg(*ap, long);
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8b 00                	mov    (%eax),%eax
  800d65:	8d 50 04             	lea    0x4(%eax),%edx
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 10                	mov    %edx,(%eax)
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	83 e8 04             	sub    $0x4,%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	99                   	cltd   
  800d78:	eb 18                	jmp    800d92 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8b 00                	mov    (%eax),%eax
  800d7f:	8d 50 04             	lea    0x4(%eax),%edx
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	89 10                	mov    %edx,(%eax)
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	83 e8 04             	sub    $0x4,%eax
  800d8f:	8b 00                	mov    (%eax),%eax
  800d91:	99                   	cltd   
}
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d9c:	eb 17                	jmp    800db5 <vprintfmt+0x21>
			if (ch == '\0')
  800d9e:	85 db                	test   %ebx,%ebx
  800da0:	0f 84 af 03 00 00    	je     801155 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da6:	83 ec 08             	sub    $0x8,%esp
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	53                   	push   %ebx
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	ff d0                	call   *%eax
  800db2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db5:	8b 45 10             	mov    0x10(%ebp),%eax
  800db8:	8d 50 01             	lea    0x1(%eax),%edx
  800dbb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	0f b6 d8             	movzbl %al,%ebx
  800dc3:	83 fb 25             	cmp    $0x25,%ebx
  800dc6:	75 d6                	jne    800d9e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dcc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dda:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de8:	8b 45 10             	mov    0x10(%ebp),%eax
  800deb:	8d 50 01             	lea    0x1(%eax),%edx
  800dee:	89 55 10             	mov    %edx,0x10(%ebp)
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	0f b6 d8             	movzbl %al,%ebx
  800df6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df9:	83 f8 55             	cmp    $0x55,%eax
  800dfc:	0f 87 2b 03 00 00    	ja     80112d <vprintfmt+0x399>
  800e02:	8b 04 85 78 29 80 00 	mov    0x802978(,%eax,4),%eax
  800e09:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e0b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0f:	eb d7                	jmp    800de8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e11:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e15:	eb d1                	jmp    800de8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	c1 e0 02             	shl    $0x2,%eax
  800e26:	01 d0                	add    %edx,%eax
  800e28:	01 c0                	add    %eax,%eax
  800e2a:	01 d8                	add    %ebx,%eax
  800e2c:	83 e8 30             	sub    $0x30,%eax
  800e2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e32:	8b 45 10             	mov    0x10(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e3a:	83 fb 2f             	cmp    $0x2f,%ebx
  800e3d:	7e 3e                	jle    800e7d <vprintfmt+0xe9>
  800e3f:	83 fb 39             	cmp    $0x39,%ebx
  800e42:	7f 39                	jg     800e7d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e44:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e47:	eb d5                	jmp    800e1e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e49:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4c:	83 c0 04             	add    $0x4,%eax
  800e4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e52:	8b 45 14             	mov    0x14(%ebp),%eax
  800e55:	83 e8 04             	sub    $0x4,%eax
  800e58:	8b 00                	mov    (%eax),%eax
  800e5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e5d:	eb 1f                	jmp    800e7e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e63:	79 83                	jns    800de8 <vprintfmt+0x54>
				width = 0;
  800e65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e6c:	e9 77 ff ff ff       	jmp    800de8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e71:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e78:	e9 6b ff ff ff       	jmp    800de8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e7d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e82:	0f 89 60 ff ff ff    	jns    800de8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e8e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e95:	e9 4e ff ff ff       	jmp    800de8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e9a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e9d:	e9 46 ff ff ff       	jmp    800de8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea5:	83 c0 04             	add    $0x4,%eax
  800ea8:	89 45 14             	mov    %eax,0x14(%ebp)
  800eab:	8b 45 14             	mov    0x14(%ebp),%eax
  800eae:	83 e8 04             	sub    $0x4,%eax
  800eb1:	8b 00                	mov    (%eax),%eax
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 0c             	pushl  0xc(%ebp)
  800eb9:	50                   	push   %eax
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			break;
  800ec2:	e9 89 02 00 00       	jmp    801150 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eca:	83 c0 04             	add    $0x4,%eax
  800ecd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed3:	83 e8 04             	sub    $0x4,%eax
  800ed6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed8:	85 db                	test   %ebx,%ebx
  800eda:	79 02                	jns    800ede <vprintfmt+0x14a>
				err = -err;
  800edc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ede:	83 fb 64             	cmp    $0x64,%ebx
  800ee1:	7f 0b                	jg     800eee <vprintfmt+0x15a>
  800ee3:	8b 34 9d c0 27 80 00 	mov    0x8027c0(,%ebx,4),%esi
  800eea:	85 f6                	test   %esi,%esi
  800eec:	75 19                	jne    800f07 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800eee:	53                   	push   %ebx
  800eef:	68 65 29 80 00       	push   $0x802965
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	ff 75 08             	pushl  0x8(%ebp)
  800efa:	e8 5e 02 00 00       	call   80115d <printfmt>
  800eff:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f02:	e9 49 02 00 00       	jmp    801150 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f07:	56                   	push   %esi
  800f08:	68 6e 29 80 00       	push   $0x80296e
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	ff 75 08             	pushl  0x8(%ebp)
  800f13:	e8 45 02 00 00       	call   80115d <printfmt>
  800f18:	83 c4 10             	add    $0x10,%esp
			break;
  800f1b:	e9 30 02 00 00       	jmp    801150 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f20:	8b 45 14             	mov    0x14(%ebp),%eax
  800f23:	83 c0 04             	add    $0x4,%eax
  800f26:	89 45 14             	mov    %eax,0x14(%ebp)
  800f29:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2c:	83 e8 04             	sub    $0x4,%eax
  800f2f:	8b 30                	mov    (%eax),%esi
  800f31:	85 f6                	test   %esi,%esi
  800f33:	75 05                	jne    800f3a <vprintfmt+0x1a6>
				p = "(null)";
  800f35:	be 71 29 80 00       	mov    $0x802971,%esi
			if (width > 0 && padc != '-')
  800f3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f3e:	7e 6d                	jle    800fad <vprintfmt+0x219>
  800f40:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f44:	74 67                	je     800fad <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f49:	83 ec 08             	sub    $0x8,%esp
  800f4c:	50                   	push   %eax
  800f4d:	56                   	push   %esi
  800f4e:	e8 0c 03 00 00       	call   80125f <strnlen>
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f59:	eb 16                	jmp    800f71 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f5b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5f:	83 ec 08             	sub    $0x8,%esp
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	50                   	push   %eax
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	ff d0                	call   *%eax
  800f6b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f6e:	ff 4d e4             	decl   -0x1c(%ebp)
  800f71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f75:	7f e4                	jg     800f5b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f77:	eb 34                	jmp    800fad <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f7d:	74 1c                	je     800f9b <vprintfmt+0x207>
  800f7f:	83 fb 1f             	cmp    $0x1f,%ebx
  800f82:	7e 05                	jle    800f89 <vprintfmt+0x1f5>
  800f84:	83 fb 7e             	cmp    $0x7e,%ebx
  800f87:	7e 12                	jle    800f9b <vprintfmt+0x207>
					putch('?', putdat);
  800f89:	83 ec 08             	sub    $0x8,%esp
  800f8c:	ff 75 0c             	pushl  0xc(%ebp)
  800f8f:	6a 3f                	push   $0x3f
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	ff d0                	call   *%eax
  800f96:	83 c4 10             	add    $0x10,%esp
  800f99:	eb 0f                	jmp    800faa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	53                   	push   %ebx
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	ff d0                	call   *%eax
  800fa7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800faa:	ff 4d e4             	decl   -0x1c(%ebp)
  800fad:	89 f0                	mov    %esi,%eax
  800faf:	8d 70 01             	lea    0x1(%eax),%esi
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	0f be d8             	movsbl %al,%ebx
  800fb7:	85 db                	test   %ebx,%ebx
  800fb9:	74 24                	je     800fdf <vprintfmt+0x24b>
  800fbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fbf:	78 b8                	js     800f79 <vprintfmt+0x1e5>
  800fc1:	ff 4d e0             	decl   -0x20(%ebp)
  800fc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc8:	79 af                	jns    800f79 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fca:	eb 13                	jmp    800fdf <vprintfmt+0x24b>
				putch(' ', putdat);
  800fcc:	83 ec 08             	sub    $0x8,%esp
  800fcf:	ff 75 0c             	pushl  0xc(%ebp)
  800fd2:	6a 20                	push   $0x20
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	ff d0                	call   *%eax
  800fd9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fdc:	ff 4d e4             	decl   -0x1c(%ebp)
  800fdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe3:	7f e7                	jg     800fcc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe5:	e9 66 01 00 00       	jmp    801150 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff3:	50                   	push   %eax
  800ff4:	e8 3c fd ff ff       	call   800d35 <getint>
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801008:	85 d2                	test   %edx,%edx
  80100a:	79 23                	jns    80102f <vprintfmt+0x29b>
				putch('-', putdat);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	6a 2d                	push   $0x2d
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	ff d0                	call   *%eax
  801019:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80101c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801022:	f7 d8                	neg    %eax
  801024:	83 d2 00             	adc    $0x0,%edx
  801027:	f7 da                	neg    %edx
  801029:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801036:	e9 bc 00 00 00       	jmp    8010f7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 e8             	pushl  -0x18(%ebp)
  801041:	8d 45 14             	lea    0x14(%ebp),%eax
  801044:	50                   	push   %eax
  801045:	e8 84 fc ff ff       	call   800cce <getuint>
  80104a:	83 c4 10             	add    $0x10,%esp
  80104d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801050:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801053:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80105a:	e9 98 00 00 00       	jmp    8010f7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105f:	83 ec 08             	sub    $0x8,%esp
  801062:	ff 75 0c             	pushl  0xc(%ebp)
  801065:	6a 58                	push   $0x58
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	ff d0                	call   *%eax
  80106c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 0c             	pushl  0xc(%ebp)
  801075:	6a 58                	push   $0x58
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	ff d0                	call   *%eax
  80107c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107f:	83 ec 08             	sub    $0x8,%esp
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	6a 58                	push   $0x58
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
			break;
  80108f:	e9 bc 00 00 00       	jmp    801150 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801094:	83 ec 08             	sub    $0x8,%esp
  801097:	ff 75 0c             	pushl  0xc(%ebp)
  80109a:	6a 30                	push   $0x30
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	ff d0                	call   *%eax
  8010a1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010a4:	83 ec 08             	sub    $0x8,%esp
  8010a7:	ff 75 0c             	pushl  0xc(%ebp)
  8010aa:	6a 78                	push   $0x78
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	ff d0                	call   *%eax
  8010b1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	83 c0 04             	add    $0x4,%eax
  8010ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8010bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c0:	83 e8 04             	sub    $0x4,%eax
  8010c3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010cf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d6:	eb 1f                	jmp    8010f7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d8:	83 ec 08             	sub    $0x8,%esp
  8010db:	ff 75 e8             	pushl  -0x18(%ebp)
  8010de:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e1:	50                   	push   %eax
  8010e2:	e8 e7 fb ff ff       	call   800cce <getuint>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010fe:	83 ec 04             	sub    $0x4,%esp
  801101:	52                   	push   %edx
  801102:	ff 75 e4             	pushl  -0x1c(%ebp)
  801105:	50                   	push   %eax
  801106:	ff 75 f4             	pushl  -0xc(%ebp)
  801109:	ff 75 f0             	pushl  -0x10(%ebp)
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	ff 75 08             	pushl  0x8(%ebp)
  801112:	e8 00 fb ff ff       	call   800c17 <printnum>
  801117:	83 c4 20             	add    $0x20,%esp
			break;
  80111a:	eb 34                	jmp    801150 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80111c:	83 ec 08             	sub    $0x8,%esp
  80111f:	ff 75 0c             	pushl  0xc(%ebp)
  801122:	53                   	push   %ebx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	eb 23                	jmp    801150 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	6a 25                	push   $0x25
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80113d:	ff 4d 10             	decl   0x10(%ebp)
  801140:	eb 03                	jmp    801145 <vprintfmt+0x3b1>
  801142:	ff 4d 10             	decl   0x10(%ebp)
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	3c 25                	cmp    $0x25,%al
  80114d:	75 f3                	jne    801142 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114f:	90                   	nop
		}
	}
  801150:	e9 47 fc ff ff       	jmp    800d9c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801155:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801156:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801159:	5b                   	pop    %ebx
  80115a:	5e                   	pop    %esi
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801163:	8d 45 10             	lea    0x10(%ebp),%eax
  801166:	83 c0 04             	add    $0x4,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	ff 75 f4             	pushl  -0xc(%ebp)
  801172:	50                   	push   %eax
  801173:	ff 75 0c             	pushl  0xc(%ebp)
  801176:	ff 75 08             	pushl  0x8(%ebp)
  801179:	e8 16 fc ff ff       	call   800d94 <vprintfmt>
  80117e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801181:	90                   	nop
  801182:	c9                   	leave  
  801183:	c3                   	ret    

00801184 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	8b 40 08             	mov    0x8(%eax),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 10                	mov    (%eax),%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8b 40 04             	mov    0x4(%eax),%eax
  8011a1:	39 c2                	cmp    %eax,%edx
  8011a3:	73 12                	jae    8011b7 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a8:	8b 00                	mov    (%eax),%eax
  8011aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8011ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b0:	89 0a                	mov    %ecx,(%edx)
  8011b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b5:	88 10                	mov    %dl,(%eax)
}
  8011b7:	90                   	nop
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011df:	74 06                	je     8011e7 <vsnprintf+0x2d>
  8011e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e5:	7f 07                	jg     8011ee <vsnprintf+0x34>
		return -E_INVAL;
  8011e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8011ec:	eb 20                	jmp    80120e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011ee:	ff 75 14             	pushl  0x14(%ebp)
  8011f1:	ff 75 10             	pushl  0x10(%ebp)
  8011f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f7:	50                   	push   %eax
  8011f8:	68 84 11 80 00       	push   $0x801184
  8011fd:	e8 92 fb ff ff       	call   800d94 <vprintfmt>
  801202:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801208:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80120b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801216:	8d 45 10             	lea    0x10(%ebp),%eax
  801219:	83 c0 04             	add    $0x4,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121f:	8b 45 10             	mov    0x10(%ebp),%eax
  801222:	ff 75 f4             	pushl  -0xc(%ebp)
  801225:	50                   	push   %eax
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	ff 75 08             	pushl  0x8(%ebp)
  80122c:	e8 89 ff ff ff       	call   8011ba <vsnprintf>
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801237:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801242:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801249:	eb 06                	jmp    801251 <strlen+0x15>
		n++;
  80124b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80124e:	ff 45 08             	incl   0x8(%ebp)
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	75 f1                	jne    80124b <strlen+0xf>
		n++;
	return n;
  80125a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801265:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126c:	eb 09                	jmp    801277 <strnlen+0x18>
		n++;
  80126e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801271:	ff 45 08             	incl   0x8(%ebp)
  801274:	ff 4d 0c             	decl   0xc(%ebp)
  801277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127b:	74 09                	je     801286 <strnlen+0x27>
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	84 c0                	test   %al,%al
  801284:	75 e8                	jne    80126e <strnlen+0xf>
		n++;
	return n;
  801286:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801297:	90                   	nop
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8d 50 01             	lea    0x1(%eax),%edx
  80129e:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012aa:	8a 12                	mov    (%edx),%dl
  8012ac:	88 10                	mov    %dl,(%eax)
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	75 e4                	jne    801298 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012cc:	eb 1f                	jmp    8012ed <strncpy+0x34>
		*dst++ = *src;
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	8d 50 01             	lea    0x1(%eax),%edx
  8012d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012da:	8a 12                	mov    (%edx),%dl
  8012dc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	84 c0                	test   %al,%al
  8012e5:	74 03                	je     8012ea <strncpy+0x31>
			src++;
  8012e7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ea:	ff 45 fc             	incl   -0x4(%ebp)
  8012ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f3:	72 d9                	jb     8012ce <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801306:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80130a:	74 30                	je     80133c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80130c:	eb 16                	jmp    801324 <strlcpy+0x2a>
			*dst++ = *src++;
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8d 50 01             	lea    0x1(%eax),%edx
  801314:	89 55 08             	mov    %edx,0x8(%ebp)
  801317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80131d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801320:	8a 12                	mov    (%edx),%dl
  801322:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801324:	ff 4d 10             	decl   0x10(%ebp)
  801327:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80132b:	74 09                	je     801336 <strlcpy+0x3c>
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	84 c0                	test   %al,%al
  801334:	75 d8                	jne    80130e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80133c:	8b 55 08             	mov    0x8(%ebp),%edx
  80133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801342:	29 c2                	sub    %eax,%edx
  801344:	89 d0                	mov    %edx,%eax
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80134b:	eb 06                	jmp    801353 <strcmp+0xb>
		p++, q++;
  80134d:	ff 45 08             	incl   0x8(%ebp)
  801350:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	74 0e                	je     80136a <strcmp+0x22>
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8a 10                	mov    (%eax),%dl
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	38 c2                	cmp    %al,%dl
  801368:	74 e3                	je     80134d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	0f b6 d0             	movzbl %al,%edx
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	0f b6 c0             	movzbl %al,%eax
  80137a:	29 c2                	sub    %eax,%edx
  80137c:	89 d0                	mov    %edx,%eax
}
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801383:	eb 09                	jmp    80138e <strncmp+0xe>
		n--, p++, q++;
  801385:	ff 4d 10             	decl   0x10(%ebp)
  801388:	ff 45 08             	incl   0x8(%ebp)
  80138b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80138e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801392:	74 17                	je     8013ab <strncmp+0x2b>
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	84 c0                	test   %al,%al
  80139b:	74 0e                	je     8013ab <strncmp+0x2b>
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	8a 10                	mov    (%eax),%dl
  8013a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	38 c2                	cmp    %al,%dl
  8013a9:	74 da                	je     801385 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013af:	75 07                	jne    8013b8 <strncmp+0x38>
		return 0;
  8013b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b6:	eb 14                	jmp    8013cc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	0f b6 d0             	movzbl %al,%edx
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	0f b6 c0             	movzbl %al,%eax
  8013c8:	29 c2                	sub    %eax,%edx
  8013ca:	89 d0                	mov    %edx,%eax
}
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    

008013ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013da:	eb 12                	jmp    8013ee <strchr+0x20>
		if (*s == c)
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013e4:	75 05                	jne    8013eb <strchr+0x1d>
			return (char *) s;
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	eb 11                	jmp    8013fc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 e5                	jne    8013dc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 04             	sub    $0x4,%esp
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80140a:	eb 0d                	jmp    801419 <strfind+0x1b>
		if (*s == c)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801414:	74 0e                	je     801424 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801416:	ff 45 08             	incl   0x8(%ebp)
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	84 c0                	test   %al,%al
  801420:	75 ea                	jne    80140c <strfind+0xe>
  801422:	eb 01                	jmp    801425 <strfind+0x27>
		if (*s == c)
			break;
  801424:	90                   	nop
	return (char *) s;
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801436:	8b 45 10             	mov    0x10(%ebp),%eax
  801439:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80143c:	eb 0e                	jmp    80144c <memset+0x22>
		*p++ = c;
  80143e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801441:	8d 50 01             	lea    0x1(%eax),%edx
  801444:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80144c:	ff 4d f8             	decl   -0x8(%ebp)
  80144f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801453:	79 e9                	jns    80143e <memset+0x14>
		*p++ = c;

	return v;
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801460:	8b 45 0c             	mov    0xc(%ebp),%eax
  801463:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80146c:	eb 16                	jmp    801484 <memcpy+0x2a>
		*d++ = *s++;
  80146e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801471:	8d 50 01             	lea    0x1(%eax),%edx
  801474:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801477:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801480:	8a 12                	mov    (%edx),%dl
  801482:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801484:	8b 45 10             	mov    0x10(%ebp),%eax
  801487:	8d 50 ff             	lea    -0x1(%eax),%edx
  80148a:	89 55 10             	mov    %edx,0x10(%ebp)
  80148d:	85 c0                	test   %eax,%eax
  80148f:	75 dd                	jne    80146e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80149c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014ae:	73 50                	jae    801500 <memmove+0x6a>
  8014b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014bb:	76 43                	jbe    801500 <memmove+0x6a>
		s += n;
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014c9:	eb 10                	jmp    8014db <memmove+0x45>
			*--d = *--s;
  8014cb:	ff 4d f8             	decl   -0x8(%ebp)
  8014ce:	ff 4d fc             	decl   -0x4(%ebp)
  8014d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d4:	8a 10                	mov    (%eax),%dl
  8014d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014db:	8b 45 10             	mov    0x10(%ebp),%eax
  8014de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	75 e3                	jne    8014cb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014e8:	eb 23                	jmp    80150d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ed:	8d 50 01             	lea    0x1(%eax),%edx
  8014f0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014fc:	8a 12                	mov    (%edx),%dl
  8014fe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801500:	8b 45 10             	mov    0x10(%ebp),%eax
  801503:	8d 50 ff             	lea    -0x1(%eax),%edx
  801506:	89 55 10             	mov    %edx,0x10(%ebp)
  801509:	85 c0                	test   %eax,%eax
  80150b:	75 dd                	jne    8014ea <memmove+0x54>
			*d++ = *s++;

	return dst;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80151e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801521:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801524:	eb 2a                	jmp    801550 <memcmp+0x3e>
		if (*s1 != *s2)
  801526:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801529:	8a 10                	mov    (%eax),%dl
  80152b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	38 c2                	cmp    %al,%dl
  801532:	74 16                	je     80154a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801534:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	0f b6 d0             	movzbl %al,%edx
  80153c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	0f b6 c0             	movzbl %al,%eax
  801544:	29 c2                	sub    %eax,%edx
  801546:	89 d0                	mov    %edx,%eax
  801548:	eb 18                	jmp    801562 <memcmp+0x50>
		s1++, s2++;
  80154a:	ff 45 fc             	incl   -0x4(%ebp)
  80154d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801550:	8b 45 10             	mov    0x10(%ebp),%eax
  801553:	8d 50 ff             	lea    -0x1(%eax),%edx
  801556:	89 55 10             	mov    %edx,0x10(%ebp)
  801559:	85 c0                	test   %eax,%eax
  80155b:	75 c9                	jne    801526 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80156a:	8b 55 08             	mov    0x8(%ebp),%edx
  80156d:	8b 45 10             	mov    0x10(%ebp),%eax
  801570:	01 d0                	add    %edx,%eax
  801572:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801575:	eb 15                	jmp    80158c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8a 00                	mov    (%eax),%al
  80157c:	0f b6 d0             	movzbl %al,%edx
  80157f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801582:	0f b6 c0             	movzbl %al,%eax
  801585:	39 c2                	cmp    %eax,%edx
  801587:	74 0d                	je     801596 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801589:	ff 45 08             	incl   0x8(%ebp)
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801592:	72 e3                	jb     801577 <memfind+0x13>
  801594:	eb 01                	jmp    801597 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801596:	90                   	nop
	return (void *) s;
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b0:	eb 03                	jmp    8015b5 <strtol+0x19>
		s++;
  8015b2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	8a 00                	mov    (%eax),%al
  8015ba:	3c 20                	cmp    $0x20,%al
  8015bc:	74 f4                	je     8015b2 <strtol+0x16>
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	3c 09                	cmp    $0x9,%al
  8015c5:	74 eb                	je     8015b2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8a 00                	mov    (%eax),%al
  8015cc:	3c 2b                	cmp    $0x2b,%al
  8015ce:	75 05                	jne    8015d5 <strtol+0x39>
		s++;
  8015d0:	ff 45 08             	incl   0x8(%ebp)
  8015d3:	eb 13                	jmp    8015e8 <strtol+0x4c>
	else if (*s == '-')
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8a 00                	mov    (%eax),%al
  8015da:	3c 2d                	cmp    $0x2d,%al
  8015dc:	75 0a                	jne    8015e8 <strtol+0x4c>
		s++, neg = 1;
  8015de:	ff 45 08             	incl   0x8(%ebp)
  8015e1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ec:	74 06                	je     8015f4 <strtol+0x58>
  8015ee:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f2:	75 20                	jne    801614 <strtol+0x78>
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	3c 30                	cmp    $0x30,%al
  8015fb:	75 17                	jne    801614 <strtol+0x78>
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	40                   	inc    %eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	3c 78                	cmp    $0x78,%al
  801605:	75 0d                	jne    801614 <strtol+0x78>
		s += 2, base = 16;
  801607:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80160b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801612:	eb 28                	jmp    80163c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801614:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801618:	75 15                	jne    80162f <strtol+0x93>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 0c                	jne    80162f <strtol+0x93>
		s++, base = 8;
  801623:	ff 45 08             	incl   0x8(%ebp)
  801626:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80162d:	eb 0d                	jmp    80163c <strtol+0xa0>
	else if (base == 0)
  80162f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801633:	75 07                	jne    80163c <strtol+0xa0>
		base = 10;
  801635:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	3c 2f                	cmp    $0x2f,%al
  801643:	7e 19                	jle    80165e <strtol+0xc2>
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	8a 00                	mov    (%eax),%al
  80164a:	3c 39                	cmp    $0x39,%al
  80164c:	7f 10                	jg     80165e <strtol+0xc2>
			dig = *s - '0';
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	0f be c0             	movsbl %al,%eax
  801656:	83 e8 30             	sub    $0x30,%eax
  801659:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80165c:	eb 42                	jmp    8016a0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8a 00                	mov    (%eax),%al
  801663:	3c 60                	cmp    $0x60,%al
  801665:	7e 19                	jle    801680 <strtol+0xe4>
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8a 00                	mov    (%eax),%al
  80166c:	3c 7a                	cmp    $0x7a,%al
  80166e:	7f 10                	jg     801680 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8a 00                	mov    (%eax),%al
  801675:	0f be c0             	movsbl %al,%eax
  801678:	83 e8 57             	sub    $0x57,%eax
  80167b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80167e:	eb 20                	jmp    8016a0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	3c 40                	cmp    $0x40,%al
  801687:	7e 39                	jle    8016c2 <strtol+0x126>
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	3c 5a                	cmp    $0x5a,%al
  801690:	7f 30                	jg     8016c2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8a 00                	mov    (%eax),%al
  801697:	0f be c0             	movsbl %al,%eax
  80169a:	83 e8 37             	sub    $0x37,%eax
  80169d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016a6:	7d 19                	jge    8016c1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016a8:	ff 45 08             	incl   0x8(%ebp)
  8016ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ae:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016b2:	89 c2                	mov    %eax,%edx
  8016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016bc:	e9 7b ff ff ff       	jmp    80163c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016c1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016c6:	74 08                	je     8016d0 <strtol+0x134>
		*endptr = (char *) s;
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ce:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016d4:	74 07                	je     8016dd <strtol+0x141>
  8016d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d9:	f7 d8                	neg    %eax
  8016db:	eb 03                	jmp    8016e0 <strtol+0x144>
  8016dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <ltostr>:

void
ltostr(long value, char *str)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016fa:	79 13                	jns    80170f <ltostr+0x2d>
	{
		neg = 1;
  8016fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801703:	8b 45 0c             	mov    0xc(%ebp),%eax
  801706:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801709:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80170c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801717:	99                   	cltd   
  801718:	f7 f9                	idiv   %ecx
  80171a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80171d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801720:	8d 50 01             	lea    0x1(%eax),%edx
  801723:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801726:	89 c2                	mov    %eax,%edx
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	01 d0                	add    %edx,%eax
  80172d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801730:	83 c2 30             	add    $0x30,%edx
  801733:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801735:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801738:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80173d:	f7 e9                	imul   %ecx
  80173f:	c1 fa 02             	sar    $0x2,%edx
  801742:	89 c8                	mov    %ecx,%eax
  801744:	c1 f8 1f             	sar    $0x1f,%eax
  801747:	29 c2                	sub    %eax,%edx
  801749:	89 d0                	mov    %edx,%eax
  80174b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80174e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801751:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801756:	f7 e9                	imul   %ecx
  801758:	c1 fa 02             	sar    $0x2,%edx
  80175b:	89 c8                	mov    %ecx,%eax
  80175d:	c1 f8 1f             	sar    $0x1f,%eax
  801760:	29 c2                	sub    %eax,%edx
  801762:	89 d0                	mov    %edx,%eax
  801764:	c1 e0 02             	shl    $0x2,%eax
  801767:	01 d0                	add    %edx,%eax
  801769:	01 c0                	add    %eax,%eax
  80176b:	29 c1                	sub    %eax,%ecx
  80176d:	89 ca                	mov    %ecx,%edx
  80176f:	85 d2                	test   %edx,%edx
  801771:	75 9c                	jne    80170f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80177a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177d:	48                   	dec    %eax
  80177e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801781:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801785:	74 3d                	je     8017c4 <ltostr+0xe2>
		start = 1 ;
  801787:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80178e:	eb 34                	jmp    8017c4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801793:	8b 45 0c             	mov    0xc(%ebp),%eax
  801796:	01 d0                	add    %edx,%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80179d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a3:	01 c2                	add    %eax,%edx
  8017a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	01 c8                	add    %ecx,%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b7:	01 c2                	add    %eax,%edx
  8017b9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017bc:	88 02                	mov    %al,(%edx)
		start++ ;
  8017be:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017c1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017ca:	7c c4                	jl     801790 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d2:	01 d0                	add    %edx,%eax
  8017d4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	e8 54 fa ff ff       	call   80123c <strlen>
  8017e8:	83 c4 04             	add    $0x4,%esp
  8017eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	e8 46 fa ff ff       	call   80123c <strlen>
  8017f6:	83 c4 04             	add    $0x4,%esp
  8017f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801803:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80180a:	eb 17                	jmp    801823 <strcconcat+0x49>
		final[s] = str1[s] ;
  80180c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	01 c2                	add    %eax,%edx
  801814:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	01 c8                	add    %ecx,%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801820:	ff 45 fc             	incl   -0x4(%ebp)
  801823:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801826:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801829:	7c e1                	jl     80180c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80182b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801832:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801839:	eb 1f                	jmp    80185a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80183b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80183e:	8d 50 01             	lea    0x1(%eax),%edx
  801841:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801844:	89 c2                	mov    %eax,%edx
  801846:	8b 45 10             	mov    0x10(%ebp),%eax
  801849:	01 c2                	add    %eax,%edx
  80184b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	01 c8                	add    %ecx,%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801857:	ff 45 f8             	incl   -0x8(%ebp)
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801860:	7c d9                	jl     80183b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801862:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801865:	8b 45 10             	mov    0x10(%ebp),%eax
  801868:	01 d0                	add    %edx,%eax
  80186a:	c6 00 00             	movb   $0x0,(%eax)
}
  80186d:	90                   	nop
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801873:	8b 45 14             	mov    0x14(%ebp),%eax
  801876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80187c:	8b 45 14             	mov    0x14(%ebp),%eax
  80187f:	8b 00                	mov    (%eax),%eax
  801881:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801888:	8b 45 10             	mov    0x10(%ebp),%eax
  80188b:	01 d0                	add    %edx,%eax
  80188d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801893:	eb 0c                	jmp    8018a1 <strsplit+0x31>
			*string++ = 0;
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8d 50 01             	lea    0x1(%eax),%edx
  80189b:	89 55 08             	mov    %edx,0x8(%ebp)
  80189e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	8a 00                	mov    (%eax),%al
  8018a6:	84 c0                	test   %al,%al
  8018a8:	74 18                	je     8018c2 <strsplit+0x52>
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	0f be c0             	movsbl %al,%eax
  8018b2:	50                   	push   %eax
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	e8 13 fb ff ff       	call   8013ce <strchr>
  8018bb:	83 c4 08             	add    $0x8,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	75 d3                	jne    801895 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	8a 00                	mov    (%eax),%al
  8018c7:	84 c0                	test   %al,%al
  8018c9:	74 5a                	je     801925 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ce:	8b 00                	mov    (%eax),%eax
  8018d0:	83 f8 0f             	cmp    $0xf,%eax
  8018d3:	75 07                	jne    8018dc <strsplit+0x6c>
		{
			return 0;
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018da:	eb 66                	jmp    801942 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018df:	8b 00                	mov    (%eax),%eax
  8018e1:	8d 48 01             	lea    0x1(%eax),%ecx
  8018e4:	8b 55 14             	mov    0x14(%ebp),%edx
  8018e7:	89 0a                	mov    %ecx,(%edx)
  8018e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f3:	01 c2                	add    %eax,%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018fa:	eb 03                	jmp    8018ff <strsplit+0x8f>
			string++;
  8018fc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	8a 00                	mov    (%eax),%al
  801904:	84 c0                	test   %al,%al
  801906:	74 8b                	je     801893 <strsplit+0x23>
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	8a 00                	mov    (%eax),%al
  80190d:	0f be c0             	movsbl %al,%eax
  801910:	50                   	push   %eax
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	e8 b5 fa ff ff       	call   8013ce <strchr>
  801919:	83 c4 08             	add    $0x8,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	74 dc                	je     8018fc <strsplit+0x8c>
			string++;
	}
  801920:	e9 6e ff ff ff       	jmp    801893 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801925:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801926:	8b 45 14             	mov    0x14(%ebp),%eax
  801929:	8b 00                	mov    (%eax),%eax
  80192b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801932:	8b 45 10             	mov    0x10(%ebp),%eax
  801935:	01 d0                	add    %edx,%eax
  801937:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80193d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	68 d0 2a 80 00       	push   $0x802ad0
  801952:	6a 0e                	push   $0xe
  801954:	68 0a 2b 80 00       	push   $0x802b0a
  801959:	e8 a8 ef ff ff       	call   800906 <_panic>

0080195e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801964:	a1 04 30 80 00       	mov    0x803004,%eax
  801969:	85 c0                	test   %eax,%eax
  80196b:	74 0f                	je     80197c <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80196d:	e8 d2 ff ff ff       	call   801944 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801972:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801979:	00 00 00 
	}
	if (size == 0) return NULL ;
  80197c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801980:	75 07                	jne    801989 <malloc+0x2b>
  801982:	b8 00 00 00 00       	mov    $0x0,%eax
  801987:	eb 14                	jmp    80199d <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	68 18 2b 80 00       	push   $0x802b18
  801991:	6a 2e                	push   $0x2e
  801993:	68 0a 2b 80 00       	push   $0x802b0a
  801998:	e8 69 ef ff ff       	call   800906 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	68 40 2b 80 00       	push   $0x802b40
  8019ad:	6a 49                	push   $0x49
  8019af:	68 0a 2b 80 00       	push   $0x802b0a
  8019b4:	e8 4d ef ff ff       	call   800906 <_panic>

008019b9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 18             	sub    $0x18,%esp
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	68 64 2b 80 00       	push   $0x802b64
  8019cd:	6a 57                	push   $0x57
  8019cf:	68 0a 2b 80 00       	push   $0x802b0a
  8019d4:	e8 2d ef ff ff       	call   800906 <_panic>

008019d9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	68 8c 2b 80 00       	push   $0x802b8c
  8019e7:	6a 60                	push   $0x60
  8019e9:	68 0a 2b 80 00       	push   $0x802b0a
  8019ee:	e8 13 ef ff ff       	call   800906 <_panic>

008019f3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	68 b0 2b 80 00       	push   $0x802bb0
  801a01:	6a 7c                	push   $0x7c
  801a03:	68 0a 2b 80 00       	push   $0x802b0a
  801a08:	e8 f9 ee ff ff       	call   800906 <_panic>

00801a0d <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a13:	83 ec 04             	sub    $0x4,%esp
  801a16:	68 d8 2b 80 00       	push   $0x802bd8
  801a1b:	68 86 00 00 00       	push   $0x86
  801a20:	68 0a 2b 80 00       	push   $0x802b0a
  801a25:	e8 dc ee ff ff       	call   800906 <_panic>

00801a2a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	68 fc 2b 80 00       	push   $0x802bfc
  801a38:	68 91 00 00 00       	push   $0x91
  801a3d:	68 0a 2b 80 00       	push   $0x802b0a
  801a42:	e8 bf ee ff ff       	call   800906 <_panic>

00801a47 <shrink>:

}
void shrink(uint32 newSize)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	68 fc 2b 80 00       	push   $0x802bfc
  801a55:	68 96 00 00 00       	push   $0x96
  801a5a:	68 0a 2b 80 00       	push   $0x802b0a
  801a5f:	e8 a2 ee ff ff       	call   800906 <_panic>

00801a64 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	68 fc 2b 80 00       	push   $0x802bfc
  801a72:	68 9b 00 00 00       	push   $0x9b
  801a77:	68 0a 2b 80 00       	push   $0x802b0a
  801a7c:	e8 85 ee ff ff       	call   800906 <_panic>

00801a81 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	57                   	push   %edi
  801a85:	56                   	push   %esi
  801a86:	53                   	push   %ebx
  801a87:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a96:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a99:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a9c:	cd 30                	int    $0x30
  801a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	5b                   	pop    %ebx
  801aa8:	5e                   	pop    %esi
  801aa9:	5f                   	pop    %edi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    

00801aac <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ab8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	ff 75 0c             	pushl  0xc(%ebp)
  801ac7:	50                   	push   %eax
  801ac8:	6a 00                	push   $0x0
  801aca:	e8 b2 ff ff ff       	call   801a81 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	90                   	nop
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 01                	push   $0x1
  801ae4:	e8 98 ff ff ff       	call   801a81 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	52                   	push   %edx
  801afe:	50                   	push   %eax
  801aff:	6a 05                	push   $0x5
  801b01:	e8 7b ff ff ff       	call   801a81 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b10:	8b 75 18             	mov    0x18(%ebp),%esi
  801b13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b16:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	56                   	push   %esi
  801b20:	53                   	push   %ebx
  801b21:	51                   	push   %ecx
  801b22:	52                   	push   %edx
  801b23:	50                   	push   %eax
  801b24:	6a 06                	push   $0x6
  801b26:	e8 56 ff ff ff       	call   801a81 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5d                   	pop    %ebp
  801b34:	c3                   	ret    

00801b35 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	52                   	push   %edx
  801b45:	50                   	push   %eax
  801b46:	6a 07                	push   $0x7
  801b48:	e8 34 ff ff ff       	call   801a81 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	ff 75 08             	pushl  0x8(%ebp)
  801b61:	6a 08                	push   $0x8
  801b63:	e8 19 ff ff ff       	call   801a81 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 09                	push   $0x9
  801b7c:	e8 00 ff ff ff       	call   801a81 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 0a                	push   $0xa
  801b95:	e8 e7 fe ff ff       	call   801a81 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 0b                	push   $0xb
  801bae:	e8 ce fe ff ff       	call   801a81 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	6a 0f                	push   $0xf
  801bc9:	e8 b3 fe ff ff       	call   801a81 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
	return;
  801bd1:	90                   	nop
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	6a 10                	push   $0x10
  801be5:	e8 97 fe ff ff       	call   801a81 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
	return ;
  801bed:	90                   	nop
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	ff 75 10             	pushl  0x10(%ebp)
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	ff 75 08             	pushl  0x8(%ebp)
  801c00:	6a 11                	push   $0x11
  801c02:	e8 7a fe ff ff       	call   801a81 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0a:	90                   	nop
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 0c                	push   $0xc
  801c1c:	e8 60 fe ff ff       	call   801a81 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	ff 75 08             	pushl  0x8(%ebp)
  801c34:	6a 0d                	push   $0xd
  801c36:	e8 46 fe ff ff       	call   801a81 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 0e                	push   $0xe
  801c4f:	e8 2d fe ff ff       	call   801a81 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	90                   	nop
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 13                	push   $0x13
  801c69:	e8 13 fe ff ff       	call   801a81 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	90                   	nop
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 14                	push   $0x14
  801c83:	e8 f9 fd ff ff       	call   801a81 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	90                   	nop
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_cputc>:


void
sys_cputc(const char c)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 04             	sub    $0x4,%esp
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c9a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	50                   	push   %eax
  801ca7:	6a 15                	push   $0x15
  801ca9:	e8 d3 fd ff ff       	call   801a81 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	90                   	nop
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 16                	push   $0x16
  801cc3:	e8 b9 fd ff ff       	call   801a81 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	90                   	nop
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	50                   	push   %eax
  801cde:	6a 17                	push   $0x17
  801ce0:	e8 9c fd ff ff       	call   801a81 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	52                   	push   %edx
  801cfa:	50                   	push   %eax
  801cfb:	6a 1a                	push   $0x1a
  801cfd:	e8 7f fd ff ff       	call   801a81 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	6a 18                	push   $0x18
  801d1a:	e8 62 fd ff ff       	call   801a81 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	90                   	nop
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	52                   	push   %edx
  801d35:	50                   	push   %eax
  801d36:	6a 19                	push   $0x19
  801d38:	e8 44 fd ff ff       	call   801a81 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d52:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	51                   	push   %ecx
  801d5c:	52                   	push   %edx
  801d5d:	ff 75 0c             	pushl  0xc(%ebp)
  801d60:	50                   	push   %eax
  801d61:	6a 1b                	push   $0x1b
  801d63:	e8 19 fd ff ff       	call   801a81 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	52                   	push   %edx
  801d7d:	50                   	push   %eax
  801d7e:	6a 1c                	push   $0x1c
  801d80:	e8 fc fc ff ff       	call   801a81 <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	51                   	push   %ecx
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 1d                	push   $0x1d
  801d9f:	e8 dd fc ff ff       	call   801a81 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	6a 1e                	push   $0x1e
  801dbc:	e8 c0 fc ff ff       	call   801a81 <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 1f                	push   $0x1f
  801dd5:	e8 a7 fc ff ff       	call   801a81 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	6a 00                	push   $0x0
  801de7:	ff 75 14             	pushl  0x14(%ebp)
  801dea:	ff 75 10             	pushl  0x10(%ebp)
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	50                   	push   %eax
  801df1:	6a 20                	push   $0x20
  801df3:	e8 89 fc ff ff       	call   801a81 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	50                   	push   %eax
  801e0c:	6a 21                	push   $0x21
  801e0e:	e8 6e fc ff ff       	call   801a81 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	90                   	nop
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	50                   	push   %eax
  801e28:	6a 22                	push   $0x22
  801e2a:	e8 52 fc ff ff       	call   801a81 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 02                	push   $0x2
  801e43:	e8 39 fc ff ff       	call   801a81 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 03                	push   $0x3
  801e5c:	e8 20 fc ff ff       	call   801a81 <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 04                	push   $0x4
  801e75:	e8 07 fc ff ff       	call   801a81 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_exit_env>:


void sys_exit_env(void)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 23                	push   $0x23
  801e8e:	e8 ee fb ff ff       	call   801a81 <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	90                   	nop
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e9f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ea2:	8d 50 04             	lea    0x4(%eax),%edx
  801ea5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	52                   	push   %edx
  801eaf:	50                   	push   %eax
  801eb0:	6a 24                	push   $0x24
  801eb2:	e8 ca fb ff ff       	call   801a81 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
	return result;
  801eba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ec0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ec3:	89 01                	mov    %eax,(%ecx)
  801ec5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	c9                   	leave  
  801ecc:	c2 04 00             	ret    $0x4

00801ecf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	ff 75 10             	pushl  0x10(%ebp)
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	ff 75 08             	pushl  0x8(%ebp)
  801edf:	6a 12                	push   $0x12
  801ee1:	e8 9b fb ff ff       	call   801a81 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee9:	90                   	nop
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_rcr2>:
uint32 sys_rcr2()
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 25                	push   $0x25
  801efb:	e8 81 fb ff ff       	call   801a81 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f11:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	50                   	push   %eax
  801f1e:	6a 26                	push   $0x26
  801f20:	e8 5c fb ff ff       	call   801a81 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
	return ;
  801f28:	90                   	nop
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <rsttst>:
void rsttst()
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 28                	push   $0x28
  801f3a:	e8 42 fb ff ff       	call   801a81 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f42:	90                   	nop
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f51:	8b 55 18             	mov    0x18(%ebp),%edx
  801f54:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f58:	52                   	push   %edx
  801f59:	50                   	push   %eax
  801f5a:	ff 75 10             	pushl  0x10(%ebp)
  801f5d:	ff 75 0c             	pushl  0xc(%ebp)
  801f60:	ff 75 08             	pushl  0x8(%ebp)
  801f63:	6a 27                	push   $0x27
  801f65:	e8 17 fb ff ff       	call   801a81 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6d:	90                   	nop
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <chktst>:
void chktst(uint32 n)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	ff 75 08             	pushl  0x8(%ebp)
  801f7e:	6a 29                	push   $0x29
  801f80:	e8 fc fa ff ff       	call   801a81 <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
	return ;
  801f88:	90                   	nop
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <inctst>:

void inctst()
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 2a                	push   $0x2a
  801f9a:	e8 e2 fa ff ff       	call   801a81 <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa2:	90                   	nop
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <gettst>:
uint32 gettst()
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 2b                	push   $0x2b
  801fb4:	e8 c8 fa ff ff       	call   801a81 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 2c                	push   $0x2c
  801fd0:	e8 ac fa ff ff       	call   801a81 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
  801fd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fdb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fdf:	75 07                	jne    801fe8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fe1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe6:	eb 05                	jmp    801fed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 2c                	push   $0x2c
  802001:	e8 7b fa ff ff       	call   801a81 <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
  802009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80200c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802010:	75 07                	jne    802019 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802012:	b8 01 00 00 00       	mov    $0x1,%eax
  802017:	eb 05                	jmp    80201e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 2c                	push   $0x2c
  802032:	e8 4a fa ff ff       	call   801a81 <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
  80203a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80203d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802041:	75 07                	jne    80204a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802043:	b8 01 00 00 00       	mov    $0x1,%eax
  802048:	eb 05                	jmp    80204f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  802063:	e8 19 fa ff ff       	call   801a81 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
  80206b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80206e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802072:	75 07                	jne    80207b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802074:	b8 01 00 00 00       	mov    $0x1,%eax
  802079:	eb 05                	jmp    802080 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	6a 2d                	push   $0x2d
  802092:	e8 ea f9 ff ff       	call   801a81 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
	return ;
  80209a:	90                   	nop
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	6a 00                	push   $0x0
  8020af:	53                   	push   %ebx
  8020b0:	51                   	push   %ecx
  8020b1:	52                   	push   %edx
  8020b2:	50                   	push   %eax
  8020b3:	6a 2e                	push   $0x2e
  8020b5:	e8 c7 f9 ff ff       	call   801a81 <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
}
  8020bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	52                   	push   %edx
  8020d2:	50                   	push   %eax
  8020d3:	6a 2f                	push   $0x2f
  8020d5:	e8 a7 f9 ff ff       	call   801a81 <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    
  8020df:	90                   	nop

008020e0 <__udivdi3>:
  8020e0:	55                   	push   %ebp
  8020e1:	57                   	push   %edi
  8020e2:	56                   	push   %esi
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 1c             	sub    $0x1c,%esp
  8020e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020f7:	89 ca                	mov    %ecx,%edx
  8020f9:	89 f8                	mov    %edi,%eax
  8020fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8020ff:	85 f6                	test   %esi,%esi
  802101:	75 2d                	jne    802130 <__udivdi3+0x50>
  802103:	39 cf                	cmp    %ecx,%edi
  802105:	77 65                	ja     80216c <__udivdi3+0x8c>
  802107:	89 fd                	mov    %edi,%ebp
  802109:	85 ff                	test   %edi,%edi
  80210b:	75 0b                	jne    802118 <__udivdi3+0x38>
  80210d:	b8 01 00 00 00       	mov    $0x1,%eax
  802112:	31 d2                	xor    %edx,%edx
  802114:	f7 f7                	div    %edi
  802116:	89 c5                	mov    %eax,%ebp
  802118:	31 d2                	xor    %edx,%edx
  80211a:	89 c8                	mov    %ecx,%eax
  80211c:	f7 f5                	div    %ebp
  80211e:	89 c1                	mov    %eax,%ecx
  802120:	89 d8                	mov    %ebx,%eax
  802122:	f7 f5                	div    %ebp
  802124:	89 cf                	mov    %ecx,%edi
  802126:	89 fa                	mov    %edi,%edx
  802128:	83 c4 1c             	add    $0x1c,%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5e                   	pop    %esi
  80212d:	5f                   	pop    %edi
  80212e:	5d                   	pop    %ebp
  80212f:	c3                   	ret    
  802130:	39 ce                	cmp    %ecx,%esi
  802132:	77 28                	ja     80215c <__udivdi3+0x7c>
  802134:	0f bd fe             	bsr    %esi,%edi
  802137:	83 f7 1f             	xor    $0x1f,%edi
  80213a:	75 40                	jne    80217c <__udivdi3+0x9c>
  80213c:	39 ce                	cmp    %ecx,%esi
  80213e:	72 0a                	jb     80214a <__udivdi3+0x6a>
  802140:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802144:	0f 87 9e 00 00 00    	ja     8021e8 <__udivdi3+0x108>
  80214a:	b8 01 00 00 00       	mov    $0x1,%eax
  80214f:	89 fa                	mov    %edi,%edx
  802151:	83 c4 1c             	add    $0x1c,%esp
  802154:	5b                   	pop    %ebx
  802155:	5e                   	pop    %esi
  802156:	5f                   	pop    %edi
  802157:	5d                   	pop    %ebp
  802158:	c3                   	ret    
  802159:	8d 76 00             	lea    0x0(%esi),%esi
  80215c:	31 ff                	xor    %edi,%edi
  80215e:	31 c0                	xor    %eax,%eax
  802160:	89 fa                	mov    %edi,%edx
  802162:	83 c4 1c             	add    $0x1c,%esp
  802165:	5b                   	pop    %ebx
  802166:	5e                   	pop    %esi
  802167:	5f                   	pop    %edi
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    
  80216a:	66 90                	xchg   %ax,%ax
  80216c:	89 d8                	mov    %ebx,%eax
  80216e:	f7 f7                	div    %edi
  802170:	31 ff                	xor    %edi,%edi
  802172:	89 fa                	mov    %edi,%edx
  802174:	83 c4 1c             	add    $0x1c,%esp
  802177:	5b                   	pop    %ebx
  802178:	5e                   	pop    %esi
  802179:	5f                   	pop    %edi
  80217a:	5d                   	pop    %ebp
  80217b:	c3                   	ret    
  80217c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802181:	89 eb                	mov    %ebp,%ebx
  802183:	29 fb                	sub    %edi,%ebx
  802185:	89 f9                	mov    %edi,%ecx
  802187:	d3 e6                	shl    %cl,%esi
  802189:	89 c5                	mov    %eax,%ebp
  80218b:	88 d9                	mov    %bl,%cl
  80218d:	d3 ed                	shr    %cl,%ebp
  80218f:	89 e9                	mov    %ebp,%ecx
  802191:	09 f1                	or     %esi,%ecx
  802193:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802197:	89 f9                	mov    %edi,%ecx
  802199:	d3 e0                	shl    %cl,%eax
  80219b:	89 c5                	mov    %eax,%ebp
  80219d:	89 d6                	mov    %edx,%esi
  80219f:	88 d9                	mov    %bl,%cl
  8021a1:	d3 ee                	shr    %cl,%esi
  8021a3:	89 f9                	mov    %edi,%ecx
  8021a5:	d3 e2                	shl    %cl,%edx
  8021a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021ab:	88 d9                	mov    %bl,%cl
  8021ad:	d3 e8                	shr    %cl,%eax
  8021af:	09 c2                	or     %eax,%edx
  8021b1:	89 d0                	mov    %edx,%eax
  8021b3:	89 f2                	mov    %esi,%edx
  8021b5:	f7 74 24 0c          	divl   0xc(%esp)
  8021b9:	89 d6                	mov    %edx,%esi
  8021bb:	89 c3                	mov    %eax,%ebx
  8021bd:	f7 e5                	mul    %ebp
  8021bf:	39 d6                	cmp    %edx,%esi
  8021c1:	72 19                	jb     8021dc <__udivdi3+0xfc>
  8021c3:	74 0b                	je     8021d0 <__udivdi3+0xf0>
  8021c5:	89 d8                	mov    %ebx,%eax
  8021c7:	31 ff                	xor    %edi,%edi
  8021c9:	e9 58 ff ff ff       	jmp    802126 <__udivdi3+0x46>
  8021ce:	66 90                	xchg   %ax,%ax
  8021d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021d4:	89 f9                	mov    %edi,%ecx
  8021d6:	d3 e2                	shl    %cl,%edx
  8021d8:	39 c2                	cmp    %eax,%edx
  8021da:	73 e9                	jae    8021c5 <__udivdi3+0xe5>
  8021dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021df:	31 ff                	xor    %edi,%edi
  8021e1:	e9 40 ff ff ff       	jmp    802126 <__udivdi3+0x46>
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	31 c0                	xor    %eax,%eax
  8021ea:	e9 37 ff ff ff       	jmp    802126 <__udivdi3+0x46>
  8021ef:	90                   	nop

008021f0 <__umoddi3>:
  8021f0:	55                   	push   %ebp
  8021f1:	57                   	push   %edi
  8021f2:	56                   	push   %esi
  8021f3:	53                   	push   %ebx
  8021f4:	83 ec 1c             	sub    $0x1c,%esp
  8021f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802203:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802207:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80220b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80220f:	89 f3                	mov    %esi,%ebx
  802211:	89 fa                	mov    %edi,%edx
  802213:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802217:	89 34 24             	mov    %esi,(%esp)
  80221a:	85 c0                	test   %eax,%eax
  80221c:	75 1a                	jne    802238 <__umoddi3+0x48>
  80221e:	39 f7                	cmp    %esi,%edi
  802220:	0f 86 a2 00 00 00    	jbe    8022c8 <__umoddi3+0xd8>
  802226:	89 c8                	mov    %ecx,%eax
  802228:	89 f2                	mov    %esi,%edx
  80222a:	f7 f7                	div    %edi
  80222c:	89 d0                	mov    %edx,%eax
  80222e:	31 d2                	xor    %edx,%edx
  802230:	83 c4 1c             	add    $0x1c,%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    
  802238:	39 f0                	cmp    %esi,%eax
  80223a:	0f 87 ac 00 00 00    	ja     8022ec <__umoddi3+0xfc>
  802240:	0f bd e8             	bsr    %eax,%ebp
  802243:	83 f5 1f             	xor    $0x1f,%ebp
  802246:	0f 84 ac 00 00 00    	je     8022f8 <__umoddi3+0x108>
  80224c:	bf 20 00 00 00       	mov    $0x20,%edi
  802251:	29 ef                	sub    %ebp,%edi
  802253:	89 fe                	mov    %edi,%esi
  802255:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802259:	89 e9                	mov    %ebp,%ecx
  80225b:	d3 e0                	shl    %cl,%eax
  80225d:	89 d7                	mov    %edx,%edi
  80225f:	89 f1                	mov    %esi,%ecx
  802261:	d3 ef                	shr    %cl,%edi
  802263:	09 c7                	or     %eax,%edi
  802265:	89 e9                	mov    %ebp,%ecx
  802267:	d3 e2                	shl    %cl,%edx
  802269:	89 14 24             	mov    %edx,(%esp)
  80226c:	89 d8                	mov    %ebx,%eax
  80226e:	d3 e0                	shl    %cl,%eax
  802270:	89 c2                	mov    %eax,%edx
  802272:	8b 44 24 08          	mov    0x8(%esp),%eax
  802276:	d3 e0                	shl    %cl,%eax
  802278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802280:	89 f1                	mov    %esi,%ecx
  802282:	d3 e8                	shr    %cl,%eax
  802284:	09 d0                	or     %edx,%eax
  802286:	d3 eb                	shr    %cl,%ebx
  802288:	89 da                	mov    %ebx,%edx
  80228a:	f7 f7                	div    %edi
  80228c:	89 d3                	mov    %edx,%ebx
  80228e:	f7 24 24             	mull   (%esp)
  802291:	89 c6                	mov    %eax,%esi
  802293:	89 d1                	mov    %edx,%ecx
  802295:	39 d3                	cmp    %edx,%ebx
  802297:	0f 82 87 00 00 00    	jb     802324 <__umoddi3+0x134>
  80229d:	0f 84 91 00 00 00    	je     802334 <__umoddi3+0x144>
  8022a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022a7:	29 f2                	sub    %esi,%edx
  8022a9:	19 cb                	sbb    %ecx,%ebx
  8022ab:	89 d8                	mov    %ebx,%eax
  8022ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022b1:	d3 e0                	shl    %cl,%eax
  8022b3:	89 e9                	mov    %ebp,%ecx
  8022b5:	d3 ea                	shr    %cl,%edx
  8022b7:	09 d0                	or     %edx,%eax
  8022b9:	89 e9                	mov    %ebp,%ecx
  8022bb:	d3 eb                	shr    %cl,%ebx
  8022bd:	89 da                	mov    %ebx,%edx
  8022bf:	83 c4 1c             	add    $0x1c,%esp
  8022c2:	5b                   	pop    %ebx
  8022c3:	5e                   	pop    %esi
  8022c4:	5f                   	pop    %edi
  8022c5:	5d                   	pop    %ebp
  8022c6:	c3                   	ret    
  8022c7:	90                   	nop
  8022c8:	89 fd                	mov    %edi,%ebp
  8022ca:	85 ff                	test   %edi,%edi
  8022cc:	75 0b                	jne    8022d9 <__umoddi3+0xe9>
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f7                	div    %edi
  8022d7:	89 c5                	mov    %eax,%ebp
  8022d9:	89 f0                	mov    %esi,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f5                	div    %ebp
  8022df:	89 c8                	mov    %ecx,%eax
  8022e1:	f7 f5                	div    %ebp
  8022e3:	89 d0                	mov    %edx,%eax
  8022e5:	e9 44 ff ff ff       	jmp    80222e <__umoddi3+0x3e>
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	89 c8                	mov    %ecx,%eax
  8022ee:	89 f2                	mov    %esi,%edx
  8022f0:	83 c4 1c             	add    $0x1c,%esp
  8022f3:	5b                   	pop    %ebx
  8022f4:	5e                   	pop    %esi
  8022f5:	5f                   	pop    %edi
  8022f6:	5d                   	pop    %ebp
  8022f7:	c3                   	ret    
  8022f8:	3b 04 24             	cmp    (%esp),%eax
  8022fb:	72 06                	jb     802303 <__umoddi3+0x113>
  8022fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802301:	77 0f                	ja     802312 <__umoddi3+0x122>
  802303:	89 f2                	mov    %esi,%edx
  802305:	29 f9                	sub    %edi,%ecx
  802307:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80230b:	89 14 24             	mov    %edx,(%esp)
  80230e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802312:	8b 44 24 04          	mov    0x4(%esp),%eax
  802316:	8b 14 24             	mov    (%esp),%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d 76 00             	lea    0x0(%esi),%esi
  802324:	2b 04 24             	sub    (%esp),%eax
  802327:	19 fa                	sbb    %edi,%edx
  802329:	89 d1                	mov    %edx,%ecx
  80232b:	89 c6                	mov    %eax,%esi
  80232d:	e9 71 ff ff ff       	jmp    8022a3 <__umoddi3+0xb3>
  802332:	66 90                	xchg   %ax,%ax
  802334:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802338:	72 ea                	jb     802324 <__umoddi3+0x134>
  80233a:	89 d9                	mov    %ebx,%ecx
  80233c:	e9 62 ff ff ff       	jmp    8022a3 <__umoddi3+0xb3>
