
obj/user/tst_placement_3:     file format elf32-i386


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
  800031:	e8 ac 03 00 00       	call   8003e2 <libmain>
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

	char arr[PAGE_SIZE*1024*4];
	int x = 0;
  800043:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 actual_active_list[13] = {0xedbfdb78,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  80004a:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  800050:	b9 0d 00 00 00       	mov    $0xd,%ecx
  800055:	b8 00 00 00 00       	mov    $0x0,%eax
  80005a:	89 d7                	mov    %edx,%edi
  80005c:	f3 ab                	rep stos %eax,%es:(%edi)
  80005e:	c7 85 a4 ff ff fe 78 	movl   $0xedbfdb78,-0x100005c(%ebp)
  800065:	db bf ed 
  800068:	c7 85 a8 ff ff fe 00 	movl   $0xeebfd000,-0x1000058(%ebp)
  80006f:	d0 bf ee 
  800072:	c7 85 ac ff ff fe 00 	movl   $0x803000,-0x1000054(%ebp)
  800079:	30 80 00 
  80007c:	c7 85 b0 ff ff fe 00 	movl   $0x802000,-0x1000050(%ebp)
  800083:	20 80 00 
  800086:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  80008d:	10 80 00 
  800090:	c7 85 b8 ff ff fe 00 	movl   $0x800000,-0x1000048(%ebp)
  800097:	00 80 00 
  80009a:	c7 85 bc ff ff fe 00 	movl   $0x205000,-0x1000044(%ebp)
  8000a1:	50 20 00 
  8000a4:	c7 85 c0 ff ff fe 00 	movl   $0x204000,-0x1000040(%ebp)
  8000ab:	40 20 00 
  8000ae:	c7 85 c4 ff ff fe 00 	movl   $0x203000,-0x100003c(%ebp)
  8000b5:	30 20 00 
  8000b8:	c7 85 c8 ff ff fe 00 	movl   $0x202000,-0x1000038(%ebp)
  8000bf:	20 20 00 
  8000c2:	c7 85 cc ff ff fe 00 	movl   $0x201000,-0x1000034(%ebp)
  8000c9:	10 20 00 
  8000cc:	c7 85 d0 ff ff fe 00 	movl   $0x200000,-0x1000030(%ebp)
  8000d3:	00 20 00 
	uint32 actual_second_list[7] = {};
  8000d6:	8d 95 88 ff ff fe    	lea    -0x1000078(%ebp),%edx
  8000dc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000ea:	6a 00                	push   $0x0
  8000ec:	6a 0c                	push   $0xc
  8000ee:	8d 85 88 ff ff fe    	lea    -0x1000078(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	8d 85 a4 ff ff fe    	lea    -0x100005c(%ebp),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 8a 1a 00 00       	call   801b8b <sys_check_LRU_lists>
  800101:	83 c4 10             	add    $0x10,%esp
  800104:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(check == 0)
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80010b:	75 14                	jne    800121 <_main+0xe9>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 40 1e 80 00       	push   $0x801e40
  800115:	6a 14                	push   $0x14
  800117:	68 8f 1e 80 00       	push   $0x801e8f
  80011c:	e8 10 04 00 00       	call   800531 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800121:	e8 d5 15 00 00       	call   8016fb <sys_pf_calculate_allocated_pages>
  800126:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freePages = sys_calculate_free_frames();
  800129:	e8 2d 15 00 00       	call   80165b <sys_calculate_free_frames>
  80012e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int i=0;
  800131:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800138:	eb 11                	jmp    80014b <_main+0x113>
	{
		arr[i] = -1;
  80013a:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800143:	01 d0                	add    %edx,%eax
  800145:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800148:	ff 45 f4             	incl   -0xc(%ebp)
  80014b:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800152:	7e e6                	jle    80013a <_main+0x102>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800154:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80015b:	eb 11                	jmp    80016e <_main+0x136>
	{
		arr[i] = -1;
  80015d:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80016b:	ff 45 f4             	incl   -0xc(%ebp)
  80016e:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  800175:	7e e6                	jle    80015d <_main+0x125>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800177:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80017e:	eb 11                	jmp    800191 <_main+0x159>
	{
		arr[i] = -1;
  800180:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800189:	01 d0                	add    %edx,%eax
  80018b:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80018e:	ff 45 f4             	incl   -0xc(%ebp)
  800191:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  800198:	7e e6                	jle    800180 <_main+0x148>
	{
		arr[i] = -1;
	}

	uint32* secondlistVA= (uint32*)0x200000;
  80019a:	c7 45 dc 00 00 20 00 	movl   $0x200000,-0x24(%ebp)
	x = x + *secondlistVA;
  8001a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a4:	8b 10                	mov    (%eax),%edx
  8001a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a9:	01 d0                	add    %edx,%eax
  8001ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
	secondlistVA = (uint32*) 0x202000;
  8001ae:	c7 45 dc 00 20 20 00 	movl   $0x202000,-0x24(%ebp)
	x = x + *secondlistVA;
  8001b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b8:	8b 10                	mov    (%eax),%edx
  8001ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	actual_second_list[0]=0X205000;
  8001c2:	c7 85 88 ff ff fe 00 	movl   $0x205000,-0x1000078(%ebp)
  8001c9:	50 20 00 
	actual_second_list[1]=0X204000;
  8001cc:	c7 85 8c ff ff fe 00 	movl   $0x204000,-0x1000074(%ebp)
  8001d3:	40 20 00 
	actual_second_list[2]=0x203000;
  8001d6:	c7 85 90 ff ff fe 00 	movl   $0x203000,-0x1000070(%ebp)
  8001dd:	30 20 00 
	actual_second_list[3]=0x201000;
  8001e0:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  8001e7:	10 20 00 
	for (int i=12;i>6;i--)
  8001ea:	c7 45 f0 0c 00 00 00 	movl   $0xc,-0x10(%ebp)
  8001f1:	eb 1a                	jmp    80020d <_main+0x1d5>
		actual_active_list[i]=actual_active_list[i-7];
  8001f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001f6:	83 e8 07             	sub    $0x7,%eax
  8001f9:	8b 94 85 a4 ff ff fe 	mov    -0x100005c(%ebp,%eax,4),%edx
  800200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800203:	89 94 85 a4 ff ff fe 	mov    %edx,-0x100005c(%ebp,%eax,4)

	actual_second_list[0]=0X205000;
	actual_second_list[1]=0X204000;
	actual_second_list[2]=0x203000;
	actual_second_list[3]=0x201000;
	for (int i=12;i>6;i--)
  80020a:	ff 4d f0             	decl   -0x10(%ebp)
  80020d:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
  800211:	7f e0                	jg     8001f3 <_main+0x1bb>
		actual_active_list[i]=actual_active_list[i-7];

	actual_active_list[0]=0x202000;
  800213:	c7 85 a4 ff ff fe 00 	movl   $0x202000,-0x100005c(%ebp)
  80021a:	20 20 00 
	actual_active_list[1]=0x200000;
  80021d:	c7 85 a8 ff ff fe 00 	movl   $0x200000,-0x1000058(%ebp)
  800224:	00 20 00 
	actual_active_list[2]=0xee3fe000;
  800227:	c7 85 ac ff ff fe 00 	movl   $0xee3fe000,-0x1000054(%ebp)
  80022e:	e0 3f ee 
	actual_active_list[3]=0xee3fdfa0;
  800231:	c7 85 b0 ff ff fe a0 	movl   $0xee3fdfa0,-0x1000050(%ebp)
  800238:	df 3f ee 
	actual_active_list[4]=0xedffe000;
  80023b:	c7 85 b4 ff ff fe 00 	movl   $0xedffe000,-0x100004c(%ebp)
  800242:	e0 ff ed 
	actual_active_list[5]=0xedffdfa0;
  800245:	c7 85 b8 ff ff fe a0 	movl   $0xedffdfa0,-0x1000048(%ebp)
  80024c:	df ff ed 
	actual_active_list[6]=0xedbfe000;
  80024f:	c7 85 bc ff ff fe 00 	movl   $0xedbfe000,-0x1000044(%ebp)
  800256:	e0 bf ed 

	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	68 a8 1e 80 00       	push   $0x801ea8
  800261:	e8 7f 05 00 00       	call   8007e5 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  800269:	8a 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%al
  80026f:	3c ff                	cmp    $0xff,%al
  800271:	74 14                	je     800287 <_main+0x24f>
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 d8 1e 80 00       	push   $0x801ed8
  80027b:	6a 42                	push   $0x42
  80027d:	68 8f 1e 80 00       	push   $0x801e8f
  800282:	e8 aa 02 00 00       	call   800531 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800287:	8a 85 d8 0f 00 ff    	mov    -0xfff028(%ebp),%al
  80028d:	3c ff                	cmp    $0xff,%al
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 d8 1e 80 00       	push   $0x801ed8
  800299:	6a 43                	push   $0x43
  80029b:	68 8f 1e 80 00       	push   $0x801e8f
  8002a0:	e8 8c 02 00 00       	call   800531 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8002a5:	8a 85 d8 ff 3f ff    	mov    -0xc00028(%ebp),%al
  8002ab:	3c ff                	cmp    $0xff,%al
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 d8 1e 80 00       	push   $0x801ed8
  8002b7:	6a 45                	push   $0x45
  8002b9:	68 8f 1e 80 00       	push   $0x801e8f
  8002be:	e8 6e 02 00 00       	call   800531 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8002c3:	8a 85 d8 0f 40 ff    	mov    -0xbff028(%ebp),%al
  8002c9:	3c ff                	cmp    $0xff,%al
  8002cb:	74 14                	je     8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 d8 1e 80 00       	push   $0x801ed8
  8002d5:	6a 46                	push   $0x46
  8002d7:	68 8f 1e 80 00       	push   $0x801e8f
  8002dc:	e8 50 02 00 00       	call   800531 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  8002e1:	8a 85 d8 ff 7f ff    	mov    -0x800028(%ebp),%al
  8002e7:	3c ff                	cmp    $0xff,%al
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 d8 1e 80 00       	push   $0x801ed8
  8002f3:	6a 48                	push   $0x48
  8002f5:	68 8f 1e 80 00       	push   $0x801e8f
  8002fa:	e8 32 02 00 00       	call   800531 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8002ff:	8a 85 d8 0f 80 ff    	mov    -0x7ff028(%ebp),%al
  800305:	3c ff                	cmp    $0xff,%al
  800307:	74 14                	je     80031d <_main+0x2e5>
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 d8 1e 80 00       	push   $0x801ed8
  800311:	6a 49                	push   $0x49
  800313:	68 8f 1e 80 00       	push   $0x801e8f
  800318:	e8 14 02 00 00       	call   800531 <_panic>

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  80031d:	e8 d9 13 00 00       	call   8016fb <sys_pf_calculate_allocated_pages>
  800322:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800325:	83 f8 05             	cmp    $0x5,%eax
  800328:	74 14                	je     80033e <_main+0x306>
  80032a:	83 ec 04             	sub    $0x4,%esp
  80032d:	68 f8 1e 80 00       	push   $0x801ef8
  800332:	6a 4b                	push   $0x4b
  800334:	68 8f 1e 80 00       	push   $0x801e8f
  800339:	e8 f3 01 00 00       	call   800531 <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  80033e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800341:	e8 15 13 00 00       	call   80165b <sys_calculate_free_frames>
  800346:	29 c3                	sub    %eax,%ebx
  800348:	89 d8                	mov    %ebx,%eax
  80034a:	83 f8 09             	cmp    $0x9,%eax
  80034d:	74 14                	je     800363 <_main+0x32b>
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	68 28 1f 80 00       	push   $0x801f28
  800357:	6a 4d                	push   $0x4d
  800359:	68 8f 1e 80 00       	push   $0x801e8f
  80035e:	e8 ce 01 00 00       	call   800531 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 48 1f 80 00       	push   $0x801f48
  80036b:	e8 75 04 00 00       	call   8007e5 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking LRU lists entries After Required PAGES IN SECOND LIST...\n");
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	68 7c 1f 80 00       	push   $0x801f7c
  80037b:	e8 65 04 00 00       	call   8007e5 <cprintf>
  800380:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  800383:	6a 04                	push   $0x4
  800385:	6a 0d                	push   $0xd
  800387:	8d 85 88 ff ff fe    	lea    -0x1000078(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 a4 ff ff fe    	lea    -0x100005c(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 f1 17 00 00       	call   801b8b <sys_check_LRU_lists>
  80039a:	83 c4 10             	add    $0x10,%esp
  80039d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if(check == 0)
  8003a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8003a4:	75 14                	jne    8003ba <_main+0x382>
				panic("LRU lists entries are not correct, check your logic again!!");
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 c8 1f 80 00       	push   $0x801fc8
  8003ae:	6a 55                	push   $0x55
  8003b0:	68 8f 1e 80 00       	push   $0x801e8f
  8003b5:	e8 77 01 00 00       	call   800531 <_panic>
	}
	cprintf("STEP B passed: checking LRU lists entries After Required PAGES IN SECOND LIST test are correct\n\n\n");
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	68 04 20 80 00       	push   $0x802004
  8003c2:	e8 1e 04 00 00       	call   8007e5 <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of PAGE PLACEMENT THIRD SCENARIO completed successfully!!\n\n\n");
  8003ca:	83 ec 0c             	sub    $0xc,%esp
  8003cd:	68 68 20 80 00       	push   $0x802068
  8003d2:	e8 0e 04 00 00       	call   8007e5 <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
	return;
  8003da:	90                   	nop
}
  8003db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003de:	5b                   	pop    %ebx
  8003df:	5f                   	pop    %edi
  8003e0:	5d                   	pop    %ebp
  8003e1:	c3                   	ret    

008003e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003e8:	e8 4e 15 00 00       	call   80193b <sys_getenvindex>
  8003ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003f3:	89 d0                	mov    %edx,%eax
  8003f5:	01 c0                	add    %eax,%eax
  8003f7:	01 d0                	add    %edx,%eax
  8003f9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800400:	01 c8                	add    %ecx,%eax
  800402:	c1 e0 02             	shl    $0x2,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80040e:	01 c8                	add    %ecx,%eax
  800410:	c1 e0 02             	shl    $0x2,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 02             	shl    $0x2,%eax
  800418:	01 d0                	add    %edx,%eax
  80041a:	c1 e0 03             	shl    $0x3,%eax
  80041d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800422:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800427:	a1 20 30 80 00       	mov    0x803020,%eax
  80042c:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800432:	84 c0                	test   %al,%al
  800434:	74 0f                	je     800445 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800436:	a1 20 30 80 00       	mov    0x803020,%eax
  80043b:	05 18 da 01 00       	add    $0x1da18,%eax
  800440:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800445:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800449:	7e 0a                	jle    800455 <libmain+0x73>
		binaryname = argv[0];
  80044b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	ff 75 0c             	pushl  0xc(%ebp)
  80045b:	ff 75 08             	pushl  0x8(%ebp)
  80045e:	e8 d5 fb ff ff       	call   800038 <_main>
  800463:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800466:	e8 dd 12 00 00       	call   801748 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80046b:	83 ec 0c             	sub    $0xc,%esp
  80046e:	68 d4 20 80 00       	push   $0x8020d4
  800473:	e8 6d 03 00 00       	call   8007e5 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80047b:	a1 20 30 80 00       	mov    0x803020,%eax
  800480:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800486:	a1 20 30 80 00       	mov    0x803020,%eax
  80048b:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	52                   	push   %edx
  800495:	50                   	push   %eax
  800496:	68 fc 20 80 00       	push   $0x8020fc
  80049b:	e8 45 03 00 00       	call   8007e5 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a8:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8004ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b3:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8004b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004be:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8004c4:	51                   	push   %ecx
  8004c5:	52                   	push   %edx
  8004c6:	50                   	push   %eax
  8004c7:	68 24 21 80 00       	push   $0x802124
  8004cc:	e8 14 03 00 00       	call   8007e5 <cprintf>
  8004d1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d9:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	50                   	push   %eax
  8004e3:	68 7c 21 80 00       	push   $0x80217c
  8004e8:	e8 f8 02 00 00       	call   8007e5 <cprintf>
  8004ed:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004f0:	83 ec 0c             	sub    $0xc,%esp
  8004f3:	68 d4 20 80 00       	push   $0x8020d4
  8004f8:	e8 e8 02 00 00       	call   8007e5 <cprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800500:	e8 5d 12 00 00       	call   801762 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800505:	e8 19 00 00 00       	call   800523 <exit>
}
  80050a:	90                   	nop
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	6a 00                	push   $0x0
  800518:	e8 ea 13 00 00       	call   801907 <sys_destroy_env>
  80051d:	83 c4 10             	add    $0x10,%esp
}
  800520:	90                   	nop
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <exit>:

void
exit(void)
{
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800529:	e8 3f 14 00 00       	call   80196d <sys_exit_env>
}
  80052e:	90                   	nop
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800537:	8d 45 10             	lea    0x10(%ebp),%eax
  80053a:	83 c0 04             	add    $0x4,%eax
  80053d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800540:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800545:	85 c0                	test   %eax,%eax
  800547:	74 16                	je     80055f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800549:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	50                   	push   %eax
  800552:	68 90 21 80 00       	push   $0x802190
  800557:	e8 89 02 00 00       	call   8007e5 <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80055f:	a1 00 30 80 00       	mov    0x803000,%eax
  800564:	ff 75 0c             	pushl  0xc(%ebp)
  800567:	ff 75 08             	pushl  0x8(%ebp)
  80056a:	50                   	push   %eax
  80056b:	68 95 21 80 00       	push   $0x802195
  800570:	e8 70 02 00 00       	call   8007e5 <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800578:	8b 45 10             	mov    0x10(%ebp),%eax
  80057b:	83 ec 08             	sub    $0x8,%esp
  80057e:	ff 75 f4             	pushl  -0xc(%ebp)
  800581:	50                   	push   %eax
  800582:	e8 f3 01 00 00       	call   80077a <vcprintf>
  800587:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	6a 00                	push   $0x0
  80058f:	68 b1 21 80 00       	push   $0x8021b1
  800594:	e8 e1 01 00 00       	call   80077a <vcprintf>
  800599:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80059c:	e8 82 ff ff ff       	call   800523 <exit>

	// should not return here
	while (1) ;
  8005a1:	eb fe                	jmp    8005a1 <_panic+0x70>

008005a3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ae:	8b 50 74             	mov    0x74(%eax),%edx
  8005b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b4:	39 c2                	cmp    %eax,%edx
  8005b6:	74 14                	je     8005cc <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 b4 21 80 00       	push   $0x8021b4
  8005c0:	6a 26                	push   $0x26
  8005c2:	68 00 22 80 00       	push   $0x802200
  8005c7:	e8 65 ff ff ff       	call   800531 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005da:	e9 c2 00 00 00       	jmp    8006a1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	85 c0                	test   %eax,%eax
  8005f2:	75 08                	jne    8005fc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005f4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005f7:	e9 a2 00 00 00       	jmp    80069e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800603:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80060a:	eb 69                	jmp    800675 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80060c:	a1 20 30 80 00       	mov    0x803020,%eax
  800611:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800617:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80061a:	89 d0                	mov    %edx,%eax
  80061c:	01 c0                	add    %eax,%eax
  80061e:	01 d0                	add    %edx,%eax
  800620:	c1 e0 03             	shl    $0x3,%eax
  800623:	01 c8                	add    %ecx,%eax
  800625:	8a 40 04             	mov    0x4(%eax),%al
  800628:	84 c0                	test   %al,%al
  80062a:	75 46                	jne    800672 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80062c:	a1 20 30 80 00       	mov    0x803020,%eax
  800631:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800637:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80063a:	89 d0                	mov    %edx,%eax
  80063c:	01 c0                	add    %eax,%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	c1 e0 03             	shl    $0x3,%eax
  800643:	01 c8                	add    %ecx,%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80064a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800652:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	01 c8                	add    %ecx,%eax
  800663:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800665:	39 c2                	cmp    %eax,%edx
  800667:	75 09                	jne    800672 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800669:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800670:	eb 12                	jmp    800684 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800672:	ff 45 e8             	incl   -0x18(%ebp)
  800675:	a1 20 30 80 00       	mov    0x803020,%eax
  80067a:	8b 50 74             	mov    0x74(%eax),%edx
  80067d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800680:	39 c2                	cmp    %eax,%edx
  800682:	77 88                	ja     80060c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800684:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800688:	75 14                	jne    80069e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	68 0c 22 80 00       	push   $0x80220c
  800692:	6a 3a                	push   $0x3a
  800694:	68 00 22 80 00       	push   $0x802200
  800699:	e8 93 fe ff ff       	call   800531 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80069e:	ff 45 f0             	incl   -0x10(%ebp)
  8006a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a7:	0f 8c 32 ff ff ff    	jl     8005df <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006bb:	eb 26                	jmp    8006e3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8006c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006cb:	89 d0                	mov    %edx,%eax
  8006cd:	01 c0                	add    %eax,%eax
  8006cf:	01 d0                	add    %edx,%eax
  8006d1:	c1 e0 03             	shl    $0x3,%eax
  8006d4:	01 c8                	add    %ecx,%eax
  8006d6:	8a 40 04             	mov    0x4(%eax),%al
  8006d9:	3c 01                	cmp    $0x1,%al
  8006db:	75 03                	jne    8006e0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006dd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e0:	ff 45 e0             	incl   -0x20(%ebp)
  8006e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8006e8:	8b 50 74             	mov    0x74(%eax),%edx
  8006eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ee:	39 c2                	cmp    %eax,%edx
  8006f0:	77 cb                	ja     8006bd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006f8:	74 14                	je     80070e <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006fa:	83 ec 04             	sub    $0x4,%esp
  8006fd:	68 60 22 80 00       	push   $0x802260
  800702:	6a 44                	push   $0x44
  800704:	68 00 22 80 00       	push   $0x802200
  800709:	e8 23 fe ff ff       	call   800531 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80070e:	90                   	nop
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 48 01             	lea    0x1(%eax),%ecx
  80071f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800722:	89 0a                	mov    %ecx,(%edx)
  800724:	8b 55 08             	mov    0x8(%ebp),%edx
  800727:	88 d1                	mov    %dl,%cl
  800729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	3d ff 00 00 00       	cmp    $0xff,%eax
  80073a:	75 2c                	jne    800768 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80073c:	a0 24 30 80 00       	mov    0x803024,%al
  800741:	0f b6 c0             	movzbl %al,%eax
  800744:	8b 55 0c             	mov    0xc(%ebp),%edx
  800747:	8b 12                	mov    (%edx),%edx
  800749:	89 d1                	mov    %edx,%ecx
  80074b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80074e:	83 c2 08             	add    $0x8,%edx
  800751:	83 ec 04             	sub    $0x4,%esp
  800754:	50                   	push   %eax
  800755:	51                   	push   %ecx
  800756:	52                   	push   %edx
  800757:	e8 3e 0e 00 00       	call   80159a <sys_cputs>
  80075c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80075f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800762:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076b:	8b 40 04             	mov    0x4(%eax),%eax
  80076e:	8d 50 01             	lea    0x1(%eax),%edx
  800771:	8b 45 0c             	mov    0xc(%ebp),%eax
  800774:	89 50 04             	mov    %edx,0x4(%eax)
}
  800777:	90                   	nop
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800783:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80078a:	00 00 00 
	b.cnt = 0;
  80078d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800794:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	ff 75 08             	pushl  0x8(%ebp)
  80079d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007a3:	50                   	push   %eax
  8007a4:	68 11 07 80 00       	push   $0x800711
  8007a9:	e8 11 02 00 00       	call   8009bf <vprintfmt>
  8007ae:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007b1:	a0 24 30 80 00       	mov    0x803024,%al
  8007b6:	0f b6 c0             	movzbl %al,%eax
  8007b9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	50                   	push   %eax
  8007c3:	52                   	push   %edx
  8007c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ca:	83 c0 08             	add    $0x8,%eax
  8007cd:	50                   	push   %eax
  8007ce:	e8 c7 0d 00 00       	call   80159a <sys_cputs>
  8007d3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007d6:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007eb:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800801:	50                   	push   %eax
  800802:	e8 73 ff ff ff       	call   80077a <vcprintf>
  800807:	83 c4 10             	add    $0x10,%esp
  80080a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80080d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800818:	e8 2b 0f 00 00       	call   801748 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80081d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800820:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	ff 75 f4             	pushl  -0xc(%ebp)
  80082c:	50                   	push   %eax
  80082d:	e8 48 ff ff ff       	call   80077a <vcprintf>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800838:	e8 25 0f 00 00       	call   801762 <sys_enable_interrupt>
	return cnt;
  80083d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800840:	c9                   	leave  
  800841:	c3                   	ret    

00800842 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	53                   	push   %ebx
  800846:	83 ec 14             	sub    $0x14,%esp
  800849:	8b 45 10             	mov    0x10(%ebp),%eax
  80084c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800855:	8b 45 18             	mov    0x18(%ebp),%eax
  800858:	ba 00 00 00 00       	mov    $0x0,%edx
  80085d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800860:	77 55                	ja     8008b7 <printnum+0x75>
  800862:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800865:	72 05                	jb     80086c <printnum+0x2a>
  800867:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80086a:	77 4b                	ja     8008b7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80086c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80086f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800872:	8b 45 18             	mov    0x18(%ebp),%eax
  800875:	ba 00 00 00 00       	mov    $0x0,%edx
  80087a:	52                   	push   %edx
  80087b:	50                   	push   %eax
  80087c:	ff 75 f4             	pushl  -0xc(%ebp)
  80087f:	ff 75 f0             	pushl  -0x10(%ebp)
  800882:	e8 49 13 00 00       	call   801bd0 <__udivdi3>
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	83 ec 04             	sub    $0x4,%esp
  80088d:	ff 75 20             	pushl  0x20(%ebp)
  800890:	53                   	push   %ebx
  800891:	ff 75 18             	pushl  0x18(%ebp)
  800894:	52                   	push   %edx
  800895:	50                   	push   %eax
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	ff 75 08             	pushl  0x8(%ebp)
  80089c:	e8 a1 ff ff ff       	call   800842 <printnum>
  8008a1:	83 c4 20             	add    $0x20,%esp
  8008a4:	eb 1a                	jmp    8008c0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	ff 75 20             	pushl  0x20(%ebp)
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	ff d0                	call   *%eax
  8008b4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b7:	ff 4d 1c             	decl   0x1c(%ebp)
  8008ba:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008be:	7f e6                	jg     8008a6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008c0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ce:	53                   	push   %ebx
  8008cf:	51                   	push   %ecx
  8008d0:	52                   	push   %edx
  8008d1:	50                   	push   %eax
  8008d2:	e8 09 14 00 00       	call   801ce0 <__umoddi3>
  8008d7:	83 c4 10             	add    $0x10,%esp
  8008da:	05 d4 24 80 00       	add    $0x8024d4,%eax
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f be c0             	movsbl %al,%eax
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
}
  8008f3:	90                   	nop
  8008f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800900:	7e 1c                	jle    80091e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	8d 50 08             	lea    0x8(%eax),%edx
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	89 10                	mov    %edx,(%eax)
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	83 e8 08             	sub    $0x8,%eax
  800917:	8b 50 04             	mov    0x4(%eax),%edx
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	eb 40                	jmp    80095e <getuint+0x65>
	else if (lflag)
  80091e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800922:	74 1e                	je     800942 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	8d 50 04             	lea    0x4(%eax),%edx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	89 10                	mov    %edx,(%eax)
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	83 e8 04             	sub    $0x4,%eax
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	ba 00 00 00 00       	mov    $0x0,%edx
  800940:	eb 1c                	jmp    80095e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	8d 50 04             	lea    0x4(%eax),%edx
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	89 10                	mov    %edx,(%eax)
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	83 e8 04             	sub    $0x4,%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800963:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800967:	7e 1c                	jle    800985 <getint+0x25>
		return va_arg(*ap, long long);
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	8d 50 08             	lea    0x8(%eax),%edx
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	89 10                	mov    %edx,(%eax)
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	83 e8 08             	sub    $0x8,%eax
  80097e:	8b 50 04             	mov    0x4(%eax),%edx
  800981:	8b 00                	mov    (%eax),%eax
  800983:	eb 38                	jmp    8009bd <getint+0x5d>
	else if (lflag)
  800985:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800989:	74 1a                	je     8009a5 <getint+0x45>
		return va_arg(*ap, long);
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	8d 50 04             	lea    0x4(%eax),%edx
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	89 10                	mov    %edx,(%eax)
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	83 e8 04             	sub    $0x4,%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	99                   	cltd   
  8009a3:	eb 18                	jmp    8009bd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	8d 50 04             	lea    0x4(%eax),%edx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	89 10                	mov    %edx,(%eax)
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	83 e8 04             	sub    $0x4,%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	99                   	cltd   
}
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	56                   	push   %esi
  8009c3:	53                   	push   %ebx
  8009c4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c7:	eb 17                	jmp    8009e0 <vprintfmt+0x21>
			if (ch == '\0')
  8009c9:	85 db                	test   %ebx,%ebx
  8009cb:	0f 84 af 03 00 00    	je     800d80 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	53                   	push   %ebx
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	8d 50 01             	lea    0x1(%eax),%edx
  8009e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	0f b6 d8             	movzbl %al,%ebx
  8009ee:	83 fb 25             	cmp    $0x25,%ebx
  8009f1:	75 d6                	jne    8009c9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009f3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009f7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a13:	8b 45 10             	mov    0x10(%ebp),%eax
  800a16:	8d 50 01             	lea    0x1(%eax),%edx
  800a19:	89 55 10             	mov    %edx,0x10(%ebp)
  800a1c:	8a 00                	mov    (%eax),%al
  800a1e:	0f b6 d8             	movzbl %al,%ebx
  800a21:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a24:	83 f8 55             	cmp    $0x55,%eax
  800a27:	0f 87 2b 03 00 00    	ja     800d58 <vprintfmt+0x399>
  800a2d:	8b 04 85 f8 24 80 00 	mov    0x8024f8(,%eax,4),%eax
  800a34:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a36:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a3a:	eb d7                	jmp    800a13 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a3c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a40:	eb d1                	jmp    800a13 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a49:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a4c:	89 d0                	mov    %edx,%eax
  800a4e:	c1 e0 02             	shl    $0x2,%eax
  800a51:	01 d0                	add    %edx,%eax
  800a53:	01 c0                	add    %eax,%eax
  800a55:	01 d8                	add    %ebx,%eax
  800a57:	83 e8 30             	sub    $0x30,%eax
  800a5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a60:	8a 00                	mov    (%eax),%al
  800a62:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a65:	83 fb 2f             	cmp    $0x2f,%ebx
  800a68:	7e 3e                	jle    800aa8 <vprintfmt+0xe9>
  800a6a:	83 fb 39             	cmp    $0x39,%ebx
  800a6d:	7f 39                	jg     800aa8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a6f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a72:	eb d5                	jmp    800a49 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 c0 04             	add    $0x4,%eax
  800a7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	83 e8 04             	sub    $0x4,%eax
  800a83:	8b 00                	mov    (%eax),%eax
  800a85:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a88:	eb 1f                	jmp    800aa9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8e:	79 83                	jns    800a13 <vprintfmt+0x54>
				width = 0;
  800a90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a97:	e9 77 ff ff ff       	jmp    800a13 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a9c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aa3:	e9 6b ff ff ff       	jmp    800a13 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aa8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aa9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aad:	0f 89 60 ff ff ff    	jns    800a13 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ab9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ac0:	e9 4e ff ff ff       	jmp    800a13 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ac5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ac8:	e9 46 ff ff ff       	jmp    800a13 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800acd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad0:	83 c0 04             	add    $0x4,%eax
  800ad3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	83 e8 04             	sub    $0x4,%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	50                   	push   %eax
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			break;
  800aed:	e9 89 02 00 00       	jmp    800d7b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b03:	85 db                	test   %ebx,%ebx
  800b05:	79 02                	jns    800b09 <vprintfmt+0x14a>
				err = -err;
  800b07:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b09:	83 fb 64             	cmp    $0x64,%ebx
  800b0c:	7f 0b                	jg     800b19 <vprintfmt+0x15a>
  800b0e:	8b 34 9d 40 23 80 00 	mov    0x802340(,%ebx,4),%esi
  800b15:	85 f6                	test   %esi,%esi
  800b17:	75 19                	jne    800b32 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b19:	53                   	push   %ebx
  800b1a:	68 e5 24 80 00       	push   $0x8024e5
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 5e 02 00 00       	call   800d88 <printfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2d:	e9 49 02 00 00       	jmp    800d7b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b32:	56                   	push   %esi
  800b33:	68 ee 24 80 00       	push   $0x8024ee
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 45 02 00 00       	call   800d88 <printfmt>
  800b43:	83 c4 10             	add    $0x10,%esp
			break;
  800b46:	e9 30 02 00 00       	jmp    800d7b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 30                	mov    (%eax),%esi
  800b5c:	85 f6                	test   %esi,%esi
  800b5e:	75 05                	jne    800b65 <vprintfmt+0x1a6>
				p = "(null)";
  800b60:	be f1 24 80 00       	mov    $0x8024f1,%esi
			if (width > 0 && padc != '-')
  800b65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b69:	7e 6d                	jle    800bd8 <vprintfmt+0x219>
  800b6b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b6f:	74 67                	je     800bd8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	50                   	push   %eax
  800b78:	56                   	push   %esi
  800b79:	e8 0c 03 00 00       	call   800e8a <strnlen>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b84:	eb 16                	jmp    800b9c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b86:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	ff d0                	call   *%eax
  800b96:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b99:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba0:	7f e4                	jg     800b86 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba2:	eb 34                	jmp    800bd8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ba4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ba8:	74 1c                	je     800bc6 <vprintfmt+0x207>
  800baa:	83 fb 1f             	cmp    $0x1f,%ebx
  800bad:	7e 05                	jle    800bb4 <vprintfmt+0x1f5>
  800baf:	83 fb 7e             	cmp    $0x7e,%ebx
  800bb2:	7e 12                	jle    800bc6 <vprintfmt+0x207>
					putch('?', putdat);
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	6a 3f                	push   $0x3f
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	ff d0                	call   *%eax
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	eb 0f                	jmp    800bd5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd5:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd8:	89 f0                	mov    %esi,%eax
  800bda:	8d 70 01             	lea    0x1(%eax),%esi
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	0f be d8             	movsbl %al,%ebx
  800be2:	85 db                	test   %ebx,%ebx
  800be4:	74 24                	je     800c0a <vprintfmt+0x24b>
  800be6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bea:	78 b8                	js     800ba4 <vprintfmt+0x1e5>
  800bec:	ff 4d e0             	decl   -0x20(%ebp)
  800bef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf3:	79 af                	jns    800ba4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf5:	eb 13                	jmp    800c0a <vprintfmt+0x24b>
				putch(' ', putdat);
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	6a 20                	push   $0x20
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	ff d0                	call   *%eax
  800c04:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c07:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0e:	7f e7                	jg     800bf7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c10:	e9 66 01 00 00       	jmp    800d7b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c15:	83 ec 08             	sub    $0x8,%esp
  800c18:	ff 75 e8             	pushl  -0x18(%ebp)
  800c1b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1e:	50                   	push   %eax
  800c1f:	e8 3c fd ff ff       	call   800960 <getint>
  800c24:	83 c4 10             	add    $0x10,%esp
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c33:	85 d2                	test   %edx,%edx
  800c35:	79 23                	jns    800c5a <vprintfmt+0x29b>
				putch('-', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 2d                	push   $0x2d
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4d:	f7 d8                	neg    %eax
  800c4f:	83 d2 00             	adc    $0x0,%edx
  800c52:	f7 da                	neg    %edx
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c61:	e9 bc 00 00 00       	jmp    800d22 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 e8             	pushl  -0x18(%ebp)
  800c6c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	e8 84 fc ff ff       	call   8008f9 <getuint>
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c7e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c85:	e9 98 00 00 00       	jmp    800d22 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	6a 58                	push   $0x58
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	ff d0                	call   *%eax
  800c97:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ca0:	6a 58                	push   $0x58
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	ff d0                	call   *%eax
  800ca7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	6a 58                	push   $0x58
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	ff d0                	call   *%eax
  800cb7:	83 c4 10             	add    $0x10,%esp
			break;
  800cba:	e9 bc 00 00 00       	jmp    800d7b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	6a 30                	push   $0x30
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	ff d0                	call   *%eax
  800ccc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ccf:	83 ec 08             	sub    $0x8,%esp
  800cd2:	ff 75 0c             	pushl  0xc(%ebp)
  800cd5:	6a 78                	push   $0x78
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	ff d0                	call   *%eax
  800cdc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cfa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d01:	eb 1f                	jmp    800d22 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	ff 75 e8             	pushl  -0x18(%ebp)
  800d09:	8d 45 14             	lea    0x14(%ebp),%eax
  800d0c:	50                   	push   %eax
  800d0d:	e8 e7 fb ff ff       	call   8008f9 <getuint>
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d1b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d22:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d29:	83 ec 04             	sub    $0x4,%esp
  800d2c:	52                   	push   %edx
  800d2d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d30:	50                   	push   %eax
  800d31:	ff 75 f4             	pushl  -0xc(%ebp)
  800d34:	ff 75 f0             	pushl  -0x10(%ebp)
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	ff 75 08             	pushl  0x8(%ebp)
  800d3d:	e8 00 fb ff ff       	call   800842 <printnum>
  800d42:	83 c4 20             	add    $0x20,%esp
			break;
  800d45:	eb 34                	jmp    800d7b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d47:	83 ec 08             	sub    $0x8,%esp
  800d4a:	ff 75 0c             	pushl  0xc(%ebp)
  800d4d:	53                   	push   %ebx
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
			break;
  800d56:	eb 23                	jmp    800d7b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d58:	83 ec 08             	sub    $0x8,%esp
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	6a 25                	push   $0x25
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	ff d0                	call   *%eax
  800d65:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	eb 03                	jmp    800d70 <vprintfmt+0x3b1>
  800d6d:	ff 4d 10             	decl   0x10(%ebp)
  800d70:	8b 45 10             	mov    0x10(%ebp),%eax
  800d73:	48                   	dec    %eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	3c 25                	cmp    $0x25,%al
  800d78:	75 f3                	jne    800d6d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d7a:	90                   	nop
		}
	}
  800d7b:	e9 47 fc ff ff       	jmp    8009c7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d80:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d91:	83 c0 04             	add    $0x4,%eax
  800d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d97:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9d:	50                   	push   %eax
  800d9e:	ff 75 0c             	pushl  0xc(%ebp)
  800da1:	ff 75 08             	pushl  0x8(%ebp)
  800da4:	e8 16 fc ff ff       	call   8009bf <vprintfmt>
  800da9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dac:	90                   	nop
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8b 40 08             	mov    0x8(%eax),%eax
  800db8:	8d 50 01             	lea    0x1(%eax),%edx
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	8b 10                	mov    (%eax),%edx
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	8b 40 04             	mov    0x4(%eax),%eax
  800dcc:	39 c2                	cmp    %eax,%edx
  800dce:	73 12                	jae    800de2 <sprintputch+0x33>
		*b->buf++ = ch;
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	8b 00                	mov    (%eax),%eax
  800dd5:	8d 48 01             	lea    0x1(%eax),%ecx
  800dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddb:	89 0a                	mov    %ecx,(%edx)
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	88 10                	mov    %dl,(%eax)
}
  800de2:	90                   	nop
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	01 d0                	add    %edx,%eax
  800dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0a:	74 06                	je     800e12 <vsnprintf+0x2d>
  800e0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e10:	7f 07                	jg     800e19 <vsnprintf+0x34>
		return -E_INVAL;
  800e12:	b8 03 00 00 00       	mov    $0x3,%eax
  800e17:	eb 20                	jmp    800e39 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e19:	ff 75 14             	pushl  0x14(%ebp)
  800e1c:	ff 75 10             	pushl  0x10(%ebp)
  800e1f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e22:	50                   	push   %eax
  800e23:	68 af 0d 80 00       	push   $0x800daf
  800e28:	e8 92 fb ff ff       	call   8009bf <vprintfmt>
  800e2d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e33:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e41:	8d 45 10             	lea    0x10(%ebp),%eax
  800e44:	83 c0 04             	add    $0x4,%eax
  800e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e50:	50                   	push   %eax
  800e51:	ff 75 0c             	pushl  0xc(%ebp)
  800e54:	ff 75 08             	pushl  0x8(%ebp)
  800e57:	e8 89 ff ff ff       	call   800de5 <vsnprintf>
  800e5c:	83 c4 10             	add    $0x10,%esp
  800e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e74:	eb 06                	jmp    800e7c <strlen+0x15>
		n++;
  800e76:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e79:	ff 45 08             	incl   0x8(%ebp)
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8a 00                	mov    (%eax),%al
  800e81:	84 c0                	test   %al,%al
  800e83:	75 f1                	jne    800e76 <strlen+0xf>
		n++;
	return n;
  800e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e97:	eb 09                	jmp    800ea2 <strnlen+0x18>
		n++;
  800e99:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9c:	ff 45 08             	incl   0x8(%ebp)
  800e9f:	ff 4d 0c             	decl   0xc(%ebp)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 09                	je     800eb1 <strnlen+0x27>
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	84 c0                	test   %al,%al
  800eaf:	75 e8                	jne    800e99 <strnlen+0xf>
		n++;
	return n;
  800eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ec2:	90                   	nop
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	75 e4                	jne    800ec3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ef0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef7:	eb 1f                	jmp    800f18 <strncpy+0x34>
		*dst++ = *src;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 08             	mov    %edx,0x8(%ebp)
  800f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f05:	8a 12                	mov    (%edx),%dl
  800f07:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	84 c0                	test   %al,%al
  800f10:	74 03                	je     800f15 <strncpy+0x31>
			src++;
  800f12:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f1e:	72 d9                	jb     800ef9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f35:	74 30                	je     800f67 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f37:	eb 16                	jmp    800f4f <strlcpy+0x2a>
			*dst++ = *src++;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8d 50 01             	lea    0x1(%eax),%edx
  800f3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f4b:	8a 12                	mov    (%edx),%dl
  800f4d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f4f:	ff 4d 10             	decl   0x10(%ebp)
  800f52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f56:	74 09                	je     800f61 <strlcpy+0x3c>
  800f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	84 c0                	test   %al,%al
  800f5f:	75 d8                	jne    800f39 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f67:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6d:	29 c2                	sub    %eax,%edx
  800f6f:	89 d0                	mov    %edx,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f76:	eb 06                	jmp    800f7e <strcmp+0xb>
		p++, q++;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	84 c0                	test   %al,%al
  800f85:	74 0e                	je     800f95 <strcmp+0x22>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 10                	mov    (%eax),%dl
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	38 c2                	cmp    %al,%dl
  800f93:	74 e3                	je     800f78 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	0f b6 d0             	movzbl %al,%edx
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	29 c2                	sub    %eax,%edx
  800fa7:	89 d0                	mov    %edx,%eax
}
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fae:	eb 09                	jmp    800fb9 <strncmp+0xe>
		n--, p++, q++;
  800fb0:	ff 4d 10             	decl   0x10(%ebp)
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	74 17                	je     800fd6 <strncmp+0x2b>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	84 c0                	test   %al,%al
  800fc6:	74 0e                	je     800fd6 <strncmp+0x2b>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 10                	mov    (%eax),%dl
  800fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	38 c2                	cmp    %al,%dl
  800fd4:	74 da                	je     800fb0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fda:	75 07                	jne    800fe3 <strncmp+0x38>
		return 0;
  800fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe1:	eb 14                	jmp    800ff7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	0f b6 d0             	movzbl %al,%edx
  800feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	0f b6 c0             	movzbl %al,%eax
  800ff3:	29 c2                	sub    %eax,%edx
  800ff5:	89 d0                	mov    %edx,%eax
}
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	83 ec 04             	sub    $0x4,%esp
  800fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801002:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801005:	eb 12                	jmp    801019 <strchr+0x20>
		if (*s == c)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80100f:	75 05                	jne    801016 <strchr+0x1d>
			return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	eb 11                	jmp    801027 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801016:	ff 45 08             	incl   0x8(%ebp)
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	84 c0                	test   %al,%al
  801020:	75 e5                	jne    801007 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801022:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 04             	sub    $0x4,%esp
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801035:	eb 0d                	jmp    801044 <strfind+0x1b>
		if (*s == c)
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80103f:	74 0e                	je     80104f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801041:	ff 45 08             	incl   0x8(%ebp)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	84 c0                	test   %al,%al
  80104b:	75 ea                	jne    801037 <strfind+0xe>
  80104d:	eb 01                	jmp    801050 <strfind+0x27>
		if (*s == c)
			break;
  80104f:	90                   	nop
	return (char *) s;
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801053:	c9                   	leave  
  801054:	c3                   	ret    

00801055 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801061:	8b 45 10             	mov    0x10(%ebp),%eax
  801064:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801067:	eb 0e                	jmp    801077 <memset+0x22>
		*p++ = c;
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106c:	8d 50 01             	lea    0x1(%eax),%edx
  80106f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801072:	8b 55 0c             	mov    0xc(%ebp),%edx
  801075:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801077:	ff 4d f8             	decl   -0x8(%ebp)
  80107a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80107e:	79 e9                	jns    801069 <memset+0x14>
		*p++ = c;

	return v;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801083:	c9                   	leave  
  801084:	c3                   	ret    

00801085 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801097:	eb 16                	jmp    8010af <memcpy+0x2a>
		*d++ = *s++;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ab:	8a 12                	mov    (%edx),%dl
  8010ad:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	75 dd                	jne    801099 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010d9:	73 50                	jae    80112b <memmove+0x6a>
  8010db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	01 d0                	add    %edx,%eax
  8010e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e6:	76 43                	jbe    80112b <memmove+0x6a>
		s += n;
  8010e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010eb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010f4:	eb 10                	jmp    801106 <memmove+0x45>
			*--d = *--s;
  8010f6:	ff 4d f8             	decl   -0x8(%ebp)
  8010f9:	ff 4d fc             	decl   -0x4(%ebp)
  8010fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ff:	8a 10                	mov    (%eax),%dl
  801101:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801104:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801106:	8b 45 10             	mov    0x10(%ebp),%eax
  801109:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110c:	89 55 10             	mov    %edx,0x10(%ebp)
  80110f:	85 c0                	test   %eax,%eax
  801111:	75 e3                	jne    8010f6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801113:	eb 23                	jmp    801138 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	8d 50 01             	lea    0x1(%eax),%edx
  80111b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80111e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801121:	8d 4a 01             	lea    0x1(%edx),%ecx
  801124:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801127:	8a 12                	mov    (%edx),%dl
  801129:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801131:	89 55 10             	mov    %edx,0x10(%ebp)
  801134:	85 c0                	test   %eax,%eax
  801136:	75 dd                	jne    801115 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80114f:	eb 2a                	jmp    80117b <memcmp+0x3e>
		if (*s1 != *s2)
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	8a 10                	mov    (%eax),%dl
  801156:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	38 c2                	cmp    %al,%dl
  80115d:	74 16                	je     801175 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d0             	movzbl %al,%edx
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	0f b6 c0             	movzbl %al,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	eb 18                	jmp    80118d <memcmp+0x50>
		s1++, s2++;
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80117b:	8b 45 10             	mov    0x10(%ebp),%eax
  80117e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801181:	89 55 10             	mov    %edx,0x10(%ebp)
  801184:	85 c0                	test   %eax,%eax
  801186:	75 c9                	jne    801151 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801188:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801195:	8b 55 08             	mov    0x8(%ebp),%edx
  801198:	8b 45 10             	mov    0x10(%ebp),%eax
  80119b:	01 d0                	add    %edx,%eax
  80119d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011a0:	eb 15                	jmp    8011b7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	0f b6 d0             	movzbl %al,%edx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	0f b6 c0             	movzbl %al,%eax
  8011b0:	39 c2                	cmp    %eax,%edx
  8011b2:	74 0d                	je     8011c1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011bd:	72 e3                	jb     8011a2 <memfind+0x13>
  8011bf:	eb 01                	jmp    8011c2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011c1:	90                   	nop
	return (void *) s;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011db:	eb 03                	jmp    8011e0 <strtol+0x19>
		s++;
  8011dd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 20                	cmp    $0x20,%al
  8011e7:	74 f4                	je     8011dd <strtol+0x16>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 09                	cmp    $0x9,%al
  8011f0:	74 eb                	je     8011dd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 2b                	cmp    $0x2b,%al
  8011f9:	75 05                	jne    801200 <strtol+0x39>
		s++;
  8011fb:	ff 45 08             	incl   0x8(%ebp)
  8011fe:	eb 13                	jmp    801213 <strtol+0x4c>
	else if (*s == '-')
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 2d                	cmp    $0x2d,%al
  801207:	75 0a                	jne    801213 <strtol+0x4c>
		s++, neg = 1;
  801209:	ff 45 08             	incl   0x8(%ebp)
  80120c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801213:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801217:	74 06                	je     80121f <strtol+0x58>
  801219:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80121d:	75 20                	jne    80123f <strtol+0x78>
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 30                	cmp    $0x30,%al
  801226:	75 17                	jne    80123f <strtol+0x78>
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	40                   	inc    %eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	3c 78                	cmp    $0x78,%al
  801230:	75 0d                	jne    80123f <strtol+0x78>
		s += 2, base = 16;
  801232:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801236:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80123d:	eb 28                	jmp    801267 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80123f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801243:	75 15                	jne    80125a <strtol+0x93>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	3c 30                	cmp    $0x30,%al
  80124c:	75 0c                	jne    80125a <strtol+0x93>
		s++, base = 8;
  80124e:	ff 45 08             	incl   0x8(%ebp)
  801251:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801258:	eb 0d                	jmp    801267 <strtol+0xa0>
	else if (base == 0)
  80125a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125e:	75 07                	jne    801267 <strtol+0xa0>
		base = 10;
  801260:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 2f                	cmp    $0x2f,%al
  80126e:	7e 19                	jle    801289 <strtol+0xc2>
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 39                	cmp    $0x39,%al
  801277:	7f 10                	jg     801289 <strtol+0xc2>
			dig = *s - '0';
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	83 e8 30             	sub    $0x30,%eax
  801284:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801287:	eb 42                	jmp    8012cb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 60                	cmp    $0x60,%al
  801290:	7e 19                	jle    8012ab <strtol+0xe4>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3c 7a                	cmp    $0x7a,%al
  801299:	7f 10                	jg     8012ab <strtol+0xe4>
			dig = *s - 'a' + 10;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	0f be c0             	movsbl %al,%eax
  8012a3:	83 e8 57             	sub    $0x57,%eax
  8012a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a9:	eb 20                	jmp    8012cb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 40                	cmp    $0x40,%al
  8012b2:	7e 39                	jle    8012ed <strtol+0x126>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 5a                	cmp    $0x5a,%al
  8012bb:	7f 30                	jg     8012ed <strtol+0x126>
			dig = *s - 'A' + 10;
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	0f be c0             	movsbl %al,%eax
  8012c5:	83 e8 37             	sub    $0x37,%eax
  8012c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ce:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012d1:	7d 19                	jge    8012ec <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012d3:	ff 45 08             	incl   0x8(%ebp)
  8012d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012dd:	89 c2                	mov    %eax,%edx
  8012df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e2:	01 d0                	add    %edx,%eax
  8012e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012e7:	e9 7b ff ff ff       	jmp    801267 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ec:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f1:	74 08                	je     8012fb <strtol+0x134>
		*endptr = (char *) s;
  8012f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ff:	74 07                	je     801308 <strtol+0x141>
  801301:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801304:	f7 d8                	neg    %eax
  801306:	eb 03                	jmp    80130b <strtol+0x144>
  801308:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <ltostr>:

void
ltostr(long value, char *str)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801313:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80131a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801325:	79 13                	jns    80133a <ltostr+0x2d>
	{
		neg = 1;
  801327:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801334:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801337:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801342:	99                   	cltd   
  801343:	f7 f9                	idiv   %ecx
  801345:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	8d 50 01             	lea    0x1(%eax),%edx
  80134e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80135b:	83 c2 30             	add    $0x30,%edx
  80135e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801360:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801363:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801368:	f7 e9                	imul   %ecx
  80136a:	c1 fa 02             	sar    $0x2,%edx
  80136d:	89 c8                	mov    %ecx,%eax
  80136f:	c1 f8 1f             	sar    $0x1f,%eax
  801372:	29 c2                	sub    %eax,%edx
  801374:	89 d0                	mov    %edx,%eax
  801376:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801381:	f7 e9                	imul   %ecx
  801383:	c1 fa 02             	sar    $0x2,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	c1 f8 1f             	sar    $0x1f,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	c1 e0 02             	shl    $0x2,%eax
  801392:	01 d0                	add    %edx,%eax
  801394:	01 c0                	add    %eax,%eax
  801396:	29 c1                	sub    %eax,%ecx
  801398:	89 ca                	mov    %ecx,%edx
  80139a:	85 d2                	test   %edx,%edx
  80139c:	75 9c                	jne    80133a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80139e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a8:	48                   	dec    %eax
  8013a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b0:	74 3d                	je     8013ef <ltostr+0xe2>
		start = 1 ;
  8013b2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b9:	eb 34                	jmp    8013ef <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	01 d0                	add    %edx,%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	01 c2                	add    %eax,%edx
  8013d0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	01 c8                	add    %ecx,%eax
  8013d8:	8a 00                	mov    (%eax),%al
  8013da:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013e7:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ec:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f5:	7c c4                	jl     8013bb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80140b:	ff 75 08             	pushl  0x8(%ebp)
  80140e:	e8 54 fa ff ff       	call   800e67 <strlen>
  801413:	83 c4 04             	add    $0x4,%esp
  801416:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801419:	ff 75 0c             	pushl  0xc(%ebp)
  80141c:	e8 46 fa ff ff       	call   800e67 <strlen>
  801421:	83 c4 04             	add    $0x4,%esp
  801424:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801427:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80142e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801435:	eb 17                	jmp    80144e <strcconcat+0x49>
		final[s] = str1[s] ;
  801437:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143a:	8b 45 10             	mov    0x10(%ebp),%eax
  80143d:	01 c2                	add    %eax,%edx
  80143f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	01 c8                	add    %ecx,%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80144b:	ff 45 fc             	incl   -0x4(%ebp)
  80144e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801451:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801454:	7c e1                	jl     801437 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801456:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80145d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801464:	eb 1f                	jmp    801485 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801466:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801469:	8d 50 01             	lea    0x1(%eax),%edx
  80146c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146f:	89 c2                	mov    %eax,%edx
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	01 c2                	add    %eax,%edx
  801476:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	01 c8                	add    %ecx,%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801482:	ff 45 f8             	incl   -0x8(%ebp)
  801485:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801488:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80148b:	7c d9                	jl     801466 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80148d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801490:	8b 45 10             	mov    0x10(%ebp),%eax
  801493:	01 d0                	add    %edx,%eax
  801495:	c6 00 00             	movb   $0x0,(%eax)
}
  801498:	90                   	nop
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80149e:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014aa:	8b 00                	mov    (%eax),%eax
  8014ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014be:	eb 0c                	jmp    8014cc <strsplit+0x31>
			*string++ = 0;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8d 50 01             	lea    0x1(%eax),%edx
  8014c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	84 c0                	test   %al,%al
  8014d3:	74 18                	je     8014ed <strsplit+0x52>
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	0f be c0             	movsbl %al,%eax
  8014dd:	50                   	push   %eax
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	e8 13 fb ff ff       	call   800ff9 <strchr>
  8014e6:	83 c4 08             	add    $0x8,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	75 d3                	jne    8014c0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	8a 00                	mov    (%eax),%al
  8014f2:	84 c0                	test   %al,%al
  8014f4:	74 5a                	je     801550 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	83 f8 0f             	cmp    $0xf,%eax
  8014fe:	75 07                	jne    801507 <strsplit+0x6c>
		{
			return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
  801505:	eb 66                	jmp    80156d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801507:	8b 45 14             	mov    0x14(%ebp),%eax
  80150a:	8b 00                	mov    (%eax),%eax
  80150c:	8d 48 01             	lea    0x1(%eax),%ecx
  80150f:	8b 55 14             	mov    0x14(%ebp),%edx
  801512:	89 0a                	mov    %ecx,(%edx)
  801514:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151b:	8b 45 10             	mov    0x10(%ebp),%eax
  80151e:	01 c2                	add    %eax,%edx
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801525:	eb 03                	jmp    80152a <strsplit+0x8f>
			string++;
  801527:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 8b                	je     8014be <strsplit+0x23>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	0f be c0             	movsbl %al,%eax
  80153b:	50                   	push   %eax
  80153c:	ff 75 0c             	pushl  0xc(%ebp)
  80153f:	e8 b5 fa ff ff       	call   800ff9 <strchr>
  801544:	83 c4 08             	add    $0x8,%esp
  801547:	85 c0                	test   %eax,%eax
  801549:	74 dc                	je     801527 <strsplit+0x8c>
			string++;
	}
  80154b:	e9 6e ff ff ff       	jmp    8014be <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801550:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801551:	8b 45 14             	mov    0x14(%ebp),%eax
  801554:	8b 00                	mov    (%eax),%eax
  801556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	01 d0                	add    %edx,%eax
  801562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801568:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	57                   	push   %edi
  801573:	56                   	push   %esi
  801574:	53                   	push   %ebx
  801575:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801581:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801584:	8b 7d 18             	mov    0x18(%ebp),%edi
  801587:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80158a:	cd 30                	int    $0x30
  80158c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	5b                   	pop    %ebx
  801596:	5e                   	pop    %esi
  801597:	5f                   	pop    %edi
  801598:	5d                   	pop    %ebp
  801599:	c3                   	ret    

0080159a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015a6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	52                   	push   %edx
  8015b2:	ff 75 0c             	pushl  0xc(%ebp)
  8015b5:	50                   	push   %eax
  8015b6:	6a 00                	push   $0x0
  8015b8:	e8 b2 ff ff ff       	call   80156f <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	90                   	nop
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 01                	push   $0x1
  8015d2:	e8 98 ff ff ff       	call   80156f <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	52                   	push   %edx
  8015ec:	50                   	push   %eax
  8015ed:	6a 05                	push   $0x5
  8015ef:	e8 7b ff ff ff       	call   80156f <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	56                   	push   %esi
  8015fd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015fe:	8b 75 18             	mov    0x18(%ebp),%esi
  801601:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801604:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	56                   	push   %esi
  80160e:	53                   	push   %ebx
  80160f:	51                   	push   %ecx
  801610:	52                   	push   %edx
  801611:	50                   	push   %eax
  801612:	6a 06                	push   $0x6
  801614:	e8 56 ff ff ff       	call   80156f <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80161f:	5b                   	pop    %ebx
  801620:	5e                   	pop    %esi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    

00801623 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801626:	8b 55 0c             	mov    0xc(%ebp),%edx
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	52                   	push   %edx
  801633:	50                   	push   %eax
  801634:	6a 07                	push   $0x7
  801636:	e8 34 ff ff ff       	call   80156f <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	ff 75 0c             	pushl  0xc(%ebp)
  80164c:	ff 75 08             	pushl  0x8(%ebp)
  80164f:	6a 08                	push   $0x8
  801651:	e8 19 ff ff ff       	call   80156f <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 09                	push   $0x9
  80166a:	e8 00 ff ff ff       	call   80156f <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 0a                	push   $0xa
  801683:	e8 e7 fe ff ff       	call   80156f <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 0b                	push   $0xb
  80169c:	e8 ce fe ff ff       	call   80156f <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	6a 0f                	push   $0xf
  8016b7:	e8 b3 fe ff ff       	call   80156f <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
	return;
  8016bf:	90                   	nop
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	6a 10                	push   $0x10
  8016d3:	e8 97 fe ff ff       	call   80156f <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016db:	90                   	nop
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	ff 75 10             	pushl  0x10(%ebp)
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	6a 11                	push   $0x11
  8016f0:	e8 7a fe ff ff       	call   80156f <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f8:	90                   	nop
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 0c                	push   $0xc
  80170a:	e8 60 fe ff ff       	call   80156f <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	6a 0d                	push   $0xd
  801724:	e8 46 fe ff ff       	call   80156f <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 0e                	push   $0xe
  80173d:	e8 2d fe ff ff       	call   80156f <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	90                   	nop
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 13                	push   $0x13
  801757:	e8 13 fe ff ff       	call   80156f <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	90                   	nop
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 14                	push   $0x14
  801771:	e8 f9 fd ff ff       	call   80156f <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	90                   	nop
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_cputc>:


void
sys_cputc(const char c)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801788:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	50                   	push   %eax
  801795:	6a 15                	push   $0x15
  801797:	e8 d3 fd ff ff       	call   80156f <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	90                   	nop
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 16                	push   $0x16
  8017b1:	e8 b9 fd ff ff       	call   80156f <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
}
  8017b9:	90                   	nop
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	50                   	push   %eax
  8017cc:	6a 17                	push   $0x17
  8017ce:	e8 9c fd ff ff       	call   80156f <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	52                   	push   %edx
  8017e8:	50                   	push   %eax
  8017e9:	6a 1a                	push   $0x1a
  8017eb:	e8 7f fd ff ff       	call   80156f <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	52                   	push   %edx
  801805:	50                   	push   %eax
  801806:	6a 18                	push   $0x18
  801808:	e8 62 fd ff ff       	call   80156f <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801816:	8b 55 0c             	mov    0xc(%ebp),%edx
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	52                   	push   %edx
  801823:	50                   	push   %eax
  801824:	6a 19                	push   $0x19
  801826:	e8 44 fd ff ff       	call   80156f <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	8b 45 10             	mov    0x10(%ebp),%eax
  80183a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80183d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801840:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	51                   	push   %ecx
  80184a:	52                   	push   %edx
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	50                   	push   %eax
  80184f:	6a 1b                	push   $0x1b
  801851:	e8 19 fd ff ff       	call   80156f <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	52                   	push   %edx
  80186b:	50                   	push   %eax
  80186c:	6a 1c                	push   $0x1c
  80186e:	e8 fc fc ff ff       	call   80156f <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80187b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	51                   	push   %ecx
  801889:	52                   	push   %edx
  80188a:	50                   	push   %eax
  80188b:	6a 1d                	push   $0x1d
  80188d:	e8 dd fc ff ff       	call   80156f <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	6a 1e                	push   $0x1e
  8018aa:	e8 c0 fc ff ff       	call   80156f <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 1f                	push   $0x1f
  8018c3:	e8 a7 fc ff ff       	call   80156f <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 14             	pushl  0x14(%ebp)
  8018d8:	ff 75 10             	pushl  0x10(%ebp)
  8018db:	ff 75 0c             	pushl  0xc(%ebp)
  8018de:	50                   	push   %eax
  8018df:	6a 20                	push   $0x20
  8018e1:	e8 89 fc ff ff       	call   80156f <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	50                   	push   %eax
  8018fa:	6a 21                	push   $0x21
  8018fc:	e8 6e fc ff ff       	call   80156f <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	90                   	nop
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	50                   	push   %eax
  801916:	6a 22                	push   $0x22
  801918:	e8 52 fc ff ff       	call   80156f <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 02                	push   $0x2
  801931:	e8 39 fc ff ff       	call   80156f <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 03                	push   $0x3
  80194a:	e8 20 fc ff ff       	call   80156f <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 04                	push   $0x4
  801963:	e8 07 fc ff ff       	call   80156f <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_exit_env>:


void sys_exit_env(void)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 23                	push   $0x23
  80197c:	e8 ee fb ff ff       	call   80156f <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	90                   	nop
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80198d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801990:	8d 50 04             	lea    0x4(%eax),%edx
  801993:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	52                   	push   %edx
  80199d:	50                   	push   %eax
  80199e:	6a 24                	push   $0x24
  8019a0:	e8 ca fb ff ff       	call   80156f <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
	return result;
  8019a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b1:	89 01                	mov    %eax,(%ecx)
  8019b3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	c9                   	leave  
  8019ba:	c2 04 00             	ret    $0x4

008019bd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 10             	pushl  0x10(%ebp)
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	6a 12                	push   $0x12
  8019cf:	e8 9b fb ff ff       	call   80156f <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d7:	90                   	nop
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_rcr2>:
uint32 sys_rcr2()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 25                	push   $0x25
  8019e9:	e8 81 fb ff ff       	call   80156f <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	50                   	push   %eax
  801a0c:	6a 26                	push   $0x26
  801a0e:	e8 5c fb ff ff       	call   80156f <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
	return ;
  801a16:	90                   	nop
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <rsttst>:
void rsttst()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 28                	push   $0x28
  801a28:	e8 42 fb ff ff       	call   80156f <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a30:	90                   	nop
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a3f:	8b 55 18             	mov    0x18(%ebp),%edx
  801a42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	ff 75 10             	pushl  0x10(%ebp)
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	6a 27                	push   $0x27
  801a53:	e8 17 fb ff ff       	call   80156f <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <chktst>:
void chktst(uint32 n)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 08             	pushl  0x8(%ebp)
  801a6c:	6a 29                	push   $0x29
  801a6e:	e8 fc fa ff ff       	call   80156f <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
	return ;
  801a76:	90                   	nop
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <inctst>:

void inctst()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 2a                	push   $0x2a
  801a88:	e8 e2 fa ff ff       	call   80156f <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <gettst>:
uint32 gettst()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 2b                	push   $0x2b
  801aa2:	e8 c8 fa ff ff       	call   80156f <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 2c                	push   $0x2c
  801abe:	e8 ac fa ff ff       	call   80156f <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
  801ac6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ac9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801acd:	75 07                	jne    801ad6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801acf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad4:	eb 05                	jmp    801adb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 2c                	push   $0x2c
  801aef:	e8 7b fa ff ff       	call   80156f <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
  801af7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801afa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801afe:	75 07                	jne    801b07 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b00:	b8 01 00 00 00       	mov    $0x1,%eax
  801b05:	eb 05                	jmp    801b0c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 2c                	push   $0x2c
  801b20:	e8 4a fa ff ff       	call   80156f <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
  801b28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b2b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b2f:	75 07                	jne    801b38 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b31:	b8 01 00 00 00       	mov    $0x1,%eax
  801b36:	eb 05                	jmp    801b3d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 2c                	push   $0x2c
  801b51:	e8 19 fa ff ff       	call   80156f <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
  801b59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b5c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b60:	75 07                	jne    801b69 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	eb 05                	jmp    801b6e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	6a 2d                	push   $0x2d
  801b80:	e8 ea f9 ff ff       	call   80156f <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
	return ;
  801b88:	90                   	nop
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	53                   	push   %ebx
  801b9e:	51                   	push   %ecx
  801b9f:	52                   	push   %edx
  801ba0:	50                   	push   %eax
  801ba1:	6a 2e                	push   $0x2e
  801ba3:	e8 c7 f9 ff ff       	call   80156f <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	6a 2f                	push   $0x2f
  801bc3:	e8 a7 f9 ff ff       	call   80156f <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    
  801bcd:	66 90                	xchg   %ax,%ax
  801bcf:	90                   	nop

00801bd0 <__udivdi3>:
  801bd0:	55                   	push   %ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 1c             	sub    $0x1c,%esp
  801bd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801be3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801be7:	89 ca                	mov    %ecx,%edx
  801be9:	89 f8                	mov    %edi,%eax
  801beb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bef:	85 f6                	test   %esi,%esi
  801bf1:	75 2d                	jne    801c20 <__udivdi3+0x50>
  801bf3:	39 cf                	cmp    %ecx,%edi
  801bf5:	77 65                	ja     801c5c <__udivdi3+0x8c>
  801bf7:	89 fd                	mov    %edi,%ebp
  801bf9:	85 ff                	test   %edi,%edi
  801bfb:	75 0b                	jne    801c08 <__udivdi3+0x38>
  801bfd:	b8 01 00 00 00       	mov    $0x1,%eax
  801c02:	31 d2                	xor    %edx,%edx
  801c04:	f7 f7                	div    %edi
  801c06:	89 c5                	mov    %eax,%ebp
  801c08:	31 d2                	xor    %edx,%edx
  801c0a:	89 c8                	mov    %ecx,%eax
  801c0c:	f7 f5                	div    %ebp
  801c0e:	89 c1                	mov    %eax,%ecx
  801c10:	89 d8                	mov    %ebx,%eax
  801c12:	f7 f5                	div    %ebp
  801c14:	89 cf                	mov    %ecx,%edi
  801c16:	89 fa                	mov    %edi,%edx
  801c18:	83 c4 1c             	add    $0x1c,%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    
  801c20:	39 ce                	cmp    %ecx,%esi
  801c22:	77 28                	ja     801c4c <__udivdi3+0x7c>
  801c24:	0f bd fe             	bsr    %esi,%edi
  801c27:	83 f7 1f             	xor    $0x1f,%edi
  801c2a:	75 40                	jne    801c6c <__udivdi3+0x9c>
  801c2c:	39 ce                	cmp    %ecx,%esi
  801c2e:	72 0a                	jb     801c3a <__udivdi3+0x6a>
  801c30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c34:	0f 87 9e 00 00 00    	ja     801cd8 <__udivdi3+0x108>
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	89 fa                	mov    %edi,%edx
  801c41:	83 c4 1c             	add    $0x1c,%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    
  801c49:	8d 76 00             	lea    0x0(%esi),%esi
  801c4c:	31 ff                	xor    %edi,%edi
  801c4e:	31 c0                	xor    %eax,%eax
  801c50:	89 fa                	mov    %edi,%edx
  801c52:	83 c4 1c             	add    $0x1c,%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5f                   	pop    %edi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	89 d8                	mov    %ebx,%eax
  801c5e:	f7 f7                	div    %edi
  801c60:	31 ff                	xor    %edi,%edi
  801c62:	89 fa                	mov    %edi,%edx
  801c64:	83 c4 1c             	add    $0x1c,%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
  801c6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c71:	89 eb                	mov    %ebp,%ebx
  801c73:	29 fb                	sub    %edi,%ebx
  801c75:	89 f9                	mov    %edi,%ecx
  801c77:	d3 e6                	shl    %cl,%esi
  801c79:	89 c5                	mov    %eax,%ebp
  801c7b:	88 d9                	mov    %bl,%cl
  801c7d:	d3 ed                	shr    %cl,%ebp
  801c7f:	89 e9                	mov    %ebp,%ecx
  801c81:	09 f1                	or     %esi,%ecx
  801c83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c87:	89 f9                	mov    %edi,%ecx
  801c89:	d3 e0                	shl    %cl,%eax
  801c8b:	89 c5                	mov    %eax,%ebp
  801c8d:	89 d6                	mov    %edx,%esi
  801c8f:	88 d9                	mov    %bl,%cl
  801c91:	d3 ee                	shr    %cl,%esi
  801c93:	89 f9                	mov    %edi,%ecx
  801c95:	d3 e2                	shl    %cl,%edx
  801c97:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9b:	88 d9                	mov    %bl,%cl
  801c9d:	d3 e8                	shr    %cl,%eax
  801c9f:	09 c2                	or     %eax,%edx
  801ca1:	89 d0                	mov    %edx,%eax
  801ca3:	89 f2                	mov    %esi,%edx
  801ca5:	f7 74 24 0c          	divl   0xc(%esp)
  801ca9:	89 d6                	mov    %edx,%esi
  801cab:	89 c3                	mov    %eax,%ebx
  801cad:	f7 e5                	mul    %ebp
  801caf:	39 d6                	cmp    %edx,%esi
  801cb1:	72 19                	jb     801ccc <__udivdi3+0xfc>
  801cb3:	74 0b                	je     801cc0 <__udivdi3+0xf0>
  801cb5:	89 d8                	mov    %ebx,%eax
  801cb7:	31 ff                	xor    %edi,%edi
  801cb9:	e9 58 ff ff ff       	jmp    801c16 <__udivdi3+0x46>
  801cbe:	66 90                	xchg   %ax,%ax
  801cc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cc4:	89 f9                	mov    %edi,%ecx
  801cc6:	d3 e2                	shl    %cl,%edx
  801cc8:	39 c2                	cmp    %eax,%edx
  801cca:	73 e9                	jae    801cb5 <__udivdi3+0xe5>
  801ccc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ccf:	31 ff                	xor    %edi,%edi
  801cd1:	e9 40 ff ff ff       	jmp    801c16 <__udivdi3+0x46>
  801cd6:	66 90                	xchg   %ax,%ax
  801cd8:	31 c0                	xor    %eax,%eax
  801cda:	e9 37 ff ff ff       	jmp    801c16 <__udivdi3+0x46>
  801cdf:	90                   	nop

00801ce0 <__umoddi3>:
  801ce0:	55                   	push   %ebp
  801ce1:	57                   	push   %edi
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 1c             	sub    $0x1c,%esp
  801ce7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ceb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cf3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cf7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cff:	89 f3                	mov    %esi,%ebx
  801d01:	89 fa                	mov    %edi,%edx
  801d03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d07:	89 34 24             	mov    %esi,(%esp)
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	75 1a                	jne    801d28 <__umoddi3+0x48>
  801d0e:	39 f7                	cmp    %esi,%edi
  801d10:	0f 86 a2 00 00 00    	jbe    801db8 <__umoddi3+0xd8>
  801d16:	89 c8                	mov    %ecx,%eax
  801d18:	89 f2                	mov    %esi,%edx
  801d1a:	f7 f7                	div    %edi
  801d1c:	89 d0                	mov    %edx,%eax
  801d1e:	31 d2                	xor    %edx,%edx
  801d20:	83 c4 1c             	add    $0x1c,%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5e                   	pop    %esi
  801d25:	5f                   	pop    %edi
  801d26:	5d                   	pop    %ebp
  801d27:	c3                   	ret    
  801d28:	39 f0                	cmp    %esi,%eax
  801d2a:	0f 87 ac 00 00 00    	ja     801ddc <__umoddi3+0xfc>
  801d30:	0f bd e8             	bsr    %eax,%ebp
  801d33:	83 f5 1f             	xor    $0x1f,%ebp
  801d36:	0f 84 ac 00 00 00    	je     801de8 <__umoddi3+0x108>
  801d3c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d41:	29 ef                	sub    %ebp,%edi
  801d43:	89 fe                	mov    %edi,%esi
  801d45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 e0                	shl    %cl,%eax
  801d4d:	89 d7                	mov    %edx,%edi
  801d4f:	89 f1                	mov    %esi,%ecx
  801d51:	d3 ef                	shr    %cl,%edi
  801d53:	09 c7                	or     %eax,%edi
  801d55:	89 e9                	mov    %ebp,%ecx
  801d57:	d3 e2                	shl    %cl,%edx
  801d59:	89 14 24             	mov    %edx,(%esp)
  801d5c:	89 d8                	mov    %ebx,%eax
  801d5e:	d3 e0                	shl    %cl,%eax
  801d60:	89 c2                	mov    %eax,%edx
  801d62:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d66:	d3 e0                	shl    %cl,%eax
  801d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d70:	89 f1                	mov    %esi,%ecx
  801d72:	d3 e8                	shr    %cl,%eax
  801d74:	09 d0                	or     %edx,%eax
  801d76:	d3 eb                	shr    %cl,%ebx
  801d78:	89 da                	mov    %ebx,%edx
  801d7a:	f7 f7                	div    %edi
  801d7c:	89 d3                	mov    %edx,%ebx
  801d7e:	f7 24 24             	mull   (%esp)
  801d81:	89 c6                	mov    %eax,%esi
  801d83:	89 d1                	mov    %edx,%ecx
  801d85:	39 d3                	cmp    %edx,%ebx
  801d87:	0f 82 87 00 00 00    	jb     801e14 <__umoddi3+0x134>
  801d8d:	0f 84 91 00 00 00    	je     801e24 <__umoddi3+0x144>
  801d93:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d97:	29 f2                	sub    %esi,%edx
  801d99:	19 cb                	sbb    %ecx,%ebx
  801d9b:	89 d8                	mov    %ebx,%eax
  801d9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801da1:	d3 e0                	shl    %cl,%eax
  801da3:	89 e9                	mov    %ebp,%ecx
  801da5:	d3 ea                	shr    %cl,%edx
  801da7:	09 d0                	or     %edx,%eax
  801da9:	89 e9                	mov    %ebp,%ecx
  801dab:	d3 eb                	shr    %cl,%ebx
  801dad:	89 da                	mov    %ebx,%edx
  801daf:	83 c4 1c             	add    $0x1c,%esp
  801db2:	5b                   	pop    %ebx
  801db3:	5e                   	pop    %esi
  801db4:	5f                   	pop    %edi
  801db5:	5d                   	pop    %ebp
  801db6:	c3                   	ret    
  801db7:	90                   	nop
  801db8:	89 fd                	mov    %edi,%ebp
  801dba:	85 ff                	test   %edi,%edi
  801dbc:	75 0b                	jne    801dc9 <__umoddi3+0xe9>
  801dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc3:	31 d2                	xor    %edx,%edx
  801dc5:	f7 f7                	div    %edi
  801dc7:	89 c5                	mov    %eax,%ebp
  801dc9:	89 f0                	mov    %esi,%eax
  801dcb:	31 d2                	xor    %edx,%edx
  801dcd:	f7 f5                	div    %ebp
  801dcf:	89 c8                	mov    %ecx,%eax
  801dd1:	f7 f5                	div    %ebp
  801dd3:	89 d0                	mov    %edx,%eax
  801dd5:	e9 44 ff ff ff       	jmp    801d1e <__umoddi3+0x3e>
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	89 c8                	mov    %ecx,%eax
  801dde:	89 f2                	mov    %esi,%edx
  801de0:	83 c4 1c             	add    $0x1c,%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5f                   	pop    %edi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    
  801de8:	3b 04 24             	cmp    (%esp),%eax
  801deb:	72 06                	jb     801df3 <__umoddi3+0x113>
  801ded:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801df1:	77 0f                	ja     801e02 <__umoddi3+0x122>
  801df3:	89 f2                	mov    %esi,%edx
  801df5:	29 f9                	sub    %edi,%ecx
  801df7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dfb:	89 14 24             	mov    %edx,(%esp)
  801dfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e02:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e06:	8b 14 24             	mov    (%esp),%edx
  801e09:	83 c4 1c             	add    $0x1c,%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5f                   	pop    %edi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    
  801e11:	8d 76 00             	lea    0x0(%esi),%esi
  801e14:	2b 04 24             	sub    (%esp),%eax
  801e17:	19 fa                	sbb    %edi,%edx
  801e19:	89 d1                	mov    %edx,%ecx
  801e1b:	89 c6                	mov    %eax,%esi
  801e1d:	e9 71 ff ff ff       	jmp    801d93 <__umoddi3+0xb3>
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e28:	72 ea                	jb     801e14 <__umoddi3+0x134>
  801e2a:	89 d9                	mov    %ebx,%ecx
  801e2c:	e9 62 ff ff ff       	jmp    801d93 <__umoddi3+0xb3>
