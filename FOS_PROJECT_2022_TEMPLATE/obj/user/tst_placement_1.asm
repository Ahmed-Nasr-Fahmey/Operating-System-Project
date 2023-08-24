
obj/user/tst_placement_1:     file format elf32-i386


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
  800031:	e8 41 03 00 00       	call   800377 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 70 00 00 01    	sub    $0x1000070,%esp

	//	cprintf("envID = %d\n",envID);
	char arr[PAGE_SIZE*1024*4];

	uint32 actual_active_list[17] = {0xedbfdb78,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  800043:	8d 95 9c ff ff fe    	lea    -0x1000064(%ebp),%edx
  800049:	b9 11 00 00 00       	mov    $0x11,%ecx
  80004e:	b8 00 00 00 00       	mov    $0x0,%eax
  800053:	89 d7                	mov    %edx,%edi
  800055:	f3 ab                	rep stos %eax,%es:(%edi)
  800057:	c7 85 9c ff ff fe 78 	movl   $0xedbfdb78,-0x1000064(%ebp)
  80005e:	db bf ed 
  800061:	c7 85 a0 ff ff fe 00 	movl   $0xeebfd000,-0x1000060(%ebp)
  800068:	d0 bf ee 
  80006b:	c7 85 a4 ff ff fe 00 	movl   $0x803000,-0x100005c(%ebp)
  800072:	30 80 00 
  800075:	c7 85 a8 ff ff fe 00 	movl   $0x802000,-0x1000058(%ebp)
  80007c:	20 80 00 
  80007f:	c7 85 ac ff ff fe 00 	movl   $0x801000,-0x1000054(%ebp)
  800086:	10 80 00 
  800089:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  800090:	00 80 00 
  800093:	c7 85 b4 ff ff fe 00 	movl   $0x205000,-0x100004c(%ebp)
  80009a:	50 20 00 
  80009d:	c7 85 b8 ff ff fe 00 	movl   $0x204000,-0x1000048(%ebp)
  8000a4:	40 20 00 
  8000a7:	c7 85 bc ff ff fe 00 	movl   $0x203000,-0x1000044(%ebp)
  8000ae:	30 20 00 
  8000b1:	c7 85 c0 ff ff fe 00 	movl   $0x202000,-0x1000040(%ebp)
  8000b8:	20 20 00 
  8000bb:	c7 85 c4 ff ff fe 00 	movl   $0x201000,-0x100003c(%ebp)
  8000c2:	10 20 00 
  8000c5:	c7 85 c8 ff ff fe 00 	movl   $0x200000,-0x1000038(%ebp)
  8000cc:	00 20 00 
	uint32 actual_second_list[2] = {};
  8000cf:	c7 85 94 ff ff fe 00 	movl   $0x0,-0x100006c(%ebp)
  8000d6:	00 00 00 
  8000d9:	c7 85 98 ff ff fe 00 	movl   $0x0,-0x1000068(%ebp)
  8000e0:	00 00 00 
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000e3:	6a 00                	push   $0x0
  8000e5:	6a 0c                	push   $0xc
  8000e7:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8000ed:	50                   	push   %eax
  8000ee:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	e8 26 1a 00 00       	call   801b20 <sys_check_LRU_lists>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(check == 0)
  800100:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800104:	75 14                	jne    80011a <_main+0xe2>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 e0 1d 80 00       	push   $0x801de0
  80010e:	6a 15                	push   $0x15
  800110:	68 2f 1e 80 00       	push   $0x801e2f
  800115:	e8 ac 03 00 00       	call   8004c6 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80011a:	e8 71 15 00 00       	call   801690 <sys_pf_calculate_allocated_pages>
  80011f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int freePages = sys_calculate_free_frames();
  800122:	e8 c9 14 00 00       	call   8015f0 <sys_calculate_free_frames>
  800127:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int i=0;
  80012a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800131:	eb 11                	jmp    800144 <_main+0x10c>
	{
		arr[i] = -1;
  800133:	8d 95 e0 ff ff fe    	lea    -0x1000020(%ebp),%edx
  800139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800141:	ff 45 f4             	incl   -0xc(%ebp)
  800144:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  80014b:	7e e6                	jle    800133 <_main+0xfb>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  80014d:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800154:	eb 11                	jmp    800167 <_main+0x12f>
	{
		arr[i] = -1;
  800156:	8d 95 e0 ff ff fe    	lea    -0x1000020(%ebp),%edx
  80015c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800164:	ff 45 f4             	incl   -0xc(%ebp)
  800167:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  80016e:	7e e6                	jle    800156 <_main+0x11e>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800170:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800177:	eb 11                	jmp    80018a <_main+0x152>
	{
		arr[i] = -1;
  800179:	8d 95 e0 ff ff fe    	lea    -0x1000020(%ebp),%edx
  80017f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800187:	ff 45 f4             	incl   -0xc(%ebp)
  80018a:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  800191:	7e e6                	jle    800179 <_main+0x141>
		arr[i] = -1;
	}



	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 48 1e 80 00       	push   $0x801e48
  80019b:	e8 da 05 00 00       	call   80077a <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  8001a3:	8a 85 e0 ff ff fe    	mov    -0x1000020(%ebp),%al
  8001a9:	3c ff                	cmp    $0xff,%al
  8001ab:	74 14                	je     8001c1 <_main+0x189>
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 78 1e 80 00       	push   $0x801e78
  8001b5:	6a 31                	push   $0x31
  8001b7:	68 2f 1e 80 00       	push   $0x801e2f
  8001bc:	e8 05 03 00 00       	call   8004c6 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8001c1:	8a 85 e0 0f 00 ff    	mov    -0xfff020(%ebp),%al
  8001c7:	3c ff                	cmp    $0xff,%al
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 78 1e 80 00       	push   $0x801e78
  8001d3:	6a 32                	push   $0x32
  8001d5:	68 2f 1e 80 00       	push   $0x801e2f
  8001da:	e8 e7 02 00 00       	call   8004c6 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8001df:	8a 85 e0 ff 3f ff    	mov    -0xc00020(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 14                	je     8001fd <_main+0x1c5>
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	68 78 1e 80 00       	push   $0x801e78
  8001f1:	6a 34                	push   $0x34
  8001f3:	68 2f 1e 80 00       	push   $0x801e2f
  8001f8:	e8 c9 02 00 00       	call   8004c6 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8001fd:	8a 85 e0 0f 40 ff    	mov    -0xbff020(%ebp),%al
  800203:	3c ff                	cmp    $0xff,%al
  800205:	74 14                	je     80021b <_main+0x1e3>
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 78 1e 80 00       	push   $0x801e78
  80020f:	6a 35                	push   $0x35
  800211:	68 2f 1e 80 00       	push   $0x801e2f
  800216:	e8 ab 02 00 00       	call   8004c6 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  80021b:	8a 85 e0 ff 7f ff    	mov    -0x800020(%ebp),%al
  800221:	3c ff                	cmp    $0xff,%al
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 78 1e 80 00       	push   $0x801e78
  80022d:	6a 37                	push   $0x37
  80022f:	68 2f 1e 80 00       	push   $0x801e2f
  800234:	e8 8d 02 00 00       	call   8004c6 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800239:	8a 85 e0 0f 80 ff    	mov    -0x7ff020(%ebp),%al
  80023f:	3c ff                	cmp    $0xff,%al
  800241:	74 14                	je     800257 <_main+0x21f>
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 78 1e 80 00       	push   $0x801e78
  80024b:	6a 38                	push   $0x38
  80024d:	68 2f 1e 80 00       	push   $0x801e2f
  800252:	e8 6f 02 00 00       	call   8004c6 <_panic>

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  800257:	e8 34 14 00 00       	call   801690 <sys_pf_calculate_allocated_pages>
  80025c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80025f:	83 f8 05             	cmp    $0x5,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 98 1e 80 00       	push   $0x801e98
  80026c:	6a 3a                	push   $0x3a
  80026e:	68 2f 1e 80 00       	push   $0x801e2f
  800273:	e8 4e 02 00 00       	call   8004c6 <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  800278:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80027b:	e8 70 13 00 00       	call   8015f0 <sys_calculate_free_frames>
  800280:	29 c3                	sub    %eax,%ebx
  800282:	89 d8                	mov    %ebx,%eax
  800284:	83 f8 09             	cmp    $0x9,%eax
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 c8 1e 80 00       	push   $0x801ec8
  800291:	6a 3c                	push   $0x3c
  800293:	68 2f 1e 80 00       	push   $0x801e2f
  800298:	e8 29 02 00 00       	call   8004c6 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	68 e8 1e 80 00       	push   $0x801ee8
  8002a5:	e8 d0 04 00 00       	call   80077a <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp

	for (int i=16;i>4;i--)
  8002ad:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
  8002b4:	eb 1a                	jmp    8002d0 <_main+0x298>
		actual_active_list[i]=actual_active_list[i-5];
  8002b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b9:	83 e8 05             	sub    $0x5,%eax
  8002bc:	8b 94 85 9c ff ff fe 	mov    -0x1000064(%ebp,%eax,4),%edx
  8002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c6:	89 94 85 9c ff ff fe 	mov    %edx,-0x1000064(%ebp,%eax,4)

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	for (int i=16;i>4;i--)
  8002cd:	ff 4d f0             	decl   -0x10(%ebp)
  8002d0:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  8002d4:	7f e0                	jg     8002b6 <_main+0x27e>
		actual_active_list[i]=actual_active_list[i-5];

	actual_active_list[0]=0xee3fe000;
  8002d6:	c7 85 9c ff ff fe 00 	movl   $0xee3fe000,-0x1000064(%ebp)
  8002dd:	e0 3f ee 
	actual_active_list[1]=0xee3fdfa4;
  8002e0:	c7 85 a0 ff ff fe a4 	movl   $0xee3fdfa4,-0x1000060(%ebp)
  8002e7:	df 3f ee 
	actual_active_list[2]=0xedffe000;
  8002ea:	c7 85 a4 ff ff fe 00 	movl   $0xedffe000,-0x100005c(%ebp)
  8002f1:	e0 ff ed 
	actual_active_list[3]=0xedffdfa4;
  8002f4:	c7 85 a8 ff ff fe a4 	movl   $0xedffdfa4,-0x1000058(%ebp)
  8002fb:	df ff ed 
	actual_active_list[4]=0xedbfe000;
  8002fe:	c7 85 ac ff ff fe 00 	movl   $0xedbfe000,-0x1000054(%ebp)
  800305:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 1c 1f 80 00       	push   $0x801f1c
  800310:	e8 65 04 00 00       	call   80077a <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 17, 0);
  800318:	6a 00                	push   $0x0
  80031a:	6a 11                	push   $0x11
  80031c:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  800322:	50                   	push   %eax
  800323:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  800329:	50                   	push   %eax
  80032a:	e8 f1 17 00 00       	call   801b20 <sys_check_LRU_lists>
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(check == 0)
  800335:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800339:	75 14                	jne    80034f <_main+0x317>
				panic("LRU lists entries are not correct, check your logic again!!");
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 44 1f 80 00       	push   $0x801f44
  800343:	6a 4d                	push   $0x4d
  800345:	68 2f 1e 80 00       	push   $0x801e2f
  80034a:	e8 77 01 00 00       	call   8004c6 <_panic>
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 80 1f 80 00       	push   $0x801f80
  800357:	e8 1e 04 00 00       	call   80077a <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT FIRST SCENARIO completed successfully!!\n\n\n");
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	68 b8 1f 80 00       	push   $0x801fb8
  800367:	e8 0e 04 00 00       	call   80077a <cprintf>
  80036c:	83 c4 10             	add    $0x10,%esp
	return;
  80036f:	90                   	nop
}
  800370:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800373:	5b                   	pop    %ebx
  800374:	5f                   	pop    %edi
  800375:	5d                   	pop    %ebp
  800376:	c3                   	ret    

00800377 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80037d:	e8 4e 15 00 00       	call   8018d0 <sys_getenvindex>
  800382:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800395:	01 c8                	add    %ecx,%eax
  800397:	c1 e0 02             	shl    $0x2,%eax
  80039a:	01 d0                	add    %edx,%eax
  80039c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003a3:	01 c8                	add    %ecx,%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	01 d0                	add    %edx,%eax
  8003aa:	c1 e0 02             	shl    $0x2,%eax
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	c1 e0 03             	shl    $0x3,%eax
  8003b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003b7:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c1:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8003c7:	84 c0                	test   %al,%al
  8003c9:	74 0f                	je     8003da <libmain+0x63>
		binaryname = myEnv->prog_name;
  8003cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d0:	05 18 da 01 00       	add    $0x1da18,%eax
  8003d5:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003de:	7e 0a                	jle    8003ea <libmain+0x73>
		binaryname = argv[0];
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	e8 40 fc ff ff       	call   800038 <_main>
  8003f8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003fb:	e8 dd 12 00 00       	call   8016dd <sys_disable_interrupt>
	cprintf("**************************************\n");
  800400:	83 ec 0c             	sub    $0xc,%esp
  800403:	68 24 20 80 00       	push   $0x802024
  800408:	e8 6d 03 00 00       	call   80077a <cprintf>
  80040d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800410:	a1 20 30 80 00       	mov    0x803020,%eax
  800415:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80041b:	a1 20 30 80 00       	mov    0x803020,%eax
  800420:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800426:	83 ec 04             	sub    $0x4,%esp
  800429:	52                   	push   %edx
  80042a:	50                   	push   %eax
  80042b:	68 4c 20 80 00       	push   $0x80204c
  800430:	e8 45 03 00 00       	call   80077a <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800438:	a1 20 30 80 00       	mov    0x803020,%eax
  80043d:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800443:	a1 20 30 80 00       	mov    0x803020,%eax
  800448:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80044e:	a1 20 30 80 00       	mov    0x803020,%eax
  800453:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800459:	51                   	push   %ecx
  80045a:	52                   	push   %edx
  80045b:	50                   	push   %eax
  80045c:	68 74 20 80 00       	push   $0x802074
  800461:	e8 14 03 00 00       	call   80077a <cprintf>
  800466:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800469:	a1 20 30 80 00       	mov    0x803020,%eax
  80046e:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	50                   	push   %eax
  800478:	68 cc 20 80 00       	push   $0x8020cc
  80047d:	e8 f8 02 00 00       	call   80077a <cprintf>
  800482:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800485:	83 ec 0c             	sub    $0xc,%esp
  800488:	68 24 20 80 00       	push   $0x802024
  80048d:	e8 e8 02 00 00       	call   80077a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800495:	e8 5d 12 00 00       	call   8016f7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80049a:	e8 19 00 00 00       	call   8004b8 <exit>
}
  80049f:	90                   	nop
  8004a0:	c9                   	leave  
  8004a1:	c3                   	ret    

008004a2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004a8:	83 ec 0c             	sub    $0xc,%esp
  8004ab:	6a 00                	push   $0x0
  8004ad:	e8 ea 13 00 00       	call   80189c <sys_destroy_env>
  8004b2:	83 c4 10             	add    $0x10,%esp
}
  8004b5:	90                   	nop
  8004b6:	c9                   	leave  
  8004b7:	c3                   	ret    

008004b8 <exit>:

void
exit(void)
{
  8004b8:	55                   	push   %ebp
  8004b9:	89 e5                	mov    %esp,%ebp
  8004bb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004be:	e8 3f 14 00 00       	call   801902 <sys_exit_env>
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004cf:	83 c0 04             	add    $0x4,%eax
  8004d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004d5:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8004da:	85 c0                	test   %eax,%eax
  8004dc:	74 16                	je     8004f4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004de:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	50                   	push   %eax
  8004e7:	68 e0 20 80 00       	push   $0x8020e0
  8004ec:	e8 89 02 00 00       	call   80077a <cprintf>
  8004f1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004f4:	a1 00 30 80 00       	mov    0x803000,%eax
  8004f9:	ff 75 0c             	pushl  0xc(%ebp)
  8004fc:	ff 75 08             	pushl  0x8(%ebp)
  8004ff:	50                   	push   %eax
  800500:	68 e5 20 80 00       	push   $0x8020e5
  800505:	e8 70 02 00 00       	call   80077a <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80050d:	8b 45 10             	mov    0x10(%ebp),%eax
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	ff 75 f4             	pushl  -0xc(%ebp)
  800516:	50                   	push   %eax
  800517:	e8 f3 01 00 00       	call   80070f <vcprintf>
  80051c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	6a 00                	push   $0x0
  800524:	68 01 21 80 00       	push   $0x802101
  800529:	e8 e1 01 00 00       	call   80070f <vcprintf>
  80052e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800531:	e8 82 ff ff ff       	call   8004b8 <exit>

	// should not return here
	while (1) ;
  800536:	eb fe                	jmp    800536 <_panic+0x70>

00800538 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800538:	55                   	push   %ebp
  800539:	89 e5                	mov    %esp,%ebp
  80053b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80053e:	a1 20 30 80 00       	mov    0x803020,%eax
  800543:	8b 50 74             	mov    0x74(%eax),%edx
  800546:	8b 45 0c             	mov    0xc(%ebp),%eax
  800549:	39 c2                	cmp    %eax,%edx
  80054b:	74 14                	je     800561 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 04 21 80 00       	push   $0x802104
  800555:	6a 26                	push   $0x26
  800557:	68 50 21 80 00       	push   $0x802150
  80055c:	e8 65 ff ff ff       	call   8004c6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800561:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800568:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056f:	e9 c2 00 00 00       	jmp    800636 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800577:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057e:	8b 45 08             	mov    0x8(%ebp),%eax
  800581:	01 d0                	add    %edx,%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	85 c0                	test   %eax,%eax
  800587:	75 08                	jne    800591 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800589:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80058c:	e9 a2 00 00 00       	jmp    800633 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800598:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80059f:	eb 69                	jmp    80060a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a6:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	01 c0                	add    %eax,%eax
  8005b3:	01 d0                	add    %edx,%eax
  8005b5:	c1 e0 03             	shl    $0x3,%eax
  8005b8:	01 c8                	add    %ecx,%eax
  8005ba:	8a 40 04             	mov    0x4(%eax),%al
  8005bd:	84 c0                	test   %al,%al
  8005bf:	75 46                	jne    800607 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c6:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005cf:	89 d0                	mov    %edx,%eax
  8005d1:	01 c0                	add    %eax,%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	c1 e0 03             	shl    $0x3,%eax
  8005d8:	01 c8                	add    %ecx,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ec:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	01 c8                	add    %ecx,%eax
  8005f8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005fa:	39 c2                	cmp    %eax,%edx
  8005fc:	75 09                	jne    800607 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005fe:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800605:	eb 12                	jmp    800619 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800607:	ff 45 e8             	incl   -0x18(%ebp)
  80060a:	a1 20 30 80 00       	mov    0x803020,%eax
  80060f:	8b 50 74             	mov    0x74(%eax),%edx
  800612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800615:	39 c2                	cmp    %eax,%edx
  800617:	77 88                	ja     8005a1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800619:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80061d:	75 14                	jne    800633 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80061f:	83 ec 04             	sub    $0x4,%esp
  800622:	68 5c 21 80 00       	push   $0x80215c
  800627:	6a 3a                	push   $0x3a
  800629:	68 50 21 80 00       	push   $0x802150
  80062e:	e8 93 fe ff ff       	call   8004c6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800633:	ff 45 f0             	incl   -0x10(%ebp)
  800636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800639:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80063c:	0f 8c 32 ff ff ff    	jl     800574 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800642:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800649:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800650:	eb 26                	jmp    800678 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800652:	a1 20 30 80 00       	mov    0x803020,%eax
  800657:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80065d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800660:	89 d0                	mov    %edx,%eax
  800662:	01 c0                	add    %eax,%eax
  800664:	01 d0                	add    %edx,%eax
  800666:	c1 e0 03             	shl    $0x3,%eax
  800669:	01 c8                	add    %ecx,%eax
  80066b:	8a 40 04             	mov    0x4(%eax),%al
  80066e:	3c 01                	cmp    $0x1,%al
  800670:	75 03                	jne    800675 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800672:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	ff 45 e0             	incl   -0x20(%ebp)
  800678:	a1 20 30 80 00       	mov    0x803020,%eax
  80067d:	8b 50 74             	mov    0x74(%eax),%edx
  800680:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800683:	39 c2                	cmp    %eax,%edx
  800685:	77 cb                	ja     800652 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80068d:	74 14                	je     8006a3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 b0 21 80 00       	push   $0x8021b0
  800697:	6a 44                	push   $0x44
  800699:	68 50 21 80 00       	push   $0x802150
  80069e:	e8 23 fe ff ff       	call   8004c6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006a3:	90                   	nop
  8006a4:	c9                   	leave  
  8006a5:	c3                   	ret    

008006a6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b7:	89 0a                	mov    %ecx,(%edx)
  8006b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006bc:	88 d1                	mov    %dl,%cl
  8006be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006cf:	75 2c                	jne    8006fd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006d1:	a0 24 30 80 00       	mov    0x803024,%al
  8006d6:	0f b6 c0             	movzbl %al,%eax
  8006d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006dc:	8b 12                	mov    (%edx),%edx
  8006de:	89 d1                	mov    %edx,%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	83 c2 08             	add    $0x8,%edx
  8006e6:	83 ec 04             	sub    $0x4,%esp
  8006e9:	50                   	push   %eax
  8006ea:	51                   	push   %ecx
  8006eb:	52                   	push   %edx
  8006ec:	e8 3e 0e 00 00       	call   80152f <sys_cputs>
  8006f1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800700:	8b 40 04             	mov    0x4(%eax),%eax
  800703:	8d 50 01             	lea    0x1(%eax),%edx
  800706:	8b 45 0c             	mov    0xc(%ebp),%eax
  800709:	89 50 04             	mov    %edx,0x4(%eax)
}
  80070c:	90                   	nop
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    

0080070f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
  800712:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800718:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80071f:	00 00 00 
	b.cnt = 0;
  800722:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800729:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	ff 75 08             	pushl  0x8(%ebp)
  800732:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	68 a6 06 80 00       	push   $0x8006a6
  80073e:	e8 11 02 00 00       	call   800954 <vprintfmt>
  800743:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800746:	a0 24 30 80 00       	mov    0x803024,%al
  80074b:	0f b6 c0             	movzbl %al,%eax
  80074e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800754:	83 ec 04             	sub    $0x4,%esp
  800757:	50                   	push   %eax
  800758:	52                   	push   %edx
  800759:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075f:	83 c0 08             	add    $0x8,%eax
  800762:	50                   	push   %eax
  800763:	e8 c7 0d 00 00       	call   80152f <sys_cputs>
  800768:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80076b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800772:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <cprintf>:

int cprintf(const char *fmt, ...) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800780:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800787:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 f4             	pushl  -0xc(%ebp)
  800796:	50                   	push   %eax
  800797:	e8 73 ff ff ff       	call   80070f <vcprintf>
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a5:	c9                   	leave  
  8007a6:	c3                   	ret    

008007a7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007ad:	e8 2b 0f 00 00       	call   8016dd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007b2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	e8 48 ff ff ff       	call   80070f <vcprintf>
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007cd:	e8 25 0f 00 00       	call   8016f7 <sys_enable_interrupt>
	return cnt;
  8007d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d5:	c9                   	leave  
  8007d6:	c3                   	ret    

008007d7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	83 ec 14             	sub    $0x14,%esp
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f5:	77 55                	ja     80084c <printnum+0x75>
  8007f7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007fa:	72 05                	jb     800801 <printnum+0x2a>
  8007fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007ff:	77 4b                	ja     80084c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800801:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800804:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800807:	8b 45 18             	mov    0x18(%ebp),%eax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
  80080f:	52                   	push   %edx
  800810:	50                   	push   %eax
  800811:	ff 75 f4             	pushl  -0xc(%ebp)
  800814:	ff 75 f0             	pushl  -0x10(%ebp)
  800817:	e8 48 13 00 00       	call   801b64 <__udivdi3>
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	83 ec 04             	sub    $0x4,%esp
  800822:	ff 75 20             	pushl  0x20(%ebp)
  800825:	53                   	push   %ebx
  800826:	ff 75 18             	pushl  0x18(%ebp)
  800829:	52                   	push   %edx
  80082a:	50                   	push   %eax
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	ff 75 08             	pushl  0x8(%ebp)
  800831:	e8 a1 ff ff ff       	call   8007d7 <printnum>
  800836:	83 c4 20             	add    $0x20,%esp
  800839:	eb 1a                	jmp    800855 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	ff 75 20             	pushl  0x20(%ebp)
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80084c:	ff 4d 1c             	decl   0x1c(%ebp)
  80084f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800853:	7f e6                	jg     80083b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800855:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800858:	bb 00 00 00 00       	mov    $0x0,%ebx
  80085d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800860:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800863:	53                   	push   %ebx
  800864:	51                   	push   %ecx
  800865:	52                   	push   %edx
  800866:	50                   	push   %eax
  800867:	e8 08 14 00 00       	call   801c74 <__umoddi3>
  80086c:	83 c4 10             	add    $0x10,%esp
  80086f:	05 14 24 80 00       	add    $0x802414,%eax
  800874:	8a 00                	mov    (%eax),%al
  800876:	0f be c0             	movsbl %al,%eax
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 0c             	pushl  0xc(%ebp)
  80087f:	50                   	push   %eax
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	ff d0                	call   *%eax
  800885:	83 c4 10             	add    $0x10,%esp
}
  800888:	90                   	nop
  800889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088c:	c9                   	leave  
  80088d:	c3                   	ret    

0080088e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800891:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800895:	7e 1c                	jle    8008b3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	8d 50 08             	lea    0x8(%eax),%edx
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	89 10                	mov    %edx,(%eax)
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	83 e8 08             	sub    $0x8,%eax
  8008ac:	8b 50 04             	mov    0x4(%eax),%edx
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	eb 40                	jmp    8008f3 <getuint+0x65>
	else if (lflag)
  8008b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b7:	74 1e                	je     8008d7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 50 04             	lea    0x4(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	89 10                	mov    %edx,(%eax)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 e8 04             	sub    $0x4,%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d5:	eb 1c                	jmp    8008f3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	8d 50 04             	lea    0x4(%eax),%edx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	89 10                	mov    %edx,(%eax)
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	83 e8 04             	sub    $0x4,%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008fc:	7e 1c                	jle    80091a <getint+0x25>
		return va_arg(*ap, long long);
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	8d 50 08             	lea    0x8(%eax),%edx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	89 10                	mov    %edx,(%eax)
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	83 e8 08             	sub    $0x8,%eax
  800913:	8b 50 04             	mov    0x4(%eax),%edx
  800916:	8b 00                	mov    (%eax),%eax
  800918:	eb 38                	jmp    800952 <getint+0x5d>
	else if (lflag)
  80091a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091e:	74 1a                	je     80093a <getint+0x45>
		return va_arg(*ap, long);
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	8d 50 04             	lea    0x4(%eax),%edx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	89 10                	mov    %edx,(%eax)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	99                   	cltd   
  800938:	eb 18                	jmp    800952 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	8d 50 04             	lea    0x4(%eax),%edx
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	89 10                	mov    %edx,(%eax)
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	99                   	cltd   
}
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    

00800954 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095c:	eb 17                	jmp    800975 <vprintfmt+0x21>
			if (ch == '\0')
  80095e:	85 db                	test   %ebx,%ebx
  800960:	0f 84 af 03 00 00    	je     800d15 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	ff d0                	call   *%eax
  800972:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800975:	8b 45 10             	mov    0x10(%ebp),%eax
  800978:	8d 50 01             	lea    0x1(%eax),%edx
  80097b:	89 55 10             	mov    %edx,0x10(%ebp)
  80097e:	8a 00                	mov    (%eax),%al
  800980:	0f b6 d8             	movzbl %al,%ebx
  800983:	83 fb 25             	cmp    $0x25,%ebx
  800986:	75 d6                	jne    80095e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800988:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80098c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800993:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80099a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009a1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ab:	8d 50 01             	lea    0x1(%eax),%edx
  8009ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b1:	8a 00                	mov    (%eax),%al
  8009b3:	0f b6 d8             	movzbl %al,%ebx
  8009b6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b9:	83 f8 55             	cmp    $0x55,%eax
  8009bc:	0f 87 2b 03 00 00    	ja     800ced <vprintfmt+0x399>
  8009c2:	8b 04 85 38 24 80 00 	mov    0x802438(,%eax,4),%eax
  8009c9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009cb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009cf:	eb d7                	jmp    8009a8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009d1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d5:	eb d1                	jmp    8009a8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e1:	89 d0                	mov    %edx,%eax
  8009e3:	c1 e0 02             	shl    $0x2,%eax
  8009e6:	01 d0                	add    %edx,%eax
  8009e8:	01 c0                	add    %eax,%eax
  8009ea:	01 d8                	add    %ebx,%eax
  8009ec:	83 e8 30             	sub    $0x30,%eax
  8009ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f5:	8a 00                	mov    (%eax),%al
  8009f7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009fa:	83 fb 2f             	cmp    $0x2f,%ebx
  8009fd:	7e 3e                	jle    800a3d <vprintfmt+0xe9>
  8009ff:	83 fb 39             	cmp    $0x39,%ebx
  800a02:	7f 39                	jg     800a3d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a04:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a07:	eb d5                	jmp    8009de <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a1d:	eb 1f                	jmp    800a3e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	79 83                	jns    8009a8 <vprintfmt+0x54>
				width = 0;
  800a25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a2c:	e9 77 ff ff ff       	jmp    8009a8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a31:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a38:	e9 6b ff ff ff       	jmp    8009a8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a3d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a42:	0f 89 60 ff ff ff    	jns    8009a8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a4e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a55:	e9 4e ff ff ff       	jmp    8009a8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a5a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a5d:	e9 46 ff ff ff       	jmp    8009a8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 c0 04             	add    $0x4,%eax
  800a68:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	50                   	push   %eax
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	ff d0                	call   *%eax
  800a7f:	83 c4 10             	add    $0x10,%esp
			break;
  800a82:	e9 89 02 00 00       	jmp    800d10 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	83 c0 04             	add    $0x4,%eax
  800a8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a90:	8b 45 14             	mov    0x14(%ebp),%eax
  800a93:	83 e8 04             	sub    $0x4,%eax
  800a96:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a98:	85 db                	test   %ebx,%ebx
  800a9a:	79 02                	jns    800a9e <vprintfmt+0x14a>
				err = -err;
  800a9c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a9e:	83 fb 64             	cmp    $0x64,%ebx
  800aa1:	7f 0b                	jg     800aae <vprintfmt+0x15a>
  800aa3:	8b 34 9d 80 22 80 00 	mov    0x802280(,%ebx,4),%esi
  800aaa:	85 f6                	test   %esi,%esi
  800aac:	75 19                	jne    800ac7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aae:	53                   	push   %ebx
  800aaf:	68 25 24 80 00       	push   $0x802425
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	ff 75 08             	pushl  0x8(%ebp)
  800aba:	e8 5e 02 00 00       	call   800d1d <printfmt>
  800abf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac2:	e9 49 02 00 00       	jmp    800d10 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac7:	56                   	push   %esi
  800ac8:	68 2e 24 80 00       	push   $0x80242e
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	ff 75 08             	pushl  0x8(%ebp)
  800ad3:	e8 45 02 00 00       	call   800d1d <printfmt>
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	e9 30 02 00 00       	jmp    800d10 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ae0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae3:	83 c0 04             	add    $0x4,%eax
  800ae6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	83 e8 04             	sub    $0x4,%eax
  800aef:	8b 30                	mov    (%eax),%esi
  800af1:	85 f6                	test   %esi,%esi
  800af3:	75 05                	jne    800afa <vprintfmt+0x1a6>
				p = "(null)";
  800af5:	be 31 24 80 00       	mov    $0x802431,%esi
			if (width > 0 && padc != '-')
  800afa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afe:	7e 6d                	jle    800b6d <vprintfmt+0x219>
  800b00:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b04:	74 67                	je     800b6d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	50                   	push   %eax
  800b0d:	56                   	push   %esi
  800b0e:	e8 0c 03 00 00       	call   800e1f <strnlen>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b19:	eb 16                	jmp    800b31 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b1b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	50                   	push   %eax
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b35:	7f e4                	jg     800b1b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b37:	eb 34                	jmp    800b6d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b39:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b3d:	74 1c                	je     800b5b <vprintfmt+0x207>
  800b3f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b42:	7e 05                	jle    800b49 <vprintfmt+0x1f5>
  800b44:	83 fb 7e             	cmp    $0x7e,%ebx
  800b47:	7e 12                	jle    800b5b <vprintfmt+0x207>
					putch('?', putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	6a 3f                	push   $0x3f
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
  800b59:	eb 0f                	jmp    800b6a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	53                   	push   %ebx
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	ff d0                	call   *%eax
  800b67:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6d:	89 f0                	mov    %esi,%eax
  800b6f:	8d 70 01             	lea    0x1(%eax),%esi
  800b72:	8a 00                	mov    (%eax),%al
  800b74:	0f be d8             	movsbl %al,%ebx
  800b77:	85 db                	test   %ebx,%ebx
  800b79:	74 24                	je     800b9f <vprintfmt+0x24b>
  800b7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7f:	78 b8                	js     800b39 <vprintfmt+0x1e5>
  800b81:	ff 4d e0             	decl   -0x20(%ebp)
  800b84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b88:	79 af                	jns    800b39 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8a:	eb 13                	jmp    800b9f <vprintfmt+0x24b>
				putch(' ', putdat);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	6a 20                	push   $0x20
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	ff d0                	call   *%eax
  800b99:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba3:	7f e7                	jg     800b8c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba5:	e9 66 01 00 00       	jmp    800d10 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb3:	50                   	push   %eax
  800bb4:	e8 3c fd ff ff       	call   8008f5 <getint>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc8:	85 d2                	test   %edx,%edx
  800bca:	79 23                	jns    800bef <vprintfmt+0x29b>
				putch('-', putdat);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 0c             	pushl  0xc(%ebp)
  800bd2:	6a 2d                	push   $0x2d
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	ff d0                	call   *%eax
  800bd9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be2:	f7 d8                	neg    %eax
  800be4:	83 d2 00             	adc    $0x0,%edx
  800be7:	f7 da                	neg    %edx
  800be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf6:	e9 bc 00 00 00       	jmp    800cb7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  800c01:	8d 45 14             	lea    0x14(%ebp),%eax
  800c04:	50                   	push   %eax
  800c05:	e8 84 fc ff ff       	call   80088e <getuint>
  800c0a:	83 c4 10             	add    $0x10,%esp
  800c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c13:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c1a:	e9 98 00 00 00       	jmp    800cb7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	ff 75 0c             	pushl  0xc(%ebp)
  800c25:	6a 58                	push   $0x58
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			break;
  800c4f:	e9 bc 00 00 00       	jmp    800d10 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	6a 30                	push   $0x30
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	ff d0                	call   *%eax
  800c61:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 78                	push   $0x78
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c8f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c96:	eb 1f                	jmp    800cb7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c98:	83 ec 08             	sub    $0x8,%esp
  800c9b:	ff 75 e8             	pushl  -0x18(%ebp)
  800c9e:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca1:	50                   	push   %eax
  800ca2:	e8 e7 fb ff ff       	call   80088e <getuint>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cb0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cbe:	83 ec 04             	sub    $0x4,%esp
  800cc1:	52                   	push   %edx
  800cc2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc5:	50                   	push   %eax
  800cc6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc9:	ff 75 f0             	pushl  -0x10(%ebp)
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	ff 75 08             	pushl  0x8(%ebp)
  800cd2:	e8 00 fb ff ff       	call   8007d7 <printnum>
  800cd7:	83 c4 20             	add    $0x20,%esp
			break;
  800cda:	eb 34                	jmp    800d10 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cdc:	83 ec 08             	sub    $0x8,%esp
  800cdf:	ff 75 0c             	pushl  0xc(%ebp)
  800ce2:	53                   	push   %ebx
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	ff d0                	call   *%eax
  800ce8:	83 c4 10             	add    $0x10,%esp
			break;
  800ceb:	eb 23                	jmp    800d10 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	6a 25                	push   $0x25
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	ff d0                	call   *%eax
  800cfa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cfd:	ff 4d 10             	decl   0x10(%ebp)
  800d00:	eb 03                	jmp    800d05 <vprintfmt+0x3b1>
  800d02:	ff 4d 10             	decl   0x10(%ebp)
  800d05:	8b 45 10             	mov    0x10(%ebp),%eax
  800d08:	48                   	dec    %eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	3c 25                	cmp    $0x25,%al
  800d0d:	75 f3                	jne    800d02 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d0f:	90                   	nop
		}
	}
  800d10:	e9 47 fc ff ff       	jmp    80095c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d15:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d23:	8d 45 10             	lea    0x10(%ebp),%eax
  800d26:	83 c0 04             	add    $0x4,%eax
  800d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d32:	50                   	push   %eax
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	ff 75 08             	pushl  0x8(%ebp)
  800d39:	e8 16 fc ff ff       	call   800954 <vprintfmt>
  800d3e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d41:	90                   	nop
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4a:	8b 40 08             	mov    0x8(%eax),%eax
  800d4d:	8d 50 01             	lea    0x1(%eax),%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8b 10                	mov    (%eax),%edx
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	8b 40 04             	mov    0x4(%eax),%eax
  800d61:	39 c2                	cmp    %eax,%edx
  800d63:	73 12                	jae    800d77 <sprintputch+0x33>
		*b->buf++ = ch;
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	8b 00                	mov    (%eax),%eax
  800d6a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d70:	89 0a                	mov    %ecx,(%edx)
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	88 10                	mov    %dl,(%eax)
}
  800d77:	90                   	nop
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	01 d0                	add    %edx,%eax
  800d91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d9f:	74 06                	je     800da7 <vsnprintf+0x2d>
  800da1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da5:	7f 07                	jg     800dae <vsnprintf+0x34>
		return -E_INVAL;
  800da7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dac:	eb 20                	jmp    800dce <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dae:	ff 75 14             	pushl  0x14(%ebp)
  800db1:	ff 75 10             	pushl  0x10(%ebp)
  800db4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800db7:	50                   	push   %eax
  800db8:	68 44 0d 80 00       	push   $0x800d44
  800dbd:	e8 92 fb ff ff       	call   800954 <vprintfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dd6:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  800de2:	ff 75 f4             	pushl  -0xc(%ebp)
  800de5:	50                   	push   %eax
  800de6:	ff 75 0c             	pushl  0xc(%ebp)
  800de9:	ff 75 08             	pushl  0x8(%ebp)
  800dec:	e8 89 ff ff ff       	call   800d7a <vsnprintf>
  800df1:	83 c4 10             	add    $0x10,%esp
  800df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e09:	eb 06                	jmp    800e11 <strlen+0x15>
		n++;
  800e0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0e:	ff 45 08             	incl   0x8(%ebp)
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	84 c0                	test   %al,%al
  800e18:	75 f1                	jne    800e0b <strlen+0xf>
		n++;
	return n;
  800e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2c:	eb 09                	jmp    800e37 <strnlen+0x18>
		n++;
  800e2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e31:	ff 45 08             	incl   0x8(%ebp)
  800e34:	ff 4d 0c             	decl   0xc(%ebp)
  800e37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3b:	74 09                	je     800e46 <strnlen+0x27>
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 e8                	jne    800e2e <strnlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e57:	90                   	nop
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8d 50 01             	lea    0x1(%eax),%edx
  800e5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e6a:	8a 12                	mov    (%edx),%dl
  800e6c:	88 10                	mov    %dl,(%eax)
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	84 c0                	test   %al,%al
  800e72:	75 e4                	jne    800e58 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8c:	eb 1f                	jmp    800ead <strncpy+0x34>
		*dst++ = *src;
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 08             	mov    %edx,0x8(%ebp)
  800e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9a:	8a 12                	mov    (%edx),%dl
  800e9c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	84 c0                	test   %al,%al
  800ea5:	74 03                	je     800eaa <strncpy+0x31>
			src++;
  800ea7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eaa:	ff 45 fc             	incl   -0x4(%ebp)
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eb3:	72 d9                	jb     800e8e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eb8:	c9                   	leave  
  800eb9:	c3                   	ret    

00800eba <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ec6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eca:	74 30                	je     800efc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ecc:	eb 16                	jmp    800ee4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8d 50 01             	lea    0x1(%eax),%edx
  800ed4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee0:	8a 12                	mov    (%edx),%dl
  800ee2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ee4:	ff 4d 10             	decl   0x10(%ebp)
  800ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eeb:	74 09                	je     800ef6 <strlcpy+0x3c>
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	84 c0                	test   %al,%al
  800ef4:	75 d8                	jne    800ece <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800efc:	8b 55 08             	mov    0x8(%ebp),%edx
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	29 c2                	sub    %eax,%edx
  800f04:	89 d0                	mov    %edx,%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f0b:	eb 06                	jmp    800f13 <strcmp+0xb>
		p++, q++;
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	84 c0                	test   %al,%al
  800f1a:	74 0e                	je     800f2a <strcmp+0x22>
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 10                	mov    (%eax),%dl
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	38 c2                	cmp    %al,%dl
  800f28:	74 e3                	je     800f0d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	0f b6 d0             	movzbl %al,%edx
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f b6 c0             	movzbl %al,%eax
  800f3a:	29 c2                	sub    %eax,%edx
  800f3c:	89 d0                	mov    %edx,%eax
}
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f43:	eb 09                	jmp    800f4e <strncmp+0xe>
		n--, p++, q++;
  800f45:	ff 4d 10             	decl   0x10(%ebp)
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f52:	74 17                	je     800f6b <strncmp+0x2b>
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	74 0e                	je     800f6b <strncmp+0x2b>
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 10                	mov    (%eax),%dl
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	38 c2                	cmp    %al,%dl
  800f69:	74 da                	je     800f45 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6f:	75 07                	jne    800f78 <strncmp+0x38>
		return 0;
  800f71:	b8 00 00 00 00       	mov    $0x0,%eax
  800f76:	eb 14                	jmp    800f8c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	8a 00                	mov    (%eax),%al
  800f7d:	0f b6 d0             	movzbl %al,%edx
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f b6 c0             	movzbl %al,%eax
  800f88:	29 c2                	sub    %eax,%edx
  800f8a:	89 d0                	mov    %edx,%eax
}
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    

00800f8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 04             	sub    $0x4,%esp
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9a:	eb 12                	jmp    800fae <strchr+0x20>
		if (*s == c)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa4:	75 05                	jne    800fab <strchr+0x1d>
			return (char *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	eb 11                	jmp    800fbc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fab:	ff 45 08             	incl   0x8(%ebp)
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	84 c0                	test   %al,%al
  800fb5:	75 e5                	jne    800f9c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 04             	sub    $0x4,%esp
  800fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fca:	eb 0d                	jmp    800fd9 <strfind+0x1b>
		if (*s == c)
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd4:	74 0e                	je     800fe4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fd6:	ff 45 08             	incl   0x8(%ebp)
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	84 c0                	test   %al,%al
  800fe0:	75 ea                	jne    800fcc <strfind+0xe>
  800fe2:	eb 01                	jmp    800fe5 <strfind+0x27>
		if (*s == c)
			break;
  800fe4:	90                   	nop
	return (char *) s;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ffc:	eb 0e                	jmp    80100c <memset+0x22>
		*p++ = c;
  800ffe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801001:	8d 50 01             	lea    0x1(%eax),%edx
  801004:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801007:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80100c:	ff 4d f8             	decl   -0x8(%ebp)
  80100f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801013:	79 e9                	jns    800ffe <memset+0x14>
		*p++ = c;

	return v;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801018:	c9                   	leave  
  801019:	c3                   	ret    

0080101a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80102c:	eb 16                	jmp    801044 <memcpy+0x2a>
		*d++ = *s++;
  80102e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801031:	8d 50 01             	lea    0x1(%eax),%edx
  801034:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801037:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801040:	8a 12                	mov    (%edx),%dl
  801042:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801044:	8b 45 10             	mov    0x10(%ebp),%eax
  801047:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104a:	89 55 10             	mov    %edx,0x10(%ebp)
  80104d:	85 c0                	test   %eax,%eax
  80104f:	75 dd                	jne    80102e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801068:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80106e:	73 50                	jae    8010c0 <memmove+0x6a>
  801070:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	01 d0                	add    %edx,%eax
  801078:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107b:	76 43                	jbe    8010c0 <memmove+0x6a>
		s += n;
  80107d:	8b 45 10             	mov    0x10(%ebp),%eax
  801080:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801089:	eb 10                	jmp    80109b <memmove+0x45>
			*--d = *--s;
  80108b:	ff 4d f8             	decl   -0x8(%ebp)
  80108e:	ff 4d fc             	decl   -0x4(%ebp)
  801091:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801094:	8a 10                	mov    (%eax),%dl
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	75 e3                	jne    80108b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010a8:	eb 23                	jmp    8010cd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ad:	8d 50 01             	lea    0x1(%eax),%edx
  8010b0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010bc:	8a 12                	mov    (%edx),%dl
  8010be:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	75 dd                	jne    8010aa <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010e4:	eb 2a                	jmp    801110 <memcmp+0x3e>
		if (*s1 != *s2)
  8010e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e9:	8a 10                	mov    (%eax),%dl
  8010eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	38 c2                	cmp    %al,%dl
  8010f2:	74 16                	je     80110a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	0f b6 d0             	movzbl %al,%edx
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	0f b6 c0             	movzbl %al,%eax
  801104:	29 c2                	sub    %eax,%edx
  801106:	89 d0                	mov    %edx,%eax
  801108:	eb 18                	jmp    801122 <memcmp+0x50>
		s1++, s2++;
  80110a:	ff 45 fc             	incl   -0x4(%ebp)
  80110d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801110:	8b 45 10             	mov    0x10(%ebp),%eax
  801113:	8d 50 ff             	lea    -0x1(%eax),%edx
  801116:	89 55 10             	mov    %edx,0x10(%ebp)
  801119:	85 c0                	test   %eax,%eax
  80111b:	75 c9                	jne    8010e6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	01 d0                	add    %edx,%eax
  801132:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801135:	eb 15                	jmp    80114c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	0f b6 d0             	movzbl %al,%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	0f b6 c0             	movzbl %al,%eax
  801145:	39 c2                	cmp    %eax,%edx
  801147:	74 0d                	je     801156 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801149:	ff 45 08             	incl   0x8(%ebp)
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801152:	72 e3                	jb     801137 <memfind+0x13>
  801154:	eb 01                	jmp    801157 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801156:	90                   	nop
	return (void *) s;
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801169:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801170:	eb 03                	jmp    801175 <strtol+0x19>
		s++;
  801172:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 20                	cmp    $0x20,%al
  80117c:	74 f4                	je     801172 <strtol+0x16>
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 09                	cmp    $0x9,%al
  801185:	74 eb                	je     801172 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 2b                	cmp    $0x2b,%al
  80118e:	75 05                	jne    801195 <strtol+0x39>
		s++;
  801190:	ff 45 08             	incl   0x8(%ebp)
  801193:	eb 13                	jmp    8011a8 <strtol+0x4c>
	else if (*s == '-')
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 2d                	cmp    $0x2d,%al
  80119c:	75 0a                	jne    8011a8 <strtol+0x4c>
		s++, neg = 1;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ac:	74 06                	je     8011b4 <strtol+0x58>
  8011ae:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b2:	75 20                	jne    8011d4 <strtol+0x78>
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	3c 30                	cmp    $0x30,%al
  8011bb:	75 17                	jne    8011d4 <strtol+0x78>
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	40                   	inc    %eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3c 78                	cmp    $0x78,%al
  8011c5:	75 0d                	jne    8011d4 <strtol+0x78>
		s += 2, base = 16;
  8011c7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011cb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d2:	eb 28                	jmp    8011fc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	75 15                	jne    8011ef <strtol+0x93>
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	3c 30                	cmp    $0x30,%al
  8011e1:	75 0c                	jne    8011ef <strtol+0x93>
		s++, base = 8;
  8011e3:	ff 45 08             	incl   0x8(%ebp)
  8011e6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ed:	eb 0d                	jmp    8011fc <strtol+0xa0>
	else if (base == 0)
  8011ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f3:	75 07                	jne    8011fc <strtol+0xa0>
		base = 10;
  8011f5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	3c 2f                	cmp    $0x2f,%al
  801203:	7e 19                	jle    80121e <strtol+0xc2>
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3c 39                	cmp    $0x39,%al
  80120c:	7f 10                	jg     80121e <strtol+0xc2>
			dig = *s - '0';
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	0f be c0             	movsbl %al,%eax
  801216:	83 e8 30             	sub    $0x30,%eax
  801219:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121c:	eb 42                	jmp    801260 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	3c 60                	cmp    $0x60,%al
  801225:	7e 19                	jle    801240 <strtol+0xe4>
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	3c 7a                	cmp    $0x7a,%al
  80122e:	7f 10                	jg     801240 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	0f be c0             	movsbl %al,%eax
  801238:	83 e8 57             	sub    $0x57,%eax
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	eb 20                	jmp    801260 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	3c 40                	cmp    $0x40,%al
  801247:	7e 39                	jle    801282 <strtol+0x126>
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	3c 5a                	cmp    $0x5a,%al
  801250:	7f 30                	jg     801282 <strtol+0x126>
			dig = *s - 'A' + 10;
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	0f be c0             	movsbl %al,%eax
  80125a:	83 e8 37             	sub    $0x37,%eax
  80125d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801263:	3b 45 10             	cmp    0x10(%ebp),%eax
  801266:	7d 19                	jge    801281 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801268:	ff 45 08             	incl   0x8(%ebp)
  80126b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801272:	89 c2                	mov    %eax,%edx
  801274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80127c:	e9 7b ff ff ff       	jmp    8011fc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801281:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801282:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801286:	74 08                	je     801290 <strtol+0x134>
		*endptr = (char *) s;
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	8b 55 08             	mov    0x8(%ebp),%edx
  80128e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801290:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801294:	74 07                	je     80129d <strtol+0x141>
  801296:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801299:	f7 d8                	neg    %eax
  80129b:	eb 03                	jmp    8012a0 <strtol+0x144>
  80129d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ba:	79 13                	jns    8012cf <ltostr+0x2d>
	{
		neg = 1;
  8012bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012c9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012cc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012d7:	99                   	cltd   
  8012d8:	f7 f9                	idiv   %ecx
  8012da:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e0:	8d 50 01             	lea    0x1(%eax),%edx
  8012e3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e6:	89 c2                	mov    %eax,%edx
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	01 d0                	add    %edx,%eax
  8012ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f0:	83 c2 30             	add    $0x30,%edx
  8012f3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012fd:	f7 e9                	imul   %ecx
  8012ff:	c1 fa 02             	sar    $0x2,%edx
  801302:	89 c8                	mov    %ecx,%eax
  801304:	c1 f8 1f             	sar    $0x1f,%eax
  801307:	29 c2                	sub    %eax,%edx
  801309:	89 d0                	mov    %edx,%eax
  80130b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80130e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801311:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801316:	f7 e9                	imul   %ecx
  801318:	c1 fa 02             	sar    $0x2,%edx
  80131b:	89 c8                	mov    %ecx,%eax
  80131d:	c1 f8 1f             	sar    $0x1f,%eax
  801320:	29 c2                	sub    %eax,%edx
  801322:	89 d0                	mov    %edx,%eax
  801324:	c1 e0 02             	shl    $0x2,%eax
  801327:	01 d0                	add    %edx,%eax
  801329:	01 c0                	add    %eax,%eax
  80132b:	29 c1                	sub    %eax,%ecx
  80132d:	89 ca                	mov    %ecx,%edx
  80132f:	85 d2                	test   %edx,%edx
  801331:	75 9c                	jne    8012cf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80133a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133d:	48                   	dec    %eax
  80133e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801341:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801345:	74 3d                	je     801384 <ltostr+0xe2>
		start = 1 ;
  801347:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80134e:	eb 34                	jmp    801384 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	8b 45 0c             	mov    0xc(%ebp),%eax
  801363:	01 c2                	add    %eax,%edx
  801365:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	01 c8                	add    %ecx,%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801371:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801374:	8b 45 0c             	mov    0xc(%ebp),%eax
  801377:	01 c2                	add    %eax,%edx
  801379:	8a 45 eb             	mov    -0x15(%ebp),%al
  80137c:	88 02                	mov    %al,(%edx)
		start++ ;
  80137e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801381:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80138a:	7c c4                	jl     801350 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80138c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	01 d0                	add    %edx,%eax
  801394:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801397:	90                   	nop
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 54 fa ff ff       	call   800dfc <strlen>
  8013a8:	83 c4 04             	add    $0x4,%esp
  8013ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	e8 46 fa ff ff       	call   800dfc <strlen>
  8013b6:	83 c4 04             	add    $0x4,%esp
  8013b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ca:	eb 17                	jmp    8013e3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d2:	01 c2                	add    %eax,%edx
  8013d4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	01 c8                	add    %ecx,%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013e0:	ff 45 fc             	incl   -0x4(%ebp)
  8013e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013e9:	7c e1                	jl     8013cc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013f9:	eb 1f                	jmp    80141a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013fe:	8d 50 01             	lea    0x1(%eax),%edx
  801401:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801404:	89 c2                	mov    %eax,%edx
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	01 c2                	add    %eax,%edx
  80140b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80140e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801411:	01 c8                	add    %ecx,%eax
  801413:	8a 00                	mov    (%eax),%al
  801415:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801417:	ff 45 f8             	incl   -0x8(%ebp)
  80141a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80141d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801420:	7c d9                	jl     8013fb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801422:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801425:	8b 45 10             	mov    0x10(%ebp),%eax
  801428:	01 d0                	add    %edx,%eax
  80142a:	c6 00 00             	movb   $0x0,(%eax)
}
  80142d:	90                   	nop
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801433:	8b 45 14             	mov    0x14(%ebp),%eax
  801436:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80143c:	8b 45 14             	mov    0x14(%ebp),%eax
  80143f:	8b 00                	mov    (%eax),%eax
  801441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801448:	8b 45 10             	mov    0x10(%ebp),%eax
  80144b:	01 d0                	add    %edx,%eax
  80144d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801453:	eb 0c                	jmp    801461 <strsplit+0x31>
			*string++ = 0;
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8d 50 01             	lea    0x1(%eax),%edx
  80145b:	89 55 08             	mov    %edx,0x8(%ebp)
  80145e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	84 c0                	test   %al,%al
  801468:	74 18                	je     801482 <strsplit+0x52>
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	0f be c0             	movsbl %al,%eax
  801472:	50                   	push   %eax
  801473:	ff 75 0c             	pushl  0xc(%ebp)
  801476:	e8 13 fb ff ff       	call   800f8e <strchr>
  80147b:	83 c4 08             	add    $0x8,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	75 d3                	jne    801455 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 5a                	je     8014e5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80148b:	8b 45 14             	mov    0x14(%ebp),%eax
  80148e:	8b 00                	mov    (%eax),%eax
  801490:	83 f8 0f             	cmp    $0xf,%eax
  801493:	75 07                	jne    80149c <strsplit+0x6c>
		{
			return 0;
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
  80149a:	eb 66                	jmp    801502 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80149c:	8b 45 14             	mov    0x14(%ebp),%eax
  80149f:	8b 00                	mov    (%eax),%eax
  8014a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014a4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014a7:	89 0a                	mov    %ecx,(%edx)
  8014a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 c2                	add    %eax,%edx
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ba:	eb 03                	jmp    8014bf <strsplit+0x8f>
			string++;
  8014bc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	84 c0                	test   %al,%al
  8014c6:	74 8b                	je     801453 <strsplit+0x23>
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8a 00                	mov    (%eax),%al
  8014cd:	0f be c0             	movsbl %al,%eax
  8014d0:	50                   	push   %eax
  8014d1:	ff 75 0c             	pushl  0xc(%ebp)
  8014d4:	e8 b5 fa ff ff       	call   800f8e <strchr>
  8014d9:	83 c4 08             	add    $0x8,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	74 dc                	je     8014bc <strsplit+0x8c>
			string++;
	}
  8014e0:	e9 6e ff ff ff       	jmp    801453 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014e5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e9:	8b 00                	mov    (%eax),%eax
  8014eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f5:	01 d0                	add    %edx,%eax
  8014f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014fd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	57                   	push   %edi
  801508:	56                   	push   %esi
  801509:	53                   	push   %ebx
  80150a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801516:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801519:	8b 7d 18             	mov    0x18(%ebp),%edi
  80151c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80151f:	cd 30                	int    $0x30
  801521:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	5b                   	pop    %ebx
  80152b:	5e                   	pop    %esi
  80152c:	5f                   	pop    %edi
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	8b 45 10             	mov    0x10(%ebp),%eax
  801538:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80153b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	52                   	push   %edx
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	50                   	push   %eax
  80154b:	6a 00                	push   $0x0
  80154d:	e8 b2 ff ff ff       	call   801504 <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
}
  801555:	90                   	nop
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_cgetc>:

int
sys_cgetc(void)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 01                	push   $0x1
  801567:	e8 98 ff ff ff       	call   801504 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801574:	8b 55 0c             	mov    0xc(%ebp),%edx
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	52                   	push   %edx
  801581:	50                   	push   %eax
  801582:	6a 05                	push   $0x5
  801584:	e8 7b ff ff ff       	call   801504 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	56                   	push   %esi
  801592:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801593:	8b 75 18             	mov    0x18(%ebp),%esi
  801596:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801599:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	56                   	push   %esi
  8015a3:	53                   	push   %ebx
  8015a4:	51                   	push   %ecx
  8015a5:	52                   	push   %edx
  8015a6:	50                   	push   %eax
  8015a7:	6a 06                	push   $0x6
  8015a9:	e8 56 ff ff ff       	call   801504 <syscall>
  8015ae:	83 c4 18             	add    $0x18,%esp
}
  8015b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b4:	5b                   	pop    %ebx
  8015b5:	5e                   	pop    %esi
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	52                   	push   %edx
  8015c8:	50                   	push   %eax
  8015c9:	6a 07                	push   $0x7
  8015cb:	e8 34 ff ff ff       	call   801504 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	ff 75 08             	pushl  0x8(%ebp)
  8015e4:	6a 08                	push   $0x8
  8015e6:	e8 19 ff ff ff       	call   801504 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 09                	push   $0x9
  8015ff:	e8 00 ff ff ff       	call   801504 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 0a                	push   $0xa
  801618:	e8 e7 fe ff ff       	call   801504 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 0b                	push   $0xb
  801631:	e8 ce fe ff ff       	call   801504 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	ff 75 0c             	pushl  0xc(%ebp)
  801647:	ff 75 08             	pushl  0x8(%ebp)
  80164a:	6a 0f                	push   $0xf
  80164c:	e8 b3 fe ff ff       	call   801504 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
	return;
  801654:	90                   	nop
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	6a 10                	push   $0x10
  801668:	e8 97 fe ff ff       	call   801504 <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
	return ;
  801670:	90                   	nop
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	ff 75 10             	pushl  0x10(%ebp)
  80167d:	ff 75 0c             	pushl  0xc(%ebp)
  801680:	ff 75 08             	pushl  0x8(%ebp)
  801683:	6a 11                	push   $0x11
  801685:	e8 7a fe ff ff       	call   801504 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
	return ;
  80168d:	90                   	nop
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 0c                	push   $0xc
  80169f:	e8 60 fe ff ff       	call   801504 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	ff 75 08             	pushl  0x8(%ebp)
  8016b7:	6a 0d                	push   $0xd
  8016b9:	e8 46 fe ff ff       	call   801504 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 0e                	push   $0xe
  8016d2:	e8 2d fe ff ff       	call   801504 <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	90                   	nop
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 13                	push   $0x13
  8016ec:	e8 13 fe ff ff       	call   801504 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	90                   	nop
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 14                	push   $0x14
  801706:	e8 f9 fd ff ff       	call   801504 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	90                   	nop
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_cputc>:


void
sys_cputc(const char c)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 04             	sub    $0x4,%esp
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80171d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	50                   	push   %eax
  80172a:	6a 15                	push   $0x15
  80172c:	e8 d3 fd ff ff       	call   801504 <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	90                   	nop
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 16                	push   $0x16
  801746:	e8 b9 fd ff ff       	call   801504 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	ff 75 0c             	pushl  0xc(%ebp)
  801760:	50                   	push   %eax
  801761:	6a 17                	push   $0x17
  801763:	e8 9c fd ff ff       	call   801504 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801770:	8b 55 0c             	mov    0xc(%ebp),%edx
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	52                   	push   %edx
  80177d:	50                   	push   %eax
  80177e:	6a 1a                	push   $0x1a
  801780:	e8 7f fd ff ff       	call   801504 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80178d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	52                   	push   %edx
  80179a:	50                   	push   %eax
  80179b:	6a 18                	push   $0x18
  80179d:	e8 62 fd ff ff       	call   801504 <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	90                   	nop
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	6a 19                	push   $0x19
  8017bb:	e8 44 fd ff ff       	call   801504 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	90                   	nop
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017d5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	6a 00                	push   $0x0
  8017de:	51                   	push   %ecx
  8017df:	52                   	push   %edx
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	50                   	push   %eax
  8017e4:	6a 1b                	push   $0x1b
  8017e6:	e8 19 fd ff ff       	call   801504 <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	52                   	push   %edx
  801800:	50                   	push   %eax
  801801:	6a 1c                	push   $0x1c
  801803:	e8 fc fc ff ff       	call   801504 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801810:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801813:	8b 55 0c             	mov    0xc(%ebp),%edx
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	51                   	push   %ecx
  80181e:	52                   	push   %edx
  80181f:	50                   	push   %eax
  801820:	6a 1d                	push   $0x1d
  801822:	e8 dd fc ff ff       	call   801504 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80182f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	52                   	push   %edx
  80183c:	50                   	push   %eax
  80183d:	6a 1e                	push   $0x1e
  80183f:	e8 c0 fc ff ff       	call   801504 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 1f                	push   $0x1f
  801858:	e8 a7 fc ff ff       	call   801504 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	6a 00                	push   $0x0
  80186a:	ff 75 14             	pushl  0x14(%ebp)
  80186d:	ff 75 10             	pushl  0x10(%ebp)
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	50                   	push   %eax
  801874:	6a 20                	push   $0x20
  801876:	e8 89 fc ff ff       	call   801504 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	50                   	push   %eax
  80188f:	6a 21                	push   $0x21
  801891:	e8 6e fc ff ff       	call   801504 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	50                   	push   %eax
  8018ab:	6a 22                	push   $0x22
  8018ad:	e8 52 fc ff ff       	call   801504 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 02                	push   $0x2
  8018c6:	e8 39 fc ff ff       	call   801504 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 03                	push   $0x3
  8018df:	e8 20 fc ff ff       	call   801504 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 04                	push   $0x4
  8018f8:	e8 07 fc ff ff       	call   801504 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_exit_env>:


void sys_exit_env(void)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 23                	push   $0x23
  801911:	e8 ee fb ff ff       	call   801504 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	90                   	nop
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801922:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801925:	8d 50 04             	lea    0x4(%eax),%edx
  801928:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	6a 24                	push   $0x24
  801935:	e8 ca fb ff ff       	call   801504 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
	return result;
  80193d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801940:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801943:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801946:	89 01                	mov    %eax,(%ecx)
  801948:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	c9                   	leave  
  80194f:	c2 04 00             	ret    $0x4

00801952 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 10             	pushl  0x10(%ebp)
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	6a 12                	push   $0x12
  801964:	e8 9b fb ff ff       	call   801504 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
	return ;
  80196c:	90                   	nop
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_rcr2>:
uint32 sys_rcr2()
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 25                	push   $0x25
  80197e:	e8 81 fb ff ff       	call   801504 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801994:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	50                   	push   %eax
  8019a1:	6a 26                	push   $0x26
  8019a3:	e8 5c fb ff ff       	call   801504 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ab:	90                   	nop
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <rsttst>:
void rsttst()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 28                	push   $0x28
  8019bd:	e8 42 fb ff ff       	call   801504 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c5:	90                   	nop
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019d4:	8b 55 18             	mov    0x18(%ebp),%edx
  8019d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019db:	52                   	push   %edx
  8019dc:	50                   	push   %eax
  8019dd:	ff 75 10             	pushl  0x10(%ebp)
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	6a 27                	push   $0x27
  8019e8:	e8 17 fb ff ff       	call   801504 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f0:	90                   	nop
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <chktst>:
void chktst(uint32 n)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	6a 29                	push   $0x29
  801a03:	e8 fc fa ff ff       	call   801504 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0b:	90                   	nop
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <inctst>:

void inctst()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 2a                	push   $0x2a
  801a1d:	e8 e2 fa ff ff       	call   801504 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
	return ;
  801a25:	90                   	nop
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <gettst>:
uint32 gettst()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 2b                	push   $0x2b
  801a37:	e8 c8 fa ff ff       	call   801504 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 2c                	push   $0x2c
  801a53:	e8 ac fa ff ff       	call   801504 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
  801a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a5e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a62:	75 07                	jne    801a6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a64:	b8 01 00 00 00       	mov    $0x1,%eax
  801a69:	eb 05                	jmp    801a70 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 2c                	push   $0x2c
  801a84:	e8 7b fa ff ff       	call   801504 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
  801a8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a8f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a93:	75 07                	jne    801a9c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a95:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9a:	eb 05                	jmp    801aa1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 2c                	push   $0x2c
  801ab5:	e8 4a fa ff ff       	call   801504 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
  801abd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ac0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ac4:	75 07                	jne    801acd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  801acb:	eb 05                	jmp    801ad2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 2c                	push   $0x2c
  801ae6:	e8 19 fa ff ff       	call   801504 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
  801aee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801af1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801af5:	75 07                	jne    801afe <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801af7:	b8 01 00 00 00       	mov    $0x1,%eax
  801afc:	eb 05                	jmp    801b03 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	ff 75 08             	pushl  0x8(%ebp)
  801b13:	6a 2d                	push   $0x2d
  801b15:	e8 ea f9 ff ff       	call   801504 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1d:	90                   	nop
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b24:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	53                   	push   %ebx
  801b33:	51                   	push   %ecx
  801b34:	52                   	push   %edx
  801b35:	50                   	push   %eax
  801b36:	6a 2e                	push   $0x2e
  801b38:	e8 c7 f9 ff ff       	call   801504 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	52                   	push   %edx
  801b55:	50                   	push   %eax
  801b56:	6a 2f                	push   $0x2f
  801b58:	e8 a7 f9 ff ff       	call   801504 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    
  801b62:	66 90                	xchg   %ax,%ax

00801b64 <__udivdi3>:
  801b64:	55                   	push   %ebp
  801b65:	57                   	push   %edi
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	83 ec 1c             	sub    $0x1c,%esp
  801b6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b7b:	89 ca                	mov    %ecx,%edx
  801b7d:	89 f8                	mov    %edi,%eax
  801b7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b83:	85 f6                	test   %esi,%esi
  801b85:	75 2d                	jne    801bb4 <__udivdi3+0x50>
  801b87:	39 cf                	cmp    %ecx,%edi
  801b89:	77 65                	ja     801bf0 <__udivdi3+0x8c>
  801b8b:	89 fd                	mov    %edi,%ebp
  801b8d:	85 ff                	test   %edi,%edi
  801b8f:	75 0b                	jne    801b9c <__udivdi3+0x38>
  801b91:	b8 01 00 00 00       	mov    $0x1,%eax
  801b96:	31 d2                	xor    %edx,%edx
  801b98:	f7 f7                	div    %edi
  801b9a:	89 c5                	mov    %eax,%ebp
  801b9c:	31 d2                	xor    %edx,%edx
  801b9e:	89 c8                	mov    %ecx,%eax
  801ba0:	f7 f5                	div    %ebp
  801ba2:	89 c1                	mov    %eax,%ecx
  801ba4:	89 d8                	mov    %ebx,%eax
  801ba6:	f7 f5                	div    %ebp
  801ba8:	89 cf                	mov    %ecx,%edi
  801baa:	89 fa                	mov    %edi,%edx
  801bac:	83 c4 1c             	add    $0x1c,%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5f                   	pop    %edi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    
  801bb4:	39 ce                	cmp    %ecx,%esi
  801bb6:	77 28                	ja     801be0 <__udivdi3+0x7c>
  801bb8:	0f bd fe             	bsr    %esi,%edi
  801bbb:	83 f7 1f             	xor    $0x1f,%edi
  801bbe:	75 40                	jne    801c00 <__udivdi3+0x9c>
  801bc0:	39 ce                	cmp    %ecx,%esi
  801bc2:	72 0a                	jb     801bce <__udivdi3+0x6a>
  801bc4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bc8:	0f 87 9e 00 00 00    	ja     801c6c <__udivdi3+0x108>
  801bce:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd3:	89 fa                	mov    %edi,%edx
  801bd5:	83 c4 1c             	add    $0x1c,%esp
  801bd8:	5b                   	pop    %ebx
  801bd9:	5e                   	pop    %esi
  801bda:	5f                   	pop    %edi
  801bdb:	5d                   	pop    %ebp
  801bdc:	c3                   	ret    
  801bdd:	8d 76 00             	lea    0x0(%esi),%esi
  801be0:	31 ff                	xor    %edi,%edi
  801be2:	31 c0                	xor    %eax,%eax
  801be4:	89 fa                	mov    %edi,%edx
  801be6:	83 c4 1c             	add    $0x1c,%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5f                   	pop    %edi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    
  801bee:	66 90                	xchg   %ax,%ax
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	f7 f7                	div    %edi
  801bf4:	31 ff                	xor    %edi,%edi
  801bf6:	89 fa                	mov    %edi,%edx
  801bf8:	83 c4 1c             	add    $0x1c,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5f                   	pop    %edi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    
  801c00:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c05:	89 eb                	mov    %ebp,%ebx
  801c07:	29 fb                	sub    %edi,%ebx
  801c09:	89 f9                	mov    %edi,%ecx
  801c0b:	d3 e6                	shl    %cl,%esi
  801c0d:	89 c5                	mov    %eax,%ebp
  801c0f:	88 d9                	mov    %bl,%cl
  801c11:	d3 ed                	shr    %cl,%ebp
  801c13:	89 e9                	mov    %ebp,%ecx
  801c15:	09 f1                	or     %esi,%ecx
  801c17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c1b:	89 f9                	mov    %edi,%ecx
  801c1d:	d3 e0                	shl    %cl,%eax
  801c1f:	89 c5                	mov    %eax,%ebp
  801c21:	89 d6                	mov    %edx,%esi
  801c23:	88 d9                	mov    %bl,%cl
  801c25:	d3 ee                	shr    %cl,%esi
  801c27:	89 f9                	mov    %edi,%ecx
  801c29:	d3 e2                	shl    %cl,%edx
  801c2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2f:	88 d9                	mov    %bl,%cl
  801c31:	d3 e8                	shr    %cl,%eax
  801c33:	09 c2                	or     %eax,%edx
  801c35:	89 d0                	mov    %edx,%eax
  801c37:	89 f2                	mov    %esi,%edx
  801c39:	f7 74 24 0c          	divl   0xc(%esp)
  801c3d:	89 d6                	mov    %edx,%esi
  801c3f:	89 c3                	mov    %eax,%ebx
  801c41:	f7 e5                	mul    %ebp
  801c43:	39 d6                	cmp    %edx,%esi
  801c45:	72 19                	jb     801c60 <__udivdi3+0xfc>
  801c47:	74 0b                	je     801c54 <__udivdi3+0xf0>
  801c49:	89 d8                	mov    %ebx,%eax
  801c4b:	31 ff                	xor    %edi,%edi
  801c4d:	e9 58 ff ff ff       	jmp    801baa <__udivdi3+0x46>
  801c52:	66 90                	xchg   %ax,%ax
  801c54:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c58:	89 f9                	mov    %edi,%ecx
  801c5a:	d3 e2                	shl    %cl,%edx
  801c5c:	39 c2                	cmp    %eax,%edx
  801c5e:	73 e9                	jae    801c49 <__udivdi3+0xe5>
  801c60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c63:	31 ff                	xor    %edi,%edi
  801c65:	e9 40 ff ff ff       	jmp    801baa <__udivdi3+0x46>
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	31 c0                	xor    %eax,%eax
  801c6e:	e9 37 ff ff ff       	jmp    801baa <__udivdi3+0x46>
  801c73:	90                   	nop

00801c74 <__umoddi3>:
  801c74:	55                   	push   %ebp
  801c75:	57                   	push   %edi
  801c76:	56                   	push   %esi
  801c77:	53                   	push   %ebx
  801c78:	83 ec 1c             	sub    $0x1c,%esp
  801c7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c93:	89 f3                	mov    %esi,%ebx
  801c95:	89 fa                	mov    %edi,%edx
  801c97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c9b:	89 34 24             	mov    %esi,(%esp)
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	75 1a                	jne    801cbc <__umoddi3+0x48>
  801ca2:	39 f7                	cmp    %esi,%edi
  801ca4:	0f 86 a2 00 00 00    	jbe    801d4c <__umoddi3+0xd8>
  801caa:	89 c8                	mov    %ecx,%eax
  801cac:	89 f2                	mov    %esi,%edx
  801cae:	f7 f7                	div    %edi
  801cb0:	89 d0                	mov    %edx,%eax
  801cb2:	31 d2                	xor    %edx,%edx
  801cb4:	83 c4 1c             	add    $0x1c,%esp
  801cb7:	5b                   	pop    %ebx
  801cb8:	5e                   	pop    %esi
  801cb9:	5f                   	pop    %edi
  801cba:	5d                   	pop    %ebp
  801cbb:	c3                   	ret    
  801cbc:	39 f0                	cmp    %esi,%eax
  801cbe:	0f 87 ac 00 00 00    	ja     801d70 <__umoddi3+0xfc>
  801cc4:	0f bd e8             	bsr    %eax,%ebp
  801cc7:	83 f5 1f             	xor    $0x1f,%ebp
  801cca:	0f 84 ac 00 00 00    	je     801d7c <__umoddi3+0x108>
  801cd0:	bf 20 00 00 00       	mov    $0x20,%edi
  801cd5:	29 ef                	sub    %ebp,%edi
  801cd7:	89 fe                	mov    %edi,%esi
  801cd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cdd:	89 e9                	mov    %ebp,%ecx
  801cdf:	d3 e0                	shl    %cl,%eax
  801ce1:	89 d7                	mov    %edx,%edi
  801ce3:	89 f1                	mov    %esi,%ecx
  801ce5:	d3 ef                	shr    %cl,%edi
  801ce7:	09 c7                	or     %eax,%edi
  801ce9:	89 e9                	mov    %ebp,%ecx
  801ceb:	d3 e2                	shl    %cl,%edx
  801ced:	89 14 24             	mov    %edx,(%esp)
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	d3 e0                	shl    %cl,%eax
  801cf4:	89 c2                	mov    %eax,%edx
  801cf6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cfa:	d3 e0                	shl    %cl,%eax
  801cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d00:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d04:	89 f1                	mov    %esi,%ecx
  801d06:	d3 e8                	shr    %cl,%eax
  801d08:	09 d0                	or     %edx,%eax
  801d0a:	d3 eb                	shr    %cl,%ebx
  801d0c:	89 da                	mov    %ebx,%edx
  801d0e:	f7 f7                	div    %edi
  801d10:	89 d3                	mov    %edx,%ebx
  801d12:	f7 24 24             	mull   (%esp)
  801d15:	89 c6                	mov    %eax,%esi
  801d17:	89 d1                	mov    %edx,%ecx
  801d19:	39 d3                	cmp    %edx,%ebx
  801d1b:	0f 82 87 00 00 00    	jb     801da8 <__umoddi3+0x134>
  801d21:	0f 84 91 00 00 00    	je     801db8 <__umoddi3+0x144>
  801d27:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d2b:	29 f2                	sub    %esi,%edx
  801d2d:	19 cb                	sbb    %ecx,%ebx
  801d2f:	89 d8                	mov    %ebx,%eax
  801d31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d35:	d3 e0                	shl    %cl,%eax
  801d37:	89 e9                	mov    %ebp,%ecx
  801d39:	d3 ea                	shr    %cl,%edx
  801d3b:	09 d0                	or     %edx,%eax
  801d3d:	89 e9                	mov    %ebp,%ecx
  801d3f:	d3 eb                	shr    %cl,%ebx
  801d41:	89 da                	mov    %ebx,%edx
  801d43:	83 c4 1c             	add    $0x1c,%esp
  801d46:	5b                   	pop    %ebx
  801d47:	5e                   	pop    %esi
  801d48:	5f                   	pop    %edi
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    
  801d4b:	90                   	nop
  801d4c:	89 fd                	mov    %edi,%ebp
  801d4e:	85 ff                	test   %edi,%edi
  801d50:	75 0b                	jne    801d5d <__umoddi3+0xe9>
  801d52:	b8 01 00 00 00       	mov    $0x1,%eax
  801d57:	31 d2                	xor    %edx,%edx
  801d59:	f7 f7                	div    %edi
  801d5b:	89 c5                	mov    %eax,%ebp
  801d5d:	89 f0                	mov    %esi,%eax
  801d5f:	31 d2                	xor    %edx,%edx
  801d61:	f7 f5                	div    %ebp
  801d63:	89 c8                	mov    %ecx,%eax
  801d65:	f7 f5                	div    %ebp
  801d67:	89 d0                	mov    %edx,%eax
  801d69:	e9 44 ff ff ff       	jmp    801cb2 <__umoddi3+0x3e>
  801d6e:	66 90                	xchg   %ax,%ax
  801d70:	89 c8                	mov    %ecx,%eax
  801d72:	89 f2                	mov    %esi,%edx
  801d74:	83 c4 1c             	add    $0x1c,%esp
  801d77:	5b                   	pop    %ebx
  801d78:	5e                   	pop    %esi
  801d79:	5f                   	pop    %edi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    
  801d7c:	3b 04 24             	cmp    (%esp),%eax
  801d7f:	72 06                	jb     801d87 <__umoddi3+0x113>
  801d81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d85:	77 0f                	ja     801d96 <__umoddi3+0x122>
  801d87:	89 f2                	mov    %esi,%edx
  801d89:	29 f9                	sub    %edi,%ecx
  801d8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d8f:	89 14 24             	mov    %edx,(%esp)
  801d92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d96:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d9a:	8b 14 24             	mov    (%esp),%edx
  801d9d:	83 c4 1c             	add    $0x1c,%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5f                   	pop    %edi
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    
  801da5:	8d 76 00             	lea    0x0(%esi),%esi
  801da8:	2b 04 24             	sub    (%esp),%eax
  801dab:	19 fa                	sbb    %edi,%edx
  801dad:	89 d1                	mov    %edx,%ecx
  801daf:	89 c6                	mov    %eax,%esi
  801db1:	e9 71 ff ff ff       	jmp    801d27 <__umoddi3+0xb3>
  801db6:	66 90                	xchg   %ax,%ax
  801db8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dbc:	72 ea                	jb     801da8 <__umoddi3+0x134>
  801dbe:	89 d9                	mov    %ebx,%ecx
  801dc0:	e9 62 ff ff ff       	jmp    801d27 <__umoddi3+0xb3>
