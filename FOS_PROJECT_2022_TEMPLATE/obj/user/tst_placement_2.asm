
obj/user/tst_placement_2:     file format elf32-i386


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
  800031:	e8 76 03 00 00       	call   8003ac <libmain>
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

	uint32 actual_active_list[13] = {0xedbfdb78,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  800043:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  800049:	b9 0d 00 00 00       	mov    $0xd,%ecx
  80004e:	b8 00 00 00 00       	mov    $0x0,%eax
  800053:	89 d7                	mov    %edx,%edi
  800055:	f3 ab                	rep stos %eax,%es:(%edi)
  800057:	c7 85 a4 ff ff fe 78 	movl   $0xedbfdb78,-0x100005c(%ebp)
  80005e:	db bf ed 
  800061:	c7 85 a8 ff ff fe 00 	movl   $0xeebfd000,-0x1000058(%ebp)
  800068:	d0 bf ee 
  80006b:	c7 85 ac ff ff fe 00 	movl   $0x803000,-0x1000054(%ebp)
  800072:	30 80 00 
  800075:	c7 85 b0 ff ff fe 00 	movl   $0x802000,-0x1000050(%ebp)
  80007c:	20 80 00 
  80007f:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  800086:	10 80 00 
  800089:	c7 85 b8 ff ff fe 00 	movl   $0x800000,-0x1000048(%ebp)
  800090:	00 80 00 
  800093:	c7 85 bc ff ff fe 00 	movl   $0x205000,-0x1000044(%ebp)
  80009a:	50 20 00 
  80009d:	c7 85 c0 ff ff fe 00 	movl   $0x204000,-0x1000040(%ebp)
  8000a4:	40 20 00 
  8000a7:	c7 85 c4 ff ff fe 00 	movl   $0x203000,-0x100003c(%ebp)
  8000ae:	30 20 00 
  8000b1:	c7 85 c8 ff ff fe 00 	movl   $0x202000,-0x1000038(%ebp)
  8000b8:	20 20 00 
  8000bb:	c7 85 cc ff ff fe 00 	movl   $0x201000,-0x1000034(%ebp)
  8000c2:	10 20 00 
  8000c5:	c7 85 d0 ff ff fe 00 	movl   $0x200000,-0x1000030(%ebp)
  8000cc:	00 20 00 
	uint32 actual_second_list[7] = {};
  8000cf:	8d 95 88 ff ff fe    	lea    -0x1000078(%ebp),%edx
  8000d5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000da:	b8 00 00 00 00       	mov    $0x0,%eax
  8000df:	89 d7                	mov    %edx,%edi
  8000e1:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000e3:	6a 00                	push   $0x0
  8000e5:	6a 0c                	push   $0xc
  8000e7:	8d 85 88 ff ff fe    	lea    -0x1000078(%ebp),%eax
  8000ed:	50                   	push   %eax
  8000ee:	8d 85 a4 ff ff fe    	lea    -0x100005c(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	e8 5b 1a 00 00       	call   801b55 <sys_check_LRU_lists>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(check == 0)
  800100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800104:	75 14                	jne    80011a <_main+0xe2>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 00 1e 80 00       	push   $0x801e00
  80010e:	6a 14                	push   $0x14
  800110:	68 4f 1e 80 00       	push   $0x801e4f
  800115:	e8 e1 03 00 00       	call   8004fb <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80011a:	e8 a6 15 00 00       	call   8016c5 <sys_pf_calculate_allocated_pages>
  80011f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int freePages = sys_calculate_free_frames();
  800122:	e8 fe 14 00 00       	call   801625 <sys_calculate_free_frames>
  800127:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int i=0;
  80012a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800131:	eb 11                	jmp    800144 <_main+0x10c>
	{
		arr[i] = -1;
  800133:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
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
  800156:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
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
  800179:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
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
	{
		arr[i] = -1;
	}

	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 68 1e 80 00       	push   $0x801e68
  80019b:	e8 0f 06 00 00       	call   8007af <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  8001a3:	8a 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%al
  8001a9:	3c ff                	cmp    $0xff,%al
  8001ab:	74 14                	je     8001c1 <_main+0x189>
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 98 1e 80 00       	push   $0x801e98
  8001b5:	6a 2e                	push   $0x2e
  8001b7:	68 4f 1e 80 00       	push   $0x801e4f
  8001bc:	e8 3a 03 00 00       	call   8004fb <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8001c1:	8a 85 d8 0f 00 ff    	mov    -0xfff028(%ebp),%al
  8001c7:	3c ff                	cmp    $0xff,%al
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 98 1e 80 00       	push   $0x801e98
  8001d3:	6a 2f                	push   $0x2f
  8001d5:	68 4f 1e 80 00       	push   $0x801e4f
  8001da:	e8 1c 03 00 00       	call   8004fb <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8001df:	8a 85 d8 ff 3f ff    	mov    -0xc00028(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 14                	je     8001fd <_main+0x1c5>
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	68 98 1e 80 00       	push   $0x801e98
  8001f1:	6a 31                	push   $0x31
  8001f3:	68 4f 1e 80 00       	push   $0x801e4f
  8001f8:	e8 fe 02 00 00       	call   8004fb <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8001fd:	8a 85 d8 0f 40 ff    	mov    -0xbff028(%ebp),%al
  800203:	3c ff                	cmp    $0xff,%al
  800205:	74 14                	je     80021b <_main+0x1e3>
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 98 1e 80 00       	push   $0x801e98
  80020f:	6a 32                	push   $0x32
  800211:	68 4f 1e 80 00       	push   $0x801e4f
  800216:	e8 e0 02 00 00       	call   8004fb <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  80021b:	8a 85 d8 ff 7f ff    	mov    -0x800028(%ebp),%al
  800221:	3c ff                	cmp    $0xff,%al
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 98 1e 80 00       	push   $0x801e98
  80022d:	6a 34                	push   $0x34
  80022f:	68 4f 1e 80 00       	push   $0x801e4f
  800234:	e8 c2 02 00 00       	call   8004fb <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800239:	8a 85 d8 0f 80 ff    	mov    -0x7ff028(%ebp),%al
  80023f:	3c ff                	cmp    $0xff,%al
  800241:	74 14                	je     800257 <_main+0x21f>
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 98 1e 80 00       	push   $0x801e98
  80024b:	6a 35                	push   $0x35
  80024d:	68 4f 1e 80 00       	push   $0x801e4f
  800252:	e8 a4 02 00 00       	call   8004fb <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  800257:	e8 69 14 00 00       	call   8016c5 <sys_pf_calculate_allocated_pages>
  80025c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80025f:	83 f8 05             	cmp    $0x5,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 b8 1e 80 00       	push   $0x801eb8
  80026c:	6a 38                	push   $0x38
  80026e:	68 4f 1e 80 00       	push   $0x801e4f
  800273:	e8 83 02 00 00       	call   8004fb <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  800278:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80027b:	e8 a5 13 00 00       	call   801625 <sys_calculate_free_frames>
  800280:	29 c3                	sub    %eax,%ebx
  800282:	89 d8                	mov    %ebx,%eax
  800284:	83 f8 09             	cmp    $0x9,%eax
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 e8 1e 80 00       	push   $0x801ee8
  800291:	6a 3a                	push   $0x3a
  800293:	68 4f 1e 80 00       	push   $0x801e4f
  800298:	e8 5e 02 00 00       	call   8004fb <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	68 08 1f 80 00       	push   $0x801f08
  8002a5:	e8 05 05 00 00       	call   8007af <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp

	int j=0;
  8002ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (int i=3;i>=0;i--,j++)
  8002b4:	c7 45 ec 03 00 00 00 	movl   $0x3,-0x14(%ebp)
  8002bb:	eb 1f                	jmp    8002dc <_main+0x2a4>
		actual_second_list[i]=actual_active_list[11-j];
  8002bd:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002c2:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8002c5:	8b 94 85 a4 ff ff fe 	mov    -0x100005c(%ebp,%eax,4),%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	89 94 85 88 ff ff fe 	mov    %edx,-0x1000078(%ebp,%eax,4)
		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	int j=0;
	for (int i=3;i>=0;i--,j++)
  8002d6:	ff 4d ec             	decl   -0x14(%ebp)
  8002d9:	ff 45 f0             	incl   -0x10(%ebp)
  8002dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002e0:	79 db                	jns    8002bd <_main+0x285>
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  8002e2:	c7 45 e8 0c 00 00 00 	movl   $0xc,-0x18(%ebp)
  8002e9:	eb 1a                	jmp    800305 <_main+0x2cd>
		actual_active_list[i]=actual_active_list[i-5];
  8002eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ee:	83 e8 05             	sub    $0x5,%eax
  8002f1:	8b 94 85 a4 ff ff fe 	mov    -0x100005c(%ebp,%eax,4),%edx
  8002f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002fb:	89 94 85 a4 ff ff fe 	mov    %edx,-0x100005c(%ebp,%eax,4)
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	int j=0;
	for (int i=3;i>=0;i--,j++)
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  800302:	ff 4d e8             	decl   -0x18(%ebp)
  800305:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
  800309:	7f e0                	jg     8002eb <_main+0x2b3>
		actual_active_list[i]=actual_active_list[i-5];
	actual_active_list[0]=0xee3fe000;
  80030b:	c7 85 a4 ff ff fe 00 	movl   $0xee3fe000,-0x100005c(%ebp)
  800312:	e0 3f ee 
	actual_active_list[1]=0xee3fdfa0;
  800315:	c7 85 a8 ff ff fe a0 	movl   $0xee3fdfa0,-0x1000058(%ebp)
  80031c:	df 3f ee 
	actual_active_list[2]=0xedffe000;
  80031f:	c7 85 ac ff ff fe 00 	movl   $0xedffe000,-0x1000054(%ebp)
  800326:	e0 ff ed 
	actual_active_list[3]=0xedffdfa0;
  800329:	c7 85 b0 ff ff fe a0 	movl   $0xedffdfa0,-0x1000050(%ebp)
  800330:	df ff ed 
	actual_active_list[4]=0xedbfe000;
  800333:	c7 85 b4 ff ff fe 00 	movl   $0xedbfe000,-0x100004c(%ebp)
  80033a:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 3c 1f 80 00       	push   $0x801f3c
  800345:	e8 65 04 00 00       	call   8007af <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  80034d:	6a 04                	push   $0x4
  80034f:	6a 0d                	push   $0xd
  800351:	8d 85 88 ff ff fe    	lea    -0x1000078(%ebp),%eax
  800357:	50                   	push   %eax
  800358:	8d 85 a4 ff ff fe    	lea    -0x100005c(%ebp),%eax
  80035e:	50                   	push   %eax
  80035f:	e8 f1 17 00 00       	call   801b55 <sys_check_LRU_lists>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(check == 0)
  80036a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80036e:	75 14                	jne    800384 <_main+0x34c>
			panic("LRU lists entries are not correct, check your logic again!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 64 1f 80 00       	push   $0x801f64
  800378:	6a 4d                	push   $0x4d
  80037a:	68 4f 1e 80 00       	push   $0x801e4f
  80037f:	e8 77 01 00 00       	call   8004fb <_panic>
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	68 a0 1f 80 00       	push   $0x801fa0
  80038c:	e8 1e 04 00 00       	call   8007af <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT SECOND SCENARIO completed successfully!!\n\n\n");
  800394:	83 ec 0c             	sub    $0xc,%esp
  800397:	68 d8 1f 80 00       	push   $0x801fd8
  80039c:	e8 0e 04 00 00       	call   8007af <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	return;
  8003a4:	90                   	nop
}
  8003a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003a8:	5b                   	pop    %ebx
  8003a9:	5f                   	pop    %edi
  8003aa:	5d                   	pop    %ebp
  8003ab:	c3                   	ret    

008003ac <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003b2:	e8 4e 15 00 00       	call   801905 <sys_getenvindex>
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003ca:	01 c8                	add    %ecx,%eax
  8003cc:	c1 e0 02             	shl    $0x2,%eax
  8003cf:	01 d0                	add    %edx,%eax
  8003d1:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003d8:	01 c8                	add    %ecx,%eax
  8003da:	c1 e0 02             	shl    $0x2,%eax
  8003dd:	01 d0                	add    %edx,%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	01 d0                	add    %edx,%eax
  8003e4:	c1 e0 03             	shl    $0x3,%eax
  8003e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ec:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f6:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8003fc:	84 c0                	test   %al,%al
  8003fe:	74 0f                	je     80040f <libmain+0x63>
		binaryname = myEnv->prog_name;
  800400:	a1 20 30 80 00       	mov    0x803020,%eax
  800405:	05 18 da 01 00       	add    $0x1da18,%eax
  80040a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80040f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800413:	7e 0a                	jle    80041f <libmain+0x73>
		binaryname = argv[0];
  800415:	8b 45 0c             	mov    0xc(%ebp),%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	ff 75 0c             	pushl  0xc(%ebp)
  800425:	ff 75 08             	pushl  0x8(%ebp)
  800428:	e8 0b fc ff ff       	call   800038 <_main>
  80042d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800430:	e8 dd 12 00 00       	call   801712 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800435:	83 ec 0c             	sub    $0xc,%esp
  800438:	68 48 20 80 00       	push   $0x802048
  80043d:	e8 6d 03 00 00       	call   8007af <cprintf>
  800442:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800445:	a1 20 30 80 00       	mov    0x803020,%eax
  80044a:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800450:	a1 20 30 80 00       	mov    0x803020,%eax
  800455:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80045b:	83 ec 04             	sub    $0x4,%esp
  80045e:	52                   	push   %edx
  80045f:	50                   	push   %eax
  800460:	68 70 20 80 00       	push   $0x802070
  800465:	e8 45 03 00 00       	call   8007af <cprintf>
  80046a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80046d:	a1 20 30 80 00       	mov    0x803020,%eax
  800472:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800478:	a1 20 30 80 00       	mov    0x803020,%eax
  80047d:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800483:	a1 20 30 80 00       	mov    0x803020,%eax
  800488:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80048e:	51                   	push   %ecx
  80048f:	52                   	push   %edx
  800490:	50                   	push   %eax
  800491:	68 98 20 80 00       	push   $0x802098
  800496:	e8 14 03 00 00       	call   8007af <cprintf>
  80049b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80049e:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a3:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	50                   	push   %eax
  8004ad:	68 f0 20 80 00       	push   $0x8020f0
  8004b2:	e8 f8 02 00 00       	call   8007af <cprintf>
  8004b7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004ba:	83 ec 0c             	sub    $0xc,%esp
  8004bd:	68 48 20 80 00       	push   $0x802048
  8004c2:	e8 e8 02 00 00       	call   8007af <cprintf>
  8004c7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004ca:	e8 5d 12 00 00       	call   80172c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004cf:	e8 19 00 00 00       	call   8004ed <exit>
}
  8004d4:	90                   	nop
  8004d5:	c9                   	leave  
  8004d6:	c3                   	ret    

008004d7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	6a 00                	push   $0x0
  8004e2:	e8 ea 13 00 00       	call   8018d1 <sys_destroy_env>
  8004e7:	83 c4 10             	add    $0x10,%esp
}
  8004ea:	90                   	nop
  8004eb:	c9                   	leave  
  8004ec:	c3                   	ret    

008004ed <exit>:

void
exit(void)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004f3:	e8 3f 14 00 00       	call   801937 <sys_exit_env>
}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800501:	8d 45 10             	lea    0x10(%ebp),%eax
  800504:	83 c0 04             	add    $0x4,%eax
  800507:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80050a:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80050f:	85 c0                	test   %eax,%eax
  800511:	74 16                	je     800529 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800513:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	50                   	push   %eax
  80051c:	68 04 21 80 00       	push   $0x802104
  800521:	e8 89 02 00 00       	call   8007af <cprintf>
  800526:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800529:	a1 00 30 80 00       	mov    0x803000,%eax
  80052e:	ff 75 0c             	pushl  0xc(%ebp)
  800531:	ff 75 08             	pushl  0x8(%ebp)
  800534:	50                   	push   %eax
  800535:	68 09 21 80 00       	push   $0x802109
  80053a:	e8 70 02 00 00       	call   8007af <cprintf>
  80053f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800542:	8b 45 10             	mov    0x10(%ebp),%eax
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	ff 75 f4             	pushl  -0xc(%ebp)
  80054b:	50                   	push   %eax
  80054c:	e8 f3 01 00 00       	call   800744 <vcprintf>
  800551:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	6a 00                	push   $0x0
  800559:	68 25 21 80 00       	push   $0x802125
  80055e:	e8 e1 01 00 00       	call   800744 <vcprintf>
  800563:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800566:	e8 82 ff ff ff       	call   8004ed <exit>

	// should not return here
	while (1) ;
  80056b:	eb fe                	jmp    80056b <_panic+0x70>

0080056d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800573:	a1 20 30 80 00       	mov    0x803020,%eax
  800578:	8b 50 74             	mov    0x74(%eax),%edx
  80057b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057e:	39 c2                	cmp    %eax,%edx
  800580:	74 14                	je     800596 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800582:	83 ec 04             	sub    $0x4,%esp
  800585:	68 28 21 80 00       	push   $0x802128
  80058a:	6a 26                	push   $0x26
  80058c:	68 74 21 80 00       	push   $0x802174
  800591:	e8 65 ff ff ff       	call   8004fb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80059d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a4:	e9 c2 00 00 00       	jmp    80066b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	85 c0                	test   %eax,%eax
  8005bc:	75 08                	jne    8005c6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005be:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005c1:	e9 a2 00 00 00       	jmp    800668 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d4:	eb 69                	jmp    80063f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005db:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005e4:	89 d0                	mov    %edx,%eax
  8005e6:	01 c0                	add    %eax,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	01 c8                	add    %ecx,%eax
  8005ef:	8a 40 04             	mov    0x4(%eax),%al
  8005f2:	84 c0                	test   %al,%al
  8005f4:	75 46                	jne    80063c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fb:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800601:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800604:	89 d0                	mov    %edx,%eax
  800606:	01 c0                	add    %eax,%eax
  800608:	01 d0                	add    %edx,%eax
  80060a:	c1 e0 03             	shl    $0x3,%eax
  80060d:	01 c8                	add    %ecx,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800614:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800617:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80061c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80061e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800621:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800628:	8b 45 08             	mov    0x8(%ebp),%eax
  80062b:	01 c8                	add    %ecx,%eax
  80062d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80062f:	39 c2                	cmp    %eax,%edx
  800631:	75 09                	jne    80063c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800633:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80063a:	eb 12                	jmp    80064e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063c:	ff 45 e8             	incl   -0x18(%ebp)
  80063f:	a1 20 30 80 00       	mov    0x803020,%eax
  800644:	8b 50 74             	mov    0x74(%eax),%edx
  800647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80064a:	39 c2                	cmp    %eax,%edx
  80064c:	77 88                	ja     8005d6 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80064e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800652:	75 14                	jne    800668 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 80 21 80 00       	push   $0x802180
  80065c:	6a 3a                	push   $0x3a
  80065e:	68 74 21 80 00       	push   $0x802174
  800663:	e8 93 fe ff ff       	call   8004fb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800668:	ff 45 f0             	incl   -0x10(%ebp)
  80066b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800671:	0f 8c 32 ff ff ff    	jl     8005a9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800677:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80067e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800685:	eb 26                	jmp    8006ad <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800687:	a1 20 30 80 00       	mov    0x803020,%eax
  80068c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	89 d0                	mov    %edx,%eax
  800697:	01 c0                	add    %eax,%eax
  800699:	01 d0                	add    %edx,%eax
  80069b:	c1 e0 03             	shl    $0x3,%eax
  80069e:	01 c8                	add    %ecx,%eax
  8006a0:	8a 40 04             	mov    0x4(%eax),%al
  8006a3:	3c 01                	cmp    $0x1,%al
  8006a5:	75 03                	jne    8006aa <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006a7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006aa:	ff 45 e0             	incl   -0x20(%ebp)
  8006ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b2:	8b 50 74             	mov    0x74(%eax),%edx
  8006b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	77 cb                	ja     800687 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006c2:	74 14                	je     8006d8 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006c4:	83 ec 04             	sub    $0x4,%esp
  8006c7:	68 d4 21 80 00       	push   $0x8021d4
  8006cc:	6a 44                	push   $0x44
  8006ce:	68 74 21 80 00       	push   $0x802174
  8006d3:	e8 23 fe ff ff       	call   8004fb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006d8:	90                   	nop
  8006d9:	c9                   	leave  
  8006da:	c3                   	ret    

008006db <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	89 0a                	mov    %ecx,(%edx)
  8006ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f1:	88 d1                	mov    %dl,%cl
  8006f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800704:	75 2c                	jne    800732 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800706:	a0 24 30 80 00       	mov    0x803024,%al
  80070b:	0f b6 c0             	movzbl %al,%eax
  80070e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800711:	8b 12                	mov    (%edx),%edx
  800713:	89 d1                	mov    %edx,%ecx
  800715:	8b 55 0c             	mov    0xc(%ebp),%edx
  800718:	83 c2 08             	add    $0x8,%edx
  80071b:	83 ec 04             	sub    $0x4,%esp
  80071e:	50                   	push   %eax
  80071f:	51                   	push   %ecx
  800720:	52                   	push   %edx
  800721:	e8 3e 0e 00 00       	call   801564 <sys_cputs>
  800726:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	8b 40 04             	mov    0x4(%eax),%eax
  800738:	8d 50 01             	lea    0x1(%eax),%edx
  80073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80074d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800754:	00 00 00 
	b.cnt = 0;
  800757:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80075e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076d:	50                   	push   %eax
  80076e:	68 db 06 80 00       	push   $0x8006db
  800773:	e8 11 02 00 00       	call   800989 <vprintfmt>
  800778:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80077b:	a0 24 30 80 00       	mov    0x803024,%al
  800780:	0f b6 c0             	movzbl %al,%eax
  800783:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800789:	83 ec 04             	sub    $0x4,%esp
  80078c:	50                   	push   %eax
  80078d:	52                   	push   %edx
  80078e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800794:	83 c0 08             	add    $0x8,%eax
  800797:	50                   	push   %eax
  800798:	e8 c7 0d 00 00       	call   801564 <sys_cputs>
  80079d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007a0:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007ad:	c9                   	leave  
  8007ae:	c3                   	ret    

008007af <cprintf>:

int cprintf(const char *fmt, ...) {
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007b5:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cb:	50                   	push   %eax
  8007cc:	e8 73 ff ff ff       	call   800744 <vcprintf>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007da:	c9                   	leave  
  8007db:	c3                   	ret    

008007dc <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007e2:	e8 2b 0f 00 00       	call   801712 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f6:	50                   	push   %eax
  8007f7:	e8 48 ff ff ff       	call   800744 <vcprintf>
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800802:	e8 25 0f 00 00       	call   80172c <sys_enable_interrupt>
	return cnt;
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    

0080080c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	53                   	push   %ebx
  800810:	83 ec 14             	sub    $0x14,%esp
  800813:	8b 45 10             	mov    0x10(%ebp),%eax
  800816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081f:	8b 45 18             	mov    0x18(%ebp),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082a:	77 55                	ja     800881 <printnum+0x75>
  80082c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082f:	72 05                	jb     800836 <printnum+0x2a>
  800831:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800834:	77 4b                	ja     800881 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800836:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800839:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083c:	8b 45 18             	mov    0x18(%ebp),%eax
  80083f:	ba 00 00 00 00       	mov    $0x0,%edx
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	ff 75 f4             	pushl  -0xc(%ebp)
  800849:	ff 75 f0             	pushl  -0x10(%ebp)
  80084c:	e8 47 13 00 00       	call   801b98 <__udivdi3>
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	83 ec 04             	sub    $0x4,%esp
  800857:	ff 75 20             	pushl  0x20(%ebp)
  80085a:	53                   	push   %ebx
  80085b:	ff 75 18             	pushl  0x18(%ebp)
  80085e:	52                   	push   %edx
  80085f:	50                   	push   %eax
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 a1 ff ff ff       	call   80080c <printnum>
  80086b:	83 c4 20             	add    $0x20,%esp
  80086e:	eb 1a                	jmp    80088a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	ff 75 20             	pushl  0x20(%ebp)
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	ff d0                	call   *%eax
  80087e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800881:	ff 4d 1c             	decl   0x1c(%ebp)
  800884:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800888:	7f e6                	jg     800870 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800898:	53                   	push   %ebx
  800899:	51                   	push   %ecx
  80089a:	52                   	push   %edx
  80089b:	50                   	push   %eax
  80089c:	e8 07 14 00 00       	call   801ca8 <__umoddi3>
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	05 34 24 80 00       	add    $0x802434,%eax
  8008a9:	8a 00                	mov    (%eax),%al
  8008ab:	0f be c0             	movsbl %al,%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	90                   	nop
  8008be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ca:	7e 1c                	jle    8008e8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 08             	lea    0x8(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 08             	sub    $0x8,%eax
  8008e1:	8b 50 04             	mov    0x4(%eax),%edx
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	eb 40                	jmp    800928 <getuint+0x65>
	else if (lflag)
  8008e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ec:	74 1e                	je     80090c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	8d 50 04             	lea    0x4(%eax),%edx
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	89 10                	mov    %edx,(%eax)
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	ba 00 00 00 00       	mov    $0x0,%edx
  80090a:	eb 1c                	jmp    800928 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 50 04             	lea    0x4(%eax),%edx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	89 10                	mov    %edx,(%eax)
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800931:	7e 1c                	jle    80094f <getint+0x25>
		return va_arg(*ap, long long);
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 50 08             	lea    0x8(%eax),%edx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	89 10                	mov    %edx,(%eax)
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	83 e8 08             	sub    $0x8,%eax
  800948:	8b 50 04             	mov    0x4(%eax),%edx
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	eb 38                	jmp    800987 <getint+0x5d>
	else if (lflag)
  80094f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800953:	74 1a                	je     80096f <getint+0x45>
		return va_arg(*ap, long);
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	8d 50 04             	lea    0x4(%eax),%edx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	89 10                	mov    %edx,(%eax)
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	83 e8 04             	sub    $0x4,%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	99                   	cltd   
  80096d:	eb 18                	jmp    800987 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	8d 50 04             	lea    0x4(%eax),%edx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	89 10                	mov    %edx,(%eax)
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	83 e8 04             	sub    $0x4,%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	99                   	cltd   
}
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	56                   	push   %esi
  80098d:	53                   	push   %ebx
  80098e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800991:	eb 17                	jmp    8009aa <vprintfmt+0x21>
			if (ch == '\0')
  800993:	85 db                	test   %ebx,%ebx
  800995:	0f 84 af 03 00 00    	je     800d4a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	53                   	push   %ebx
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	ff d0                	call   *%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ad:	8d 50 01             	lea    0x1(%eax),%edx
  8009b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b3:	8a 00                	mov    (%eax),%al
  8009b5:	0f b6 d8             	movzbl %al,%ebx
  8009b8:	83 fb 25             	cmp    $0x25,%ebx
  8009bb:	75 d6                	jne    800993 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009bd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e0:	8d 50 01             	lea    0x1(%eax),%edx
  8009e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e6:	8a 00                	mov    (%eax),%al
  8009e8:	0f b6 d8             	movzbl %al,%ebx
  8009eb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ee:	83 f8 55             	cmp    $0x55,%eax
  8009f1:	0f 87 2b 03 00 00    	ja     800d22 <vprintfmt+0x399>
  8009f7:	8b 04 85 58 24 80 00 	mov    0x802458(,%eax,4),%eax
  8009fe:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a00:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a04:	eb d7                	jmp    8009dd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a06:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0a:	eb d1                	jmp    8009dd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a16:	89 d0                	mov    %edx,%eax
  800a18:	c1 e0 02             	shl    $0x2,%eax
  800a1b:	01 d0                	add    %edx,%eax
  800a1d:	01 c0                	add    %eax,%eax
  800a1f:	01 d8                	add    %ebx,%eax
  800a21:	83 e8 30             	sub    $0x30,%eax
  800a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a32:	7e 3e                	jle    800a72 <vprintfmt+0xe9>
  800a34:	83 fb 39             	cmp    $0x39,%ebx
  800a37:	7f 39                	jg     800a72 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a39:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3c:	eb d5                	jmp    800a13 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax
  800a4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a58:	79 83                	jns    8009dd <vprintfmt+0x54>
				width = 0;
  800a5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a61:	e9 77 ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a66:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6d:	e9 6b ff ff ff       	jmp    8009dd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a72:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a77:	0f 89 60 ff ff ff    	jns    8009dd <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a83:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8a:	e9 4e ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a8f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a92:	e9 46 ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	50                   	push   %eax
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			break;
  800ab7:	e9 89 02 00 00       	jmp    800d45 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 c0 04             	add    $0x4,%eax
  800ac2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	83 e8 04             	sub    $0x4,%eax
  800acb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800acd:	85 db                	test   %ebx,%ebx
  800acf:	79 02                	jns    800ad3 <vprintfmt+0x14a>
				err = -err;
  800ad1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad3:	83 fb 64             	cmp    $0x64,%ebx
  800ad6:	7f 0b                	jg     800ae3 <vprintfmt+0x15a>
  800ad8:	8b 34 9d a0 22 80 00 	mov    0x8022a0(,%ebx,4),%esi
  800adf:	85 f6                	test   %esi,%esi
  800ae1:	75 19                	jne    800afc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae3:	53                   	push   %ebx
  800ae4:	68 45 24 80 00       	push   $0x802445
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	ff 75 08             	pushl  0x8(%ebp)
  800aef:	e8 5e 02 00 00       	call   800d52 <printfmt>
  800af4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af7:	e9 49 02 00 00       	jmp    800d45 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afc:	56                   	push   %esi
  800afd:	68 4e 24 80 00       	push   $0x80244e
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	ff 75 08             	pushl  0x8(%ebp)
  800b08:	e8 45 02 00 00       	call   800d52 <printfmt>
  800b0d:	83 c4 10             	add    $0x10,%esp
			break;
  800b10:	e9 30 02 00 00       	jmp    800d45 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 c0 04             	add    $0x4,%eax
  800b1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	83 e8 04             	sub    $0x4,%eax
  800b24:	8b 30                	mov    (%eax),%esi
  800b26:	85 f6                	test   %esi,%esi
  800b28:	75 05                	jne    800b2f <vprintfmt+0x1a6>
				p = "(null)";
  800b2a:	be 51 24 80 00       	mov    $0x802451,%esi
			if (width > 0 && padc != '-')
  800b2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b33:	7e 6d                	jle    800ba2 <vprintfmt+0x219>
  800b35:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b39:	74 67                	je     800ba2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	50                   	push   %eax
  800b42:	56                   	push   %esi
  800b43:	e8 0c 03 00 00       	call   800e54 <strnlen>
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4e:	eb 16                	jmp    800b66 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b50:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	50                   	push   %eax
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b63:	ff 4d e4             	decl   -0x1c(%ebp)
  800b66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6a:	7f e4                	jg     800b50 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6c:	eb 34                	jmp    800ba2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b72:	74 1c                	je     800b90 <vprintfmt+0x207>
  800b74:	83 fb 1f             	cmp    $0x1f,%ebx
  800b77:	7e 05                	jle    800b7e <vprintfmt+0x1f5>
  800b79:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7c:	7e 12                	jle    800b90 <vprintfmt+0x207>
					putch('?', putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	6a 3f                	push   $0x3f
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
  800b8e:	eb 0f                	jmp    800b9f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	53                   	push   %ebx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9f:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba2:	89 f0                	mov    %esi,%eax
  800ba4:	8d 70 01             	lea    0x1(%eax),%esi
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	0f be d8             	movsbl %al,%ebx
  800bac:	85 db                	test   %ebx,%ebx
  800bae:	74 24                	je     800bd4 <vprintfmt+0x24b>
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	78 b8                	js     800b6e <vprintfmt+0x1e5>
  800bb6:	ff 4d e0             	decl   -0x20(%ebp)
  800bb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbd:	79 af                	jns    800b6e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbf:	eb 13                	jmp    800bd4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 20                	push   $0x20
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd1:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd8:	7f e7                	jg     800bc1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bda:	e9 66 01 00 00       	jmp    800d45 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 e8             	pushl  -0x18(%ebp)
  800be5:	8d 45 14             	lea    0x14(%ebp),%eax
  800be8:	50                   	push   %eax
  800be9:	e8 3c fd ff ff       	call   80092a <getint>
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	85 d2                	test   %edx,%edx
  800bff:	79 23                	jns    800c24 <vprintfmt+0x29b>
				putch('-', putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	6a 2d                	push   $0x2d
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	ff d0                	call   *%eax
  800c0e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c17:	f7 d8                	neg    %eax
  800c19:	83 d2 00             	adc    $0x0,%edx
  800c1c:	f7 da                	neg    %edx
  800c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c21:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c24:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2b:	e9 bc 00 00 00       	jmp    800cec <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 e8             	pushl  -0x18(%ebp)
  800c36:	8d 45 14             	lea    0x14(%ebp),%eax
  800c39:	50                   	push   %eax
  800c3a:	e8 84 fc ff ff       	call   8008c3 <getuint>
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c48:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4f:	e9 98 00 00 00       	jmp    800cec <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	6a 58                	push   $0x58
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	ff d0                	call   *%eax
  800c61:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 58                	push   $0x58
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 58                	push   $0x58
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			break;
  800c84:	e9 bc 00 00 00       	jmp    800d45 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	6a 30                	push   $0x30
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	6a 78                	push   $0x78
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	ff d0                	call   *%eax
  800ca6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 c0 04             	add    $0x4,%eax
  800caf:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	83 e8 04             	sub    $0x4,%eax
  800cb8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccb:	eb 1f                	jmp    800cec <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd3:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd6:	50                   	push   %eax
  800cd7:	e8 e7 fb ff ff       	call   8008c3 <getuint>
  800cdc:	83 c4 10             	add    $0x10,%esp
  800cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cec:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf3:	83 ec 04             	sub    $0x4,%esp
  800cf6:	52                   	push   %edx
  800cf7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfe:	ff 75 f0             	pushl  -0x10(%ebp)
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	ff 75 08             	pushl  0x8(%ebp)
  800d07:	e8 00 fb ff ff       	call   80080c <printnum>
  800d0c:	83 c4 20             	add    $0x20,%esp
			break;
  800d0f:	eb 34                	jmp    800d45 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	53                   	push   %ebx
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	ff d0                	call   *%eax
  800d1d:	83 c4 10             	add    $0x10,%esp
			break;
  800d20:	eb 23                	jmp    800d45 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d22:	83 ec 08             	sub    $0x8,%esp
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	6a 25                	push   $0x25
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	ff d0                	call   *%eax
  800d2f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d32:	ff 4d 10             	decl   0x10(%ebp)
  800d35:	eb 03                	jmp    800d3a <vprintfmt+0x3b1>
  800d37:	ff 4d 10             	decl   0x10(%ebp)
  800d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3d:	48                   	dec    %eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	3c 25                	cmp    $0x25,%al
  800d42:	75 f3                	jne    800d37 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d44:	90                   	nop
		}
	}
  800d45:	e9 47 fc ff ff       	jmp    800991 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d4a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d58:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	ff 75 f4             	pushl  -0xc(%ebp)
  800d67:	50                   	push   %eax
  800d68:	ff 75 0c             	pushl  0xc(%ebp)
  800d6b:	ff 75 08             	pushl  0x8(%ebp)
  800d6e:	e8 16 fc ff ff       	call   800989 <vprintfmt>
  800d73:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d76:	90                   	nop
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	8b 40 08             	mov    0x8(%eax),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8b 10                	mov    (%eax),%edx
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8b 40 04             	mov    0x4(%eax),%eax
  800d96:	39 c2                	cmp    %eax,%edx
  800d98:	73 12                	jae    800dac <sprintputch+0x33>
		*b->buf++ = ch;
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	8b 00                	mov    (%eax),%eax
  800d9f:	8d 48 01             	lea    0x1(%eax),%ecx
  800da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da5:	89 0a                	mov    %ecx,(%edx)
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	88 10                	mov    %dl,(%eax)
}
  800dac:	90                   	nop
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	01 d0                	add    %edx,%eax
  800dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd4:	74 06                	je     800ddc <vsnprintf+0x2d>
  800dd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dda:	7f 07                	jg     800de3 <vsnprintf+0x34>
		return -E_INVAL;
  800ddc:	b8 03 00 00 00       	mov    $0x3,%eax
  800de1:	eb 20                	jmp    800e03 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de3:	ff 75 14             	pushl  0x14(%ebp)
  800de6:	ff 75 10             	pushl  0x10(%ebp)
  800de9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dec:	50                   	push   %eax
  800ded:	68 79 0d 80 00       	push   $0x800d79
  800df2:	e8 92 fb ff ff       	call   800989 <vprintfmt>
  800df7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e0b:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0e:	83 c0 04             	add    $0x4,%eax
  800e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1a:	50                   	push   %eax
  800e1b:	ff 75 0c             	pushl  0xc(%ebp)
  800e1e:	ff 75 08             	pushl  0x8(%ebp)
  800e21:	e8 89 ff ff ff       	call   800daf <vsnprintf>
  800e26:	83 c4 10             	add    $0x10,%esp
  800e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3e:	eb 06                	jmp    800e46 <strlen+0x15>
		n++;
  800e40:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	84 c0                	test   %al,%al
  800e4d:	75 f1                	jne    800e40 <strlen+0xf>
		n++;
	return n;
  800e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e61:	eb 09                	jmp    800e6c <strnlen+0x18>
		n++;
  800e63:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e66:	ff 45 08             	incl   0x8(%ebp)
  800e69:	ff 4d 0c             	decl   0xc(%ebp)
  800e6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e70:	74 09                	je     800e7b <strnlen+0x27>
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	84 c0                	test   %al,%al
  800e79:	75 e8                	jne    800e63 <strnlen+0xf>
		n++;
	return n;
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e8c:	90                   	nop
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8d 50 01             	lea    0x1(%eax),%edx
  800e93:	89 55 08             	mov    %edx,0x8(%ebp)
  800e96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e99:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9f:	8a 12                	mov    (%edx),%dl
  800ea1:	88 10                	mov    %dl,(%eax)
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	84 c0                	test   %al,%al
  800ea7:	75 e4                	jne    800e8d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec1:	eb 1f                	jmp    800ee2 <strncpy+0x34>
		*dst++ = *src;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8a 12                	mov    (%edx),%dl
  800ed1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	84 c0                	test   %al,%al
  800eda:	74 03                	je     800edf <strncpy+0x31>
			src++;
  800edc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800edf:	ff 45 fc             	incl   -0x4(%ebp)
  800ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee8:	72 d9                	jb     800ec3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eed:	c9                   	leave  
  800eee:	c3                   	ret    

00800eef <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800efb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eff:	74 30                	je     800f31 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f01:	eb 16                	jmp    800f19 <strlcpy+0x2a>
			*dst++ = *src++;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8d 50 01             	lea    0x1(%eax),%edx
  800f09:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f15:	8a 12                	mov    (%edx),%dl
  800f17:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f19:	ff 4d 10             	decl   0x10(%ebp)
  800f1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f20:	74 09                	je     800f2b <strlcpy+0x3c>
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	84 c0                	test   %al,%al
  800f29:	75 d8                	jne    800f03 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f31:	8b 55 08             	mov    0x8(%ebp),%edx
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	29 c2                	sub    %eax,%edx
  800f39:	89 d0                	mov    %edx,%eax
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f40:	eb 06                	jmp    800f48 <strcmp+0xb>
		p++, q++;
  800f42:	ff 45 08             	incl   0x8(%ebp)
  800f45:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	84 c0                	test   %al,%al
  800f4f:	74 0e                	je     800f5f <strcmp+0x22>
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 10                	mov    (%eax),%dl
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	38 c2                	cmp    %al,%dl
  800f5d:	74 e3                	je     800f42 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	0f b6 d0             	movzbl %al,%edx
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	0f b6 c0             	movzbl %al,%eax
  800f6f:	29 c2                	sub    %eax,%edx
  800f71:	89 d0                	mov    %edx,%eax
}
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f78:	eb 09                	jmp    800f83 <strncmp+0xe>
		n--, p++, q++;
  800f7a:	ff 4d 10             	decl   0x10(%ebp)
  800f7d:	ff 45 08             	incl   0x8(%ebp)
  800f80:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f87:	74 17                	je     800fa0 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	84 c0                	test   %al,%al
  800f90:	74 0e                	je     800fa0 <strncmp+0x2b>
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 10                	mov    (%eax),%dl
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	38 c2                	cmp    %al,%dl
  800f9e:	74 da                	je     800f7a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	75 07                	jne    800fad <strncmp+0x38>
		return 0;
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fab:	eb 14                	jmp    800fc1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f b6 d0             	movzbl %al,%edx
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f b6 c0             	movzbl %al,%eax
  800fbd:	29 c2                	sub    %eax,%edx
  800fbf:	89 d0                	mov    %edx,%eax
}
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 04             	sub    $0x4,%esp
  800fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fcf:	eb 12                	jmp    800fe3 <strchr+0x20>
		if (*s == c)
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd9:	75 05                	jne    800fe0 <strchr+0x1d>
			return (char *) s;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	eb 11                	jmp    800ff1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fe0:	ff 45 08             	incl   0x8(%ebp)
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	84 c0                	test   %al,%al
  800fea:	75 e5                	jne    800fd1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 04             	sub    $0x4,%esp
  800ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fff:	eb 0d                	jmp    80100e <strfind+0x1b>
		if (*s == c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801009:	74 0e                	je     801019 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80100b:	ff 45 08             	incl   0x8(%ebp)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	84 c0                	test   %al,%al
  801015:	75 ea                	jne    801001 <strfind+0xe>
  801017:	eb 01                	jmp    80101a <strfind+0x27>
		if (*s == c)
			break;
  801019:	90                   	nop
	return (char *) s;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80102b:	8b 45 10             	mov    0x10(%ebp),%eax
  80102e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801031:	eb 0e                	jmp    801041 <memset+0x22>
		*p++ = c;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801036:	8d 50 01             	lea    0x1(%eax),%edx
  801039:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80103c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801041:	ff 4d f8             	decl   -0x8(%ebp)
  801044:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801048:	79 e9                	jns    801033 <memset+0x14>
		*p++ = c;

	return v;
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801061:	eb 16                	jmp    801079 <memcpy+0x2a>
		*d++ = *s++;
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801066:	8d 50 01             	lea    0x1(%eax),%edx
  801069:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80106c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80106f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801072:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801075:	8a 12                	mov    (%edx),%dl
  801077:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107f:	89 55 10             	mov    %edx,0x10(%ebp)
  801082:	85 c0                	test   %eax,%eax
  801084:	75 dd                	jne    801063 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80109d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a3:	73 50                	jae    8010f5 <memmove+0x6a>
  8010a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	01 d0                	add    %edx,%eax
  8010ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010b0:	76 43                	jbe    8010f5 <memmove+0x6a>
		s += n;
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010be:	eb 10                	jmp    8010d0 <memmove+0x45>
			*--d = *--s;
  8010c0:	ff 4d f8             	decl   -0x8(%ebp)
  8010c3:	ff 4d fc             	decl   -0x4(%ebp)
  8010c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c9:	8a 10                	mov    (%eax),%dl
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 e3                	jne    8010c0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010dd:	eb 23                	jmp    801102 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e2:	8d 50 01             	lea    0x1(%eax),%edx
  8010e5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010f1:	8a 12                	mov    (%edx),%dl
  8010f3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fe:	85 c0                	test   %eax,%eax
  801100:	75 dd                	jne    8010df <memmove+0x54>
			*d++ = *s++;

	return dst;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801119:	eb 2a                	jmp    801145 <memcmp+0x3e>
		if (*s1 != *s2)
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111e:	8a 10                	mov    (%eax),%dl
  801120:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	38 c2                	cmp    %al,%dl
  801127:	74 16                	je     80113f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f b6 d0             	movzbl %al,%edx
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	0f b6 c0             	movzbl %al,%eax
  801139:	29 c2                	sub    %eax,%edx
  80113b:	89 d0                	mov    %edx,%eax
  80113d:	eb 18                	jmp    801157 <memcmp+0x50>
		s1++, s2++;
  80113f:	ff 45 fc             	incl   -0x4(%ebp)
  801142:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114b:	89 55 10             	mov    %edx,0x10(%ebp)
  80114e:	85 c0                	test   %eax,%eax
  801150:	75 c9                	jne    80111b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801152:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801157:	c9                   	leave  
  801158:	c3                   	ret    

00801159 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80115f:	8b 55 08             	mov    0x8(%ebp),%edx
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	01 d0                	add    %edx,%eax
  801167:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80116a:	eb 15                	jmp    801181 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	0f b6 d0             	movzbl %al,%edx
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	0f b6 c0             	movzbl %al,%eax
  80117a:	39 c2                	cmp    %eax,%edx
  80117c:	74 0d                	je     80118b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80117e:	ff 45 08             	incl   0x8(%ebp)
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801187:	72 e3                	jb     80116c <memfind+0x13>
  801189:	eb 01                	jmp    80118c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80118b:	90                   	nop
	return (void *) s;
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801197:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80119e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a5:	eb 03                	jmp    8011aa <strtol+0x19>
		s++;
  8011a7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 20                	cmp    $0x20,%al
  8011b1:	74 f4                	je     8011a7 <strtol+0x16>
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 09                	cmp    $0x9,%al
  8011ba:	74 eb                	je     8011a7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	3c 2b                	cmp    $0x2b,%al
  8011c3:	75 05                	jne    8011ca <strtol+0x39>
		s++;
  8011c5:	ff 45 08             	incl   0x8(%ebp)
  8011c8:	eb 13                	jmp    8011dd <strtol+0x4c>
	else if (*s == '-')
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	3c 2d                	cmp    $0x2d,%al
  8011d1:	75 0a                	jne    8011dd <strtol+0x4c>
		s++, neg = 1;
  8011d3:	ff 45 08             	incl   0x8(%ebp)
  8011d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	74 06                	je     8011e9 <strtol+0x58>
  8011e3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011e7:	75 20                	jne    801209 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 30                	cmp    $0x30,%al
  8011f0:	75 17                	jne    801209 <strtol+0x78>
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	40                   	inc    %eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	3c 78                	cmp    $0x78,%al
  8011fa:	75 0d                	jne    801209 <strtol+0x78>
		s += 2, base = 16;
  8011fc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801200:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801207:	eb 28                	jmp    801231 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801209:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120d:	75 15                	jne    801224 <strtol+0x93>
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	3c 30                	cmp    $0x30,%al
  801216:	75 0c                	jne    801224 <strtol+0x93>
		s++, base = 8;
  801218:	ff 45 08             	incl   0x8(%ebp)
  80121b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801222:	eb 0d                	jmp    801231 <strtol+0xa0>
	else if (base == 0)
  801224:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801228:	75 07                	jne    801231 <strtol+0xa0>
		base = 10;
  80122a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 2f                	cmp    $0x2f,%al
  801238:	7e 19                	jle    801253 <strtol+0xc2>
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	3c 39                	cmp    $0x39,%al
  801241:	7f 10                	jg     801253 <strtol+0xc2>
			dig = *s - '0';
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	0f be c0             	movsbl %al,%eax
  80124b:	83 e8 30             	sub    $0x30,%eax
  80124e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801251:	eb 42                	jmp    801295 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 60                	cmp    $0x60,%al
  80125a:	7e 19                	jle    801275 <strtol+0xe4>
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	3c 7a                	cmp    $0x7a,%al
  801263:	7f 10                	jg     801275 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	8a 00                	mov    (%eax),%al
  80126a:	0f be c0             	movsbl %al,%eax
  80126d:	83 e8 57             	sub    $0x57,%eax
  801270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801273:	eb 20                	jmp    801295 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 40                	cmp    $0x40,%al
  80127c:	7e 39                	jle    8012b7 <strtol+0x126>
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 5a                	cmp    $0x5a,%al
  801285:	7f 30                	jg     8012b7 <strtol+0x126>
			dig = *s - 'A' + 10;
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	0f be c0             	movsbl %al,%eax
  80128f:	83 e8 37             	sub    $0x37,%eax
  801292:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801298:	3b 45 10             	cmp    0x10(%ebp),%eax
  80129b:	7d 19                	jge    8012b6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80129d:	ff 45 08             	incl   0x8(%ebp)
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012a7:	89 c2                	mov    %eax,%edx
  8012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ac:	01 d0                	add    %edx,%eax
  8012ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012b1:	e9 7b ff ff ff       	jmp    801231 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012b6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012bb:	74 08                	je     8012c5 <strtol+0x134>
		*endptr = (char *) s;
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c9:	74 07                	je     8012d2 <strtol+0x141>
  8012cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ce:	f7 d8                	neg    %eax
  8012d0:	eb 03                	jmp    8012d5 <strtol+0x144>
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <ltostr>:

void
ltostr(long value, char *str)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ef:	79 13                	jns    801304 <ltostr+0x2d>
	{
		neg = 1;
  8012f1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012fe:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801301:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80130c:	99                   	cltd   
  80130d:	f7 f9                	idiv   %ecx
  80130f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801312:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801315:	8d 50 01             	lea    0x1(%eax),%edx
  801318:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80131b:	89 c2                	mov    %eax,%edx
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	01 d0                	add    %edx,%eax
  801322:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801325:	83 c2 30             	add    $0x30,%edx
  801328:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80132a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801332:	f7 e9                	imul   %ecx
  801334:	c1 fa 02             	sar    $0x2,%edx
  801337:	89 c8                	mov    %ecx,%eax
  801339:	c1 f8 1f             	sar    $0x1f,%eax
  80133c:	29 c2                	sub    %eax,%edx
  80133e:	89 d0                	mov    %edx,%eax
  801340:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801343:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801346:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80134b:	f7 e9                	imul   %ecx
  80134d:	c1 fa 02             	sar    $0x2,%edx
  801350:	89 c8                	mov    %ecx,%eax
  801352:	c1 f8 1f             	sar    $0x1f,%eax
  801355:	29 c2                	sub    %eax,%edx
  801357:	89 d0                	mov    %edx,%eax
  801359:	c1 e0 02             	shl    $0x2,%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	01 c0                	add    %eax,%eax
  801360:	29 c1                	sub    %eax,%ecx
  801362:	89 ca                	mov    %ecx,%edx
  801364:	85 d2                	test   %edx,%edx
  801366:	75 9c                	jne    801304 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80136f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801372:	48                   	dec    %eax
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801376:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137a:	74 3d                	je     8013b9 <ltostr+0xe2>
		start = 1 ;
  80137c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801383:	eb 34                	jmp    8013b9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138b:	01 d0                	add    %edx,%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801392:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
  801398:	01 c2                	add    %eax,%edx
  80139a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80139d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a0:	01 c8                	add    %ecx,%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	01 c2                	add    %eax,%edx
  8013ae:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013b1:	88 02                	mov    %al,(%edx)
		start++ ;
  8013b3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013b6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013bf:	7c c4                	jl     801385 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013cc:	90                   	nop
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013d5:	ff 75 08             	pushl  0x8(%ebp)
  8013d8:	e8 54 fa ff ff       	call   800e31 <strlen>
  8013dd:	83 c4 04             	add    $0x4,%esp
  8013e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	e8 46 fa ff ff       	call   800e31 <strlen>
  8013eb:	83 c4 04             	add    $0x4,%esp
  8013ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ff:	eb 17                	jmp    801418 <strcconcat+0x49>
		final[s] = str1[s] ;
  801401:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	01 c2                	add    %eax,%edx
  801409:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	01 c8                	add    %ecx,%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801415:	ff 45 fc             	incl   -0x4(%ebp)
  801418:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80141e:	7c e1                	jl     801401 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801420:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801427:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80142e:	eb 1f                	jmp    80144f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801433:	8d 50 01             	lea    0x1(%eax),%edx
  801436:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801439:	89 c2                	mov    %eax,%edx
  80143b:	8b 45 10             	mov    0x10(%ebp),%eax
  80143e:	01 c2                	add    %eax,%edx
  801440:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801443:	8b 45 0c             	mov    0xc(%ebp),%eax
  801446:	01 c8                	add    %ecx,%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80144c:	ff 45 f8             	incl   -0x8(%ebp)
  80144f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801452:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801455:	7c d9                	jl     801430 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801457:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145a:	8b 45 10             	mov    0x10(%ebp),%eax
  80145d:	01 d0                	add    %edx,%eax
  80145f:	c6 00 00             	movb   $0x0,(%eax)
}
  801462:	90                   	nop
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801471:	8b 45 14             	mov    0x14(%ebp),%eax
  801474:	8b 00                	mov    (%eax),%eax
  801476:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147d:	8b 45 10             	mov    0x10(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801488:	eb 0c                	jmp    801496 <strsplit+0x31>
			*string++ = 0;
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	8d 50 01             	lea    0x1(%eax),%edx
  801490:	89 55 08             	mov    %edx,0x8(%ebp)
  801493:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	84 c0                	test   %al,%al
  80149d:	74 18                	je     8014b7 <strsplit+0x52>
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	0f be c0             	movsbl %al,%eax
  8014a7:	50                   	push   %eax
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	e8 13 fb ff ff       	call   800fc3 <strchr>
  8014b0:	83 c4 08             	add    $0x8,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 d3                	jne    80148a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	84 c0                	test   %al,%al
  8014be:	74 5a                	je     80151a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	83 f8 0f             	cmp    $0xf,%eax
  8014c8:	75 07                	jne    8014d1 <strsplit+0x6c>
		{
			return 0;
  8014ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cf:	eb 66                	jmp    801537 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d4:	8b 00                	mov    (%eax),%eax
  8014d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8014dc:	89 0a                	mov    %ecx,(%edx)
  8014de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e8:	01 c2                	add    %eax,%edx
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ef:	eb 03                	jmp    8014f4 <strsplit+0x8f>
			string++;
  8014f1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	84 c0                	test   %al,%al
  8014fb:	74 8b                	je     801488 <strsplit+0x23>
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	0f be c0             	movsbl %al,%eax
  801505:	50                   	push   %eax
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	e8 b5 fa ff ff       	call   800fc3 <strchr>
  80150e:	83 c4 08             	add    $0x8,%esp
  801511:	85 c0                	test   %eax,%eax
  801513:	74 dc                	je     8014f1 <strsplit+0x8c>
			string++;
	}
  801515:	e9 6e ff ff ff       	jmp    801488 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80151a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80151b:	8b 45 14             	mov    0x14(%ebp),%eax
  80151e:	8b 00                	mov    (%eax),%eax
  801520:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801527:	8b 45 10             	mov    0x10(%ebp),%eax
  80152a:	01 d0                	add    %edx,%eax
  80152c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801532:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	57                   	push   %edi
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8b 55 0c             	mov    0xc(%ebp),%edx
  801548:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80154b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801551:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801554:	cd 30                	int    $0x30
  801556:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801559:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5f                   	pop    %edi
  801562:	5d                   	pop    %ebp
  801563:	c3                   	ret    

00801564 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	8b 45 10             	mov    0x10(%ebp),%eax
  80156d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801570:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	52                   	push   %edx
  80157c:	ff 75 0c             	pushl  0xc(%ebp)
  80157f:	50                   	push   %eax
  801580:	6a 00                	push   $0x0
  801582:	e8 b2 ff ff ff       	call   801539 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	90                   	nop
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_cgetc>:

int
sys_cgetc(void)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 01                	push   $0x1
  80159c:	e8 98 ff ff ff       	call   801539 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	52                   	push   %edx
  8015b6:	50                   	push   %eax
  8015b7:	6a 05                	push   $0x5
  8015b9:	e8 7b ff ff ff       	call   801539 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8015cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	56                   	push   %esi
  8015d8:	53                   	push   %ebx
  8015d9:	51                   	push   %ecx
  8015da:	52                   	push   %edx
  8015db:	50                   	push   %eax
  8015dc:	6a 06                	push   $0x6
  8015de:	e8 56 ff ff ff       	call   801539 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
}
  8015e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e9:	5b                   	pop    %ebx
  8015ea:	5e                   	pop    %esi
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    

008015ed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	52                   	push   %edx
  8015fd:	50                   	push   %eax
  8015fe:	6a 07                	push   $0x7
  801600:	e8 34 ff ff ff       	call   801539 <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	ff 75 08             	pushl  0x8(%ebp)
  801619:	6a 08                	push   $0x8
  80161b:	e8 19 ff ff ff       	call   801539 <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 09                	push   $0x9
  801634:	e8 00 ff ff ff       	call   801539 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 0a                	push   $0xa
  80164d:	e8 e7 fe ff ff       	call   801539 <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 0b                	push   $0xb
  801666:	e8 ce fe ff ff       	call   801539 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	6a 0f                	push   $0xf
  801681:	e8 b3 fe ff ff       	call   801539 <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
	return;
  801689:	90                   	nop
}
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	ff 75 0c             	pushl  0xc(%ebp)
  801698:	ff 75 08             	pushl  0x8(%ebp)
  80169b:	6a 10                	push   $0x10
  80169d:	e8 97 fe ff ff       	call   801539 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a5:	90                   	nop
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	ff 75 10             	pushl  0x10(%ebp)
  8016b2:	ff 75 0c             	pushl  0xc(%ebp)
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	6a 11                	push   $0x11
  8016ba:	e8 7a fe ff ff       	call   801539 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c2:	90                   	nop
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 0c                	push   $0xc
  8016d4:	e8 60 fe ff ff       	call   801539 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	ff 75 08             	pushl  0x8(%ebp)
  8016ec:	6a 0d                	push   $0xd
  8016ee:	e8 46 fe ff ff       	call   801539 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 0e                	push   $0xe
  801707:	e8 2d fe ff ff       	call   801539 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 13                	push   $0x13
  801721:	e8 13 fe ff ff       	call   801539 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	90                   	nop
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 14                	push   $0x14
  80173b:	e8 f9 fd ff ff       	call   801539 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	90                   	nop
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_cputc>:


void
sys_cputc(const char c)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801752:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	50                   	push   %eax
  80175f:	6a 15                	push   $0x15
  801761:	e8 d3 fd ff ff       	call   801539 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	90                   	nop
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 16                	push   $0x16
  80177b:	e8 b9 fd ff ff       	call   801539 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	90                   	nop
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	50                   	push   %eax
  801796:	6a 17                	push   $0x17
  801798:	e8 9c fd ff ff       	call   801539 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	52                   	push   %edx
  8017b2:	50                   	push   %eax
  8017b3:	6a 1a                	push   $0x1a
  8017b5:	e8 7f fd ff ff       	call   801539 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	52                   	push   %edx
  8017cf:	50                   	push   %eax
  8017d0:	6a 18                	push   $0x18
  8017d2:	e8 62 fd ff ff       	call   801539 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	90                   	nop
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	52                   	push   %edx
  8017ed:	50                   	push   %eax
  8017ee:	6a 19                	push   $0x19
  8017f0:	e8 44 fd ff ff       	call   801539 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	90                   	nop
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 04             	sub    $0x4,%esp
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801807:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80180a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	6a 00                	push   $0x0
  801813:	51                   	push   %ecx
  801814:	52                   	push   %edx
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	50                   	push   %eax
  801819:	6a 1b                	push   $0x1b
  80181b:	e8 19 fd ff ff       	call   801539 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	52                   	push   %edx
  801835:	50                   	push   %eax
  801836:	6a 1c                	push   $0x1c
  801838:	e8 fc fc ff ff       	call   801539 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801845:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	51                   	push   %ecx
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	6a 1d                	push   $0x1d
  801857:	e8 dd fc ff ff       	call   801539 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	6a 1e                	push   $0x1e
  801874:	e8 c0 fc ff ff       	call   801539 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 1f                	push   $0x1f
  80188d:	e8 a7 fc ff ff       	call   801539 <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	ff 75 14             	pushl  0x14(%ebp)
  8018a2:	ff 75 10             	pushl  0x10(%ebp)
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	50                   	push   %eax
  8018a9:	6a 20                	push   $0x20
  8018ab:	e8 89 fc ff ff       	call   801539 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	50                   	push   %eax
  8018c4:	6a 21                	push   $0x21
  8018c6:	e8 6e fc ff ff       	call   801539 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	90                   	nop
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	50                   	push   %eax
  8018e0:	6a 22                	push   $0x22
  8018e2:	e8 52 fc ff ff       	call   801539 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 02                	push   $0x2
  8018fb:	e8 39 fc ff ff       	call   801539 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 03                	push   $0x3
  801914:	e8 20 fc ff ff       	call   801539 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 04                	push   $0x4
  80192d:	e8 07 fc ff ff       	call   801539 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_exit_env>:


void sys_exit_env(void)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 23                	push   $0x23
  801946:	e8 ee fb ff ff       	call   801539 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	90                   	nop
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801957:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80195a:	8d 50 04             	lea    0x4(%eax),%edx
  80195d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	52                   	push   %edx
  801967:	50                   	push   %eax
  801968:	6a 24                	push   $0x24
  80196a:	e8 ca fb ff ff       	call   801539 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
	return result;
  801972:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801975:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801978:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80197b:	89 01                	mov    %eax,(%ecx)
  80197d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	c9                   	leave  
  801984:	c2 04 00             	ret    $0x4

00801987 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 10             	pushl  0x10(%ebp)
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 12                	push   $0x12
  801999:	e8 9b fb ff ff       	call   801539 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 25                	push   $0x25
  8019b3:	e8 81 fb ff ff       	call   801539 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019c9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	50                   	push   %eax
  8019d6:	6a 26                	push   $0x26
  8019d8:	e8 5c fb ff ff       	call   801539 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <rsttst>:
void rsttst()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 28                	push   $0x28
  8019f2:	e8 42 fb ff ff       	call   801539 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fa:	90                   	nop
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	8b 45 14             	mov    0x14(%ebp),%eax
  801a06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a09:	8b 55 18             	mov    0x18(%ebp),%edx
  801a0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a10:	52                   	push   %edx
  801a11:	50                   	push   %eax
  801a12:	ff 75 10             	pushl  0x10(%ebp)
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	6a 27                	push   $0x27
  801a1d:	e8 17 fb ff ff       	call   801539 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
	return ;
  801a25:	90                   	nop
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <chktst>:
void chktst(uint32 n)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	6a 29                	push   $0x29
  801a38:	e8 fc fa ff ff       	call   801539 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <inctst>:

void inctst()
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 2a                	push   $0x2a
  801a52:	e8 e2 fa ff ff       	call   801539 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <gettst>:
uint32 gettst()
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 2b                	push   $0x2b
  801a6c:	e8 c8 fa ff ff       	call   801539 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 2c                	push   $0x2c
  801a88:	e8 ac fa ff ff       	call   801539 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
  801a90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a93:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a97:	75 07                	jne    801aa0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a99:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9e:	eb 05                	jmp    801aa5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801aa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 2c                	push   $0x2c
  801ab9:	e8 7b fa ff ff       	call   801539 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
  801ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ac4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ac8:	75 07                	jne    801ad1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801aca:	b8 01 00 00 00       	mov    $0x1,%eax
  801acf:	eb 05                	jmp    801ad6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 2c                	push   $0x2c
  801aea:	e8 4a fa ff ff       	call   801539 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
  801af2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801af5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801af9:	75 07                	jne    801b02 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801afb:	b8 01 00 00 00       	mov    $0x1,%eax
  801b00:	eb 05                	jmp    801b07 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 2c                	push   $0x2c
  801b1b:	e8 19 fa ff ff       	call   801539 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
  801b23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b26:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b2a:	75 07                	jne    801b33 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b31:	eb 05                	jmp    801b38 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	6a 2d                	push   $0x2d
  801b4a:	e8 ea f9 ff ff       	call   801539 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b52:	90                   	nop
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	53                   	push   %ebx
  801b68:	51                   	push   %ecx
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 2e                	push   $0x2e
  801b6d:	e8 c7 f9 ff ff       	call   801539 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 2f                	push   $0x2f
  801b8d:	e8 a7 f9 ff ff       	call   801539 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    
  801b97:	90                   	nop

00801b98 <__udivdi3>:
  801b98:	55                   	push   %ebp
  801b99:	57                   	push   %edi
  801b9a:	56                   	push   %esi
  801b9b:	53                   	push   %ebx
  801b9c:	83 ec 1c             	sub    $0x1c,%esp
  801b9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ba3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ba7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801baf:	89 ca                	mov    %ecx,%edx
  801bb1:	89 f8                	mov    %edi,%eax
  801bb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bb7:	85 f6                	test   %esi,%esi
  801bb9:	75 2d                	jne    801be8 <__udivdi3+0x50>
  801bbb:	39 cf                	cmp    %ecx,%edi
  801bbd:	77 65                	ja     801c24 <__udivdi3+0x8c>
  801bbf:	89 fd                	mov    %edi,%ebp
  801bc1:	85 ff                	test   %edi,%edi
  801bc3:	75 0b                	jne    801bd0 <__udivdi3+0x38>
  801bc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bca:	31 d2                	xor    %edx,%edx
  801bcc:	f7 f7                	div    %edi
  801bce:	89 c5                	mov    %eax,%ebp
  801bd0:	31 d2                	xor    %edx,%edx
  801bd2:	89 c8                	mov    %ecx,%eax
  801bd4:	f7 f5                	div    %ebp
  801bd6:	89 c1                	mov    %eax,%ecx
  801bd8:	89 d8                	mov    %ebx,%eax
  801bda:	f7 f5                	div    %ebp
  801bdc:	89 cf                	mov    %ecx,%edi
  801bde:	89 fa                	mov    %edi,%edx
  801be0:	83 c4 1c             	add    $0x1c,%esp
  801be3:	5b                   	pop    %ebx
  801be4:	5e                   	pop    %esi
  801be5:	5f                   	pop    %edi
  801be6:	5d                   	pop    %ebp
  801be7:	c3                   	ret    
  801be8:	39 ce                	cmp    %ecx,%esi
  801bea:	77 28                	ja     801c14 <__udivdi3+0x7c>
  801bec:	0f bd fe             	bsr    %esi,%edi
  801bef:	83 f7 1f             	xor    $0x1f,%edi
  801bf2:	75 40                	jne    801c34 <__udivdi3+0x9c>
  801bf4:	39 ce                	cmp    %ecx,%esi
  801bf6:	72 0a                	jb     801c02 <__udivdi3+0x6a>
  801bf8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bfc:	0f 87 9e 00 00 00    	ja     801ca0 <__udivdi3+0x108>
  801c02:	b8 01 00 00 00       	mov    $0x1,%eax
  801c07:	89 fa                	mov    %edi,%edx
  801c09:	83 c4 1c             	add    $0x1c,%esp
  801c0c:	5b                   	pop    %ebx
  801c0d:	5e                   	pop    %esi
  801c0e:	5f                   	pop    %edi
  801c0f:	5d                   	pop    %ebp
  801c10:	c3                   	ret    
  801c11:	8d 76 00             	lea    0x0(%esi),%esi
  801c14:	31 ff                	xor    %edi,%edi
  801c16:	31 c0                	xor    %eax,%eax
  801c18:	89 fa                	mov    %edi,%edx
  801c1a:	83 c4 1c             	add    $0x1c,%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5f                   	pop    %edi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    
  801c22:	66 90                	xchg   %ax,%ax
  801c24:	89 d8                	mov    %ebx,%eax
  801c26:	f7 f7                	div    %edi
  801c28:	31 ff                	xor    %edi,%edi
  801c2a:	89 fa                	mov    %edi,%edx
  801c2c:	83 c4 1c             	add    $0x1c,%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5f                   	pop    %edi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    
  801c34:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c39:	89 eb                	mov    %ebp,%ebx
  801c3b:	29 fb                	sub    %edi,%ebx
  801c3d:	89 f9                	mov    %edi,%ecx
  801c3f:	d3 e6                	shl    %cl,%esi
  801c41:	89 c5                	mov    %eax,%ebp
  801c43:	88 d9                	mov    %bl,%cl
  801c45:	d3 ed                	shr    %cl,%ebp
  801c47:	89 e9                	mov    %ebp,%ecx
  801c49:	09 f1                	or     %esi,%ecx
  801c4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c4f:	89 f9                	mov    %edi,%ecx
  801c51:	d3 e0                	shl    %cl,%eax
  801c53:	89 c5                	mov    %eax,%ebp
  801c55:	89 d6                	mov    %edx,%esi
  801c57:	88 d9                	mov    %bl,%cl
  801c59:	d3 ee                	shr    %cl,%esi
  801c5b:	89 f9                	mov    %edi,%ecx
  801c5d:	d3 e2                	shl    %cl,%edx
  801c5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c63:	88 d9                	mov    %bl,%cl
  801c65:	d3 e8                	shr    %cl,%eax
  801c67:	09 c2                	or     %eax,%edx
  801c69:	89 d0                	mov    %edx,%eax
  801c6b:	89 f2                	mov    %esi,%edx
  801c6d:	f7 74 24 0c          	divl   0xc(%esp)
  801c71:	89 d6                	mov    %edx,%esi
  801c73:	89 c3                	mov    %eax,%ebx
  801c75:	f7 e5                	mul    %ebp
  801c77:	39 d6                	cmp    %edx,%esi
  801c79:	72 19                	jb     801c94 <__udivdi3+0xfc>
  801c7b:	74 0b                	je     801c88 <__udivdi3+0xf0>
  801c7d:	89 d8                	mov    %ebx,%eax
  801c7f:	31 ff                	xor    %edi,%edi
  801c81:	e9 58 ff ff ff       	jmp    801bde <__udivdi3+0x46>
  801c86:	66 90                	xchg   %ax,%ax
  801c88:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c8c:	89 f9                	mov    %edi,%ecx
  801c8e:	d3 e2                	shl    %cl,%edx
  801c90:	39 c2                	cmp    %eax,%edx
  801c92:	73 e9                	jae    801c7d <__udivdi3+0xe5>
  801c94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c97:	31 ff                	xor    %edi,%edi
  801c99:	e9 40 ff ff ff       	jmp    801bde <__udivdi3+0x46>
  801c9e:	66 90                	xchg   %ax,%ax
  801ca0:	31 c0                	xor    %eax,%eax
  801ca2:	e9 37 ff ff ff       	jmp    801bde <__udivdi3+0x46>
  801ca7:	90                   	nop

00801ca8 <__umoddi3>:
  801ca8:	55                   	push   %ebp
  801ca9:	57                   	push   %edi
  801caa:	56                   	push   %esi
  801cab:	53                   	push   %ebx
  801cac:	83 ec 1c             	sub    $0x1c,%esp
  801caf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cc7:	89 f3                	mov    %esi,%ebx
  801cc9:	89 fa                	mov    %edi,%edx
  801ccb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ccf:	89 34 24             	mov    %esi,(%esp)
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	75 1a                	jne    801cf0 <__umoddi3+0x48>
  801cd6:	39 f7                	cmp    %esi,%edi
  801cd8:	0f 86 a2 00 00 00    	jbe    801d80 <__umoddi3+0xd8>
  801cde:	89 c8                	mov    %ecx,%eax
  801ce0:	89 f2                	mov    %esi,%edx
  801ce2:	f7 f7                	div    %edi
  801ce4:	89 d0                	mov    %edx,%eax
  801ce6:	31 d2                	xor    %edx,%edx
  801ce8:	83 c4 1c             	add    $0x1c,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    
  801cf0:	39 f0                	cmp    %esi,%eax
  801cf2:	0f 87 ac 00 00 00    	ja     801da4 <__umoddi3+0xfc>
  801cf8:	0f bd e8             	bsr    %eax,%ebp
  801cfb:	83 f5 1f             	xor    $0x1f,%ebp
  801cfe:	0f 84 ac 00 00 00    	je     801db0 <__umoddi3+0x108>
  801d04:	bf 20 00 00 00       	mov    $0x20,%edi
  801d09:	29 ef                	sub    %ebp,%edi
  801d0b:	89 fe                	mov    %edi,%esi
  801d0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d11:	89 e9                	mov    %ebp,%ecx
  801d13:	d3 e0                	shl    %cl,%eax
  801d15:	89 d7                	mov    %edx,%edi
  801d17:	89 f1                	mov    %esi,%ecx
  801d19:	d3 ef                	shr    %cl,%edi
  801d1b:	09 c7                	or     %eax,%edi
  801d1d:	89 e9                	mov    %ebp,%ecx
  801d1f:	d3 e2                	shl    %cl,%edx
  801d21:	89 14 24             	mov    %edx,(%esp)
  801d24:	89 d8                	mov    %ebx,%eax
  801d26:	d3 e0                	shl    %cl,%eax
  801d28:	89 c2                	mov    %eax,%edx
  801d2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d2e:	d3 e0                	shl    %cl,%eax
  801d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d34:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d38:	89 f1                	mov    %esi,%ecx
  801d3a:	d3 e8                	shr    %cl,%eax
  801d3c:	09 d0                	or     %edx,%eax
  801d3e:	d3 eb                	shr    %cl,%ebx
  801d40:	89 da                	mov    %ebx,%edx
  801d42:	f7 f7                	div    %edi
  801d44:	89 d3                	mov    %edx,%ebx
  801d46:	f7 24 24             	mull   (%esp)
  801d49:	89 c6                	mov    %eax,%esi
  801d4b:	89 d1                	mov    %edx,%ecx
  801d4d:	39 d3                	cmp    %edx,%ebx
  801d4f:	0f 82 87 00 00 00    	jb     801ddc <__umoddi3+0x134>
  801d55:	0f 84 91 00 00 00    	je     801dec <__umoddi3+0x144>
  801d5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d5f:	29 f2                	sub    %esi,%edx
  801d61:	19 cb                	sbb    %ecx,%ebx
  801d63:	89 d8                	mov    %ebx,%eax
  801d65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d69:	d3 e0                	shl    %cl,%eax
  801d6b:	89 e9                	mov    %ebp,%ecx
  801d6d:	d3 ea                	shr    %cl,%edx
  801d6f:	09 d0                	or     %edx,%eax
  801d71:	89 e9                	mov    %ebp,%ecx
  801d73:	d3 eb                	shr    %cl,%ebx
  801d75:	89 da                	mov    %ebx,%edx
  801d77:	83 c4 1c             	add    $0x1c,%esp
  801d7a:	5b                   	pop    %ebx
  801d7b:	5e                   	pop    %esi
  801d7c:	5f                   	pop    %edi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    
  801d7f:	90                   	nop
  801d80:	89 fd                	mov    %edi,%ebp
  801d82:	85 ff                	test   %edi,%edi
  801d84:	75 0b                	jne    801d91 <__umoddi3+0xe9>
  801d86:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8b:	31 d2                	xor    %edx,%edx
  801d8d:	f7 f7                	div    %edi
  801d8f:	89 c5                	mov    %eax,%ebp
  801d91:	89 f0                	mov    %esi,%eax
  801d93:	31 d2                	xor    %edx,%edx
  801d95:	f7 f5                	div    %ebp
  801d97:	89 c8                	mov    %ecx,%eax
  801d99:	f7 f5                	div    %ebp
  801d9b:	89 d0                	mov    %edx,%eax
  801d9d:	e9 44 ff ff ff       	jmp    801ce6 <__umoddi3+0x3e>
  801da2:	66 90                	xchg   %ax,%ax
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	89 f2                	mov    %esi,%edx
  801da8:	83 c4 1c             	add    $0x1c,%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5f                   	pop    %edi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    
  801db0:	3b 04 24             	cmp    (%esp),%eax
  801db3:	72 06                	jb     801dbb <__umoddi3+0x113>
  801db5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801db9:	77 0f                	ja     801dca <__umoddi3+0x122>
  801dbb:	89 f2                	mov    %esi,%edx
  801dbd:	29 f9                	sub    %edi,%ecx
  801dbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dc3:	89 14 24             	mov    %edx,(%esp)
  801dc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dca:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dce:	8b 14 24             	mov    (%esp),%edx
  801dd1:	83 c4 1c             	add    $0x1c,%esp
  801dd4:	5b                   	pop    %ebx
  801dd5:	5e                   	pop    %esi
  801dd6:	5f                   	pop    %edi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    
  801dd9:	8d 76 00             	lea    0x0(%esi),%esi
  801ddc:	2b 04 24             	sub    (%esp),%eax
  801ddf:	19 fa                	sbb    %edi,%edx
  801de1:	89 d1                	mov    %edx,%ecx
  801de3:	89 c6                	mov    %eax,%esi
  801de5:	e9 71 ff ff ff       	jmp    801d5b <__umoddi3+0xb3>
  801dea:	66 90                	xchg   %ax,%ax
  801dec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801df0:	72 ea                	jb     801ddc <__umoddi3+0x134>
  801df2:	89 d9                	mov    %ebx,%ecx
  801df4:	e9 62 ff ff ff       	jmp    801d5b <__umoddi3+0xb3>
