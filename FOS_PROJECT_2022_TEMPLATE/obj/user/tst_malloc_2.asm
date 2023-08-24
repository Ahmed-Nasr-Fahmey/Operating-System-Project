
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 30 80 00       	mov    0x803020,%eax
  800054:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 30 80 00       	mov    0x803020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 60 1f 80 00       	push   $0x801f60
  800095:	6a 1a                	push   $0x1a
  800097:	68 7c 1f 80 00       	push   $0x801f7c
  80009c:	e8 64 04 00 00       	call   800505 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 b2 14 00 00       	call   80155d <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 5a 14 00 00       	call   80155d <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 16 14 00 00       	call   80155d <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 c8 13 00 00       	call   80155d <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 78 13 00 00       	call   80155d <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 90 1f 80 00       	push   $0x801f90
  800287:	6a 45                	push   $0x45
  800289:	68 7c 1f 80 00       	push   $0x801f7c
  80028e:	e8 72 02 00 00       	call   800505 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 90 1f 80 00       	push   $0x801f90
  8002bc:	6a 46                	push   $0x46
  8002be:	68 7c 1f 80 00       	push   $0x801f7c
  8002c3:	e8 3d 02 00 00       	call   800505 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 90 1f 80 00       	push   $0x801f90
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 7c 1f 80 00       	push   $0x801f7c
  8002f7:	e8 09 02 00 00       	call   800505 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 90 1f 80 00       	push   $0x801f90
  800324:	6a 49                	push   $0x49
  800326:	68 7c 1f 80 00       	push   $0x801f7c
  80032b:	e8 d5 01 00 00       	call   800505 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 90 1f 80 00       	push   $0x801f90
  80035e:	6a 4a                	push   $0x4a
  800360:	68 7c 1f 80 00       	push   $0x801f7c
  800365:	e8 9b 01 00 00       	call   800505 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 90 1f 80 00       	push   $0x801f90
  800394:	6a 4b                	push   $0x4b
  800396:	68 7c 1f 80 00       	push   $0x801f7c
  80039b:	e8 65 01 00 00       	call   800505 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 c8 1f 80 00       	push   $0x801fc8
  8003a8:	e8 0c 04 00 00       	call   8007b9 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 8b 16 00 00       	call   801a4c <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	01 c0                	add    %eax,%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003d4:	01 c8                	add    %ecx,%eax
  8003d6:	c1 e0 02             	shl    $0x2,%eax
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003e2:	01 c8                	add    %ecx,%eax
  8003e4:	c1 e0 02             	shl    $0x2,%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	c1 e0 02             	shl    $0x2,%eax
  8003ec:	01 d0                	add    %edx,%eax
  8003ee:	c1 e0 03             	shl    $0x3,%eax
  8003f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003f6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800400:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800406:	84 c0                	test   %al,%al
  800408:	74 0f                	je     800419 <libmain+0x63>
		binaryname = myEnv->prog_name;
  80040a:	a1 20 30 80 00       	mov    0x803020,%eax
  80040f:	05 18 da 01 00       	add    $0x1da18,%eax
  800414:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80041d:	7e 0a                	jle    800429 <libmain+0x73>
		binaryname = argv[0];
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 01 fc ff ff       	call   800038 <_main>
  800437:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80043a:	e8 1a 14 00 00       	call   801859 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	68 1c 20 80 00       	push   $0x80201c
  800447:	e8 6d 03 00 00       	call   8007b9 <cprintf>
  80044c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80044f:	a1 20 30 80 00       	mov    0x803020,%eax
  800454:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80045a:	a1 20 30 80 00       	mov    0x803020,%eax
  80045f:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800465:	83 ec 04             	sub    $0x4,%esp
  800468:	52                   	push   %edx
  800469:	50                   	push   %eax
  80046a:	68 44 20 80 00       	push   $0x802044
  80046f:	e8 45 03 00 00       	call   8007b9 <cprintf>
  800474:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800477:	a1 20 30 80 00       	mov    0x803020,%eax
  80047c:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800482:	a1 20 30 80 00       	mov    0x803020,%eax
  800487:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80048d:	a1 20 30 80 00       	mov    0x803020,%eax
  800492:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800498:	51                   	push   %ecx
  800499:	52                   	push   %edx
  80049a:	50                   	push   %eax
  80049b:	68 6c 20 80 00       	push   $0x80206c
  8004a0:	e8 14 03 00 00       	call   8007b9 <cprintf>
  8004a5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ad:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	50                   	push   %eax
  8004b7:	68 c4 20 80 00       	push   $0x8020c4
  8004bc:	e8 f8 02 00 00       	call   8007b9 <cprintf>
  8004c1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004c4:	83 ec 0c             	sub    $0xc,%esp
  8004c7:	68 1c 20 80 00       	push   $0x80201c
  8004cc:	e8 e8 02 00 00       	call   8007b9 <cprintf>
  8004d1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004d4:	e8 9a 13 00 00       	call   801873 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004d9:	e8 19 00 00 00       	call   8004f7 <exit>
}
  8004de:	90                   	nop
  8004df:	c9                   	leave  
  8004e0:	c3                   	ret    

008004e1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	6a 00                	push   $0x0
  8004ec:	e8 27 15 00 00       	call   801a18 <sys_destroy_env>
  8004f1:	83 c4 10             	add    $0x10,%esp
}
  8004f4:	90                   	nop
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <exit>:

void
exit(void)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004fd:	e8 7c 15 00 00       	call   801a7e <sys_exit_env>
}
  800502:	90                   	nop
  800503:	c9                   	leave  
  800504:	c3                   	ret    

00800505 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80050b:	8d 45 10             	lea    0x10(%ebp),%eax
  80050e:	83 c0 04             	add    $0x4,%eax
  800511:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800514:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800519:	85 c0                	test   %eax,%eax
  80051b:	74 16                	je     800533 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80051d:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	50                   	push   %eax
  800526:	68 d8 20 80 00       	push   $0x8020d8
  80052b:	e8 89 02 00 00       	call   8007b9 <cprintf>
  800530:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800533:	a1 00 30 80 00       	mov    0x803000,%eax
  800538:	ff 75 0c             	pushl  0xc(%ebp)
  80053b:	ff 75 08             	pushl  0x8(%ebp)
  80053e:	50                   	push   %eax
  80053f:	68 dd 20 80 00       	push   $0x8020dd
  800544:	e8 70 02 00 00       	call   8007b9 <cprintf>
  800549:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80054c:	8b 45 10             	mov    0x10(%ebp),%eax
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	ff 75 f4             	pushl  -0xc(%ebp)
  800555:	50                   	push   %eax
  800556:	e8 f3 01 00 00       	call   80074e <vcprintf>
  80055b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	6a 00                	push   $0x0
  800563:	68 f9 20 80 00       	push   $0x8020f9
  800568:	e8 e1 01 00 00       	call   80074e <vcprintf>
  80056d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800570:	e8 82 ff ff ff       	call   8004f7 <exit>

	// should not return here
	while (1) ;
  800575:	eb fe                	jmp    800575 <_panic+0x70>

00800577 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80057d:	a1 20 30 80 00       	mov    0x803020,%eax
  800582:	8b 50 74             	mov    0x74(%eax),%edx
  800585:	8b 45 0c             	mov    0xc(%ebp),%eax
  800588:	39 c2                	cmp    %eax,%edx
  80058a:	74 14                	je     8005a0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 fc 20 80 00       	push   $0x8020fc
  800594:	6a 26                	push   $0x26
  800596:	68 48 21 80 00       	push   $0x802148
  80059b:	e8 65 ff ff ff       	call   800505 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005ae:	e9 c2 00 00 00       	jmp    800675 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 d0                	add    %edx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	75 08                	jne    8005d0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005c8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005cb:	e9 a2 00 00 00       	jmp    800672 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005de:	eb 69                	jmp    800649 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e5:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ee:	89 d0                	mov    %edx,%eax
  8005f0:	01 c0                	add    %eax,%eax
  8005f2:	01 d0                	add    %edx,%eax
  8005f4:	c1 e0 03             	shl    $0x3,%eax
  8005f7:	01 c8                	add    %ecx,%eax
  8005f9:	8a 40 04             	mov    0x4(%eax),%al
  8005fc:	84 c0                	test   %al,%al
  8005fe:	75 46                	jne    800646 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800600:	a1 20 30 80 00       	mov    0x803020,%eax
  800605:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80060b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80060e:	89 d0                	mov    %edx,%eax
  800610:	01 c0                	add    %eax,%eax
  800612:	01 d0                	add    %edx,%eax
  800614:	c1 e0 03             	shl    $0x3,%eax
  800617:	01 c8                	add    %ecx,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80061e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800621:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800626:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	01 c8                	add    %ecx,%eax
  800637:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800639:	39 c2                	cmp    %eax,%edx
  80063b:	75 09                	jne    800646 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80063d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800644:	eb 12                	jmp    800658 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800646:	ff 45 e8             	incl   -0x18(%ebp)
  800649:	a1 20 30 80 00       	mov    0x803020,%eax
  80064e:	8b 50 74             	mov    0x74(%eax),%edx
  800651:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800654:	39 c2                	cmp    %eax,%edx
  800656:	77 88                	ja     8005e0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800658:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80065c:	75 14                	jne    800672 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 54 21 80 00       	push   $0x802154
  800666:	6a 3a                	push   $0x3a
  800668:	68 48 21 80 00       	push   $0x802148
  80066d:	e8 93 fe ff ff       	call   800505 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800672:	ff 45 f0             	incl   -0x10(%ebp)
  800675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800678:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80067b:	0f 8c 32 ff ff ff    	jl     8005b3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800681:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800688:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80068f:	eb 26                	jmp    8006b7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800691:	a1 20 30 80 00       	mov    0x803020,%eax
  800696:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80069c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80069f:	89 d0                	mov    %edx,%eax
  8006a1:	01 c0                	add    %eax,%eax
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	c1 e0 03             	shl    $0x3,%eax
  8006a8:	01 c8                	add    %ecx,%eax
  8006aa:	8a 40 04             	mov    0x4(%eax),%al
  8006ad:	3c 01                	cmp    $0x1,%al
  8006af:	75 03                	jne    8006b4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006b1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b4:	ff 45 e0             	incl   -0x20(%ebp)
  8006b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8006bc:	8b 50 74             	mov    0x74(%eax),%edx
  8006bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c2:	39 c2                	cmp    %eax,%edx
  8006c4:	77 cb                	ja     800691 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006cc:	74 14                	je     8006e2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 a8 21 80 00       	push   $0x8021a8
  8006d6:	6a 44                	push   $0x44
  8006d8:	68 48 21 80 00       	push   $0x802148
  8006dd:	e8 23 fe ff ff       	call   800505 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006e2:	90                   	nop
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8006f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f6:	89 0a                	mov    %ecx,(%edx)
  8006f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8006fb:	88 d1                	mov    %dl,%cl
  8006fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800700:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	3d ff 00 00 00       	cmp    $0xff,%eax
  80070e:	75 2c                	jne    80073c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800710:	a0 24 30 80 00       	mov    0x803024,%al
  800715:	0f b6 c0             	movzbl %al,%eax
  800718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071b:	8b 12                	mov    (%edx),%edx
  80071d:	89 d1                	mov    %edx,%ecx
  80071f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800722:	83 c2 08             	add    $0x8,%edx
  800725:	83 ec 04             	sub    $0x4,%esp
  800728:	50                   	push   %eax
  800729:	51                   	push   %ecx
  80072a:	52                   	push   %edx
  80072b:	e8 7b 0f 00 00       	call   8016ab <sys_cputs>
  800730:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073f:	8b 40 04             	mov    0x4(%eax),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	8b 45 0c             	mov    0xc(%ebp),%eax
  800748:	89 50 04             	mov    %edx,0x4(%eax)
}
  80074b:	90                   	nop
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    

0080074e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800757:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80075e:	00 00 00 
	b.cnt = 0;
  800761:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800768:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80076b:	ff 75 0c             	pushl  0xc(%ebp)
  80076e:	ff 75 08             	pushl  0x8(%ebp)
  800771:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800777:	50                   	push   %eax
  800778:	68 e5 06 80 00       	push   $0x8006e5
  80077d:	e8 11 02 00 00       	call   800993 <vprintfmt>
  800782:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800785:	a0 24 30 80 00       	mov    0x803024,%al
  80078a:	0f b6 c0             	movzbl %al,%eax
  80078d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800793:	83 ec 04             	sub    $0x4,%esp
  800796:	50                   	push   %eax
  800797:	52                   	push   %edx
  800798:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80079e:	83 c0 08             	add    $0x8,%eax
  8007a1:	50                   	push   %eax
  8007a2:	e8 04 0f 00 00       	call   8016ab <sys_cputs>
  8007a7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007aa:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007b1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007b7:	c9                   	leave  
  8007b8:	c3                   	ret    

008007b9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007bf:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007c6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d5:	50                   	push   %eax
  8007d6:	e8 73 ff ff ff       	call   80074e <vcprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007ec:	e8 68 10 00 00       	call   801859 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800800:	50                   	push   %eax
  800801:	e8 48 ff ff ff       	call   80074e <vcprintf>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80080c:	e8 62 10 00 00       	call   801873 <sys_enable_interrupt>
	return cnt;
  800811:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800814:	c9                   	leave  
  800815:	c3                   	ret    

00800816 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	53                   	push   %ebx
  80081a:	83 ec 14             	sub    $0x14,%esp
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800829:	8b 45 18             	mov    0x18(%ebp),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800834:	77 55                	ja     80088b <printnum+0x75>
  800836:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800839:	72 05                	jb     800840 <printnum+0x2a>
  80083b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80083e:	77 4b                	ja     80088b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800840:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800843:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800846:	8b 45 18             	mov    0x18(%ebp),%eax
  800849:	ba 00 00 00 00       	mov    $0x0,%edx
  80084e:	52                   	push   %edx
  80084f:	50                   	push   %eax
  800850:	ff 75 f4             	pushl  -0xc(%ebp)
  800853:	ff 75 f0             	pushl  -0x10(%ebp)
  800856:	e8 85 14 00 00       	call   801ce0 <__udivdi3>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 20             	pushl  0x20(%ebp)
  800864:	53                   	push   %ebx
  800865:	ff 75 18             	pushl  0x18(%ebp)
  800868:	52                   	push   %edx
  800869:	50                   	push   %eax
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 08             	pushl  0x8(%ebp)
  800870:	e8 a1 ff ff ff       	call   800816 <printnum>
  800875:	83 c4 20             	add    $0x20,%esp
  800878:	eb 1a                	jmp    800894 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	ff 75 20             	pushl  0x20(%ebp)
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	ff d0                	call   *%eax
  800888:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088b:	ff 4d 1c             	decl   0x1c(%ebp)
  80088e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800892:	7f e6                	jg     80087a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800894:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800897:	bb 00 00 00 00       	mov    $0x0,%ebx
  80089c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a2:	53                   	push   %ebx
  8008a3:	51                   	push   %ecx
  8008a4:	52                   	push   %edx
  8008a5:	50                   	push   %eax
  8008a6:	e8 45 15 00 00       	call   801df0 <__umoddi3>
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	05 14 24 80 00       	add    $0x802414,%eax
  8008b3:	8a 00                	mov    (%eax),%al
  8008b5:	0f be c0             	movsbl %al,%eax
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	50                   	push   %eax
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	ff d0                	call   *%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
}
  8008c7:	90                   	nop
  8008c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cb:	c9                   	leave  
  8008cc:	c3                   	ret    

008008cd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008d4:	7e 1c                	jle    8008f2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	8d 50 08             	lea    0x8(%eax),%edx
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	89 10                	mov    %edx,(%eax)
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	83 e8 08             	sub    $0x8,%eax
  8008eb:	8b 50 04             	mov    0x4(%eax),%edx
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	eb 40                	jmp    800932 <getuint+0x65>
	else if (lflag)
  8008f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f6:	74 1e                	je     800916 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	8d 50 04             	lea    0x4(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	89 10                	mov    %edx,(%eax)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	ba 00 00 00 00       	mov    $0x0,%edx
  800914:	eb 1c                	jmp    800932 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	8d 50 04             	lea    0x4(%eax),%edx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	89 10                	mov    %edx,(%eax)
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	83 e8 04             	sub    $0x4,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800937:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093b:	7e 1c                	jle    800959 <getint+0x25>
		return va_arg(*ap, long long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 08             	lea    0x8(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 08             	sub    $0x8,%eax
  800952:	8b 50 04             	mov    0x4(%eax),%edx
  800955:	8b 00                	mov    (%eax),%eax
  800957:	eb 38                	jmp    800991 <getint+0x5d>
	else if (lflag)
  800959:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095d:	74 1a                	je     800979 <getint+0x45>
		return va_arg(*ap, long);
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	8d 50 04             	lea    0x4(%eax),%edx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	89 10                	mov    %edx,(%eax)
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	83 e8 04             	sub    $0x4,%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	99                   	cltd   
  800977:	eb 18                	jmp    800991 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	8d 50 04             	lea    0x4(%eax),%edx
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 10                	mov    %edx,(%eax)
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	83 e8 04             	sub    $0x4,%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	99                   	cltd   
}
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	56                   	push   %esi
  800997:	53                   	push   %ebx
  800998:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80099b:	eb 17                	jmp    8009b4 <vprintfmt+0x21>
			if (ch == '\0')
  80099d:	85 db                	test   %ebx,%ebx
  80099f:	0f 84 af 03 00 00    	je     800d54 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	53                   	push   %ebx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	ff d0                	call   *%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8009bd:	8a 00                	mov    (%eax),%al
  8009bf:	0f b6 d8             	movzbl %al,%ebx
  8009c2:	83 fb 25             	cmp    $0x25,%ebx
  8009c5:	75 d6                	jne    80099d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8d 50 01             	lea    0x1(%eax),%edx
  8009ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	0f b6 d8             	movzbl %al,%ebx
  8009f5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f8:	83 f8 55             	cmp    $0x55,%eax
  8009fb:	0f 87 2b 03 00 00    	ja     800d2c <vprintfmt+0x399>
  800a01:	8b 04 85 38 24 80 00 	mov    0x802438(,%eax,4),%eax
  800a08:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a0a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a0e:	eb d7                	jmp    8009e7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a10:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a14:	eb d1                	jmp    8009e7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a16:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	c1 e0 02             	shl    $0x2,%eax
  800a25:	01 d0                	add    %edx,%eax
  800a27:	01 c0                	add    %eax,%eax
  800a29:	01 d8                	add    %ebx,%eax
  800a2b:	83 e8 30             	sub    $0x30,%eax
  800a2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a31:	8b 45 10             	mov    0x10(%ebp),%eax
  800a34:	8a 00                	mov    (%eax),%al
  800a36:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a39:	83 fb 2f             	cmp    $0x2f,%ebx
  800a3c:	7e 3e                	jle    800a7c <vprintfmt+0xe9>
  800a3e:	83 fb 39             	cmp    $0x39,%ebx
  800a41:	7f 39                	jg     800a7c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a43:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a46:	eb d5                	jmp    800a1d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 c0 04             	add    $0x4,%eax
  800a4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a51:	8b 45 14             	mov    0x14(%ebp),%eax
  800a54:	83 e8 04             	sub    $0x4,%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a5c:	eb 1f                	jmp    800a7d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a62:	79 83                	jns    8009e7 <vprintfmt+0x54>
				width = 0;
  800a64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a6b:	e9 77 ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a70:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a77:	e9 6b ff ff ff       	jmp    8009e7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a7c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a81:	0f 89 60 ff ff ff    	jns    8009e7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a8d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a94:	e9 4e ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a99:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a9c:	e9 46 ff ff ff       	jmp    8009e7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 c0 04             	add    $0x4,%eax
  800aa7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	83 e8 04             	sub    $0x4,%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	50                   	push   %eax
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	ff d0                	call   *%eax
  800abe:	83 c4 10             	add    $0x10,%esp
			break;
  800ac1:	e9 89 02 00 00       	jmp    800d4f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	83 c0 04             	add    $0x4,%eax
  800acc:	89 45 14             	mov    %eax,0x14(%ebp)
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 e8 04             	sub    $0x4,%eax
  800ad5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad7:	85 db                	test   %ebx,%ebx
  800ad9:	79 02                	jns    800add <vprintfmt+0x14a>
				err = -err;
  800adb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800add:	83 fb 64             	cmp    $0x64,%ebx
  800ae0:	7f 0b                	jg     800aed <vprintfmt+0x15a>
  800ae2:	8b 34 9d 80 22 80 00 	mov    0x802280(,%ebx,4),%esi
  800ae9:	85 f6                	test   %esi,%esi
  800aeb:	75 19                	jne    800b06 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aed:	53                   	push   %ebx
  800aee:	68 25 24 80 00       	push   $0x802425
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	e8 5e 02 00 00       	call   800d5c <printfmt>
  800afe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b01:	e9 49 02 00 00       	jmp    800d4f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b06:	56                   	push   %esi
  800b07:	68 2e 24 80 00       	push   $0x80242e
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	ff 75 08             	pushl  0x8(%ebp)
  800b12:	e8 45 02 00 00       	call   800d5c <printfmt>
  800b17:	83 c4 10             	add    $0x10,%esp
			break;
  800b1a:	e9 30 02 00 00       	jmp    800d4f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 c0 04             	add    $0x4,%eax
  800b25:	89 45 14             	mov    %eax,0x14(%ebp)
  800b28:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 30                	mov    (%eax),%esi
  800b30:	85 f6                	test   %esi,%esi
  800b32:	75 05                	jne    800b39 <vprintfmt+0x1a6>
				p = "(null)";
  800b34:	be 31 24 80 00       	mov    $0x802431,%esi
			if (width > 0 && padc != '-')
  800b39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3d:	7e 6d                	jle    800bac <vprintfmt+0x219>
  800b3f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b43:	74 67                	je     800bac <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	50                   	push   %eax
  800b4c:	56                   	push   %esi
  800b4d:	e8 0c 03 00 00       	call   800e5e <strnlen>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b58:	eb 16                	jmp    800b70 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b5a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	50                   	push   %eax
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b74:	7f e4                	jg     800b5a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b76:	eb 34                	jmp    800bac <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b7c:	74 1c                	je     800b9a <vprintfmt+0x207>
  800b7e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b81:	7e 05                	jle    800b88 <vprintfmt+0x1f5>
  800b83:	83 fb 7e             	cmp    $0x7e,%ebx
  800b86:	7e 12                	jle    800b9a <vprintfmt+0x207>
					putch('?', putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	6a 3f                	push   $0x3f
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
  800b98:	eb 0f                	jmp    800ba9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	53                   	push   %ebx
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	ff d0                	call   *%eax
  800ba6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bac:	89 f0                	mov    %esi,%eax
  800bae:	8d 70 01             	lea    0x1(%eax),%esi
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	0f be d8             	movsbl %al,%ebx
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	74 24                	je     800bde <vprintfmt+0x24b>
  800bba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbe:	78 b8                	js     800b78 <vprintfmt+0x1e5>
  800bc0:	ff 4d e0             	decl   -0x20(%ebp)
  800bc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc7:	79 af                	jns    800b78 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc9:	eb 13                	jmp    800bde <vprintfmt+0x24b>
				putch(' ', putdat);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	6a 20                	push   $0x20
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	ff d0                	call   *%eax
  800bd8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdb:	ff 4d e4             	decl   -0x1c(%ebp)
  800bde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be2:	7f e7                	jg     800bcb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800be4:	e9 66 01 00 00       	jmp    800d4f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be9:	83 ec 08             	sub    $0x8,%esp
  800bec:	ff 75 e8             	pushl  -0x18(%ebp)
  800bef:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf2:	50                   	push   %eax
  800bf3:	e8 3c fd ff ff       	call   800934 <getint>
  800bf8:	83 c4 10             	add    $0x10,%esp
  800bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c07:	85 d2                	test   %edx,%edx
  800c09:	79 23                	jns    800c2e <vprintfmt+0x29b>
				putch('-', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	6a 2d                	push   $0x2d
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c21:	f7 d8                	neg    %eax
  800c23:	83 d2 00             	adc    $0x0,%edx
  800c26:	f7 da                	neg    %edx
  800c28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c35:	e9 bc 00 00 00       	jmp    800cf6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c40:	8d 45 14             	lea    0x14(%ebp),%eax
  800c43:	50                   	push   %eax
  800c44:	e8 84 fc ff ff       	call   8008cd <getuint>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c59:	e9 98 00 00 00       	jmp    800cf6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	6a 58                	push   $0x58
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	6a 58                	push   $0x58
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	ff d0                	call   *%eax
  800c7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	6a 58                	push   $0x58
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	ff d0                	call   *%eax
  800c8b:	83 c4 10             	add    $0x10,%esp
			break;
  800c8e:	e9 bc 00 00 00       	jmp    800d4f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	6a 30                	push   $0x30
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	ff d0                	call   *%eax
  800ca0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 78                	push   $0x78
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb6:	83 c0 04             	add    $0x4,%eax
  800cb9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbf:	83 e8 04             	sub    $0x4,%eax
  800cc2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cd5:	eb 1f                	jmp    800cf6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	ff 75 e8             	pushl  -0x18(%ebp)
  800cdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce0:	50                   	push   %eax
  800ce1:	e8 e7 fb ff ff       	call   8008cd <getuint>
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfd:	83 ec 04             	sub    $0x4,%esp
  800d00:	52                   	push   %edx
  800d01:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d04:	50                   	push   %eax
  800d05:	ff 75 f4             	pushl  -0xc(%ebp)
  800d08:	ff 75 f0             	pushl  -0x10(%ebp)
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	ff 75 08             	pushl  0x8(%ebp)
  800d11:	e8 00 fb ff ff       	call   800816 <printnum>
  800d16:	83 c4 20             	add    $0x20,%esp
			break;
  800d19:	eb 34                	jmp    800d4f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1b:	83 ec 08             	sub    $0x8,%esp
  800d1e:	ff 75 0c             	pushl  0xc(%ebp)
  800d21:	53                   	push   %ebx
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	ff d0                	call   *%eax
  800d27:	83 c4 10             	add    $0x10,%esp
			break;
  800d2a:	eb 23                	jmp    800d4f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2c:	83 ec 08             	sub    $0x8,%esp
  800d2f:	ff 75 0c             	pushl  0xc(%ebp)
  800d32:	6a 25                	push   $0x25
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	eb 03                	jmp    800d44 <vprintfmt+0x3b1>
  800d41:	ff 4d 10             	decl   0x10(%ebp)
  800d44:	8b 45 10             	mov    0x10(%ebp),%eax
  800d47:	48                   	dec    %eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	3c 25                	cmp    $0x25,%al
  800d4c:	75 f3                	jne    800d41 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d4e:	90                   	nop
		}
	}
  800d4f:	e9 47 fc ff ff       	jmp    80099b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d54:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d62:	8d 45 10             	lea    0x10(%ebp),%eax
  800d65:	83 c0 04             	add    $0x4,%eax
  800d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d71:	50                   	push   %eax
  800d72:	ff 75 0c             	pushl  0xc(%ebp)
  800d75:	ff 75 08             	pushl  0x8(%ebp)
  800d78:	e8 16 fc ff ff       	call   800993 <vprintfmt>
  800d7d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d80:	90                   	nop
  800d81:	c9                   	leave  
  800d82:	c3                   	ret    

00800d83 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	8b 40 08             	mov    0x8(%eax),%eax
  800d8c:	8d 50 01             	lea    0x1(%eax),%edx
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8b 10                	mov    (%eax),%edx
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	8b 40 04             	mov    0x4(%eax),%eax
  800da0:	39 c2                	cmp    %eax,%edx
  800da2:	73 12                	jae    800db6 <sprintputch+0x33>
		*b->buf++ = ch;
  800da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da7:	8b 00                	mov    (%eax),%eax
  800da9:	8d 48 01             	lea    0x1(%eax),%ecx
  800dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daf:	89 0a                	mov    %ecx,(%edx)
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	88 10                	mov    %dl,(%eax)
}
  800db6:	90                   	nop
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	01 d0                	add    %edx,%eax
  800dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dde:	74 06                	je     800de6 <vsnprintf+0x2d>
  800de0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de4:	7f 07                	jg     800ded <vsnprintf+0x34>
		return -E_INVAL;
  800de6:	b8 03 00 00 00       	mov    $0x3,%eax
  800deb:	eb 20                	jmp    800e0d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ded:	ff 75 14             	pushl  0x14(%ebp)
  800df0:	ff 75 10             	pushl  0x10(%ebp)
  800df3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df6:	50                   	push   %eax
  800df7:	68 83 0d 80 00       	push   $0x800d83
  800dfc:	e8 92 fb ff ff       	call   800993 <vprintfmt>
  800e01:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e07:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e15:	8d 45 10             	lea    0x10(%ebp),%eax
  800e18:	83 c0 04             	add    $0x4,%eax
  800e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	ff 75 f4             	pushl  -0xc(%ebp)
  800e24:	50                   	push   %eax
  800e25:	ff 75 0c             	pushl  0xc(%ebp)
  800e28:	ff 75 08             	pushl  0x8(%ebp)
  800e2b:	e8 89 ff ff ff       	call   800db9 <vsnprintf>
  800e30:	83 c4 10             	add    $0x10,%esp
  800e33:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e48:	eb 06                	jmp    800e50 <strlen+0x15>
		n++;
  800e4a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4d:	ff 45 08             	incl   0x8(%ebp)
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	84 c0                	test   %al,%al
  800e57:	75 f1                	jne    800e4a <strlen+0xf>
		n++;
	return n;
  800e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6b:	eb 09                	jmp    800e76 <strnlen+0x18>
		n++;
  800e6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	ff 4d 0c             	decl   0xc(%ebp)
  800e76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7a:	74 09                	je     800e85 <strnlen+0x27>
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	84 c0                	test   %al,%al
  800e83:	75 e8                	jne    800e6d <strnlen+0xf>
		n++;
	return n;
  800e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e96:	90                   	nop
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8d 50 01             	lea    0x1(%eax),%edx
  800e9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea9:	8a 12                	mov    (%edx),%dl
  800eab:	88 10                	mov    %dl,(%eax)
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	84 c0                	test   %al,%al
  800eb1:	75 e4                	jne    800e97 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ecb:	eb 1f                	jmp    800eec <strncpy+0x34>
		*dst++ = *src;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed9:	8a 12                	mov    (%edx),%dl
  800edb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	84 c0                	test   %al,%al
  800ee4:	74 03                	je     800ee9 <strncpy+0x31>
			src++;
  800ee6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee9:	ff 45 fc             	incl   -0x4(%ebp)
  800eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eef:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef2:	72 d9                	jb     800ecd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef7:	c9                   	leave  
  800ef8:	c3                   	ret    

00800ef9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f09:	74 30                	je     800f3b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f0b:	eb 16                	jmp    800f23 <strlcpy+0x2a>
			*dst++ = *src++;
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8d 50 01             	lea    0x1(%eax),%edx
  800f13:	89 55 08             	mov    %edx,0x8(%ebp)
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f1f:	8a 12                	mov    (%edx),%dl
  800f21:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f23:	ff 4d 10             	decl   0x10(%ebp)
  800f26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2a:	74 09                	je     800f35 <strlcpy+0x3c>
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	84 c0                	test   %al,%al
  800f33:	75 d8                	jne    800f0d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f41:	29 c2                	sub    %eax,%edx
  800f43:	89 d0                	mov    %edx,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f4a:	eb 06                	jmp    800f52 <strcmp+0xb>
		p++, q++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	84 c0                	test   %al,%al
  800f59:	74 0e                	je     800f69 <strcmp+0x22>
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	38 c2                	cmp    %al,%dl
  800f67:	74 e3                	je     800f4c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	0f b6 d0             	movzbl %al,%edx
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	0f b6 c0             	movzbl %al,%eax
  800f79:	29 c2                	sub    %eax,%edx
  800f7b:	89 d0                	mov    %edx,%eax
}
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f82:	eb 09                	jmp    800f8d <strncmp+0xe>
		n--, p++, q++;
  800f84:	ff 4d 10             	decl   0x10(%ebp)
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	74 17                	je     800faa <strncmp+0x2b>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	84 c0                	test   %al,%al
  800f9a:	74 0e                	je     800faa <strncmp+0x2b>
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 10                	mov    (%eax),%dl
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	38 c2                	cmp    %al,%dl
  800fa8:	74 da                	je     800f84 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800faa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fae:	75 07                	jne    800fb7 <strncmp+0x38>
		return 0;
  800fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb5:	eb 14                	jmp    800fcb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	0f b6 d0             	movzbl %al,%edx
  800fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f b6 c0             	movzbl %al,%eax
  800fc7:	29 c2                	sub    %eax,%edx
  800fc9:	89 d0                	mov    %edx,%eax
}
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 04             	sub    $0x4,%esp
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd9:	eb 12                	jmp    800fed <strchr+0x20>
		if (*s == c)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe3:	75 05                	jne    800fea <strchr+0x1d>
			return (char *) s;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	eb 11                	jmp    800ffb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fea:	ff 45 08             	incl   0x8(%ebp)
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	84 c0                	test   %al,%al
  800ff4:	75 e5                	jne    800fdb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ff6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    

00800ffd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 04             	sub    $0x4,%esp
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801009:	eb 0d                	jmp    801018 <strfind+0x1b>
		if (*s == c)
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801013:	74 0e                	je     801023 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801015:	ff 45 08             	incl   0x8(%ebp)
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	84 c0                	test   %al,%al
  80101f:	75 ea                	jne    80100b <strfind+0xe>
  801021:	eb 01                	jmp    801024 <strfind+0x27>
		if (*s == c)
			break;
  801023:	90                   	nop
	return (char *) s;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801035:	8b 45 10             	mov    0x10(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80103b:	eb 0e                	jmp    80104b <memset+0x22>
		*p++ = c;
  80103d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801040:	8d 50 01             	lea    0x1(%eax),%edx
  801043:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801046:	8b 55 0c             	mov    0xc(%ebp),%edx
  801049:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80104b:	ff 4d f8             	decl   -0x8(%ebp)
  80104e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801052:	79 e9                	jns    80103d <memset+0x14>
		*p++ = c;

	return v;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80106b:	eb 16                	jmp    801083 <memcpy+0x2a>
		*d++ = *s++;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	89 55 10             	mov    %edx,0x10(%ebp)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 dd                	jne    80106d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ad:	73 50                	jae    8010ff <memmove+0x6a>
  8010af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ba:	76 43                	jbe    8010ff <memmove+0x6a>
		s += n;
  8010bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010c8:	eb 10                	jmp    8010da <memmove+0x45>
			*--d = *--s;
  8010ca:	ff 4d f8             	decl   -0x8(%ebp)
  8010cd:	ff 4d fc             	decl   -0x4(%ebp)
  8010d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d3:	8a 10                	mov    (%eax),%dl
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010da:	8b 45 10             	mov    0x10(%ebp),%eax
  8010dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	75 e3                	jne    8010ca <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010e7:	eb 23                	jmp    80110c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	8d 50 ff             	lea    -0x1(%eax),%edx
  801105:	89 55 10             	mov    %edx,0x10(%ebp)
  801108:	85 c0                	test   %eax,%eax
  80110a:	75 dd                	jne    8010e9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801123:	eb 2a                	jmp    80114f <memcmp+0x3e>
		if (*s1 != *s2)
  801125:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 16                	je     801149 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d0             	movzbl %al,%edx
  80113b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	eb 18                	jmp    801161 <memcmp+0x50>
		s1++, s2++;
  801149:	ff 45 fc             	incl   -0x4(%ebp)
  80114c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	8d 50 ff             	lea    -0x1(%eax),%edx
  801155:	89 55 10             	mov    %edx,0x10(%ebp)
  801158:	85 c0                	test   %eax,%eax
  80115a:	75 c9                	jne    801125 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80115c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801169:	8b 55 08             	mov    0x8(%ebp),%edx
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 d0                	add    %edx,%eax
  801171:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801174:	eb 15                	jmp    80118b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f b6 d0             	movzbl %al,%edx
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	0f b6 c0             	movzbl %al,%eax
  801184:	39 c2                	cmp    %eax,%edx
  801186:	74 0d                	je     801195 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801188:	ff 45 08             	incl   0x8(%ebp)
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801191:	72 e3                	jb     801176 <memfind+0x13>
  801193:	eb 01                	jmp    801196 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801195:	90                   	nop
	return (void *) s;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011af:	eb 03                	jmp    8011b4 <strtol+0x19>
		s++;
  8011b1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	3c 20                	cmp    $0x20,%al
  8011bb:	74 f4                	je     8011b1 <strtol+0x16>
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	3c 09                	cmp    $0x9,%al
  8011c4:	74 eb                	je     8011b1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 2b                	cmp    $0x2b,%al
  8011cd:	75 05                	jne    8011d4 <strtol+0x39>
		s++;
  8011cf:	ff 45 08             	incl   0x8(%ebp)
  8011d2:	eb 13                	jmp    8011e7 <strtol+0x4c>
	else if (*s == '-')
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	3c 2d                	cmp    $0x2d,%al
  8011db:	75 0a                	jne    8011e7 <strtol+0x4c>
		s++, neg = 1;
  8011dd:	ff 45 08             	incl   0x8(%ebp)
  8011e0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011eb:	74 06                	je     8011f3 <strtol+0x58>
  8011ed:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011f1:	75 20                	jne    801213 <strtol+0x78>
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	3c 30                	cmp    $0x30,%al
  8011fa:	75 17                	jne    801213 <strtol+0x78>
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	40                   	inc    %eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 78                	cmp    $0x78,%al
  801204:	75 0d                	jne    801213 <strtol+0x78>
		s += 2, base = 16;
  801206:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80120a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801211:	eb 28                	jmp    80123b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801213:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801217:	75 15                	jne    80122e <strtol+0x93>
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 30                	cmp    $0x30,%al
  801220:	75 0c                	jne    80122e <strtol+0x93>
		s++, base = 8;
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80122c:	eb 0d                	jmp    80123b <strtol+0xa0>
	else if (base == 0)
  80122e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801232:	75 07                	jne    80123b <strtol+0xa0>
		base = 10;
  801234:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	3c 2f                	cmp    $0x2f,%al
  801242:	7e 19                	jle    80125d <strtol+0xc2>
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	3c 39                	cmp    $0x39,%al
  80124b:	7f 10                	jg     80125d <strtol+0xc2>
			dig = *s - '0';
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f be c0             	movsbl %al,%eax
  801255:	83 e8 30             	sub    $0x30,%eax
  801258:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80125b:	eb 42                	jmp    80129f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	3c 60                	cmp    $0x60,%al
  801264:	7e 19                	jle    80127f <strtol+0xe4>
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	3c 7a                	cmp    $0x7a,%al
  80126d:	7f 10                	jg     80127f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	0f be c0             	movsbl %al,%eax
  801277:	83 e8 57             	sub    $0x57,%eax
  80127a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80127d:	eb 20                	jmp    80129f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 40                	cmp    $0x40,%al
  801286:	7e 39                	jle    8012c1 <strtol+0x126>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	3c 5a                	cmp    $0x5a,%al
  80128f:	7f 30                	jg     8012c1 <strtol+0x126>
			dig = *s - 'A' + 10;
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	0f be c0             	movsbl %al,%eax
  801299:	83 e8 37             	sub    $0x37,%eax
  80129c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80129f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012a5:	7d 19                	jge    8012c0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012a7:	ff 45 08             	incl   0x8(%ebp)
  8012aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ad:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012b1:	89 c2                	mov    %eax,%edx
  8012b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b6:	01 d0                	add    %edx,%eax
  8012b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012bb:	e9 7b ff ff ff       	jmp    80123b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012c0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012c5:	74 08                	je     8012cf <strtol+0x134>
		*endptr = (char *) s;
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012d3:	74 07                	je     8012dc <strtol+0x141>
  8012d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d8:	f7 d8                	neg    %eax
  8012da:	eb 03                	jmp    8012df <strtol+0x144>
  8012dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <ltostr>:

void
ltostr(long value, char *str)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f9:	79 13                	jns    80130e <ltostr+0x2d>
	{
		neg = 1;
  8012fb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801302:	8b 45 0c             	mov    0xc(%ebp),%eax
  801305:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801308:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80130b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801316:	99                   	cltd   
  801317:	f7 f9                	idiv   %ecx
  801319:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80131c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131f:	8d 50 01             	lea    0x1(%eax),%edx
  801322:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801325:	89 c2                	mov    %eax,%edx
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	01 d0                	add    %edx,%eax
  80132c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80132f:	83 c2 30             	add    $0x30,%edx
  801332:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801334:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801337:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80133c:	f7 e9                	imul   %ecx
  80133e:	c1 fa 02             	sar    $0x2,%edx
  801341:	89 c8                	mov    %ecx,%eax
  801343:	c1 f8 1f             	sar    $0x1f,%eax
  801346:	29 c2                	sub    %eax,%edx
  801348:	89 d0                	mov    %edx,%eax
  80134a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80134d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801350:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801355:	f7 e9                	imul   %ecx
  801357:	c1 fa 02             	sar    $0x2,%edx
  80135a:	89 c8                	mov    %ecx,%eax
  80135c:	c1 f8 1f             	sar    $0x1f,%eax
  80135f:	29 c2                	sub    %eax,%edx
  801361:	89 d0                	mov    %edx,%eax
  801363:	c1 e0 02             	shl    $0x2,%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	01 c0                	add    %eax,%eax
  80136a:	29 c1                	sub    %eax,%ecx
  80136c:	89 ca                	mov    %ecx,%edx
  80136e:	85 d2                	test   %edx,%edx
  801370:	75 9c                	jne    80130e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801372:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801379:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137c:	48                   	dec    %eax
  80137d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801380:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801384:	74 3d                	je     8013c3 <ltostr+0xe2>
		start = 1 ;
  801386:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80138d:	eb 34                	jmp    8013c3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80138f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801392:	8b 45 0c             	mov    0xc(%ebp),%eax
  801395:	01 d0                	add    %edx,%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80139c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 c2                	add    %eax,%edx
  8013a4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	01 c8                	add    %ecx,%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	01 c2                	add    %eax,%edx
  8013b8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013bb:	88 02                	mov    %al,(%edx)
		start++ ;
  8013bd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013c0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013c9:	7c c4                	jl     80138f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013cb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013d6:	90                   	nop
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013df:	ff 75 08             	pushl  0x8(%ebp)
  8013e2:	e8 54 fa ff ff       	call   800e3b <strlen>
  8013e7:	83 c4 04             	add    $0x4,%esp
  8013ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013ed:	ff 75 0c             	pushl  0xc(%ebp)
  8013f0:	e8 46 fa ff ff       	call   800e3b <strlen>
  8013f5:	83 c4 04             	add    $0x4,%esp
  8013f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 17                	jmp    801422 <strcconcat+0x49>
		final[s] = str1[s] ;
  80140b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140e:	8b 45 10             	mov    0x10(%ebp),%eax
  801411:	01 c2                	add    %eax,%edx
  801413:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	01 c8                	add    %ecx,%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80141f:	ff 45 fc             	incl   -0x4(%ebp)
  801422:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801425:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801428:	7c e1                	jl     80140b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80142a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801431:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801438:	eb 1f                	jmp    801459 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80143a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143d:	8d 50 01             	lea    0x1(%eax),%edx
  801440:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801443:	89 c2                	mov    %eax,%edx
  801445:	8b 45 10             	mov    0x10(%ebp),%eax
  801448:	01 c2                	add    %eax,%edx
  80144a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 c8                	add    %ecx,%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801456:	ff 45 f8             	incl   -0x8(%ebp)
  801459:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80145f:	7c d9                	jl     80143a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801461:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801464:	8b 45 10             	mov    0x10(%ebp),%eax
  801467:	01 d0                	add    %edx,%eax
  801469:	c6 00 00             	movb   $0x0,(%eax)
}
  80146c:	90                   	nop
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801472:	8b 45 14             	mov    0x14(%ebp),%eax
  801475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80147b:	8b 45 14             	mov    0x14(%ebp),%eax
  80147e:	8b 00                	mov    (%eax),%eax
  801480:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801487:	8b 45 10             	mov    0x10(%ebp),%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801492:	eb 0c                	jmp    8014a0 <strsplit+0x31>
			*string++ = 0;
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 08             	mov    %edx,0x8(%ebp)
  80149d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 18                	je     8014c1 <strsplit+0x52>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	e8 13 fb ff ff       	call   800fcd <strchr>
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	75 d3                	jne    801494 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	84 c0                	test   %al,%al
  8014c8:	74 5a                	je     801524 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cd:	8b 00                	mov    (%eax),%eax
  8014cf:	83 f8 0f             	cmp    $0xf,%eax
  8014d2:	75 07                	jne    8014db <strsplit+0x6c>
		{
			return 0;
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	eb 66                	jmp    801541 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	8d 48 01             	lea    0x1(%eax),%ecx
  8014e3:	8b 55 14             	mov    0x14(%ebp),%edx
  8014e6:	89 0a                	mov    %ecx,(%edx)
  8014e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 c2                	add    %eax,%edx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f9:	eb 03                	jmp    8014fe <strsplit+0x8f>
			string++;
  8014fb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	84 c0                	test   %al,%al
  801505:	74 8b                	je     801492 <strsplit+0x23>
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f be c0             	movsbl %al,%eax
  80150f:	50                   	push   %eax
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	e8 b5 fa ff ff       	call   800fcd <strchr>
  801518:	83 c4 08             	add    $0x8,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	74 dc                	je     8014fb <strsplit+0x8c>
			string++;
	}
  80151f:	e9 6e ff ff ff       	jmp    801492 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801524:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80153c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 90 25 80 00       	push   $0x802590
  801551:	6a 0e                	push   $0xe
  801553:	68 ca 25 80 00       	push   $0x8025ca
  801558:	e8 a8 ef ff ff       	call   800505 <_panic>

0080155d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801563:	a1 04 30 80 00       	mov    0x803004,%eax
  801568:	85 c0                	test   %eax,%eax
  80156a:	74 0f                	je     80157b <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80156c:	e8 d2 ff ff ff       	call   801543 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801571:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801578:	00 00 00 
	}
	if (size == 0) return NULL ;
  80157b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80157f:	75 07                	jne    801588 <malloc+0x2b>
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
  801586:	eb 14                	jmp    80159c <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	68 d8 25 80 00       	push   $0x8025d8
  801590:	6a 2e                	push   $0x2e
  801592:	68 ca 25 80 00       	push   $0x8025ca
  801597:	e8 69 ef ff ff       	call   800505 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015a4:	83 ec 04             	sub    $0x4,%esp
  8015a7:	68 00 26 80 00       	push   $0x802600
  8015ac:	6a 49                	push   $0x49
  8015ae:	68 ca 25 80 00       	push   $0x8025ca
  8015b3:	e8 4d ef ff ff       	call   800505 <_panic>

008015b8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 18             	sub    $0x18,%esp
  8015be:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c1:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	68 24 26 80 00       	push   $0x802624
  8015cc:	6a 57                	push   $0x57
  8015ce:	68 ca 25 80 00       	push   $0x8025ca
  8015d3:	e8 2d ef ff ff       	call   800505 <_panic>

008015d8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 4c 26 80 00       	push   $0x80264c
  8015e6:	6a 60                	push   $0x60
  8015e8:	68 ca 25 80 00       	push   $0x8025ca
  8015ed:	e8 13 ef ff ff       	call   800505 <_panic>

008015f2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 70 26 80 00       	push   $0x802670
  801600:	6a 7c                	push   $0x7c
  801602:	68 ca 25 80 00       	push   $0x8025ca
  801607:	e8 f9 ee ff ff       	call   800505 <_panic>

0080160c <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	68 98 26 80 00       	push   $0x802698
  80161a:	68 86 00 00 00       	push   $0x86
  80161f:	68 ca 25 80 00       	push   $0x8025ca
  801624:	e8 dc ee ff ff       	call   800505 <_panic>

00801629 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	68 bc 26 80 00       	push   $0x8026bc
  801637:	68 91 00 00 00       	push   $0x91
  80163c:	68 ca 25 80 00       	push   $0x8025ca
  801641:	e8 bf ee ff ff       	call   800505 <_panic>

00801646 <shrink>:

}
void shrink(uint32 newSize)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	68 bc 26 80 00       	push   $0x8026bc
  801654:	68 96 00 00 00       	push   $0x96
  801659:	68 ca 25 80 00       	push   $0x8025ca
  80165e:	e8 a2 ee ff ff       	call   800505 <_panic>

00801663 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	68 bc 26 80 00       	push   $0x8026bc
  801671:	68 9b 00 00 00       	push   $0x9b
  801676:	68 ca 25 80 00       	push   $0x8025ca
  80167b:	e8 85 ee ff ff       	call   800505 <_panic>

00801680 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	57                   	push   %edi
  801684:	56                   	push   %esi
  801685:	53                   	push   %ebx
  801686:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801692:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801695:	8b 7d 18             	mov    0x18(%ebp),%edi
  801698:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80169b:	cd 30                	int    $0x30
  80169d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5f                   	pop    %edi
  8016a9:	5d                   	pop    %ebp
  8016aa:	c3                   	ret    

008016ab <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	52                   	push   %edx
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	50                   	push   %eax
  8016c7:	6a 00                	push   $0x0
  8016c9:	e8 b2 ff ff ff       	call   801680 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	90                   	nop
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 01                	push   $0x1
  8016e3:	e8 98 ff ff ff       	call   801680 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	52                   	push   %edx
  8016fd:	50                   	push   %eax
  8016fe:	6a 05                	push   $0x5
  801700:	e8 7b ff ff ff       	call   801680 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	56                   	push   %esi
  80170e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80170f:	8b 75 18             	mov    0x18(%ebp),%esi
  801712:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801715:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	56                   	push   %esi
  80171f:	53                   	push   %ebx
  801720:	51                   	push   %ecx
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 06                	push   $0x6
  801725:	e8 56 ff ff ff       	call   801680 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5d                   	pop    %ebp
  801733:	c3                   	ret    

00801734 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	52                   	push   %edx
  801744:	50                   	push   %eax
  801745:	6a 07                	push   $0x7
  801747:	e8 34 ff ff ff       	call   801680 <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	ff 75 08             	pushl  0x8(%ebp)
  801760:	6a 08                	push   $0x8
  801762:	e8 19 ff ff ff       	call   801680 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 09                	push   $0x9
  80177b:	e8 00 ff ff ff       	call   801680 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 0a                	push   $0xa
  801794:	e8 e7 fe ff ff       	call   801680 <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 0b                	push   $0xb
  8017ad:	e8 ce fe ff ff       	call   801680 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	ff 75 08             	pushl  0x8(%ebp)
  8017c6:	6a 0f                	push   $0xf
  8017c8:	e8 b3 fe ff ff       	call   801680 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
	return;
  8017d0:	90                   	nop
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	ff 75 08             	pushl  0x8(%ebp)
  8017e2:	6a 10                	push   $0x10
  8017e4:	e8 97 fe ff ff       	call   801680 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ec:	90                   	nop
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 10             	pushl  0x10(%ebp)
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	ff 75 08             	pushl  0x8(%ebp)
  8017ff:	6a 11                	push   $0x11
  801801:	e8 7a fe ff ff       	call   801680 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
	return ;
  801809:	90                   	nop
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 0c                	push   $0xc
  80181b:	e8 60 fe ff ff       	call   801680 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	6a 0d                	push   $0xd
  801835:	e8 46 fe ff ff       	call   801680 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 0e                	push   $0xe
  80184e:	e8 2d fe ff ff       	call   801680 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	90                   	nop
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 13                	push   $0x13
  801868:	e8 13 fe ff ff       	call   801680 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 14                	push   $0x14
  801882:	e8 f9 fd ff ff       	call   801680 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_cputc>:


void
sys_cputc(const char c)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801899:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	50                   	push   %eax
  8018a6:	6a 15                	push   $0x15
  8018a8:	e8 d3 fd ff ff       	call   801680 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	90                   	nop
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 16                	push   $0x16
  8018c2:	e8 b9 fd ff ff       	call   801680 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	90                   	nop
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	50                   	push   %eax
  8018dd:	6a 17                	push   $0x17
  8018df:	e8 9c fd ff ff       	call   801680 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 1a                	push   $0x1a
  8018fc:	e8 7f fd ff ff       	call   801680 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	50                   	push   %eax
  801917:	6a 18                	push   $0x18
  801919:	e8 62 fd ff ff       	call   801680 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	52                   	push   %edx
  801934:	50                   	push   %eax
  801935:	6a 19                	push   $0x19
  801937:	e8 44 fd ff ff       	call   801680 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80194e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801951:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	51                   	push   %ecx
  80195b:	52                   	push   %edx
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	50                   	push   %eax
  801960:	6a 1b                	push   $0x1b
  801962:	e8 19 fd ff ff       	call   801680 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 1c                	push   $0x1c
  80197f:	e8 fc fc ff ff       	call   801680 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80198c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	51                   	push   %ecx
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 1d                	push   $0x1d
  80199e:	e8 dd fc ff ff       	call   801680 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	6a 1e                	push   $0x1e
  8019bb:	e8 c0 fc ff ff       	call   801680 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 1f                	push   $0x1f
  8019d4:	e8 a7 fc ff ff       	call   801680 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 14             	pushl  0x14(%ebp)
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 20                	push   $0x20
  8019f2:	e8 89 fc ff ff       	call   801680 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	50                   	push   %eax
  801a0b:	6a 21                	push   $0x21
  801a0d:	e8 6e fc ff ff       	call   801680 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	50                   	push   %eax
  801a27:	6a 22                	push   $0x22
  801a29:	e8 52 fc ff ff       	call   801680 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 02                	push   $0x2
  801a42:	e8 39 fc ff ff       	call   801680 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 03                	push   $0x3
  801a5b:	e8 20 fc ff ff       	call   801680 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 04                	push   $0x4
  801a74:	e8 07 fc ff ff       	call   801680 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_exit_env>:


void sys_exit_env(void)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 23                	push   $0x23
  801a8d:	e8 ee fb ff ff       	call   801680 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a9e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa1:	8d 50 04             	lea    0x4(%eax),%edx
  801aa4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 24                	push   $0x24
  801ab1:	e8 ca fb ff ff       	call   801680 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
	return result;
  801ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac2:	89 01                	mov    %eax,(%ecx)
  801ac4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	c9                   	leave  
  801acb:	c2 04 00             	ret    $0x4

00801ace <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	ff 75 10             	pushl  0x10(%ebp)
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	ff 75 08             	pushl  0x8(%ebp)
  801ade:	6a 12                	push   $0x12
  801ae0:	e8 9b fb ff ff       	call   801680 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae8:	90                   	nop
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_rcr2>:
uint32 sys_rcr2()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 25                	push   $0x25
  801afa:	e8 81 fb ff ff       	call   801680 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b10:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	50                   	push   %eax
  801b1d:	6a 26                	push   $0x26
  801b1f:	e8 5c fb ff ff       	call   801680 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
	return ;
  801b27:	90                   	nop
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <rsttst>:
void rsttst()
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 28                	push   $0x28
  801b39:	e8 42 fb ff ff       	call   801680 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b41:	90                   	nop
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b50:	8b 55 18             	mov    0x18(%ebp),%edx
  801b53:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	ff 75 10             	pushl  0x10(%ebp)
  801b5c:	ff 75 0c             	pushl  0xc(%ebp)
  801b5f:	ff 75 08             	pushl  0x8(%ebp)
  801b62:	6a 27                	push   $0x27
  801b64:	e8 17 fb ff ff       	call   801680 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6c:	90                   	nop
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <chktst>:
void chktst(uint32 n)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	ff 75 08             	pushl  0x8(%ebp)
  801b7d:	6a 29                	push   $0x29
  801b7f:	e8 fc fa ff ff       	call   801680 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
	return ;
  801b87:	90                   	nop
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <inctst>:

void inctst()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 2a                	push   $0x2a
  801b99:	e8 e2 fa ff ff       	call   801680 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba1:	90                   	nop
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <gettst>:
uint32 gettst()
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 2b                	push   $0x2b
  801bb3:	e8 c8 fa ff ff       	call   801680 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 2c                	push   $0x2c
  801bcf:	e8 ac fa ff ff       	call   801680 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
  801bd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bda:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bde:	75 07                	jne    801be7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801be0:	b8 01 00 00 00       	mov    $0x1,%eax
  801be5:	eb 05                	jmp    801bec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 2c                	push   $0x2c
  801c00:	e8 7b fa ff ff       	call   801680 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
  801c08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c0b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c0f:	75 07                	jne    801c18 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c11:	b8 01 00 00 00       	mov    $0x1,%eax
  801c16:	eb 05                	jmp    801c1d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 2c                	push   $0x2c
  801c31:	e8 4a fa ff ff       	call   801680 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
  801c39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c3c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c40:	75 07                	jne    801c49 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c42:	b8 01 00 00 00       	mov    $0x1,%eax
  801c47:	eb 05                	jmp    801c4e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 2c                	push   $0x2c
  801c62:	e8 19 fa ff ff       	call   801680 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
  801c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c6d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c71:	75 07                	jne    801c7a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c73:	b8 01 00 00 00       	mov    $0x1,%eax
  801c78:	eb 05                	jmp    801c7f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	ff 75 08             	pushl  0x8(%ebp)
  801c8f:	6a 2d                	push   $0x2d
  801c91:	e8 ea f9 ff ff       	call   801680 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
	return ;
  801c99:	90                   	nop
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ca0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	53                   	push   %ebx
  801caf:	51                   	push   %ecx
  801cb0:	52                   	push   %edx
  801cb1:	50                   	push   %eax
  801cb2:	6a 2e                	push   $0x2e
  801cb4:	e8 c7 f9 ff ff       	call   801680 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 2f                	push   $0x2f
  801cd4:	e8 a7 f9 ff ff       	call   801680 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    
  801cde:	66 90                	xchg   %ax,%ax

00801ce0 <__udivdi3>:
  801ce0:	55                   	push   %ebp
  801ce1:	57                   	push   %edi
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 1c             	sub    $0x1c,%esp
  801ce7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ceb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cf3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cf7:	89 ca                	mov    %ecx,%edx
  801cf9:	89 f8                	mov    %edi,%eax
  801cfb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cff:	85 f6                	test   %esi,%esi
  801d01:	75 2d                	jne    801d30 <__udivdi3+0x50>
  801d03:	39 cf                	cmp    %ecx,%edi
  801d05:	77 65                	ja     801d6c <__udivdi3+0x8c>
  801d07:	89 fd                	mov    %edi,%ebp
  801d09:	85 ff                	test   %edi,%edi
  801d0b:	75 0b                	jne    801d18 <__udivdi3+0x38>
  801d0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d12:	31 d2                	xor    %edx,%edx
  801d14:	f7 f7                	div    %edi
  801d16:	89 c5                	mov    %eax,%ebp
  801d18:	31 d2                	xor    %edx,%edx
  801d1a:	89 c8                	mov    %ecx,%eax
  801d1c:	f7 f5                	div    %ebp
  801d1e:	89 c1                	mov    %eax,%ecx
  801d20:	89 d8                	mov    %ebx,%eax
  801d22:	f7 f5                	div    %ebp
  801d24:	89 cf                	mov    %ecx,%edi
  801d26:	89 fa                	mov    %edi,%edx
  801d28:	83 c4 1c             	add    $0x1c,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5e                   	pop    %esi
  801d2d:	5f                   	pop    %edi
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    
  801d30:	39 ce                	cmp    %ecx,%esi
  801d32:	77 28                	ja     801d5c <__udivdi3+0x7c>
  801d34:	0f bd fe             	bsr    %esi,%edi
  801d37:	83 f7 1f             	xor    $0x1f,%edi
  801d3a:	75 40                	jne    801d7c <__udivdi3+0x9c>
  801d3c:	39 ce                	cmp    %ecx,%esi
  801d3e:	72 0a                	jb     801d4a <__udivdi3+0x6a>
  801d40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d44:	0f 87 9e 00 00 00    	ja     801de8 <__udivdi3+0x108>
  801d4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4f:	89 fa                	mov    %edi,%edx
  801d51:	83 c4 1c             	add    $0x1c,%esp
  801d54:	5b                   	pop    %ebx
  801d55:	5e                   	pop    %esi
  801d56:	5f                   	pop    %edi
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    
  801d59:	8d 76 00             	lea    0x0(%esi),%esi
  801d5c:	31 ff                	xor    %edi,%edi
  801d5e:	31 c0                	xor    %eax,%eax
  801d60:	89 fa                	mov    %edi,%edx
  801d62:	83 c4 1c             	add    $0x1c,%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5f                   	pop    %edi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    
  801d6a:	66 90                	xchg   %ax,%ax
  801d6c:	89 d8                	mov    %ebx,%eax
  801d6e:	f7 f7                	div    %edi
  801d70:	31 ff                	xor    %edi,%edi
  801d72:	89 fa                	mov    %edi,%edx
  801d74:	83 c4 1c             	add    $0x1c,%esp
  801d77:	5b                   	pop    %ebx
  801d78:	5e                   	pop    %esi
  801d79:	5f                   	pop    %edi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    
  801d7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d81:	89 eb                	mov    %ebp,%ebx
  801d83:	29 fb                	sub    %edi,%ebx
  801d85:	89 f9                	mov    %edi,%ecx
  801d87:	d3 e6                	shl    %cl,%esi
  801d89:	89 c5                	mov    %eax,%ebp
  801d8b:	88 d9                	mov    %bl,%cl
  801d8d:	d3 ed                	shr    %cl,%ebp
  801d8f:	89 e9                	mov    %ebp,%ecx
  801d91:	09 f1                	or     %esi,%ecx
  801d93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d97:	89 f9                	mov    %edi,%ecx
  801d99:	d3 e0                	shl    %cl,%eax
  801d9b:	89 c5                	mov    %eax,%ebp
  801d9d:	89 d6                	mov    %edx,%esi
  801d9f:	88 d9                	mov    %bl,%cl
  801da1:	d3 ee                	shr    %cl,%esi
  801da3:	89 f9                	mov    %edi,%ecx
  801da5:	d3 e2                	shl    %cl,%edx
  801da7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dab:	88 d9                	mov    %bl,%cl
  801dad:	d3 e8                	shr    %cl,%eax
  801daf:	09 c2                	or     %eax,%edx
  801db1:	89 d0                	mov    %edx,%eax
  801db3:	89 f2                	mov    %esi,%edx
  801db5:	f7 74 24 0c          	divl   0xc(%esp)
  801db9:	89 d6                	mov    %edx,%esi
  801dbb:	89 c3                	mov    %eax,%ebx
  801dbd:	f7 e5                	mul    %ebp
  801dbf:	39 d6                	cmp    %edx,%esi
  801dc1:	72 19                	jb     801ddc <__udivdi3+0xfc>
  801dc3:	74 0b                	je     801dd0 <__udivdi3+0xf0>
  801dc5:	89 d8                	mov    %ebx,%eax
  801dc7:	31 ff                	xor    %edi,%edi
  801dc9:	e9 58 ff ff ff       	jmp    801d26 <__udivdi3+0x46>
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801dd4:	89 f9                	mov    %edi,%ecx
  801dd6:	d3 e2                	shl    %cl,%edx
  801dd8:	39 c2                	cmp    %eax,%edx
  801dda:	73 e9                	jae    801dc5 <__udivdi3+0xe5>
  801ddc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ddf:	31 ff                	xor    %edi,%edi
  801de1:	e9 40 ff ff ff       	jmp    801d26 <__udivdi3+0x46>
  801de6:	66 90                	xchg   %ax,%ax
  801de8:	31 c0                	xor    %eax,%eax
  801dea:	e9 37 ff ff ff       	jmp    801d26 <__udivdi3+0x46>
  801def:	90                   	nop

00801df0 <__umoddi3>:
  801df0:	55                   	push   %ebp
  801df1:	57                   	push   %edi
  801df2:	56                   	push   %esi
  801df3:	53                   	push   %ebx
  801df4:	83 ec 1c             	sub    $0x1c,%esp
  801df7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dfb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e0f:	89 f3                	mov    %esi,%ebx
  801e11:	89 fa                	mov    %edi,%edx
  801e13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e17:	89 34 24             	mov    %esi,(%esp)
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	75 1a                	jne    801e38 <__umoddi3+0x48>
  801e1e:	39 f7                	cmp    %esi,%edi
  801e20:	0f 86 a2 00 00 00    	jbe    801ec8 <__umoddi3+0xd8>
  801e26:	89 c8                	mov    %ecx,%eax
  801e28:	89 f2                	mov    %esi,%edx
  801e2a:	f7 f7                	div    %edi
  801e2c:	89 d0                	mov    %edx,%eax
  801e2e:	31 d2                	xor    %edx,%edx
  801e30:	83 c4 1c             	add    $0x1c,%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5e                   	pop    %esi
  801e35:	5f                   	pop    %edi
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    
  801e38:	39 f0                	cmp    %esi,%eax
  801e3a:	0f 87 ac 00 00 00    	ja     801eec <__umoddi3+0xfc>
  801e40:	0f bd e8             	bsr    %eax,%ebp
  801e43:	83 f5 1f             	xor    $0x1f,%ebp
  801e46:	0f 84 ac 00 00 00    	je     801ef8 <__umoddi3+0x108>
  801e4c:	bf 20 00 00 00       	mov    $0x20,%edi
  801e51:	29 ef                	sub    %ebp,%edi
  801e53:	89 fe                	mov    %edi,%esi
  801e55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e59:	89 e9                	mov    %ebp,%ecx
  801e5b:	d3 e0                	shl    %cl,%eax
  801e5d:	89 d7                	mov    %edx,%edi
  801e5f:	89 f1                	mov    %esi,%ecx
  801e61:	d3 ef                	shr    %cl,%edi
  801e63:	09 c7                	or     %eax,%edi
  801e65:	89 e9                	mov    %ebp,%ecx
  801e67:	d3 e2                	shl    %cl,%edx
  801e69:	89 14 24             	mov    %edx,(%esp)
  801e6c:	89 d8                	mov    %ebx,%eax
  801e6e:	d3 e0                	shl    %cl,%eax
  801e70:	89 c2                	mov    %eax,%edx
  801e72:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e76:	d3 e0                	shl    %cl,%eax
  801e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e80:	89 f1                	mov    %esi,%ecx
  801e82:	d3 e8                	shr    %cl,%eax
  801e84:	09 d0                	or     %edx,%eax
  801e86:	d3 eb                	shr    %cl,%ebx
  801e88:	89 da                	mov    %ebx,%edx
  801e8a:	f7 f7                	div    %edi
  801e8c:	89 d3                	mov    %edx,%ebx
  801e8e:	f7 24 24             	mull   (%esp)
  801e91:	89 c6                	mov    %eax,%esi
  801e93:	89 d1                	mov    %edx,%ecx
  801e95:	39 d3                	cmp    %edx,%ebx
  801e97:	0f 82 87 00 00 00    	jb     801f24 <__umoddi3+0x134>
  801e9d:	0f 84 91 00 00 00    	je     801f34 <__umoddi3+0x144>
  801ea3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ea7:	29 f2                	sub    %esi,%edx
  801ea9:	19 cb                	sbb    %ecx,%ebx
  801eab:	89 d8                	mov    %ebx,%eax
  801ead:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801eb1:	d3 e0                	shl    %cl,%eax
  801eb3:	89 e9                	mov    %ebp,%ecx
  801eb5:	d3 ea                	shr    %cl,%edx
  801eb7:	09 d0                	or     %edx,%eax
  801eb9:	89 e9                	mov    %ebp,%ecx
  801ebb:	d3 eb                	shr    %cl,%ebx
  801ebd:	89 da                	mov    %ebx,%edx
  801ebf:	83 c4 1c             	add    $0x1c,%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5f                   	pop    %edi
  801ec5:	5d                   	pop    %ebp
  801ec6:	c3                   	ret    
  801ec7:	90                   	nop
  801ec8:	89 fd                	mov    %edi,%ebp
  801eca:	85 ff                	test   %edi,%edi
  801ecc:	75 0b                	jne    801ed9 <__umoddi3+0xe9>
  801ece:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed3:	31 d2                	xor    %edx,%edx
  801ed5:	f7 f7                	div    %edi
  801ed7:	89 c5                	mov    %eax,%ebp
  801ed9:	89 f0                	mov    %esi,%eax
  801edb:	31 d2                	xor    %edx,%edx
  801edd:	f7 f5                	div    %ebp
  801edf:	89 c8                	mov    %ecx,%eax
  801ee1:	f7 f5                	div    %ebp
  801ee3:	89 d0                	mov    %edx,%eax
  801ee5:	e9 44 ff ff ff       	jmp    801e2e <__umoddi3+0x3e>
  801eea:	66 90                	xchg   %ax,%ax
  801eec:	89 c8                	mov    %ecx,%eax
  801eee:	89 f2                	mov    %esi,%edx
  801ef0:	83 c4 1c             	add    $0x1c,%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5e                   	pop    %esi
  801ef5:	5f                   	pop    %edi
  801ef6:	5d                   	pop    %ebp
  801ef7:	c3                   	ret    
  801ef8:	3b 04 24             	cmp    (%esp),%eax
  801efb:	72 06                	jb     801f03 <__umoddi3+0x113>
  801efd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f01:	77 0f                	ja     801f12 <__umoddi3+0x122>
  801f03:	89 f2                	mov    %esi,%edx
  801f05:	29 f9                	sub    %edi,%ecx
  801f07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f0b:	89 14 24             	mov    %edx,(%esp)
  801f0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f12:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f16:	8b 14 24             	mov    (%esp),%edx
  801f19:	83 c4 1c             	add    $0x1c,%esp
  801f1c:	5b                   	pop    %ebx
  801f1d:	5e                   	pop    %esi
  801f1e:	5f                   	pop    %edi
  801f1f:	5d                   	pop    %ebp
  801f20:	c3                   	ret    
  801f21:	8d 76 00             	lea    0x0(%esi),%esi
  801f24:	2b 04 24             	sub    (%esp),%eax
  801f27:	19 fa                	sbb    %edi,%edx
  801f29:	89 d1                	mov    %edx,%ecx
  801f2b:	89 c6                	mov    %eax,%esi
  801f2d:	e9 71 ff ff ff       	jmp    801ea3 <__umoddi3+0xb3>
  801f32:	66 90                	xchg   %ax,%ax
  801f34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f38:	72 ea                	jb     801f24 <__umoddi3+0x134>
  801f3a:	89 d9                	mov    %ebx,%ecx
  801f3c:	e9 62 ff ff ff       	jmp    801ea3 <__umoddi3+0xb3>
