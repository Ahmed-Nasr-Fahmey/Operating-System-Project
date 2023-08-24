
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 20 08 00 00       	call   800856 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 ae 1e 00 00       	call   801eff <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c9 fe ff ff    	lea    -0x137(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 00 26 80 00       	push   $0x802600
  800060:	e8 76 12 00 00       	call   8012db <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c9 fe ff ff    	lea    -0x137(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 c6 17 00 00       	call   801841 <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 73 1b 00 00       	call   801c03 <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800096:	a1 24 30 80 00       	mov    0x803024,%eax
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	50                   	push   %eax
  80009f:	e8 7f 03 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS ;
  8000aa:	e8 63 1d 00 00       	call   801e12 <sys_calculate_free_frames>
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	e8 75 1d 00 00       	call   801e2b <sys_calculate_modified_frames>
  8000b6:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000bc:	29 c2                	sub    %eax,%edx
  8000be:	89 d0                	mov    %edx,%eax
  8000c0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		Elements[NumOfElements] = 10 ;
  8000c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d0:	01 d0                	add    %edx,%eax
  8000d2:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 20 26 80 00       	push   $0x802620
  8000e0:	e8 74 0b 00 00       	call   800c59 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 43 26 80 00       	push   $0x802643
  8000f0:	e8 64 0b 00 00       	call   800c59 <cprintf>
  8000f5:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	68 51 26 80 00       	push   $0x802651
  800100:	e8 54 0b 00 00       	call   800c59 <cprintf>
  800105:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  800108:	83 ec 0c             	sub    $0xc,%esp
  80010b:	68 60 26 80 00       	push   $0x802660
  800110:	e8 44 0b 00 00       	call   800c59 <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	68 70 26 80 00       	push   $0x802670
  800120:	e8 34 0b 00 00       	call   800c59 <cprintf>
  800125:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800128:	e8 d1 06 00 00       	call   8007fe <getchar>
  80012d:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800130:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	50                   	push   %eax
  800138:	e8 79 06 00 00       	call   8007b6 <cputchar>
  80013d:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	6a 0a                	push   $0xa
  800145:	e8 6c 06 00 00       	call   8007b6 <cputchar>
  80014a:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80014d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800151:	74 0c                	je     80015f <_main+0x127>
  800153:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800157:	74 06                	je     80015f <_main+0x127>
  800159:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80015d:	75 b9                	jne    800118 <_main+0xe0>
	sys_enable_interrupt();
  80015f:	e8 b5 1d 00 00       	call   801f19 <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  800164:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800168:	83 f8 62             	cmp    $0x62,%eax
  80016b:	74 1d                	je     80018a <_main+0x152>
  80016d:	83 f8 63             	cmp    $0x63,%eax
  800170:	74 2b                	je     80019d <_main+0x165>
  800172:	83 f8 61             	cmp    $0x61,%eax
  800175:	75 39                	jne    8001b0 <_main+0x178>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	ff 75 ec             	pushl  -0x14(%ebp)
  80017d:	ff 75 e8             	pushl  -0x18(%ebp)
  800180:	e8 f9 04 00 00       	call   80067e <InitializeAscending>
  800185:	83 c4 10             	add    $0x10,%esp
			break ;
  800188:	eb 37                	jmp    8001c1 <_main+0x189>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 ec             	pushl  -0x14(%ebp)
  800190:	ff 75 e8             	pushl  -0x18(%ebp)
  800193:	e8 17 05 00 00       	call   8006af <InitializeDescending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 24                	jmp    8001c1 <_main+0x189>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a6:	e8 39 05 00 00       	call   8006e4 <InitializeSemiRandom>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 11                	jmp    8001c1 <_main+0x189>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b9:	e8 26 05 00 00       	call   8006e4 <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ca:	e8 f4 02 00 00       	call   8004c3 <QuickSort>
  8001cf:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001db:	e8 f4 03 00 00       	call   8005d4 <CheckSorted>
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001ea:	75 14                	jne    800200 <_main+0x1c8>
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	68 7c 26 80 00       	push   $0x80267c
  8001f4:	6a 57                	push   $0x57
  8001f6:	68 9e 26 80 00       	push   $0x80269e
  8001fb:	e8 a5 07 00 00       	call   8009a5 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	68 bc 26 80 00       	push   $0x8026bc
  800208:	e8 4c 0a 00 00       	call   800c59 <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 f0 26 80 00       	push   $0x8026f0
  800218:	e8 3c 0a 00 00       	call   800c59 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	68 24 27 80 00       	push   $0x802724
  800228:	e8 2c 0a 00 00       	call   800c59 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 56 27 80 00       	push   $0x802756
  800238:	e8 1c 0a 00 00       	call   800c59 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 e8             	pushl  -0x18(%ebp)
  800246:	e8 f9 19 00 00       	call   801c44 <free>
  80024b:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  80024e:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800252:	75 72                	jne    8002c6 <_main+0x28e>
		{
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800254:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80025b:	75 06                	jne    800263 <_main+0x22b>
  80025d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800261:	74 14                	je     800277 <_main+0x23f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	68 6c 27 80 00       	push   $0x80276c
  80026b:	6a 69                	push   $0x69
  80026d:	68 9e 26 80 00       	push   $0x80269e
  800272:	e8 2e 07 00 00       	call   8009a5 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800277:	a1 24 30 80 00       	mov    0x803024,%eax
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	50                   	push   %eax
  800280:	e8 9e 01 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80028b:	e8 82 1b 00 00       	call   801e12 <sys_calculate_free_frames>
  800290:	89 c3                	mov    %eax,%ebx
  800292:	e8 94 1b 00 00       	call   801e2b <sys_calculate_modified_frames>
  800297:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80029a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029d:	29 c2                	sub    %eax,%edx
  80029f:	89 d0                	mov    %edx,%eax
  8002a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002aa:	0f 84 05 01 00 00    	je     8003b5 <_main+0x37d>
  8002b0:	68 bc 27 80 00       	push   $0x8027bc
  8002b5:	68 e1 27 80 00       	push   $0x8027e1
  8002ba:	6a 6d                	push   $0x6d
  8002bc:	68 9e 26 80 00       	push   $0x80269e
  8002c1:	e8 df 06 00 00       	call   8009a5 <_panic>
		}
		else if (Iteration == 2 )
  8002c6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ca:	75 72                	jne    80033e <_main+0x306>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002cc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002d3:	75 06                	jne    8002db <_main+0x2a3>
  8002d5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 6c 27 80 00       	push   $0x80276c
  8002e3:	6a 72                	push   $0x72
  8002e5:	68 9e 26 80 00       	push   $0x80269e
  8002ea:	e8 b6 06 00 00       	call   8009a5 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ef:	a1 24 30 80 00       	mov    0x803024,%eax
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	50                   	push   %eax
  8002f8:	e8 26 01 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800303:	e8 0a 1b 00 00       	call   801e12 <sys_calculate_free_frames>
  800308:	89 c3                	mov    %eax,%ebx
  80030a:	e8 1c 1b 00 00       	call   801e2b <sys_calculate_modified_frames>
  80030f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800315:	29 c2                	sub    %eax,%edx
  800317:	89 d0                	mov    %edx,%eax
  800319:	89 45 d0             	mov    %eax,-0x30(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80031c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80031f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800322:	0f 84 8d 00 00 00    	je     8003b5 <_main+0x37d>
  800328:	68 bc 27 80 00       	push   $0x8027bc
  80032d:	68 e1 27 80 00       	push   $0x8027e1
  800332:	6a 76                	push   $0x76
  800334:	68 9e 26 80 00       	push   $0x80269e
  800339:	e8 67 06 00 00       	call   8009a5 <_panic>
		}
		else if (Iteration == 3 )
  80033e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800342:	75 71                	jne    8003b5 <_main+0x37d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800344:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80034b:	75 06                	jne    800353 <_main+0x31b>
  80034d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800351:	74 14                	je     800367 <_main+0x32f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800353:	83 ec 04             	sub    $0x4,%esp
  800356:	68 6c 27 80 00       	push   $0x80276c
  80035b:	6a 7b                	push   $0x7b
  80035d:	68 9e 26 80 00       	push   $0x80269e
  800362:	e8 3e 06 00 00       	call   8009a5 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800367:	a1 24 30 80 00       	mov    0x803024,%eax
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	50                   	push   %eax
  800370:	e8 ae 00 00 00       	call   800423 <CheckAndCountEmptyLocInWS>
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	89 45 cc             	mov    %eax,-0x34(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80037b:	e8 92 1a 00 00       	call   801e12 <sys_calculate_free_frames>
  800380:	89 c3                	mov    %eax,%ebx
  800382:	e8 a4 1a 00 00       	call   801e2b <sys_calculate_modified_frames>
  800387:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80038a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80038d:	29 c2                	sub    %eax,%edx
  80038f:	89 d0                	mov    %edx,%eax
  800391:	89 45 c8             	mov    %eax,-0x38(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  800394:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800397:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039a:	74 19                	je     8003b5 <_main+0x37d>
  80039c:	68 bc 27 80 00       	push   $0x8027bc
  8003a1:	68 e1 27 80 00       	push   $0x8027e1
  8003a6:	68 80 00 00 00       	push   $0x80
  8003ab:	68 9e 26 80 00       	push   $0x80269e
  8003b0:	e8 f0 05 00 00       	call   8009a5 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003b5:	e8 45 1b 00 00       	call   801eff <sys_disable_interrupt>
		Chose = 0 ;
  8003ba:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003be:	eb 42                	jmp    800402 <_main+0x3ca>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003c0:	83 ec 0c             	sub    $0xc,%esp
  8003c3:	68 f6 27 80 00       	push   $0x8027f6
  8003c8:	e8 8c 08 00 00       	call   800c59 <cprintf>
  8003cd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003d0:	e8 29 04 00 00       	call   8007fe <getchar>
  8003d5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003d8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003dc:	83 ec 0c             	sub    $0xc,%esp
  8003df:	50                   	push   %eax
  8003e0:	e8 d1 03 00 00       	call   8007b6 <cputchar>
  8003e5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	6a 0a                	push   $0xa
  8003ed:	e8 c4 03 00 00       	call   8007b6 <cputchar>
  8003f2:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	6a 0a                	push   $0xa
  8003fa:	e8 b7 03 00 00       	call   8007b6 <cputchar>
  8003ff:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800402:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800406:	74 06                	je     80040e <_main+0x3d6>
  800408:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80040c:	75 b2                	jne    8003c0 <_main+0x388>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80040e:	e8 06 1b 00 00       	call   801f19 <sys_enable_interrupt>

	} while (Chose == 'y');
  800413:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800417:	0f 84 2c fc ff ff    	je     800049 <_main+0x11>
}
  80041d:	90                   	nop
  80041e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800421:	c9                   	leave  
  800422:	c3                   	ret    

00800423 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800423:	55                   	push   %ebp
  800424:	89 e5                	mov    %esp,%ebp
  800426:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800429:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800430:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800437:	eb 74                	jmp    8004ad <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800442:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800445:	89 d0                	mov    %edx,%eax
  800447:	01 c0                	add    %eax,%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	c1 e0 03             	shl    $0x3,%eax
  80044e:	01 c8                	add    %ecx,%eax
  800450:	8a 40 04             	mov    0x4(%eax),%al
  800453:	84 c0                	test   %al,%al
  800455:	74 05                	je     80045c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800457:	ff 45 f4             	incl   -0xc(%ebp)
  80045a:	eb 4e                	jmp    8004aa <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800465:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800480:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	79 20                	jns    8004aa <CheckAndCountEmptyLocInWS+0x87>
  80048a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  800491:	77 17                	ja     8004aa <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  800493:	83 ec 04             	sub    $0x4,%esp
  800496:	68 14 28 80 00       	push   $0x802814
  80049b:	68 9f 00 00 00       	push   $0x9f
  8004a0:	68 9e 26 80 00       	push   $0x80269e
  8004a5:	e8 fb 04 00 00       	call   8009a5 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004aa:	ff 45 f0             	incl   -0x10(%ebp)
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 50 74             	mov    0x74(%eax),%edx
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	39 c2                	cmp    %eax,%edx
  8004b8:	0f 87 7b ff ff ff    	ja     800439 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004be:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004c1:	c9                   	leave  
  8004c2:	c3                   	ret    

008004c3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
  8004c6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	48                   	dec    %eax
  8004cd:	50                   	push   %eax
  8004ce:	6a 00                	push   $0x0
  8004d0:	ff 75 0c             	pushl  0xc(%ebp)
  8004d3:	ff 75 08             	pushl  0x8(%ebp)
  8004d6:	e8 06 00 00 00       	call   8004e1 <QSort>
  8004db:	83 c4 10             	add    $0x10,%esp
}
  8004de:	90                   	nop
  8004df:	c9                   	leave  
  8004e0:	c3                   	ret    

008004e1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ea:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004ed:	0f 8d de 00 00 00    	jge    8005d1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	40                   	inc    %eax
  8004f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800500:	e9 80 00 00 00       	jmp    800585 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800505:	ff 45 f4             	incl   -0xc(%ebp)
  800508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80050e:	7f 2b                	jg     80053b <QSort+0x5a>
  800510:	8b 45 10             	mov    0x10(%ebp),%eax
  800513:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	8b 10                	mov    (%eax),%edx
  800521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800524:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	01 c8                	add    %ecx,%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	39 c2                	cmp    %eax,%edx
  800534:	7d cf                	jge    800505 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800536:	eb 03                	jmp    80053b <QSort+0x5a>
  800538:	ff 4d f0             	decl   -0x10(%ebp)
  80053b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800541:	7e 26                	jle    800569 <QSort+0x88>
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	8b 10                	mov    (%eax),%edx
  800554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800557:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	01 c8                	add    %ecx,%eax
  800563:	8b 00                	mov    (%eax),%eax
  800565:	39 c2                	cmp    %eax,%edx
  800567:	7e cf                	jle    800538 <QSort+0x57>

		if (i <= j)
  800569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80056f:	7f 14                	jg     800585 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800571:	83 ec 04             	sub    $0x4,%esp
  800574:	ff 75 f0             	pushl  -0x10(%ebp)
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	ff 75 08             	pushl  0x8(%ebp)
  80057d:	e8 a9 00 00 00       	call   80062b <Swap>
  800582:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800588:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80058b:	0f 8e 77 ff ff ff    	jle    800508 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800591:	83 ec 04             	sub    $0x4,%esp
  800594:	ff 75 f0             	pushl  -0x10(%ebp)
  800597:	ff 75 10             	pushl  0x10(%ebp)
  80059a:	ff 75 08             	pushl  0x8(%ebp)
  80059d:	e8 89 00 00 00       	call   80062b <Swap>
  8005a2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a8:	48                   	dec    %eax
  8005a9:	50                   	push   %eax
  8005aa:	ff 75 10             	pushl  0x10(%ebp)
  8005ad:	ff 75 0c             	pushl  0xc(%ebp)
  8005b0:	ff 75 08             	pushl  0x8(%ebp)
  8005b3:	e8 29 ff ff ff       	call   8004e1 <QSort>
  8005b8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005bb:	ff 75 14             	pushl  0x14(%ebp)
  8005be:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c1:	ff 75 0c             	pushl  0xc(%ebp)
  8005c4:	ff 75 08             	pushl  0x8(%ebp)
  8005c7:	e8 15 ff ff ff       	call   8004e1 <QSort>
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	eb 01                	jmp    8005d2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005d1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005e8:	eb 33                	jmp    80061d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	8b 10                	mov    (%eax),%edx
  8005fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fe:	40                   	inc    %eax
  8005ff:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	01 c8                	add    %ecx,%eax
  80060b:	8b 00                	mov    (%eax),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	7e 09                	jle    80061a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800611:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800618:	eb 0c                	jmp    800626 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80061a:	ff 45 f8             	incl   -0x8(%ebp)
  80061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800620:	48                   	dec    %eax
  800621:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800624:	7f c4                	jg     8005ea <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800626:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800629:	c9                   	leave  
  80062a:	c3                   	ret    

0080062b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80062b:	55                   	push   %ebp
  80062c:	89 e5                	mov    %esp,%ebp
  80062e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800631:	8b 45 0c             	mov    0xc(%ebp),%eax
  800634:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	01 c2                	add    %eax,%edx
  800654:	8b 45 10             	mov    0x10(%ebp),%eax
  800657:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	01 c8                	add    %ecx,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800667:	8b 45 10             	mov    0x10(%ebp),%eax
  80066a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	01 c2                	add    %eax,%edx
  800676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800679:	89 02                	mov    %eax,(%edx)
}
  80067b:	90                   	nop
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800684:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80068b:	eb 17                	jmp    8006a4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80068d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	01 c2                	add    %eax,%edx
  80069c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80069f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006a1:	ff 45 fc             	incl   -0x4(%ebp)
  8006a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006aa:	7c e1                	jl     80068d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006ac:	90                   	nop
  8006ad:	c9                   	leave  
  8006ae:	c3                   	ret    

008006af <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
  8006b2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006bc:	eb 1b                	jmp    8006d9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	01 c2                	add    %eax,%edx
  8006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006d3:	48                   	dec    %eax
  8006d4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006d6:	ff 45 fc             	incl   -0x4(%ebp)
  8006d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006df:	7c dd                	jl     8006be <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006e1:	90                   	nop
  8006e2:	c9                   	leave  
  8006e3:	c3                   	ret    

008006e4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ed:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8006f2:	f7 e9                	imul   %ecx
  8006f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006f7:	89 d0                	mov    %edx,%eax
  8006f9:	29 c8                	sub    %ecx,%eax
  8006fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8006fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800705:	eb 1e                	jmp    800725 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800707:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80070a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	99                   	cltd   
  80071b:	f7 7d f8             	idivl  -0x8(%ebp)
  80071e:	89 d0                	mov    %edx,%eax
  800720:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800722:	ff 45 fc             	incl   -0x4(%ebp)
  800725:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800728:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80072b:	7c da                	jl     800707 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800736:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80073d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800744:	eb 42                	jmp    800788 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800749:	99                   	cltd   
  80074a:	f7 7d f0             	idivl  -0x10(%ebp)
  80074d:	89 d0                	mov    %edx,%eax
  80074f:	85 c0                	test   %eax,%eax
  800751:	75 10                	jne    800763 <PrintElements+0x33>
			cprintf("\n");
  800753:	83 ec 0c             	sub    $0xc,%esp
  800756:	68 42 28 80 00       	push   $0x802842
  80075b:	e8 f9 04 00 00       	call   800c59 <cprintf>
  800760:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800766:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	01 d0                	add    %edx,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	50                   	push   %eax
  800778:	68 44 28 80 00       	push   $0x802844
  80077d:	e8 d7 04 00 00       	call   800c59 <cprintf>
  800782:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800785:	ff 45 f4             	incl   -0xc(%ebp)
  800788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078b:	48                   	dec    %eax
  80078c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80078f:	7f b5                	jg     800746 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800794:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	01 d0                	add    %edx,%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	50                   	push   %eax
  8007a6:	68 49 28 80 00       	push   $0x802849
  8007ab:	e8 a9 04 00 00       	call   800c59 <cprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp

}
  8007b3:	90                   	nop
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007c2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007c6:	83 ec 0c             	sub    $0xc,%esp
  8007c9:	50                   	push   %eax
  8007ca:	e8 64 17 00 00       	call   801f33 <sys_cputc>
  8007cf:	83 c4 10             	add    $0x10,%esp
}
  8007d2:	90                   	nop
  8007d3:	c9                   	leave  
  8007d4:	c3                   	ret    

008007d5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007db:	e8 1f 17 00 00       	call   801eff <sys_disable_interrupt>
	char c = ch;
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007e6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007ea:	83 ec 0c             	sub    $0xc,%esp
  8007ed:	50                   	push   %eax
  8007ee:	e8 40 17 00 00       	call   801f33 <sys_cputc>
  8007f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8007f6:	e8 1e 17 00 00       	call   801f19 <sys_enable_interrupt>
}
  8007fb:	90                   	nop
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <getchar>:

int
getchar(void)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80080b:	eb 08                	jmp    800815 <getchar+0x17>
	{
		c = sys_cgetc();
  80080d:	e8 68 15 00 00       	call   801d7a <sys_cgetc>
  800812:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800819:	74 f2                	je     80080d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <atomic_getchar>:

int
atomic_getchar(void)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800826:	e8 d4 16 00 00       	call   801eff <sys_disable_interrupt>
	int c=0;
  80082b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800832:	eb 08                	jmp    80083c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800834:	e8 41 15 00 00       	call   801d7a <sys_cgetc>
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80083c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800840:	74 f2                	je     800834 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800842:	e8 d2 16 00 00       	call   801f19 <sys_enable_interrupt>
	return c;
  800847:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    

0080084c <iscons>:

int iscons(int fdnum)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80084f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80085c:	e8 91 18 00 00       	call   8020f2 <sys_getenvindex>
  800861:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800864:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800867:	89 d0                	mov    %edx,%eax
  800869:	01 c0                	add    %eax,%eax
  80086b:	01 d0                	add    %edx,%eax
  80086d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800874:	01 c8                	add    %ecx,%eax
  800876:	c1 e0 02             	shl    $0x2,%eax
  800879:	01 d0                	add    %edx,%eax
  80087b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800882:	01 c8                	add    %ecx,%eax
  800884:	c1 e0 02             	shl    $0x2,%eax
  800887:	01 d0                	add    %edx,%eax
  800889:	c1 e0 02             	shl    $0x2,%eax
  80088c:	01 d0                	add    %edx,%eax
  80088e:	c1 e0 03             	shl    $0x3,%eax
  800891:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800896:	a3 24 30 80 00       	mov    %eax,0x803024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80089b:	a1 24 30 80 00       	mov    0x803024,%eax
  8008a0:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8008a6:	84 c0                	test   %al,%al
  8008a8:	74 0f                	je     8008b9 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8008aa:	a1 24 30 80 00       	mov    0x803024,%eax
  8008af:	05 18 da 01 00       	add    $0x1da18,%eax
  8008b4:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008bd:	7e 0a                	jle    8008c9 <libmain+0x73>
		binaryname = argv[0];
  8008bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	ff 75 0c             	pushl  0xc(%ebp)
  8008cf:	ff 75 08             	pushl  0x8(%ebp)
  8008d2:	e8 61 f7 ff ff       	call   800038 <_main>
  8008d7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008da:	e8 20 16 00 00       	call   801eff <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008df:	83 ec 0c             	sub    $0xc,%esp
  8008e2:	68 68 28 80 00       	push   $0x802868
  8008e7:	e8 6d 03 00 00       	call   800c59 <cprintf>
  8008ec:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008ef:	a1 24 30 80 00       	mov    0x803024,%eax
  8008f4:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8008fa:	a1 24 30 80 00       	mov    0x803024,%eax
  8008ff:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800905:	83 ec 04             	sub    $0x4,%esp
  800908:	52                   	push   %edx
  800909:	50                   	push   %eax
  80090a:	68 90 28 80 00       	push   $0x802890
  80090f:	e8 45 03 00 00       	call   800c59 <cprintf>
  800914:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800917:	a1 24 30 80 00       	mov    0x803024,%eax
  80091c:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800922:	a1 24 30 80 00       	mov    0x803024,%eax
  800927:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80092d:	a1 24 30 80 00       	mov    0x803024,%eax
  800932:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800938:	51                   	push   %ecx
  800939:	52                   	push   %edx
  80093a:	50                   	push   %eax
  80093b:	68 b8 28 80 00       	push   $0x8028b8
  800940:	e8 14 03 00 00       	call   800c59 <cprintf>
  800945:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800948:	a1 24 30 80 00       	mov    0x803024,%eax
  80094d:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	50                   	push   %eax
  800957:	68 10 29 80 00       	push   $0x802910
  80095c:	e8 f8 02 00 00       	call   800c59 <cprintf>
  800961:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800964:	83 ec 0c             	sub    $0xc,%esp
  800967:	68 68 28 80 00       	push   $0x802868
  80096c:	e8 e8 02 00 00       	call   800c59 <cprintf>
  800971:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800974:	e8 a0 15 00 00       	call   801f19 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800979:	e8 19 00 00 00       	call   800997 <exit>
}
  80097e:	90                   	nop
  80097f:	c9                   	leave  
  800980:	c3                   	ret    

00800981 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800987:	83 ec 0c             	sub    $0xc,%esp
  80098a:	6a 00                	push   $0x0
  80098c:	e8 2d 17 00 00       	call   8020be <sys_destroy_env>
  800991:	83 c4 10             	add    $0x10,%esp
}
  800994:	90                   	nop
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <exit>:

void
exit(void)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099d:	e8 82 17 00 00       	call   802124 <sys_exit_env>
}
  8009a2:	90                   	nop
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ae:	83 c0 04             	add    $0x4,%eax
  8009b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b4:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8009b9:	85 c0                	test   %eax,%eax
  8009bb:	74 16                	je     8009d3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009bd:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	50                   	push   %eax
  8009c6:	68 24 29 80 00       	push   $0x802924
  8009cb:	e8 89 02 00 00       	call   800c59 <cprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d3:	a1 00 30 80 00       	mov    0x803000,%eax
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	50                   	push   %eax
  8009df:	68 29 29 80 00       	push   $0x802929
  8009e4:	e8 70 02 00 00       	call   800c59 <cprintf>
  8009e9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f5:	50                   	push   %eax
  8009f6:	e8 f3 01 00 00       	call   800bee <vcprintf>
  8009fb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	6a 00                	push   $0x0
  800a03:	68 45 29 80 00       	push   $0x802945
  800a08:	e8 e1 01 00 00       	call   800bee <vcprintf>
  800a0d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a10:	e8 82 ff ff ff       	call   800997 <exit>

	// should not return here
	while (1) ;
  800a15:	eb fe                	jmp    800a15 <_panic+0x70>

00800a17 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1d:	a1 24 30 80 00       	mov    0x803024,%eax
  800a22:	8b 50 74             	mov    0x74(%eax),%edx
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 14                	je     800a40 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 48 29 80 00       	push   $0x802948
  800a34:	6a 26                	push   $0x26
  800a36:	68 94 29 80 00       	push   $0x802994
  800a3b:	e8 65 ff ff ff       	call   8009a5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a47:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4e:	e9 c2 00 00 00       	jmp    800b15 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	01 d0                	add    %edx,%eax
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	85 c0                	test   %eax,%eax
  800a66:	75 08                	jne    800a70 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a68:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a6b:	e9 a2 00 00 00       	jmp    800b12 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a77:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7e:	eb 69                	jmp    800ae9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a80:	a1 24 30 80 00       	mov    0x803024,%eax
  800a85:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800a8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8e:	89 d0                	mov    %edx,%eax
  800a90:	01 c0                	add    %eax,%eax
  800a92:	01 d0                	add    %edx,%eax
  800a94:	c1 e0 03             	shl    $0x3,%eax
  800a97:	01 c8                	add    %ecx,%eax
  800a99:	8a 40 04             	mov    0x4(%eax),%al
  800a9c:	84 c0                	test   %al,%al
  800a9e:	75 46                	jne    800ae6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800aa0:	a1 24 30 80 00       	mov    0x803024,%eax
  800aa5:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800aab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aae:	89 d0                	mov    %edx,%eax
  800ab0:	01 c0                	add    %eax,%eax
  800ab2:	01 d0                	add    %edx,%eax
  800ab4:	c1 e0 03             	shl    $0x3,%eax
  800ab7:	01 c8                	add    %ecx,%eax
  800ab9:	8b 00                	mov    (%eax),%eax
  800abb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800abe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ac1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800acb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	01 c8                	add    %ecx,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad9:	39 c2                	cmp    %eax,%edx
  800adb:	75 09                	jne    800ae6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800add:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ae4:	eb 12                	jmp    800af8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae6:	ff 45 e8             	incl   -0x18(%ebp)
  800ae9:	a1 24 30 80 00       	mov    0x803024,%eax
  800aee:	8b 50 74             	mov    0x74(%eax),%edx
  800af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af4:	39 c2                	cmp    %eax,%edx
  800af6:	77 88                	ja     800a80 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800af8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800afc:	75 14                	jne    800b12 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800afe:	83 ec 04             	sub    $0x4,%esp
  800b01:	68 a0 29 80 00       	push   $0x8029a0
  800b06:	6a 3a                	push   $0x3a
  800b08:	68 94 29 80 00       	push   $0x802994
  800b0d:	e8 93 fe ff ff       	call   8009a5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b12:	ff 45 f0             	incl   -0x10(%ebp)
  800b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b18:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b1b:	0f 8c 32 ff ff ff    	jl     800a53 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b28:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b2f:	eb 26                	jmp    800b57 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b31:	a1 24 30 80 00       	mov    0x803024,%eax
  800b36:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3f:	89 d0                	mov    %edx,%eax
  800b41:	01 c0                	add    %eax,%eax
  800b43:	01 d0                	add    %edx,%eax
  800b45:	c1 e0 03             	shl    $0x3,%eax
  800b48:	01 c8                	add    %ecx,%eax
  800b4a:	8a 40 04             	mov    0x4(%eax),%al
  800b4d:	3c 01                	cmp    $0x1,%al
  800b4f:	75 03                	jne    800b54 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b51:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b54:	ff 45 e0             	incl   -0x20(%ebp)
  800b57:	a1 24 30 80 00       	mov    0x803024,%eax
  800b5c:	8b 50 74             	mov    0x74(%eax),%edx
  800b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b62:	39 c2                	cmp    %eax,%edx
  800b64:	77 cb                	ja     800b31 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b69:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b6c:	74 14                	je     800b82 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b6e:	83 ec 04             	sub    $0x4,%esp
  800b71:	68 f4 29 80 00       	push   $0x8029f4
  800b76:	6a 44                	push   $0x44
  800b78:	68 94 29 80 00       	push   $0x802994
  800b7d:	e8 23 fe ff ff       	call   8009a5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b82:	90                   	nop
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	8d 48 01             	lea    0x1(%eax),%ecx
  800b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b96:	89 0a                	mov    %ecx,(%edx)
  800b98:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9b:	88 d1                	mov    %dl,%cl
  800b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bae:	75 2c                	jne    800bdc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bb0:	a0 28 30 80 00       	mov    0x803028,%al
  800bb5:	0f b6 c0             	movzbl %al,%eax
  800bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbb:	8b 12                	mov    (%edx),%edx
  800bbd:	89 d1                	mov    %edx,%ecx
  800bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc2:	83 c2 08             	add    $0x8,%edx
  800bc5:	83 ec 04             	sub    $0x4,%esp
  800bc8:	50                   	push   %eax
  800bc9:	51                   	push   %ecx
  800bca:	52                   	push   %edx
  800bcb:	e8 81 11 00 00       	call   801d51 <sys_cputs>
  800bd0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdf:	8b 40 04             	mov    0x4(%eax),%eax
  800be2:	8d 50 01             	lea    0x1(%eax),%edx
  800be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800beb:	90                   	nop
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bfe:	00 00 00 
	b.cnt = 0;
  800c01:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c08:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	ff 75 08             	pushl  0x8(%ebp)
  800c11:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	68 85 0b 80 00       	push   $0x800b85
  800c1d:	e8 11 02 00 00       	call   800e33 <vprintfmt>
  800c22:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c25:	a0 28 30 80 00       	mov    0x803028,%al
  800c2a:	0f b6 c0             	movzbl %al,%eax
  800c2d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c33:	83 ec 04             	sub    $0x4,%esp
  800c36:	50                   	push   %eax
  800c37:	52                   	push   %edx
  800c38:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3e:	83 c0 08             	add    $0x8,%eax
  800c41:	50                   	push   %eax
  800c42:	e8 0a 11 00 00       	call   801d51 <sys_cputs>
  800c47:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c4a:	c6 05 28 30 80 00 00 	movb   $0x0,0x803028
	return b.cnt;
  800c51:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c57:	c9                   	leave  
  800c58:	c3                   	ret    

00800c59 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c5f:	c6 05 28 30 80 00 01 	movb   $0x1,0x803028
	va_start(ap, fmt);
  800c66:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 f4             	pushl  -0xc(%ebp)
  800c75:	50                   	push   %eax
  800c76:	e8 73 ff ff ff       	call   800bee <vcprintf>
  800c7b:	83 c4 10             	add    $0x10,%esp
  800c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c8c:	e8 6e 12 00 00       	call   801eff <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c91:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca0:	50                   	push   %eax
  800ca1:	e8 48 ff ff ff       	call   800bee <vcprintf>
  800ca6:	83 c4 10             	add    $0x10,%esp
  800ca9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800cac:	e8 68 12 00 00       	call   801f19 <sys_enable_interrupt>
	return cnt;
  800cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    

00800cb6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	53                   	push   %ebx
  800cba:	83 ec 14             	sub    $0x14,%esp
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd4:	77 55                	ja     800d2b <printnum+0x75>
  800cd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd9:	72 05                	jb     800ce0 <printnum+0x2a>
  800cdb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cde:	77 4b                	ja     800d2b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ce0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce6:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	52                   	push   %edx
  800cef:	50                   	push   %eax
  800cf0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf3:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf6:	e8 89 16 00 00       	call   802384 <__udivdi3>
  800cfb:	83 c4 10             	add    $0x10,%esp
  800cfe:	83 ec 04             	sub    $0x4,%esp
  800d01:	ff 75 20             	pushl  0x20(%ebp)
  800d04:	53                   	push   %ebx
  800d05:	ff 75 18             	pushl  0x18(%ebp)
  800d08:	52                   	push   %edx
  800d09:	50                   	push   %eax
  800d0a:	ff 75 0c             	pushl  0xc(%ebp)
  800d0d:	ff 75 08             	pushl  0x8(%ebp)
  800d10:	e8 a1 ff ff ff       	call   800cb6 <printnum>
  800d15:	83 c4 20             	add    $0x20,%esp
  800d18:	eb 1a                	jmp    800d34 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d1a:	83 ec 08             	sub    $0x8,%esp
  800d1d:	ff 75 0c             	pushl  0xc(%ebp)
  800d20:	ff 75 20             	pushl  0x20(%ebp)
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	ff d0                	call   *%eax
  800d28:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d2b:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d32:	7f e6                	jg     800d1a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d34:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d42:	53                   	push   %ebx
  800d43:	51                   	push   %ecx
  800d44:	52                   	push   %edx
  800d45:	50                   	push   %eax
  800d46:	e8 49 17 00 00       	call   802494 <__umoddi3>
  800d4b:	83 c4 10             	add    $0x10,%esp
  800d4e:	05 54 2c 80 00       	add    $0x802c54,%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	0f be c0             	movsbl %al,%eax
  800d58:	83 ec 08             	sub    $0x8,%esp
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	ff d0                	call   *%eax
  800d64:	83 c4 10             	add    $0x10,%esp
}
  800d67:	90                   	nop
  800d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d70:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d74:	7e 1c                	jle    800d92 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8b 00                	mov    (%eax),%eax
  800d7b:	8d 50 08             	lea    0x8(%eax),%edx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	89 10                	mov    %edx,(%eax)
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8b 00                	mov    (%eax),%eax
  800d88:	83 e8 08             	sub    $0x8,%eax
  800d8b:	8b 50 04             	mov    0x4(%eax),%edx
  800d8e:	8b 00                	mov    (%eax),%eax
  800d90:	eb 40                	jmp    800dd2 <getuint+0x65>
	else if (lflag)
  800d92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d96:	74 1e                	je     800db6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	8d 50 04             	lea    0x4(%eax),%edx
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	89 10                	mov    %edx,(%eax)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	83 e8 04             	sub    $0x4,%eax
  800dad:	8b 00                	mov    (%eax),%eax
  800daf:	ba 00 00 00 00       	mov    $0x0,%edx
  800db4:	eb 1c                	jmp    800dd2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8b 00                	mov    (%eax),%eax
  800dbb:	8d 50 04             	lea    0x4(%eax),%edx
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	89 10                	mov    %edx,(%eax)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8b 00                	mov    (%eax),%eax
  800dc8:	83 e8 04             	sub    $0x4,%eax
  800dcb:	8b 00                	mov    (%eax),%eax
  800dcd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ddb:	7e 1c                	jle    800df9 <getint+0x25>
		return va_arg(*ap, long long);
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8b 00                	mov    (%eax),%eax
  800de2:	8d 50 08             	lea    0x8(%eax),%edx
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	89 10                	mov    %edx,(%eax)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8b 00                	mov    (%eax),%eax
  800def:	83 e8 08             	sub    $0x8,%eax
  800df2:	8b 50 04             	mov    0x4(%eax),%edx
  800df5:	8b 00                	mov    (%eax),%eax
  800df7:	eb 38                	jmp    800e31 <getint+0x5d>
	else if (lflag)
  800df9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfd:	74 1a                	je     800e19 <getint+0x45>
		return va_arg(*ap, long);
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8b 00                	mov    (%eax),%eax
  800e04:	8d 50 04             	lea    0x4(%eax),%edx
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	89 10                	mov    %edx,(%eax)
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8b 00                	mov    (%eax),%eax
  800e11:	83 e8 04             	sub    $0x4,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	99                   	cltd   
  800e17:	eb 18                	jmp    800e31 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8b 00                	mov    (%eax),%eax
  800e1e:	8d 50 04             	lea    0x4(%eax),%edx
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	89 10                	mov    %edx,(%eax)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	83 e8 04             	sub    $0x4,%eax
  800e2e:	8b 00                	mov    (%eax),%eax
  800e30:	99                   	cltd   
}
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	56                   	push   %esi
  800e37:	53                   	push   %ebx
  800e38:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e3b:	eb 17                	jmp    800e54 <vprintfmt+0x21>
			if (ch == '\0')
  800e3d:	85 db                	test   %ebx,%ebx
  800e3f:	0f 84 af 03 00 00    	je     8011f4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	ff 75 0c             	pushl  0xc(%ebp)
  800e4b:	53                   	push   %ebx
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	ff d0                	call   *%eax
  800e51:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 01             	lea    0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	8a 00                	mov    (%eax),%al
  800e5f:	0f b6 d8             	movzbl %al,%ebx
  800e62:	83 fb 25             	cmp    $0x25,%ebx
  800e65:	75 d6                	jne    800e3d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e67:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e6b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e72:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e79:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 01             	lea    0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	0f b6 d8             	movzbl %al,%ebx
  800e95:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e98:	83 f8 55             	cmp    $0x55,%eax
  800e9b:	0f 87 2b 03 00 00    	ja     8011cc <vprintfmt+0x399>
  800ea1:	8b 04 85 78 2c 80 00 	mov    0x802c78(,%eax,4),%eax
  800ea8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800eaa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eae:	eb d7                	jmp    800e87 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800eb0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb4:	eb d1                	jmp    800e87 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ebd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec0:	89 d0                	mov    %edx,%eax
  800ec2:	c1 e0 02             	shl    $0x2,%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	01 c0                	add    %eax,%eax
  800ec9:	01 d8                	add    %ebx,%eax
  800ecb:	83 e8 30             	sub    $0x30,%eax
  800ece:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed9:	83 fb 2f             	cmp    $0x2f,%ebx
  800edc:	7e 3e                	jle    800f1c <vprintfmt+0xe9>
  800ede:	83 fb 39             	cmp    $0x39,%ebx
  800ee1:	7f 39                	jg     800f1c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee6:	eb d5                	jmp    800ebd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eeb:	83 c0 04             	add    $0x4,%eax
  800eee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef4:	83 e8 04             	sub    $0x4,%eax
  800ef7:	8b 00                	mov    (%eax),%eax
  800ef9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800efc:	eb 1f                	jmp    800f1d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f02:	79 83                	jns    800e87 <vprintfmt+0x54>
				width = 0;
  800f04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f0b:	e9 77 ff ff ff       	jmp    800e87 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f10:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f17:	e9 6b ff ff ff       	jmp    800e87 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f1c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f21:	0f 89 60 ff ff ff    	jns    800e87 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f34:	e9 4e ff ff ff       	jmp    800e87 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f39:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f3c:	e9 46 ff ff ff       	jmp    800e87 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f41:	8b 45 14             	mov    0x14(%ebp),%eax
  800f44:	83 c0 04             	add    $0x4,%eax
  800f47:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4d:	83 e8 04             	sub    $0x4,%eax
  800f50:	8b 00                	mov    (%eax),%eax
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	50                   	push   %eax
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	ff d0                	call   *%eax
  800f5e:	83 c4 10             	add    $0x10,%esp
			break;
  800f61:	e9 89 02 00 00       	jmp    8011ef <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f66:	8b 45 14             	mov    0x14(%ebp),%eax
  800f69:	83 c0 04             	add    $0x4,%eax
  800f6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f72:	83 e8 04             	sub    $0x4,%eax
  800f75:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f77:	85 db                	test   %ebx,%ebx
  800f79:	79 02                	jns    800f7d <vprintfmt+0x14a>
				err = -err;
  800f7b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7d:	83 fb 64             	cmp    $0x64,%ebx
  800f80:	7f 0b                	jg     800f8d <vprintfmt+0x15a>
  800f82:	8b 34 9d c0 2a 80 00 	mov    0x802ac0(,%ebx,4),%esi
  800f89:	85 f6                	test   %esi,%esi
  800f8b:	75 19                	jne    800fa6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8d:	53                   	push   %ebx
  800f8e:	68 65 2c 80 00       	push   $0x802c65
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 5e 02 00 00       	call   8011fc <printfmt>
  800f9e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fa1:	e9 49 02 00 00       	jmp    8011ef <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa6:	56                   	push   %esi
  800fa7:	68 6e 2c 80 00       	push   $0x802c6e
  800fac:	ff 75 0c             	pushl  0xc(%ebp)
  800faf:	ff 75 08             	pushl  0x8(%ebp)
  800fb2:	e8 45 02 00 00       	call   8011fc <printfmt>
  800fb7:	83 c4 10             	add    $0x10,%esp
			break;
  800fba:	e9 30 02 00 00       	jmp    8011ef <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc2:	83 c0 04             	add    $0x4,%eax
  800fc5:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	83 e8 04             	sub    $0x4,%eax
  800fce:	8b 30                	mov    (%eax),%esi
  800fd0:	85 f6                	test   %esi,%esi
  800fd2:	75 05                	jne    800fd9 <vprintfmt+0x1a6>
				p = "(null)";
  800fd4:	be 71 2c 80 00       	mov    $0x802c71,%esi
			if (width > 0 && padc != '-')
  800fd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fdd:	7e 6d                	jle    80104c <vprintfmt+0x219>
  800fdf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe3:	74 67                	je     80104c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe8:	83 ec 08             	sub    $0x8,%esp
  800feb:	50                   	push   %eax
  800fec:	56                   	push   %esi
  800fed:	e8 12 05 00 00       	call   801504 <strnlen>
  800ff2:	83 c4 10             	add    $0x10,%esp
  800ff5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff8:	eb 16                	jmp    801010 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ffa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffe:	83 ec 08             	sub    $0x8,%esp
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	50                   	push   %eax
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100d:	ff 4d e4             	decl   -0x1c(%ebp)
  801010:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801014:	7f e4                	jg     800ffa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801016:	eb 34                	jmp    80104c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801018:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80101c:	74 1c                	je     80103a <vprintfmt+0x207>
  80101e:	83 fb 1f             	cmp    $0x1f,%ebx
  801021:	7e 05                	jle    801028 <vprintfmt+0x1f5>
  801023:	83 fb 7e             	cmp    $0x7e,%ebx
  801026:	7e 12                	jle    80103a <vprintfmt+0x207>
					putch('?', putdat);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	ff 75 0c             	pushl  0xc(%ebp)
  80102e:	6a 3f                	push   $0x3f
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	ff d0                	call   *%eax
  801035:	83 c4 10             	add    $0x10,%esp
  801038:	eb 0f                	jmp    801049 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	53                   	push   %ebx
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801049:	ff 4d e4             	decl   -0x1c(%ebp)
  80104c:	89 f0                	mov    %esi,%eax
  80104e:	8d 70 01             	lea    0x1(%eax),%esi
  801051:	8a 00                	mov    (%eax),%al
  801053:	0f be d8             	movsbl %al,%ebx
  801056:	85 db                	test   %ebx,%ebx
  801058:	74 24                	je     80107e <vprintfmt+0x24b>
  80105a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105e:	78 b8                	js     801018 <vprintfmt+0x1e5>
  801060:	ff 4d e0             	decl   -0x20(%ebp)
  801063:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801067:	79 af                	jns    801018 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801069:	eb 13                	jmp    80107e <vprintfmt+0x24b>
				putch(' ', putdat);
  80106b:	83 ec 08             	sub    $0x8,%esp
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	6a 20                	push   $0x20
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	ff d0                	call   *%eax
  801078:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80107b:	ff 4d e4             	decl   -0x1c(%ebp)
  80107e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801082:	7f e7                	jg     80106b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801084:	e9 66 01 00 00       	jmp    8011ef <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801089:	83 ec 08             	sub    $0x8,%esp
  80108c:	ff 75 e8             	pushl  -0x18(%ebp)
  80108f:	8d 45 14             	lea    0x14(%ebp),%eax
  801092:	50                   	push   %eax
  801093:	e8 3c fd ff ff       	call   800dd4 <getint>
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8010a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a7:	85 d2                	test   %edx,%edx
  8010a9:	79 23                	jns    8010ce <vprintfmt+0x29b>
				putch('-', putdat);
  8010ab:	83 ec 08             	sub    $0x8,%esp
  8010ae:	ff 75 0c             	pushl  0xc(%ebp)
  8010b1:	6a 2d                	push   $0x2d
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	ff d0                	call   *%eax
  8010b8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c1:	f7 d8                	neg    %eax
  8010c3:	83 d2 00             	adc    $0x0,%edx
  8010c6:	f7 da                	neg    %edx
  8010c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d5:	e9 bc 00 00 00       	jmp    801196 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010da:	83 ec 08             	sub    $0x8,%esp
  8010dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e3:	50                   	push   %eax
  8010e4:	e8 84 fc ff ff       	call   800d6d <getuint>
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010f2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f9:	e9 98 00 00 00       	jmp    801196 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	6a 58                	push   $0x58
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	6a 58                	push   $0x58
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	ff d0                	call   *%eax
  80111b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111e:	83 ec 08             	sub    $0x8,%esp
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	6a 58                	push   $0x58
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	ff d0                	call   *%eax
  80112b:	83 c4 10             	add    $0x10,%esp
			break;
  80112e:	e9 bc 00 00 00       	jmp    8011ef <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	6a 30                	push   $0x30
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	ff d0                	call   *%eax
  801140:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801143:	83 ec 08             	sub    $0x8,%esp
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	6a 78                	push   $0x78
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	ff d0                	call   *%eax
  801150:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801153:	8b 45 14             	mov    0x14(%ebp),%eax
  801156:	83 c0 04             	add    $0x4,%eax
  801159:	89 45 14             	mov    %eax,0x14(%ebp)
  80115c:	8b 45 14             	mov    0x14(%ebp),%eax
  80115f:	83 e8 04             	sub    $0x4,%eax
  801162:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801167:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801175:	eb 1f                	jmp    801196 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801177:	83 ec 08             	sub    $0x8,%esp
  80117a:	ff 75 e8             	pushl  -0x18(%ebp)
  80117d:	8d 45 14             	lea    0x14(%ebp),%eax
  801180:	50                   	push   %eax
  801181:	e8 e7 fb ff ff       	call   800d6d <getuint>
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80118c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801196:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80119a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119d:	83 ec 04             	sub    $0x4,%esp
  8011a0:	52                   	push   %edx
  8011a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a4:	50                   	push   %eax
  8011a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8011ab:	ff 75 0c             	pushl  0xc(%ebp)
  8011ae:	ff 75 08             	pushl  0x8(%ebp)
  8011b1:	e8 00 fb ff ff       	call   800cb6 <printnum>
  8011b6:	83 c4 20             	add    $0x20,%esp
			break;
  8011b9:	eb 34                	jmp    8011ef <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	53                   	push   %ebx
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	ff d0                	call   *%eax
  8011c7:	83 c4 10             	add    $0x10,%esp
			break;
  8011ca:	eb 23                	jmp    8011ef <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011cc:	83 ec 08             	sub    $0x8,%esp
  8011cf:	ff 75 0c             	pushl  0xc(%ebp)
  8011d2:	6a 25                	push   $0x25
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	ff d0                	call   *%eax
  8011d9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011dc:	ff 4d 10             	decl   0x10(%ebp)
  8011df:	eb 03                	jmp    8011e4 <vprintfmt+0x3b1>
  8011e1:	ff 4d 10             	decl   0x10(%ebp)
  8011e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e7:	48                   	dec    %eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	3c 25                	cmp    $0x25,%al
  8011ec:	75 f3                	jne    8011e1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011ee:	90                   	nop
		}
	}
  8011ef:	e9 47 fc ff ff       	jmp    800e3b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f8:	5b                   	pop    %ebx
  8011f9:	5e                   	pop    %esi
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801202:	8d 45 10             	lea    0x10(%ebp),%eax
  801205:	83 c0 04             	add    $0x4,%eax
  801208:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80120b:	8b 45 10             	mov    0x10(%ebp),%eax
  80120e:	ff 75 f4             	pushl  -0xc(%ebp)
  801211:	50                   	push   %eax
  801212:	ff 75 0c             	pushl  0xc(%ebp)
  801215:	ff 75 08             	pushl  0x8(%ebp)
  801218:	e8 16 fc ff ff       	call   800e33 <vprintfmt>
  80121d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801220:	90                   	nop
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	8b 40 08             	mov    0x8(%eax),%eax
  80122c:	8d 50 01             	lea    0x1(%eax),%edx
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	8b 10                	mov    (%eax),%edx
  80123a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123d:	8b 40 04             	mov    0x4(%eax),%eax
  801240:	39 c2                	cmp    %eax,%edx
  801242:	73 12                	jae    801256 <sprintputch+0x33>
		*b->buf++ = ch;
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 48 01             	lea    0x1(%eax),%ecx
  80124c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124f:	89 0a                	mov    %ecx,(%edx)
  801251:	8b 55 08             	mov    0x8(%ebp),%edx
  801254:	88 10                	mov    %dl,(%eax)
}
  801256:	90                   	nop
  801257:	5d                   	pop    %ebp
  801258:	c3                   	ret    

00801259 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	8d 50 ff             	lea    -0x1(%eax),%edx
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801273:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80127a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127e:	74 06                	je     801286 <vsnprintf+0x2d>
  801280:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801284:	7f 07                	jg     80128d <vsnprintf+0x34>
		return -E_INVAL;
  801286:	b8 03 00 00 00       	mov    $0x3,%eax
  80128b:	eb 20                	jmp    8012ad <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128d:	ff 75 14             	pushl  0x14(%ebp)
  801290:	ff 75 10             	pushl  0x10(%ebp)
  801293:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801296:	50                   	push   %eax
  801297:	68 23 12 80 00       	push   $0x801223
  80129c:	e8 92 fb ff ff       	call   800e33 <vprintfmt>
  8012a1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b8:	83 c0 04             	add    $0x4,%eax
  8012bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c4:	50                   	push   %eax
  8012c5:	ff 75 0c             	pushl  0xc(%ebp)
  8012c8:	ff 75 08             	pushl  0x8(%ebp)
  8012cb:	e8 89 ff ff ff       	call   801259 <vsnprintf>
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e5:	74 13                	je     8012fa <readline+0x1f>
		cprintf("%s", prompt);
  8012e7:	83 ec 08             	sub    $0x8,%esp
  8012ea:	ff 75 08             	pushl  0x8(%ebp)
  8012ed:	68 d0 2d 80 00       	push   $0x802dd0
  8012f2:	e8 62 f9 ff ff       	call   800c59 <cprintf>
  8012f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801301:	83 ec 0c             	sub    $0xc,%esp
  801304:	6a 00                	push   $0x0
  801306:	e8 41 f5 ff ff       	call   80084c <iscons>
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801311:	e8 e8 f4 ff ff       	call   8007fe <getchar>
  801316:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801319:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131d:	79 22                	jns    801341 <readline+0x66>
			if (c != -E_EOF)
  80131f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801323:	0f 84 ad 00 00 00    	je     8013d6 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	ff 75 ec             	pushl  -0x14(%ebp)
  80132f:	68 d3 2d 80 00       	push   $0x802dd3
  801334:	e8 20 f9 ff ff       	call   800c59 <cprintf>
  801339:	83 c4 10             	add    $0x10,%esp
			return;
  80133c:	e9 95 00 00 00       	jmp    8013d6 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801341:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801345:	7e 34                	jle    80137b <readline+0xa0>
  801347:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134e:	7f 2b                	jg     80137b <readline+0xa0>
			if (echoing)
  801350:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801354:	74 0e                	je     801364 <readline+0x89>
				cputchar(c);
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	ff 75 ec             	pushl  -0x14(%ebp)
  80135c:	e8 55 f4 ff ff       	call   8007b6 <cputchar>
  801361:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136d:	89 c2                	mov    %eax,%edx
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	01 d0                	add    %edx,%eax
  801374:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801377:	88 10                	mov    %dl,(%eax)
  801379:	eb 56                	jmp    8013d1 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80137b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137f:	75 1f                	jne    8013a0 <readline+0xc5>
  801381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801385:	7e 19                	jle    8013a0 <readline+0xc5>
			if (echoing)
  801387:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138b:	74 0e                	je     80139b <readline+0xc0>
				cputchar(c);
  80138d:	83 ec 0c             	sub    $0xc,%esp
  801390:	ff 75 ec             	pushl  -0x14(%ebp)
  801393:	e8 1e f4 ff ff       	call   8007b6 <cputchar>
  801398:	83 c4 10             	add    $0x10,%esp

			i--;
  80139b:	ff 4d f4             	decl   -0xc(%ebp)
  80139e:	eb 31                	jmp    8013d1 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8013a0:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a4:	74 0a                	je     8013b0 <readline+0xd5>
  8013a6:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013aa:	0f 85 61 ff ff ff    	jne    801311 <readline+0x36>
			if (echoing)
  8013b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b4:	74 0e                	je     8013c4 <readline+0xe9>
				cputchar(c);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013bc:	e8 f5 f3 ff ff       	call   8007b6 <cputchar>
  8013c1:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	01 d0                	add    %edx,%eax
  8013cc:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013cf:	eb 06                	jmp    8013d7 <readline+0xfc>
		}
	}
  8013d1:	e9 3b ff ff ff       	jmp    801311 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013d6:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013df:	e8 1b 0b 00 00       	call   801eff <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e8:	74 13                	je     8013fd <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	ff 75 08             	pushl  0x8(%ebp)
  8013f0:	68 d0 2d 80 00       	push   $0x802dd0
  8013f5:	e8 5f f8 ff ff       	call   800c59 <cprintf>
  8013fa:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801404:	83 ec 0c             	sub    $0xc,%esp
  801407:	6a 00                	push   $0x0
  801409:	e8 3e f4 ff ff       	call   80084c <iscons>
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801414:	e8 e5 f3 ff ff       	call   8007fe <getchar>
  801419:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80141c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801420:	79 23                	jns    801445 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801422:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801426:	74 13                	je     80143b <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	ff 75 ec             	pushl  -0x14(%ebp)
  80142e:	68 d3 2d 80 00       	push   $0x802dd3
  801433:	e8 21 f8 ff ff       	call   800c59 <cprintf>
  801438:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80143b:	e8 d9 0a 00 00       	call   801f19 <sys_enable_interrupt>
			return;
  801440:	e9 9a 00 00 00       	jmp    8014df <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801445:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801449:	7e 34                	jle    80147f <atomic_readline+0xa6>
  80144b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801452:	7f 2b                	jg     80147f <atomic_readline+0xa6>
			if (echoing)
  801454:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801458:	74 0e                	je     801468 <atomic_readline+0x8f>
				cputchar(c);
  80145a:	83 ec 0c             	sub    $0xc,%esp
  80145d:	ff 75 ec             	pushl  -0x14(%ebp)
  801460:	e8 51 f3 ff ff       	call   8007b6 <cputchar>
  801465:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146b:	8d 50 01             	lea    0x1(%eax),%edx
  80146e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801471:	89 c2                	mov    %eax,%edx
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80147b:	88 10                	mov    %dl,(%eax)
  80147d:	eb 5b                	jmp    8014da <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80147f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801483:	75 1f                	jne    8014a4 <atomic_readline+0xcb>
  801485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801489:	7e 19                	jle    8014a4 <atomic_readline+0xcb>
			if (echoing)
  80148b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148f:	74 0e                	je     80149f <atomic_readline+0xc6>
				cputchar(c);
  801491:	83 ec 0c             	sub    $0xc,%esp
  801494:	ff 75 ec             	pushl  -0x14(%ebp)
  801497:	e8 1a f3 ff ff       	call   8007b6 <cputchar>
  80149c:	83 c4 10             	add    $0x10,%esp
			i--;
  80149f:	ff 4d f4             	decl   -0xc(%ebp)
  8014a2:	eb 36                	jmp    8014da <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8014a4:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8014a8:	74 0a                	je     8014b4 <atomic_readline+0xdb>
  8014aa:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014ae:	0f 85 60 ff ff ff    	jne    801414 <atomic_readline+0x3b>
			if (echoing)
  8014b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014b8:	74 0e                	je     8014c8 <atomic_readline+0xef>
				cputchar(c);
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8014c0:	e8 f1 f2 ff ff       	call   8007b6 <cputchar>
  8014c5:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ce:	01 d0                	add    %edx,%eax
  8014d0:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014d3:	e8 41 0a 00 00       	call   801f19 <sys_enable_interrupt>
			return;
  8014d8:	eb 05                	jmp    8014df <atomic_readline+0x106>
		}
	}
  8014da:	e9 35 ff ff ff       	jmp    801414 <atomic_readline+0x3b>
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ee:	eb 06                	jmp    8014f6 <strlen+0x15>
		n++;
  8014f0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f3:	ff 45 08             	incl   0x8(%ebp)
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	84 c0                	test   %al,%al
  8014fd:	75 f1                	jne    8014f0 <strlen+0xf>
		n++;
	return n;
  8014ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80150a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801511:	eb 09                	jmp    80151c <strnlen+0x18>
		n++;
  801513:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801516:	ff 45 08             	incl   0x8(%ebp)
  801519:	ff 4d 0c             	decl   0xc(%ebp)
  80151c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801520:	74 09                	je     80152b <strnlen+0x27>
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	84 c0                	test   %al,%al
  801529:	75 e8                	jne    801513 <strnlen+0xf>
		n++;
	return n;
  80152b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80153c:	90                   	nop
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8d 50 01             	lea    0x1(%eax),%edx
  801543:	89 55 08             	mov    %edx,0x8(%ebp)
  801546:	8b 55 0c             	mov    0xc(%ebp),%edx
  801549:	8d 4a 01             	lea    0x1(%edx),%ecx
  80154c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154f:	8a 12                	mov    (%edx),%dl
  801551:	88 10                	mov    %dl,(%eax)
  801553:	8a 00                	mov    (%eax),%al
  801555:	84 c0                	test   %al,%al
  801557:	75 e4                	jne    80153d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801559:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80156a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801571:	eb 1f                	jmp    801592 <strncpy+0x34>
		*dst++ = *src;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8d 50 01             	lea    0x1(%eax),%edx
  801579:	89 55 08             	mov    %edx,0x8(%ebp)
  80157c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157f:	8a 12                	mov    (%edx),%dl
  801581:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	84 c0                	test   %al,%al
  80158a:	74 03                	je     80158f <strncpy+0x31>
			src++;
  80158c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80158f:	ff 45 fc             	incl   -0x4(%ebp)
  801592:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801595:	3b 45 10             	cmp    0x10(%ebp),%eax
  801598:	72 d9                	jb     801573 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80159a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015af:	74 30                	je     8015e1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015b1:	eb 16                	jmp    8015c9 <strlcpy+0x2a>
			*dst++ = *src++;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8d 50 01             	lea    0x1(%eax),%edx
  8015b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8015bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015c2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c5:	8a 12                	mov    (%edx),%dl
  8015c7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015c9:	ff 4d 10             	decl   0x10(%ebp)
  8015cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d0:	74 09                	je     8015db <strlcpy+0x3c>
  8015d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 d8                	jne    8015b3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e7:	29 c2                	sub    %eax,%edx
  8015e9:	89 d0                	mov    %edx,%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015f0:	eb 06                	jmp    8015f8 <strcmp+0xb>
		p++, q++;
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	8a 00                	mov    (%eax),%al
  8015fd:	84 c0                	test   %al,%al
  8015ff:	74 0e                	je     80160f <strcmp+0x22>
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8a 10                	mov    (%eax),%dl
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	38 c2                	cmp    %al,%dl
  80160d:	74 e3                	je     8015f2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	0f b6 d0             	movzbl %al,%edx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	8a 00                	mov    (%eax),%al
  80161c:	0f b6 c0             	movzbl %al,%eax
  80161f:	29 c2                	sub    %eax,%edx
  801621:	89 d0                	mov    %edx,%eax
}
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    

00801625 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801628:	eb 09                	jmp    801633 <strncmp+0xe>
		n--, p++, q++;
  80162a:	ff 4d 10             	decl   0x10(%ebp)
  80162d:	ff 45 08             	incl   0x8(%ebp)
  801630:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801633:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801637:	74 17                	je     801650 <strncmp+0x2b>
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	8a 00                	mov    (%eax),%al
  80163e:	84 c0                	test   %al,%al
  801640:	74 0e                	je     801650 <strncmp+0x2b>
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 10                	mov    (%eax),%dl
  801647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	38 c2                	cmp    %al,%dl
  80164e:	74 da                	je     80162a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801650:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801654:	75 07                	jne    80165d <strncmp+0x38>
		return 0;
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	eb 14                	jmp    801671 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f b6 d0             	movzbl %al,%edx
  801665:	8b 45 0c             	mov    0xc(%ebp),%eax
  801668:	8a 00                	mov    (%eax),%al
  80166a:	0f b6 c0             	movzbl %al,%eax
  80166d:	29 c2                	sub    %eax,%edx
  80166f:	89 d0                	mov    %edx,%eax
}
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    

00801673 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80167f:	eb 12                	jmp    801693 <strchr+0x20>
		if (*s == c)
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	8a 00                	mov    (%eax),%al
  801686:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801689:	75 05                	jne    801690 <strchr+0x1d>
			return (char *) s;
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	eb 11                	jmp    8016a1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801690:	ff 45 08             	incl   0x8(%ebp)
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8a 00                	mov    (%eax),%al
  801698:	84 c0                	test   %al,%al
  80169a:	75 e5                	jne    801681 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80169c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 04             	sub    $0x4,%esp
  8016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016af:	eb 0d                	jmp    8016be <strfind+0x1b>
		if (*s == c)
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8a 00                	mov    (%eax),%al
  8016b6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016b9:	74 0e                	je     8016c9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016bb:	ff 45 08             	incl   0x8(%ebp)
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	84 c0                	test   %al,%al
  8016c5:	75 ea                	jne    8016b1 <strfind+0xe>
  8016c7:	eb 01                	jmp    8016ca <strfind+0x27>
		if (*s == c)
			break;
  8016c9:	90                   	nop
	return (char *) s;
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016e1:	eb 0e                	jmp    8016f1 <memset+0x22>
		*p++ = c;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8d 50 01             	lea    0x1(%eax),%edx
  8016e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ef:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016f1:	ff 4d f8             	decl   -0x8(%ebp)
  8016f4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016f8:	79 e9                	jns    8016e3 <memset+0x14>
		*p++ = c;

	return v;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801711:	eb 16                	jmp    801729 <memcpy+0x2a>
		*d++ = *s++;
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	8d 50 01             	lea    0x1(%eax),%edx
  801719:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80171c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801722:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801725:	8a 12                	mov    (%edx),%dl
  801727:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801729:	8b 45 10             	mov    0x10(%ebp),%eax
  80172c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172f:	89 55 10             	mov    %edx,0x10(%ebp)
  801732:	85 c0                	test   %eax,%eax
  801734:	75 dd                	jne    801713 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80174d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801750:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801753:	73 50                	jae    8017a5 <memmove+0x6a>
  801755:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801758:	8b 45 10             	mov    0x10(%ebp),%eax
  80175b:	01 d0                	add    %edx,%eax
  80175d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801760:	76 43                	jbe    8017a5 <memmove+0x6a>
		s += n;
  801762:	8b 45 10             	mov    0x10(%ebp),%eax
  801765:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801768:	8b 45 10             	mov    0x10(%ebp),%eax
  80176b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80176e:	eb 10                	jmp    801780 <memmove+0x45>
			*--d = *--s;
  801770:	ff 4d f8             	decl   -0x8(%ebp)
  801773:	ff 4d fc             	decl   -0x4(%ebp)
  801776:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801779:	8a 10                	mov    (%eax),%dl
  80177b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801780:	8b 45 10             	mov    0x10(%ebp),%eax
  801783:	8d 50 ff             	lea    -0x1(%eax),%edx
  801786:	89 55 10             	mov    %edx,0x10(%ebp)
  801789:	85 c0                	test   %eax,%eax
  80178b:	75 e3                	jne    801770 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80178d:	eb 23                	jmp    8017b2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80178f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801792:	8d 50 01             	lea    0x1(%eax),%edx
  801795:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801798:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017a1:	8a 12                	mov    (%edx),%dl
  8017a3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8017a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ae:	85 c0                	test   %eax,%eax
  8017b0:	75 dd                	jne    80178f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017c9:	eb 2a                	jmp    8017f5 <memcmp+0x3e>
		if (*s1 != *s2)
  8017cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017ce:	8a 10                	mov    (%eax),%dl
  8017d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	38 c2                	cmp    %al,%dl
  8017d7:	74 16                	je     8017ef <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	0f b6 d0             	movzbl %al,%edx
  8017e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e4:	8a 00                	mov    (%eax),%al
  8017e6:	0f b6 c0             	movzbl %al,%eax
  8017e9:	29 c2                	sub    %eax,%edx
  8017eb:	89 d0                	mov    %edx,%eax
  8017ed:	eb 18                	jmp    801807 <memcmp+0x50>
		s1++, s2++;
  8017ef:	ff 45 fc             	incl   -0x4(%ebp)
  8017f2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8017fe:	85 c0                	test   %eax,%eax
  801800:	75 c9                	jne    8017cb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80180f:	8b 55 08             	mov    0x8(%ebp),%edx
  801812:	8b 45 10             	mov    0x10(%ebp),%eax
  801815:	01 d0                	add    %edx,%eax
  801817:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80181a:	eb 15                	jmp    801831 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	0f b6 d0             	movzbl %al,%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	0f b6 c0             	movzbl %al,%eax
  80182a:	39 c2                	cmp    %eax,%edx
  80182c:	74 0d                	je     80183b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182e:	ff 45 08             	incl   0x8(%ebp)
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801837:	72 e3                	jb     80181c <memfind+0x13>
  801839:	eb 01                	jmp    80183c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80183b:	90                   	nop
	return (void *) s;
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801847:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80184e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801855:	eb 03                	jmp    80185a <strtol+0x19>
		s++;
  801857:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8a 00                	mov    (%eax),%al
  80185f:	3c 20                	cmp    $0x20,%al
  801861:	74 f4                	je     801857 <strtol+0x16>
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8a 00                	mov    (%eax),%al
  801868:	3c 09                	cmp    $0x9,%al
  80186a:	74 eb                	je     801857 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	8a 00                	mov    (%eax),%al
  801871:	3c 2b                	cmp    $0x2b,%al
  801873:	75 05                	jne    80187a <strtol+0x39>
		s++;
  801875:	ff 45 08             	incl   0x8(%ebp)
  801878:	eb 13                	jmp    80188d <strtol+0x4c>
	else if (*s == '-')
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	3c 2d                	cmp    $0x2d,%al
  801881:	75 0a                	jne    80188d <strtol+0x4c>
		s++, neg = 1;
  801883:	ff 45 08             	incl   0x8(%ebp)
  801886:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801891:	74 06                	je     801899 <strtol+0x58>
  801893:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801897:	75 20                	jne    8018b9 <strtol+0x78>
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	3c 30                	cmp    $0x30,%al
  8018a0:	75 17                	jne    8018b9 <strtol+0x78>
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	40                   	inc    %eax
  8018a6:	8a 00                	mov    (%eax),%al
  8018a8:	3c 78                	cmp    $0x78,%al
  8018aa:	75 0d                	jne    8018b9 <strtol+0x78>
		s += 2, base = 16;
  8018ac:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8018b0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018b7:	eb 28                	jmp    8018e1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018bd:	75 15                	jne    8018d4 <strtol+0x93>
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	8a 00                	mov    (%eax),%al
  8018c4:	3c 30                	cmp    $0x30,%al
  8018c6:	75 0c                	jne    8018d4 <strtol+0x93>
		s++, base = 8;
  8018c8:	ff 45 08             	incl   0x8(%ebp)
  8018cb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018d2:	eb 0d                	jmp    8018e1 <strtol+0xa0>
	else if (base == 0)
  8018d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018d8:	75 07                	jne    8018e1 <strtol+0xa0>
		base = 10;
  8018da:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	3c 2f                	cmp    $0x2f,%al
  8018e8:	7e 19                	jle    801903 <strtol+0xc2>
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	3c 39                	cmp    $0x39,%al
  8018f1:	7f 10                	jg     801903 <strtol+0xc2>
			dig = *s - '0';
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	0f be c0             	movsbl %al,%eax
  8018fb:	83 e8 30             	sub    $0x30,%eax
  8018fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801901:	eb 42                	jmp    801945 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	8a 00                	mov    (%eax),%al
  801908:	3c 60                	cmp    $0x60,%al
  80190a:	7e 19                	jle    801925 <strtol+0xe4>
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8a 00                	mov    (%eax),%al
  801911:	3c 7a                	cmp    $0x7a,%al
  801913:	7f 10                	jg     801925 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8a 00                	mov    (%eax),%al
  80191a:	0f be c0             	movsbl %al,%eax
  80191d:	83 e8 57             	sub    $0x57,%eax
  801920:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801923:	eb 20                	jmp    801945 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	3c 40                	cmp    $0x40,%al
  80192c:	7e 39                	jle    801967 <strtol+0x126>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	3c 5a                	cmp    $0x5a,%al
  801935:	7f 30                	jg     801967 <strtol+0x126>
			dig = *s - 'A' + 10;
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	8a 00                	mov    (%eax),%al
  80193c:	0f be c0             	movsbl %al,%eax
  80193f:	83 e8 37             	sub    $0x37,%eax
  801942:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801948:	3b 45 10             	cmp    0x10(%ebp),%eax
  80194b:	7d 19                	jge    801966 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80194d:	ff 45 08             	incl   0x8(%ebp)
  801950:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801953:	0f af 45 10          	imul   0x10(%ebp),%eax
  801957:	89 c2                	mov    %eax,%edx
  801959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195c:	01 d0                	add    %edx,%eax
  80195e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801961:	e9 7b ff ff ff       	jmp    8018e1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801966:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801967:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80196b:	74 08                	je     801975 <strtol+0x134>
		*endptr = (char *) s;
  80196d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801970:	8b 55 08             	mov    0x8(%ebp),%edx
  801973:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801975:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801979:	74 07                	je     801982 <strtol+0x141>
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	f7 d8                	neg    %eax
  801980:	eb 03                	jmp    801985 <strtol+0x144>
  801982:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <ltostr>:

void
ltostr(long value, char *str)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80198d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801994:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80199b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80199f:	79 13                	jns    8019b4 <ltostr+0x2d>
	{
		neg = 1;
  8019a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8019a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ab:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8019ae:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8019b1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019bc:	99                   	cltd   
  8019bd:	f7 f9                	idiv   %ecx
  8019bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c5:	8d 50 01             	lea    0x1(%eax),%edx
  8019c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019cb:	89 c2                	mov    %eax,%edx
  8019cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d0:	01 d0                	add    %edx,%eax
  8019d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d5:	83 c2 30             	add    $0x30,%edx
  8019d8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019e2:	f7 e9                	imul   %ecx
  8019e4:	c1 fa 02             	sar    $0x2,%edx
  8019e7:	89 c8                	mov    %ecx,%eax
  8019e9:	c1 f8 1f             	sar    $0x1f,%eax
  8019ec:	29 c2                	sub    %eax,%edx
  8019ee:	89 d0                	mov    %edx,%eax
  8019f0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019fb:	f7 e9                	imul   %ecx
  8019fd:	c1 fa 02             	sar    $0x2,%edx
  801a00:	89 c8                	mov    %ecx,%eax
  801a02:	c1 f8 1f             	sar    $0x1f,%eax
  801a05:	29 c2                	sub    %eax,%edx
  801a07:	89 d0                	mov    %edx,%eax
  801a09:	c1 e0 02             	shl    $0x2,%eax
  801a0c:	01 d0                	add    %edx,%eax
  801a0e:	01 c0                	add    %eax,%eax
  801a10:	29 c1                	sub    %eax,%ecx
  801a12:	89 ca                	mov    %ecx,%edx
  801a14:	85 d2                	test   %edx,%edx
  801a16:	75 9c                	jne    8019b4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a22:	48                   	dec    %eax
  801a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a2a:	74 3d                	je     801a69 <ltostr+0xe2>
		start = 1 ;
  801a2c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a33:	eb 34                	jmp    801a69 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3b:	01 d0                	add    %edx,%eax
  801a3d:	8a 00                	mov    (%eax),%al
  801a3f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a48:	01 c2                	add    %eax,%edx
  801a4a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a50:	01 c8                	add    %ecx,%eax
  801a52:	8a 00                	mov    (%eax),%al
  801a54:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5c:	01 c2                	add    %eax,%edx
  801a5e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a61:	88 02                	mov    %al,(%edx)
		start++ ;
  801a63:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a66:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6f:	7c c4                	jl     801a35 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a71:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a77:	01 d0                	add    %edx,%eax
  801a79:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	e8 54 fa ff ff       	call   8014e1 <strlen>
  801a8d:	83 c4 04             	add    $0x4,%esp
  801a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a93:	ff 75 0c             	pushl  0xc(%ebp)
  801a96:	e8 46 fa ff ff       	call   8014e1 <strlen>
  801a9b:	83 c4 04             	add    $0x4,%esp
  801a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801aa1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aa8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aaf:	eb 17                	jmp    801ac8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801ab1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab7:	01 c2                	add    %eax,%edx
  801ab9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	01 c8                	add    %ecx,%eax
  801ac1:	8a 00                	mov    (%eax),%al
  801ac3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ac5:	ff 45 fc             	incl   -0x4(%ebp)
  801ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801acb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ace:	7c e1                	jl     801ab1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ad0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ad7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801ade:	eb 1f                	jmp    801aff <strcconcat+0x80>
		final[s++] = str2[i] ;
  801ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae3:	8d 50 01             	lea    0x1(%eax),%edx
  801ae6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae9:	89 c2                	mov    %eax,%edx
  801aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  801aee:	01 c2                	add    %eax,%edx
  801af0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af6:	01 c8                	add    %ecx,%eax
  801af8:	8a 00                	mov    (%eax),%al
  801afa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801afc:	ff 45 f8             	incl   -0x8(%ebp)
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b02:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b05:	7c d9                	jl     801ae0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0d:	01 d0                	add    %edx,%eax
  801b0f:	c6 00 00             	movb   $0x0,(%eax)
}
  801b12:	90                   	nop
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b18:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b21:	8b 45 14             	mov    0x14(%ebp),%eax
  801b24:	8b 00                	mov    (%eax),%eax
  801b26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b30:	01 d0                	add    %edx,%eax
  801b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b38:	eb 0c                	jmp    801b46 <strsplit+0x31>
			*string++ = 0;
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	8d 50 01             	lea    0x1(%eax),%edx
  801b40:	89 55 08             	mov    %edx,0x8(%ebp)
  801b43:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	8a 00                	mov    (%eax),%al
  801b4b:	84 c0                	test   %al,%al
  801b4d:	74 18                	je     801b67 <strsplit+0x52>
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	8a 00                	mov    (%eax),%al
  801b54:	0f be c0             	movsbl %al,%eax
  801b57:	50                   	push   %eax
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	e8 13 fb ff ff       	call   801673 <strchr>
  801b60:	83 c4 08             	add    $0x8,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	75 d3                	jne    801b3a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	8a 00                	mov    (%eax),%al
  801b6c:	84 c0                	test   %al,%al
  801b6e:	74 5a                	je     801bca <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b70:	8b 45 14             	mov    0x14(%ebp),%eax
  801b73:	8b 00                	mov    (%eax),%eax
  801b75:	83 f8 0f             	cmp    $0xf,%eax
  801b78:	75 07                	jne    801b81 <strsplit+0x6c>
		{
			return 0;
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7f:	eb 66                	jmp    801be7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b81:	8b 45 14             	mov    0x14(%ebp),%eax
  801b84:	8b 00                	mov    (%eax),%eax
  801b86:	8d 48 01             	lea    0x1(%eax),%ecx
  801b89:	8b 55 14             	mov    0x14(%ebp),%edx
  801b8c:	89 0a                	mov    %ecx,(%edx)
  801b8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b95:	8b 45 10             	mov    0x10(%ebp),%eax
  801b98:	01 c2                	add    %eax,%edx
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b9f:	eb 03                	jmp    801ba4 <strsplit+0x8f>
			string++;
  801ba1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	8a 00                	mov    (%eax),%al
  801ba9:	84 c0                	test   %al,%al
  801bab:	74 8b                	je     801b38 <strsplit+0x23>
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	8a 00                	mov    (%eax),%al
  801bb2:	0f be c0             	movsbl %al,%eax
  801bb5:	50                   	push   %eax
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	e8 b5 fa ff ff       	call   801673 <strchr>
  801bbe:	83 c4 08             	add    $0x8,%esp
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	74 dc                	je     801ba1 <strsplit+0x8c>
			string++;
	}
  801bc5:	e9 6e ff ff ff       	jmp    801b38 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bca:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bce:	8b 00                	mov    (%eax),%eax
  801bd0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bda:	01 d0                	add    %edx,%eax
  801bdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801be2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	68 e4 2d 80 00       	push   $0x802de4
  801bf7:	6a 0e                	push   $0xe
  801bf9:	68 1e 2e 80 00       	push   $0x802e1e
  801bfe:	e8 a2 ed ff ff       	call   8009a5 <_panic>

00801c03 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801c09:	a1 04 30 80 00       	mov    0x803004,%eax
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	74 0f                	je     801c21 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801c12:	e8 d2 ff ff ff       	call   801be9 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c17:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801c1e:	00 00 00 
	}
	if (size == 0) return NULL ;
  801c21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c25:	75 07                	jne    801c2e <malloc+0x2b>
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2c:	eb 14                	jmp    801c42 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	68 2c 2e 80 00       	push   $0x802e2c
  801c36:	6a 2e                	push   $0x2e
  801c38:	68 1e 2e 80 00       	push   $0x802e1e
  801c3d:	e8 63 ed ff ff       	call   8009a5 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801c4a:	83 ec 04             	sub    $0x4,%esp
  801c4d:	68 54 2e 80 00       	push   $0x802e54
  801c52:	6a 49                	push   $0x49
  801c54:	68 1e 2e 80 00       	push   $0x802e1e
  801c59:	e8 47 ed ff ff       	call   8009a5 <_panic>

00801c5e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 18             	sub    $0x18,%esp
  801c64:	8b 45 10             	mov    0x10(%ebp),%eax
  801c67:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	68 78 2e 80 00       	push   $0x802e78
  801c72:	6a 57                	push   $0x57
  801c74:	68 1e 2e 80 00       	push   $0x802e1e
  801c79:	e8 27 ed ff ff       	call   8009a5 <_panic>

00801c7e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	68 a0 2e 80 00       	push   $0x802ea0
  801c8c:	6a 60                	push   $0x60
  801c8e:	68 1e 2e 80 00       	push   $0x802e1e
  801c93:	e8 0d ed ff ff       	call   8009a5 <_panic>

00801c98 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	68 c4 2e 80 00       	push   $0x802ec4
  801ca6:	6a 7c                	push   $0x7c
  801ca8:	68 1e 2e 80 00       	push   $0x802e1e
  801cad:	e8 f3 ec ff ff       	call   8009a5 <_panic>

00801cb2 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	68 ec 2e 80 00       	push   $0x802eec
  801cc0:	68 86 00 00 00       	push   $0x86
  801cc5:	68 1e 2e 80 00       	push   $0x802e1e
  801cca:	e8 d6 ec ff ff       	call   8009a5 <_panic>

00801ccf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd5:	83 ec 04             	sub    $0x4,%esp
  801cd8:	68 10 2f 80 00       	push   $0x802f10
  801cdd:	68 91 00 00 00       	push   $0x91
  801ce2:	68 1e 2e 80 00       	push   $0x802e1e
  801ce7:	e8 b9 ec ff ff       	call   8009a5 <_panic>

00801cec <shrink>:

}
void shrink(uint32 newSize)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cf2:	83 ec 04             	sub    $0x4,%esp
  801cf5:	68 10 2f 80 00       	push   $0x802f10
  801cfa:	68 96 00 00 00       	push   $0x96
  801cff:	68 1e 2e 80 00       	push   $0x802e1e
  801d04:	e8 9c ec ff ff       	call   8009a5 <_panic>

00801d09 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	68 10 2f 80 00       	push   $0x802f10
  801d17:	68 9b 00 00 00       	push   $0x9b
  801d1c:	68 1e 2e 80 00       	push   $0x802e1e
  801d21:	e8 7f ec ff ff       	call   8009a5 <_panic>

00801d26 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	57                   	push   %edi
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d3b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d3e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d41:	cd 30                	int    $0x30
  801d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	5b                   	pop    %ebx
  801d4d:	5e                   	pop    %esi
  801d4e:	5f                   	pop    %edi
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 04             	sub    $0x4,%esp
  801d57:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d5d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	52                   	push   %edx
  801d69:	ff 75 0c             	pushl  0xc(%ebp)
  801d6c:	50                   	push   %eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	e8 b2 ff ff ff       	call   801d26 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	90                   	nop
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_cgetc>:

int
sys_cgetc(void)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 01                	push   $0x1
  801d89:	e8 98 ff ff ff       	call   801d26 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	52                   	push   %edx
  801da3:	50                   	push   %eax
  801da4:	6a 05                	push   $0x5
  801da6:	e8 7b ff ff ff       	call   801d26 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	56                   	push   %esi
  801db4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801db5:	8b 75 18             	mov    0x18(%ebp),%esi
  801db8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	56                   	push   %esi
  801dc5:	53                   	push   %ebx
  801dc6:	51                   	push   %ecx
  801dc7:	52                   	push   %edx
  801dc8:	50                   	push   %eax
  801dc9:	6a 06                	push   $0x6
  801dcb:	e8 56 ff ff ff       	call   801d26 <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
}
  801dd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd6:	5b                   	pop    %ebx
  801dd7:	5e                   	pop    %esi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    

00801dda <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	52                   	push   %edx
  801dea:	50                   	push   %eax
  801deb:	6a 07                	push   $0x7
  801ded:	e8 34 ff ff ff       	call   801d26 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	ff 75 0c             	pushl  0xc(%ebp)
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	6a 08                	push   $0x8
  801e08:	e8 19 ff ff ff       	call   801d26 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 09                	push   $0x9
  801e21:	e8 00 ff ff ff       	call   801d26 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 0a                	push   $0xa
  801e3a:	e8 e7 fe ff ff       	call   801d26 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 0b                	push   $0xb
  801e53:	e8 ce fe ff ff       	call   801d26 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	ff 75 0c             	pushl  0xc(%ebp)
  801e69:	ff 75 08             	pushl  0x8(%ebp)
  801e6c:	6a 0f                	push   $0xf
  801e6e:	e8 b3 fe ff ff       	call   801d26 <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
	return;
  801e76:	90                   	nop
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	ff 75 0c             	pushl  0xc(%ebp)
  801e85:	ff 75 08             	pushl  0x8(%ebp)
  801e88:	6a 10                	push   $0x10
  801e8a:	e8 97 fe ff ff       	call   801d26 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e92:	90                   	nop
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	ff 75 10             	pushl  0x10(%ebp)
  801e9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ea2:	ff 75 08             	pushl  0x8(%ebp)
  801ea5:	6a 11                	push   $0x11
  801ea7:	e8 7a fe ff ff       	call   801d26 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
	return ;
  801eaf:	90                   	nop
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 0c                	push   $0xc
  801ec1:	e8 60 fe ff ff       	call   801d26 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	ff 75 08             	pushl  0x8(%ebp)
  801ed9:	6a 0d                	push   $0xd
  801edb:	e8 46 fe ff ff       	call   801d26 <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 0e                	push   $0xe
  801ef4:	e8 2d fe ff ff       	call   801d26 <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
}
  801efc:	90                   	nop
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 13                	push   $0x13
  801f0e:	e8 13 fe ff ff       	call   801d26 <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
}
  801f16:	90                   	nop
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 14                	push   $0x14
  801f28:	e8 f9 fd ff ff       	call   801d26 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	90                   	nop
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 04             	sub    $0x4,%esp
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f3f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	50                   	push   %eax
  801f4c:	6a 15                	push   $0x15
  801f4e:	e8 d3 fd ff ff       	call   801d26 <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
}
  801f56:	90                   	nop
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 16                	push   $0x16
  801f68:	e8 b9 fd ff ff       	call   801d26 <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
}
  801f70:	90                   	nop
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	ff 75 0c             	pushl  0xc(%ebp)
  801f82:	50                   	push   %eax
  801f83:	6a 17                	push   $0x17
  801f85:	e8 9c fd ff ff       	call   801d26 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	52                   	push   %edx
  801f9f:	50                   	push   %eax
  801fa0:	6a 1a                	push   $0x1a
  801fa2:	e8 7f fd ff ff       	call   801d26 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	6a 18                	push   $0x18
  801fbf:	e8 62 fd ff ff       	call   801d26 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	90                   	nop
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	52                   	push   %edx
  801fda:	50                   	push   %eax
  801fdb:	6a 19                	push   $0x19
  801fdd:	e8 44 fd ff ff       	call   801d26 <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	90                   	nop
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ff4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ff7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	51                   	push   %ecx
  802001:	52                   	push   %edx
  802002:	ff 75 0c             	pushl  0xc(%ebp)
  802005:	50                   	push   %eax
  802006:	6a 1b                	push   $0x1b
  802008:	e8 19 fd ff ff       	call   801d26 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802015:	8b 55 0c             	mov    0xc(%ebp),%edx
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	52                   	push   %edx
  802022:	50                   	push   %eax
  802023:	6a 1c                	push   $0x1c
  802025:	e8 fc fc ff ff       	call   801d26 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802032:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802035:	8b 55 0c             	mov    0xc(%ebp),%edx
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	51                   	push   %ecx
  802040:	52                   	push   %edx
  802041:	50                   	push   %eax
  802042:	6a 1d                	push   $0x1d
  802044:	e8 dd fc ff ff       	call   801d26 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802051:	8b 55 0c             	mov    0xc(%ebp),%edx
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	52                   	push   %edx
  80205e:	50                   	push   %eax
  80205f:	6a 1e                	push   $0x1e
  802061:	e8 c0 fc ff ff       	call   801d26 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 1f                	push   $0x1f
  80207a:	e8 a7 fc ff ff       	call   801d26 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	6a 00                	push   $0x0
  80208c:	ff 75 14             	pushl  0x14(%ebp)
  80208f:	ff 75 10             	pushl  0x10(%ebp)
  802092:	ff 75 0c             	pushl  0xc(%ebp)
  802095:	50                   	push   %eax
  802096:	6a 20                	push   $0x20
  802098:	e8 89 fc ff ff       	call   801d26 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	50                   	push   %eax
  8020b1:	6a 21                	push   $0x21
  8020b3:	e8 6e fc ff ff       	call   801d26 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
}
  8020bb:	90                   	nop
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	50                   	push   %eax
  8020cd:	6a 22                	push   $0x22
  8020cf:	e8 52 fc ff ff       	call   801d26 <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 02                	push   $0x2
  8020e8:	e8 39 fc ff ff       	call   801d26 <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 03                	push   $0x3
  802101:	e8 20 fc ff ff       	call   801d26 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 04                	push   $0x4
  80211a:	e8 07 fc ff ff       	call   801d26 <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <sys_exit_env>:


void sys_exit_env(void)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 23                	push   $0x23
  802133:	e8 ee fb ff ff       	call   801d26 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
}
  80213b:	90                   	nop
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802144:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802147:	8d 50 04             	lea    0x4(%eax),%edx
  80214a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	52                   	push   %edx
  802154:	50                   	push   %eax
  802155:	6a 24                	push   $0x24
  802157:	e8 ca fb ff ff       	call   801d26 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
	return result;
  80215f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802162:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802165:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802168:	89 01                	mov    %eax,(%ecx)
  80216a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	c9                   	leave  
  802171:	c2 04 00             	ret    $0x4

00802174 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	ff 75 10             	pushl  0x10(%ebp)
  80217e:	ff 75 0c             	pushl  0xc(%ebp)
  802181:	ff 75 08             	pushl  0x8(%ebp)
  802184:	6a 12                	push   $0x12
  802186:	e8 9b fb ff ff       	call   801d26 <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
	return ;
  80218e:	90                   	nop
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <sys_rcr2>:
uint32 sys_rcr2()
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 25                	push   $0x25
  8021a0:	e8 81 fb ff ff       	call   801d26 <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	50                   	push   %eax
  8021c3:	6a 26                	push   $0x26
  8021c5:	e8 5c fb ff ff       	call   801d26 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cd:	90                   	nop
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <rsttst>:
void rsttst()
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 28                	push   $0x28
  8021df:	e8 42 fb ff ff       	call   801d26 <syscall>
  8021e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e7:	90                   	nop
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8021f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021fd:	52                   	push   %edx
  8021fe:	50                   	push   %eax
  8021ff:	ff 75 10             	pushl  0x10(%ebp)
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	6a 27                	push   $0x27
  80220a:	e8 17 fb ff ff       	call   801d26 <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
	return ;
  802212:	90                   	nop
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <chktst>:
void chktst(uint32 n)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	ff 75 08             	pushl  0x8(%ebp)
  802223:	6a 29                	push   $0x29
  802225:	e8 fc fa ff ff       	call   801d26 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
	return ;
  80222d:	90                   	nop
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <inctst>:

void inctst()
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 2a                	push   $0x2a
  80223f:	e8 e2 fa ff ff       	call   801d26 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
	return ;
  802247:	90                   	nop
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <gettst>:
uint32 gettst()
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 2b                	push   $0x2b
  802259:	e8 c8 fa ff ff       	call   801d26 <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 2c                	push   $0x2c
  802275:	e8 ac fa ff ff       	call   801d26 <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
  80227d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802280:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802284:	75 07                	jne    80228d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802286:	b8 01 00 00 00       	mov    $0x1,%eax
  80228b:	eb 05                	jmp    802292 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80228d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 2c                	push   $0x2c
  8022a6:	e8 7b fa ff ff       	call   801d26 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
  8022ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022b1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022b5:	75 07                	jne    8022be <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bc:	eb 05                	jmp    8022c3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 2c                	push   $0x2c
  8022d7:	e8 4a fa ff ff       	call   801d26 <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
  8022df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022e2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022e6:	75 07                	jne    8022ef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ed:	eb 05                	jmp    8022f4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 2c                	push   $0x2c
  802308:	e8 19 fa ff ff       	call   801d26 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
  802310:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802313:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802317:	75 07                	jne    802320 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802319:	b8 01 00 00 00       	mov    $0x1,%eax
  80231e:	eb 05                	jmp    802325 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	ff 75 08             	pushl  0x8(%ebp)
  802335:	6a 2d                	push   $0x2d
  802337:	e8 ea f9 ff ff       	call   801d26 <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
	return ;
  80233f:	90                   	nop
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802346:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802349:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	6a 00                	push   $0x0
  802354:	53                   	push   %ebx
  802355:	51                   	push   %ecx
  802356:	52                   	push   %edx
  802357:	50                   	push   %eax
  802358:	6a 2e                	push   $0x2e
  80235a:	e8 c7 f9 ff ff       	call   801d26 <syscall>
  80235f:	83 c4 18             	add    $0x18,%esp
}
  802362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80236a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	52                   	push   %edx
  802377:	50                   	push   %eax
  802378:	6a 2f                	push   $0x2f
  80237a:	e8 a7 f9 ff ff       	call   801d26 <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <__udivdi3>:
  802384:	55                   	push   %ebp
  802385:	57                   	push   %edi
  802386:	56                   	push   %esi
  802387:	53                   	push   %ebx
  802388:	83 ec 1c             	sub    $0x1c,%esp
  80238b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80238f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802393:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802397:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80239b:	89 ca                	mov    %ecx,%edx
  80239d:	89 f8                	mov    %edi,%eax
  80239f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023a3:	85 f6                	test   %esi,%esi
  8023a5:	75 2d                	jne    8023d4 <__udivdi3+0x50>
  8023a7:	39 cf                	cmp    %ecx,%edi
  8023a9:	77 65                	ja     802410 <__udivdi3+0x8c>
  8023ab:	89 fd                	mov    %edi,%ebp
  8023ad:	85 ff                	test   %edi,%edi
  8023af:	75 0b                	jne    8023bc <__udivdi3+0x38>
  8023b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b6:	31 d2                	xor    %edx,%edx
  8023b8:	f7 f7                	div    %edi
  8023ba:	89 c5                	mov    %eax,%ebp
  8023bc:	31 d2                	xor    %edx,%edx
  8023be:	89 c8                	mov    %ecx,%eax
  8023c0:	f7 f5                	div    %ebp
  8023c2:	89 c1                	mov    %eax,%ecx
  8023c4:	89 d8                	mov    %ebx,%eax
  8023c6:	f7 f5                	div    %ebp
  8023c8:	89 cf                	mov    %ecx,%edi
  8023ca:	89 fa                	mov    %edi,%edx
  8023cc:	83 c4 1c             	add    $0x1c,%esp
  8023cf:	5b                   	pop    %ebx
  8023d0:	5e                   	pop    %esi
  8023d1:	5f                   	pop    %edi
  8023d2:	5d                   	pop    %ebp
  8023d3:	c3                   	ret    
  8023d4:	39 ce                	cmp    %ecx,%esi
  8023d6:	77 28                	ja     802400 <__udivdi3+0x7c>
  8023d8:	0f bd fe             	bsr    %esi,%edi
  8023db:	83 f7 1f             	xor    $0x1f,%edi
  8023de:	75 40                	jne    802420 <__udivdi3+0x9c>
  8023e0:	39 ce                	cmp    %ecx,%esi
  8023e2:	72 0a                	jb     8023ee <__udivdi3+0x6a>
  8023e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8023e8:	0f 87 9e 00 00 00    	ja     80248c <__udivdi3+0x108>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	89 fa                	mov    %edi,%edx
  8023f5:	83 c4 1c             	add    $0x1c,%esp
  8023f8:	5b                   	pop    %ebx
  8023f9:	5e                   	pop    %esi
  8023fa:	5f                   	pop    %edi
  8023fb:	5d                   	pop    %ebp
  8023fc:	c3                   	ret    
  8023fd:	8d 76 00             	lea    0x0(%esi),%esi
  802400:	31 ff                	xor    %edi,%edi
  802402:	31 c0                	xor    %eax,%eax
  802404:	89 fa                	mov    %edi,%edx
  802406:	83 c4 1c             	add    $0x1c,%esp
  802409:	5b                   	pop    %ebx
  80240a:	5e                   	pop    %esi
  80240b:	5f                   	pop    %edi
  80240c:	5d                   	pop    %ebp
  80240d:	c3                   	ret    
  80240e:	66 90                	xchg   %ax,%ax
  802410:	89 d8                	mov    %ebx,%eax
  802412:	f7 f7                	div    %edi
  802414:	31 ff                	xor    %edi,%edi
  802416:	89 fa                	mov    %edi,%edx
  802418:	83 c4 1c             	add    $0x1c,%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5e                   	pop    %esi
  80241d:	5f                   	pop    %edi
  80241e:	5d                   	pop    %ebp
  80241f:	c3                   	ret    
  802420:	bd 20 00 00 00       	mov    $0x20,%ebp
  802425:	89 eb                	mov    %ebp,%ebx
  802427:	29 fb                	sub    %edi,%ebx
  802429:	89 f9                	mov    %edi,%ecx
  80242b:	d3 e6                	shl    %cl,%esi
  80242d:	89 c5                	mov    %eax,%ebp
  80242f:	88 d9                	mov    %bl,%cl
  802431:	d3 ed                	shr    %cl,%ebp
  802433:	89 e9                	mov    %ebp,%ecx
  802435:	09 f1                	or     %esi,%ecx
  802437:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80243b:	89 f9                	mov    %edi,%ecx
  80243d:	d3 e0                	shl    %cl,%eax
  80243f:	89 c5                	mov    %eax,%ebp
  802441:	89 d6                	mov    %edx,%esi
  802443:	88 d9                	mov    %bl,%cl
  802445:	d3 ee                	shr    %cl,%esi
  802447:	89 f9                	mov    %edi,%ecx
  802449:	d3 e2                	shl    %cl,%edx
  80244b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80244f:	88 d9                	mov    %bl,%cl
  802451:	d3 e8                	shr    %cl,%eax
  802453:	09 c2                	or     %eax,%edx
  802455:	89 d0                	mov    %edx,%eax
  802457:	89 f2                	mov    %esi,%edx
  802459:	f7 74 24 0c          	divl   0xc(%esp)
  80245d:	89 d6                	mov    %edx,%esi
  80245f:	89 c3                	mov    %eax,%ebx
  802461:	f7 e5                	mul    %ebp
  802463:	39 d6                	cmp    %edx,%esi
  802465:	72 19                	jb     802480 <__udivdi3+0xfc>
  802467:	74 0b                	je     802474 <__udivdi3+0xf0>
  802469:	89 d8                	mov    %ebx,%eax
  80246b:	31 ff                	xor    %edi,%edi
  80246d:	e9 58 ff ff ff       	jmp    8023ca <__udivdi3+0x46>
  802472:	66 90                	xchg   %ax,%ax
  802474:	8b 54 24 08          	mov    0x8(%esp),%edx
  802478:	89 f9                	mov    %edi,%ecx
  80247a:	d3 e2                	shl    %cl,%edx
  80247c:	39 c2                	cmp    %eax,%edx
  80247e:	73 e9                	jae    802469 <__udivdi3+0xe5>
  802480:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802483:	31 ff                	xor    %edi,%edi
  802485:	e9 40 ff ff ff       	jmp    8023ca <__udivdi3+0x46>
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	31 c0                	xor    %eax,%eax
  80248e:	e9 37 ff ff ff       	jmp    8023ca <__udivdi3+0x46>
  802493:	90                   	nop

00802494 <__umoddi3>:
  802494:	55                   	push   %ebp
  802495:	57                   	push   %edi
  802496:	56                   	push   %esi
  802497:	53                   	push   %ebx
  802498:	83 ec 1c             	sub    $0x1c,%esp
  80249b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80249f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024b3:	89 f3                	mov    %esi,%ebx
  8024b5:	89 fa                	mov    %edi,%edx
  8024b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024bb:	89 34 24             	mov    %esi,(%esp)
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	75 1a                	jne    8024dc <__umoddi3+0x48>
  8024c2:	39 f7                	cmp    %esi,%edi
  8024c4:	0f 86 a2 00 00 00    	jbe    80256c <__umoddi3+0xd8>
  8024ca:	89 c8                	mov    %ecx,%eax
  8024cc:	89 f2                	mov    %esi,%edx
  8024ce:	f7 f7                	div    %edi
  8024d0:	89 d0                	mov    %edx,%eax
  8024d2:	31 d2                	xor    %edx,%edx
  8024d4:	83 c4 1c             	add    $0x1c,%esp
  8024d7:	5b                   	pop    %ebx
  8024d8:	5e                   	pop    %esi
  8024d9:	5f                   	pop    %edi
  8024da:	5d                   	pop    %ebp
  8024db:	c3                   	ret    
  8024dc:	39 f0                	cmp    %esi,%eax
  8024de:	0f 87 ac 00 00 00    	ja     802590 <__umoddi3+0xfc>
  8024e4:	0f bd e8             	bsr    %eax,%ebp
  8024e7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ea:	0f 84 ac 00 00 00    	je     80259c <__umoddi3+0x108>
  8024f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8024f5:	29 ef                	sub    %ebp,%edi
  8024f7:	89 fe                	mov    %edi,%esi
  8024f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024fd:	89 e9                	mov    %ebp,%ecx
  8024ff:	d3 e0                	shl    %cl,%eax
  802501:	89 d7                	mov    %edx,%edi
  802503:	89 f1                	mov    %esi,%ecx
  802505:	d3 ef                	shr    %cl,%edi
  802507:	09 c7                	or     %eax,%edi
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	d3 e2                	shl    %cl,%edx
  80250d:	89 14 24             	mov    %edx,(%esp)
  802510:	89 d8                	mov    %ebx,%eax
  802512:	d3 e0                	shl    %cl,%eax
  802514:	89 c2                	mov    %eax,%edx
  802516:	8b 44 24 08          	mov    0x8(%esp),%eax
  80251a:	d3 e0                	shl    %cl,%eax
  80251c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802520:	8b 44 24 08          	mov    0x8(%esp),%eax
  802524:	89 f1                	mov    %esi,%ecx
  802526:	d3 e8                	shr    %cl,%eax
  802528:	09 d0                	or     %edx,%eax
  80252a:	d3 eb                	shr    %cl,%ebx
  80252c:	89 da                	mov    %ebx,%edx
  80252e:	f7 f7                	div    %edi
  802530:	89 d3                	mov    %edx,%ebx
  802532:	f7 24 24             	mull   (%esp)
  802535:	89 c6                	mov    %eax,%esi
  802537:	89 d1                	mov    %edx,%ecx
  802539:	39 d3                	cmp    %edx,%ebx
  80253b:	0f 82 87 00 00 00    	jb     8025c8 <__umoddi3+0x134>
  802541:	0f 84 91 00 00 00    	je     8025d8 <__umoddi3+0x144>
  802547:	8b 54 24 04          	mov    0x4(%esp),%edx
  80254b:	29 f2                	sub    %esi,%edx
  80254d:	19 cb                	sbb    %ecx,%ebx
  80254f:	89 d8                	mov    %ebx,%eax
  802551:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802555:	d3 e0                	shl    %cl,%eax
  802557:	89 e9                	mov    %ebp,%ecx
  802559:	d3 ea                	shr    %cl,%edx
  80255b:	09 d0                	or     %edx,%eax
  80255d:	89 e9                	mov    %ebp,%ecx
  80255f:	d3 eb                	shr    %cl,%ebx
  802561:	89 da                	mov    %ebx,%edx
  802563:	83 c4 1c             	add    $0x1c,%esp
  802566:	5b                   	pop    %ebx
  802567:	5e                   	pop    %esi
  802568:	5f                   	pop    %edi
  802569:	5d                   	pop    %ebp
  80256a:	c3                   	ret    
  80256b:	90                   	nop
  80256c:	89 fd                	mov    %edi,%ebp
  80256e:	85 ff                	test   %edi,%edi
  802570:	75 0b                	jne    80257d <__umoddi3+0xe9>
  802572:	b8 01 00 00 00       	mov    $0x1,%eax
  802577:	31 d2                	xor    %edx,%edx
  802579:	f7 f7                	div    %edi
  80257b:	89 c5                	mov    %eax,%ebp
  80257d:	89 f0                	mov    %esi,%eax
  80257f:	31 d2                	xor    %edx,%edx
  802581:	f7 f5                	div    %ebp
  802583:	89 c8                	mov    %ecx,%eax
  802585:	f7 f5                	div    %ebp
  802587:	89 d0                	mov    %edx,%eax
  802589:	e9 44 ff ff ff       	jmp    8024d2 <__umoddi3+0x3e>
  80258e:	66 90                	xchg   %ax,%ax
  802590:	89 c8                	mov    %ecx,%eax
  802592:	89 f2                	mov    %esi,%edx
  802594:	83 c4 1c             	add    $0x1c,%esp
  802597:	5b                   	pop    %ebx
  802598:	5e                   	pop    %esi
  802599:	5f                   	pop    %edi
  80259a:	5d                   	pop    %ebp
  80259b:	c3                   	ret    
  80259c:	3b 04 24             	cmp    (%esp),%eax
  80259f:	72 06                	jb     8025a7 <__umoddi3+0x113>
  8025a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025a5:	77 0f                	ja     8025b6 <__umoddi3+0x122>
  8025a7:	89 f2                	mov    %esi,%edx
  8025a9:	29 f9                	sub    %edi,%ecx
  8025ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025af:	89 14 24             	mov    %edx,(%esp)
  8025b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025ba:	8b 14 24             	mov    (%esp),%edx
  8025bd:	83 c4 1c             	add    $0x1c,%esp
  8025c0:	5b                   	pop    %ebx
  8025c1:	5e                   	pop    %esi
  8025c2:	5f                   	pop    %edi
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    
  8025c5:	8d 76 00             	lea    0x0(%esi),%esi
  8025c8:	2b 04 24             	sub    (%esp),%eax
  8025cb:	19 fa                	sbb    %edi,%edx
  8025cd:	89 d1                	mov    %edx,%ecx
  8025cf:	89 c6                	mov    %eax,%esi
  8025d1:	e9 71 ff ff ff       	jmp    802547 <__umoddi3+0xb3>
  8025d6:	66 90                	xchg   %ax,%ax
  8025d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8025dc:	72 ea                	jb     8025c8 <__umoddi3+0x134>
  8025de:	89 d9                	mov    %ebx,%ecx
  8025e0:	e9 62 ff ff ff       	jmp    802547 <__umoddi3+0xb3>
