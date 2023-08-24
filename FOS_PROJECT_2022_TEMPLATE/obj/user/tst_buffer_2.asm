
obj/user/tst_buffer_2:     file format elf32-i386


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
  800031:	e8 26 09 00 00       	call   80095c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/*SHOULD be on User DATA not on the STACK*/
char arr[PAGE_SIZE*1024*14 + PAGE_SIZE];
//=========================================

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp



	/*[1] CHECK INITIAL WORKING SET*/
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80004c:	8b 00                	mov    (%eax),%eax
  80004e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800051:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800059:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 60 24 80 00       	push   $0x802460
  800068:	6a 17                	push   $0x17
  80006a:	68 a8 24 80 00       	push   $0x8024a8
  80006f:	e8 37 0a 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80007f:	83 c0 18             	add    $0x18,%eax
  800082:	8b 00                	mov    (%eax),%eax
  800084:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008f:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800094:	74 14                	je     8000aa <_main+0x72>
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	68 60 24 80 00       	push   $0x802460
  80009e:	6a 18                	push   $0x18
  8000a0:	68 a8 24 80 00       	push   $0x8024a8
  8000a5:	e8 01 0a 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8000af:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000b5:	83 c0 30             	add    $0x30,%eax
  8000b8:	8b 00                	mov    (%eax),%eax
  8000ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c5:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 60 24 80 00       	push   $0x802460
  8000d4:	6a 19                	push   $0x19
  8000d6:	68 a8 24 80 00       	push   $0x8024a8
  8000db:	e8 cb 09 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8000eb:	83 c0 48             	add    $0x48,%eax
  8000ee:	8b 00                	mov    (%eax),%eax
  8000f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fb:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800100:	74 14                	je     800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 60 24 80 00       	push   $0x802460
  80010a:	6a 1a                	push   $0x1a
  80010c:	68 a8 24 80 00       	push   $0x8024a8
  800111:	e8 95 09 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800121:	83 c0 60             	add    $0x60,%eax
  800124:	8b 00                	mov    (%eax),%eax
  800126:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800129:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80012c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800131:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 60 24 80 00       	push   $0x802460
  800140:	6a 1b                	push   $0x1b
  800142:	68 a8 24 80 00       	push   $0x8024a8
  800147:	e8 5f 09 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800157:	83 c0 78             	add    $0x78,%eax
  80015a:	8b 00                	mov    (%eax),%eax
  80015c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80015f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800167:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016c:	74 14                	je     800182 <_main+0x14a>
  80016e:	83 ec 04             	sub    $0x4,%esp
  800171:	68 60 24 80 00       	push   $0x802460
  800176:	6a 1c                	push   $0x1c
  800178:	68 a8 24 80 00       	push   $0x8024a8
  80017d:	e8 29 09 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80018d:	05 90 00 00 00       	add    $0x90,%eax
  800192:	8b 00                	mov    (%eax),%eax
  800194:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800197:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80019a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019f:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 60 24 80 00       	push   $0x802460
  8001ae:	6a 1d                	push   $0x1d
  8001b0:	68 a8 24 80 00       	push   $0x8024a8
  8001b5:	e8 f1 08 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bf:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001c5:	05 a8 00 00 00       	add    $0xa8,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001cf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d7:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 60 24 80 00       	push   $0x802460
  8001e6:	6a 1e                	push   $0x1e
  8001e8:	68 a8 24 80 00       	push   $0x8024a8
  8001ed:	e8 b9 08 00 00       	call   800aab <_panic>
		//if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f7:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  8001fd:	05 c0 00 00 00       	add    $0xc0,%eax
  800202:	8b 00                	mov    (%eax),%eax
  800204:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800207:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800214:	74 14                	je     80022a <_main+0x1f2>
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	68 60 24 80 00       	push   $0x802460
  80021e:	6a 20                	push   $0x20
  800220:	68 a8 24 80 00       	push   $0x8024a8
  800225:	e8 81 08 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  800235:	05 d8 00 00 00       	add    $0xd8,%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80023f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800247:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80024c:	74 14                	je     800262 <_main+0x22a>
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 60 24 80 00       	push   $0x802460
  800256:	6a 21                	push   $0x21
  800258:	68 a8 24 80 00       	push   $0x8024a8
  80025d:	e8 49 08 00 00       	call   800aab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 80 58 da 01 00    	mov    0x1da58(%eax),%eax
  80026d:	05 f0 00 00 00       	add    $0xf0,%eax
  800272:	8b 00                	mov    (%eax),%eax
  800274:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800277:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80027a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027f:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800284:	74 14                	je     80029a <_main+0x262>
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	68 60 24 80 00       	push   $0x802460
  80028e:	6a 22                	push   $0x22
  800290:	68 a8 24 80 00       	push   $0x8024a8
  800295:	e8 11 08 00 00       	call   800aab <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review sizes of the two WS's..!!");
  80029a:	a1 20 30 80 00       	mov    0x803020,%eax
  80029f:	8b 80 e8 d9 01 00    	mov    0x1d9e8(%eax),%eax
  8002a5:	85 c0                	test   %eax,%eax
  8002a7:	74 14                	je     8002bd <_main+0x285>
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	68 bc 24 80 00       	push   $0x8024bc
  8002b1:	6a 23                	push   $0x23
  8002b3:	68 a8 24 80 00       	push   $0x8024a8
  8002b8:	e8 ee 07 00 00       	call   800aab <_panic>

	/*[2] RUN THE SLAVE PROGRAM*/

	//****************************************************************************************************************
	//IMP: program name is placed statically on the stack to avoid PAGE FAULT on it during the sys call inside the Kernel
	char slaveProgName[10] = "tpb2slave";
  8002bd:	8d 45 92             	lea    -0x6e(%ebp),%eax
  8002c0:	bb 43 28 80 00       	mov    $0x802843,%ebx
  8002c5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002ca:	89 c7                	mov    %eax,%edi
  8002cc:	89 de                	mov    %ebx,%esi
  8002ce:	89 d1                	mov    %edx,%ecx
  8002d0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	//****************************************************************************************************************

	int32 envIdSlave = sys_create_env(slaveProgName, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d7:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  8002dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e2:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8002e8:	89 c1                	mov    %eax,%ecx
  8002ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ef:	8b 40 74             	mov    0x74(%eax),%eax
  8002f2:	52                   	push   %edx
  8002f3:	51                   	push   %ecx
  8002f4:	50                   	push   %eax
  8002f5:	8d 45 92             	lea    -0x6e(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 49 1b 00 00       	call   801e47 <sys_create_env>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int initModBufCnt = sys_calculate_modified_frames();
  800304:	e8 e5 18 00 00       	call   801bee <sys_calculate_modified_frames>
  800309:	89 45 ac             	mov    %eax,-0x54(%ebp)
	sys_run_env(envIdSlave);
  80030c:	83 ec 0c             	sub    $0xc,%esp
  80030f:	ff 75 b0             	pushl  -0x50(%ebp)
  800312:	e8 4e 1b 00 00       	call   801e65 <sys_run_env>
  800317:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT FOR A WHILE TILL FINISHING IT*/
	env_sleep(5000);
  80031a:	83 ec 0c             	sub    $0xc,%esp
  80031d:	68 88 13 00 00       	push   $0x1388
  800322:	e8 20 1e 00 00       	call   802147 <env_sleep>
  800327:	83 c4 10             	add    $0x10,%esp


	//NOW: modified list contains 7 pages from the slave program
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames of the slave ... WRONG number of buffered pages in MODIFIED frame list");
  80032a:	e8 bf 18 00 00       	call   801bee <sys_calculate_modified_frames>
  80032f:	89 c2                	mov    %eax,%edx
  800331:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800334:	29 c2                	sub    %eax,%edx
  800336:	89 d0                	mov    %edx,%eax
  800338:	83 f8 07             	cmp    $0x7,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 0c 25 80 00       	push   $0x80250c
  800345:	6a 36                	push   $0x36
  800347:	68 a8 24 80 00       	push   $0x8024a8
  80034c:	e8 5a 07 00 00       	call   800aab <_panic>


	/*START OF TST_BUFFER_2*/
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 1f 19 00 00       	call   801c75 <sys_pf_calculate_allocated_pages>
  800356:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int freePages = sys_calculate_free_frames();
  800359:	e8 77 18 00 00       	call   801bd5 <sys_calculate_free_frames>
  80035e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  800361:	e8 88 18 00 00       	call   801bee <sys_calculate_modified_frames>
  800366:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int initFreeBufCnt = sys_calculate_notmod_frames();
  800369:	e8 99 18 00 00       	call   801c07 <sys_calculate_notmod_frames>
  80036e:	89 45 a0             	mov    %eax,-0x60(%ebp)
	int dummy = 0;
  800371:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
	//Fault #1
	int i=0;
  800378:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for(;i<1;i++)
  80037f:	eb 0e                	jmp    80038f <_main+0x357>
	{
		arr[i] = -1;
  800381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800384:	05 60 a1 82 00       	add    $0x82a160,%eax
  800389:	c6 00 ff             	movb   $0xff,(%eax)
	initModBufCnt = sys_calculate_modified_frames();
	int initFreeBufCnt = sys_calculate_notmod_frames();
	int dummy = 0;
	//Fault #1
	int i=0;
	for(;i<1;i++)
  80038c:	ff 45 e4             	incl   -0x1c(%ebp)
  80038f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800393:	7e ec                	jle    800381 <_main+0x349>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800395:	e8 6d 18 00 00       	call   801c07 <sys_calculate_notmod_frames>
  80039a:	89 c2                	mov    %eax,%edx
  80039c:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #2
	i=PAGE_SIZE*1024;
  8003a9:	c7 45 e4 00 00 40 00 	movl   $0x400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024+1;i++)
  8003b0:	eb 0e                	jmp    8003c0 <_main+0x388>
	{
		arr[i] = -1;
  8003b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b5:	05 60 a1 82 00       	add    $0x82a160,%eax
  8003ba:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #2
	i=PAGE_SIZE*1024;
	for(;i<PAGE_SIZE*1024+1;i++)
  8003bd:	ff 45 e4             	incl   -0x1c(%ebp)
  8003c0:	81 7d e4 00 00 40 00 	cmpl   $0x400000,-0x1c(%ebp)
  8003c7:	7e e9                	jle    8003b2 <_main+0x37a>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8003c9:	e8 39 18 00 00       	call   801c07 <sys_calculate_notmod_frames>
  8003ce:	89 c2                	mov    %eax,%edx
  8003d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #3
	i=PAGE_SIZE*1024*2;
  8003dd:	c7 45 e4 00 00 80 00 	movl   $0x800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*2+1;i++)
  8003e4:	eb 0e                	jmp    8003f4 <_main+0x3bc>
	{
		arr[i] = -1;
  8003e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003e9:	05 60 a1 82 00       	add    $0x82a160,%eax
  8003ee:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #3
	i=PAGE_SIZE*1024*2;
	for(;i<PAGE_SIZE*1024*2+1;i++)
  8003f1:	ff 45 e4             	incl   -0x1c(%ebp)
  8003f4:	81 7d e4 00 00 80 00 	cmpl   $0x800000,-0x1c(%ebp)
  8003fb:	7e e9                	jle    8003e6 <_main+0x3ae>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8003fd:	e8 05 18 00 00       	call   801c07 <sys_calculate_notmod_frames>
  800402:	89 c2                	mov    %eax,%edx
  800404:	a1 20 30 80 00       	mov    0x803020,%eax
  800409:	8b 40 4c             	mov    0x4c(%eax),%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #4
	i=PAGE_SIZE*1024*3;
  800411:	c7 45 e4 00 00 c0 00 	movl   $0xc00000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*3+1;i++)
  800418:	eb 0e                	jmp    800428 <_main+0x3f0>
	{
		arr[i] = -1;
  80041a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041d:	05 60 a1 82 00       	add    $0x82a160,%eax
  800422:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #4
	i=PAGE_SIZE*1024*3;
	for(;i<PAGE_SIZE*1024*3+1;i++)
  800425:	ff 45 e4             	incl   -0x1c(%ebp)
  800428:	81 7d e4 00 00 c0 00 	cmpl   $0xc00000,-0x1c(%ebp)
  80042f:	7e e9                	jle    80041a <_main+0x3e2>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800431:	e8 d1 17 00 00       	call   801c07 <sys_calculate_notmod_frames>
  800436:	89 c2                	mov    %eax,%edx
  800438:	a1 20 30 80 00       	mov    0x803020,%eax
  80043d:	8b 40 4c             	mov    0x4c(%eax),%eax
  800440:	01 d0                	add    %edx,%eax
  800442:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #5
	i=PAGE_SIZE*1024*4;
  800445:	c7 45 e4 00 00 00 01 	movl   $0x1000000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*4+1;i++)
  80044c:	eb 0e                	jmp    80045c <_main+0x424>
	{
		arr[i] = -1;
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	05 60 a1 82 00       	add    $0x82a160,%eax
  800456:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #5
	i=PAGE_SIZE*1024*4;
	for(;i<PAGE_SIZE*1024*4+1;i++)
  800459:	ff 45 e4             	incl   -0x1c(%ebp)
  80045c:	81 7d e4 00 00 00 01 	cmpl   $0x1000000,-0x1c(%ebp)
  800463:	7e e9                	jle    80044e <_main+0x416>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800465:	e8 9d 17 00 00       	call   801c07 <sys_calculate_notmod_frames>
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	a1 20 30 80 00       	mov    0x803020,%eax
  800471:	8b 40 4c             	mov    0x4c(%eax),%eax
  800474:	01 d0                	add    %edx,%eax
  800476:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #6
	i=PAGE_SIZE*1024*5;
  800479:	c7 45 e4 00 00 40 01 	movl   $0x1400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*5+1;i++)
  800480:	eb 0e                	jmp    800490 <_main+0x458>
	{
		arr[i] = -1;
  800482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800485:	05 60 a1 82 00       	add    $0x82a160,%eax
  80048a:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #6
	i=PAGE_SIZE*1024*5;
	for(;i<PAGE_SIZE*1024*5+1;i++)
  80048d:	ff 45 e4             	incl   -0x1c(%ebp)
  800490:	81 7d e4 00 00 40 01 	cmpl   $0x1400000,-0x1c(%ebp)
  800497:	7e e9                	jle    800482 <_main+0x44a>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800499:	e8 69 17 00 00       	call   801c07 <sys_calculate_notmod_frames>
  80049e:	89 c2                	mov    %eax,%edx
  8004a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8004a8:	01 d0                	add    %edx,%eax
  8004aa:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #7
	i=PAGE_SIZE*1024*6;
  8004ad:	c7 45 e4 00 00 80 01 	movl   $0x1800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*6+1;i++)
  8004b4:	eb 0e                	jmp    8004c4 <_main+0x48c>
	{
		arr[i] = -1;
  8004b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b9:	05 60 a1 82 00       	add    $0x82a160,%eax
  8004be:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #7
	i=PAGE_SIZE*1024*6;
	for(;i<PAGE_SIZE*1024*6+1;i++)
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
  8004c4:	81 7d e4 00 00 80 01 	cmpl   $0x1800000,-0x1c(%ebp)
  8004cb:	7e e9                	jle    8004b6 <_main+0x47e>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8004cd:	e8 35 17 00 00       	call   801c07 <sys_calculate_notmod_frames>
  8004d2:	89 c2                	mov    %eax,%edx
  8004d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d9:	8b 40 4c             	mov    0x4c(%eax),%eax
  8004dc:	01 d0                	add    %edx,%eax
  8004de:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #8
	i=PAGE_SIZE*1024*7;
  8004e1:	c7 45 e4 00 00 c0 01 	movl   $0x1c00000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*7+1;i++)
  8004e8:	eb 0e                	jmp    8004f8 <_main+0x4c0>
	{
		arr[i] = -1;
  8004ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ed:	05 60 a1 82 00       	add    $0x82a160,%eax
  8004f2:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #8
	i=PAGE_SIZE*1024*7;
	for(;i<PAGE_SIZE*1024*7+1;i++)
  8004f5:	ff 45 e4             	incl   -0x1c(%ebp)
  8004f8:	81 7d e4 00 00 c0 01 	cmpl   $0x1c00000,-0x1c(%ebp)
  8004ff:	7e e9                	jle    8004ea <_main+0x4b2>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800501:	e8 01 17 00 00       	call   801c07 <sys_calculate_notmod_frames>
  800506:	89 c2                	mov    %eax,%edx
  800508:	a1 20 30 80 00       	mov    0x803020,%eax
  80050d:	8b 40 4c             	mov    0x4c(%eax),%eax
  800510:	01 d0                	add    %edx,%eax
  800512:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//TILL NOW: 8 pages were brought into MEM and be modified (7 unmodified should be buffered)
	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)
  800515:	e8 ed 16 00 00       	call   801c07 <sys_calculate_notmod_frames>
  80051a:	89 c2                	mov    %eax,%edx
  80051c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80051f:	29 c2                	sub    %eax,%edx
  800521:	89 d0                	mov    %edx,%eax
  800523:	83 f8 07             	cmp    $0x7,%eax
  800526:	74 31                	je     800559 <_main+0x521>
	{
		sys_destroy_env(envIdSlave);
  800528:	83 ec 0c             	sub    $0xc,%esp
  80052b:	ff 75 b0             	pushl  -0x50(%ebp)
  80052e:	e8 4e 19 00 00       	call   801e81 <sys_destroy_env>
  800533:	83 c4 10             	add    $0x10,%esp
		panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list %d",sys_calculate_notmod_frames()  - initFreeBufCnt);
  800536:	e8 cc 16 00 00       	call   801c07 <sys_calculate_notmod_frames>
  80053b:	89 c2                	mov    %eax,%edx
  80053d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800540:	29 c2                	sub    %eax,%edx
  800542:	89 d0                	mov    %edx,%eax
  800544:	50                   	push   %eax
  800545:	68 84 25 80 00       	push   $0x802584
  80054a:	68 83 00 00 00       	push   $0x83
  80054f:	68 a8 24 80 00       	push   $0x8024a8
  800554:	e8 52 05 00 00       	call   800aab <_panic>
	}
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)
  800559:	e8 90 16 00 00       	call   801bee <sys_calculate_modified_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 25                	je     80058c <_main+0x554>
	{
		sys_destroy_env(envIdSlave);
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	ff 75 b0             	pushl  -0x50(%ebp)
  80056d:	e8 0f 19 00 00       	call   801e81 <sys_destroy_env>
  800572:	83 c4 10             	add    $0x10,%esp
		panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800575:	83 ec 04             	sub    $0x4,%esp
  800578:	68 e8 25 80 00       	push   $0x8025e8
  80057d:	68 88 00 00 00       	push   $0x88
  800582:	68 a8 24 80 00       	push   $0x8024a8
  800587:	e8 1f 05 00 00       	call   800aab <_panic>
	}

	initFreeBufCnt = sys_calculate_notmod_frames();
  80058c:	e8 76 16 00 00       	call   801c07 <sys_calculate_notmod_frames>
  800591:	89 45 a0             	mov    %eax,-0x60(%ebp)

	//The following 7 faults should victimize the 7 previously modified pages
	//(i.e. the modified list should be freed after 3 faults... then, two modified frames will be added to it again)
	//Fault #7
	i=PAGE_SIZE*1024*8;
  800594:	c7 45 e4 00 00 00 02 	movl   $0x2000000,-0x1c(%ebp)
	int s = 0;
  80059b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(;i<PAGE_SIZE*1024*8+1;i++)
  8005a2:	eb 13                	jmp    8005b7 <_main+0x57f>
	{
		s += arr[i] ;
  8005a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a7:	05 60 a1 82 00       	add    $0x82a160,%eax
  8005ac:	8a 00                	mov    (%eax),%al
  8005ae:	0f be c0             	movsbl %al,%eax
  8005b1:	01 45 e0             	add    %eax,-0x20(%ebp)
	//The following 7 faults should victimize the 7 previously modified pages
	//(i.e. the modified list should be freed after 3 faults... then, two modified frames will be added to it again)
	//Fault #7
	i=PAGE_SIZE*1024*8;
	int s = 0;
	for(;i<PAGE_SIZE*1024*8+1;i++)
  8005b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8005b7:	81 7d e4 00 00 00 02 	cmpl   $0x2000000,-0x1c(%ebp)
  8005be:	7e e4                	jle    8005a4 <_main+0x56c>
	{
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8005c0:	e8 42 16 00 00       	call   801c07 <sys_calculate_notmod_frames>
  8005c5:	89 c2                	mov    %eax,%edx
  8005c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005cc:	8b 40 4c             	mov    0x4c(%eax),%eax
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #8
	i=PAGE_SIZE*1024*9;
  8005d4:	c7 45 e4 00 00 40 02 	movl   $0x2400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*9+1;i++)
  8005db:	eb 13                	jmp    8005f0 <_main+0x5b8>
	{
		s += arr[i] ;
  8005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e0:	05 60 a1 82 00       	add    $0x82a160,%eax
  8005e5:	8a 00                	mov    (%eax),%al
  8005e7:	0f be c0             	movsbl %al,%eax
  8005ea:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #8
	i=PAGE_SIZE*1024*9;
	for(;i<PAGE_SIZE*1024*9+1;i++)
  8005ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8005f0:	81 7d e4 00 00 40 02 	cmpl   $0x2400000,-0x1c(%ebp)
  8005f7:	7e e4                	jle    8005dd <_main+0x5a5>
	{
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8005f9:	e8 09 16 00 00       	call   801c07 <sys_calculate_notmod_frames>
  8005fe:	89 c2                	mov    %eax,%edx
  800600:	a1 20 30 80 00       	mov    0x803020,%eax
  800605:	8b 40 4c             	mov    0x4c(%eax),%eax
  800608:	01 d0                	add    %edx,%eax
  80060a:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #9
	i=PAGE_SIZE*1024*10;
  80060d:	c7 45 e4 00 00 80 02 	movl   $0x2800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*10+1;i++)
  800614:	eb 13                	jmp    800629 <_main+0x5f1>
	{
		s += arr[i] ;
  800616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800619:	05 60 a1 82 00       	add    $0x82a160,%eax
  80061e:	8a 00                	mov    (%eax),%al
  800620:	0f be c0             	movsbl %al,%eax
  800623:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #9
	i=PAGE_SIZE*1024*10;
	for(;i<PAGE_SIZE*1024*10+1;i++)
  800626:	ff 45 e4             	incl   -0x1c(%ebp)
  800629:	81 7d e4 00 00 80 02 	cmpl   $0x2800000,-0x1c(%ebp)
  800630:	7e e4                	jle    800616 <_main+0x5de>
	{
		s += arr[i] ;
	}

	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800632:	e8 d0 15 00 00       	call   801c07 <sys_calculate_notmod_frames>
  800637:	89 c2                	mov    %eax,%edx
  800639:	a1 20 30 80 00       	mov    0x803020,%eax
  80063e:	8b 40 4c             	mov    0x4c(%eax),%eax
  800641:	01 d0                	add    %edx,%eax
  800643:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//HERE: modified list should be freed
	if (sys_calculate_modified_frames() != 0)
  800646:	e8 a3 15 00 00       	call   801bee <sys_calculate_modified_frames>
  80064b:	85 c0                	test   %eax,%eax
  80064d:	74 25                	je     800674 <_main+0x63c>
	{
		sys_destroy_env(envIdSlave);
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	ff 75 b0             	pushl  -0x50(%ebp)
  800655:	e8 27 18 00 00       	call   801e81 <sys_destroy_env>
  80065a:	83 c4 10             	add    $0x10,%esp
		panic("Modified frames not removed from list (or not updated) correctly when the modified list reaches MAX");
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 54 26 80 00       	push   $0x802654
  800665:	68 ad 00 00 00       	push   $0xad
  80066a:	68 a8 24 80 00       	push   $0x8024a8
  80066f:	e8 37 04 00 00       	call   800aab <_panic>
	}
	if ((sys_calculate_notmod_frames() - initFreeBufCnt) != 10)
  800674:	e8 8e 15 00 00       	call   801c07 <sys_calculate_notmod_frames>
  800679:	89 c2                	mov    %eax,%edx
  80067b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80067e:	29 c2                	sub    %eax,%edx
  800680:	89 d0                	mov    %edx,%eax
  800682:	83 f8 0a             	cmp    $0xa,%eax
  800685:	74 25                	je     8006ac <_main+0x674>
	{
		sys_destroy_env(envIdSlave);
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	ff 75 b0             	pushl  -0x50(%ebp)
  80068d:	e8 ef 17 00 00       	call   801e81 <sys_destroy_env>
  800692:	83 c4 10             	add    $0x10,%esp
		panic("Modified frames not added to free frame list as BUFFERED when the modified list reaches MAX");
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	68 b8 26 80 00       	push   $0x8026b8
  80069d:	68 b2 00 00 00       	push   $0xb2
  8006a2:	68 a8 24 80 00       	push   $0x8024a8
  8006a7:	e8 ff 03 00 00       	call   800aab <_panic>
	}

	//Three additional fault (i.e. three modified page will be added to modified list)
	//Fault #10
	i = PAGE_SIZE * 1024 * 11;
  8006ac:	c7 45 e4 00 00 c0 02 	movl   $0x2c00000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*11 + 1; i++) {
  8006b3:	eb 13                	jmp    8006c8 <_main+0x690>
		s += arr[i] ;
  8006b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006b8:	05 60 a1 82 00       	add    $0x82a160,%eax
  8006bd:	8a 00                	mov    (%eax),%al
  8006bf:	0f be c0             	movsbl %al,%eax
  8006c2:	01 45 e0             	add    %eax,-0x20(%ebp)
	}

	//Three additional fault (i.e. three modified page will be added to modified list)
	//Fault #10
	i = PAGE_SIZE * 1024 * 11;
	for (; i < PAGE_SIZE * 1024*11 + 1; i++) {
  8006c5:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c8:	81 7d e4 00 00 c0 02 	cmpl   $0x2c00000,-0x1c(%ebp)
  8006cf:	7e e4                	jle    8006b5 <_main+0x67d>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8006d1:	e8 31 15 00 00       	call   801c07 <sys_calculate_notmod_frames>
  8006d6:	89 c2                	mov    %eax,%edx
  8006d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8006dd:	8b 40 4c             	mov    0x4c(%eax),%eax
  8006e0:	01 d0                	add    %edx,%eax
  8006e2:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #11
	i = PAGE_SIZE * 1024 * 12;
  8006e5:	c7 45 e4 00 00 00 03 	movl   $0x3000000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*12 + 1; i++) {
  8006ec:	eb 13                	jmp    800701 <_main+0x6c9>
		s += arr[i] ;
  8006ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f1:	05 60 a1 82 00       	add    $0x82a160,%eax
  8006f6:	8a 00                	mov    (%eax),%al
  8006f8:	0f be c0             	movsbl %al,%eax
  8006fb:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #11
	i = PAGE_SIZE * 1024 * 12;
	for (; i < PAGE_SIZE * 1024*12 + 1; i++) {
  8006fe:	ff 45 e4             	incl   -0x1c(%ebp)
  800701:	81 7d e4 00 00 00 03 	cmpl   $0x3000000,-0x1c(%ebp)
  800708:	7e e4                	jle    8006ee <_main+0x6b6>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  80070a:	e8 f8 14 00 00       	call   801c07 <sys_calculate_notmod_frames>
  80070f:	89 c2                	mov    %eax,%edx
  800711:	a1 20 30 80 00       	mov    0x803020,%eax
  800716:	8b 40 4c             	mov    0x4c(%eax),%eax
  800719:	01 d0                	add    %edx,%eax
  80071b:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #12
	i = PAGE_SIZE * 1024 * 13;
  80071e:	c7 45 e4 00 00 40 03 	movl   $0x3400000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*13 + 1; i++) {
  800725:	eb 13                	jmp    80073a <_main+0x702>
		s += arr[i] ;
  800727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80072a:	05 60 a1 82 00       	add    $0x82a160,%eax
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f be c0             	movsbl %al,%eax
  800734:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #12
	i = PAGE_SIZE * 1024 * 13;
	for (; i < PAGE_SIZE * 1024*13 + 1; i++) {
  800737:	ff 45 e4             	incl   -0x1c(%ebp)
  80073a:	81 7d e4 00 00 40 03 	cmpl   $0x3400000,-0x1c(%ebp)
  800741:	7e e4                	jle    800727 <_main+0x6ef>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800743:	e8 bf 14 00 00       	call   801c07 <sys_calculate_notmod_frames>
  800748:	89 c2                	mov    %eax,%edx
  80074a:	a1 20 30 80 00       	mov    0x803020,%eax
  80074f:	8b 40 4c             	mov    0x4c(%eax),%eax
  800752:	01 d0                	add    %edx,%eax
  800754:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//cprintf("testing...\n");
	{
		if (sys_calculate_modified_frames() != 3)
  800757:	e8 92 14 00 00       	call   801bee <sys_calculate_modified_frames>
  80075c:	83 f8 03             	cmp    $0x3,%eax
  80075f:	74 25                	je     800786 <_main+0x74e>
		{
			sys_destroy_env(envIdSlave);
  800761:	83 ec 0c             	sub    $0xc,%esp
  800764:	ff 75 b0             	pushl  -0x50(%ebp)
  800767:	e8 15 17 00 00       	call   801e81 <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
			panic("Modified frames not removed from list (or not updated) correctly when the modified list reaches MAX");
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 54 26 80 00       	push   $0x802654
  800777:	68 d0 00 00 00       	push   $0xd0
  80077c:	68 a8 24 80 00       	push   $0x8024a8
  800781:	e8 25 03 00 00       	call   800aab <_panic>
		}

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  800786:	e8 ea 14 00 00       	call   801c75 <sys_pf_calculate_allocated_pages>
  80078b:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  80078e:	74 25                	je     8007b5 <_main+0x77d>
		{
			sys_destroy_env(envIdSlave);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	ff 75 b0             	pushl  -0x50(%ebp)
  800796:	e8 e6 16 00 00       	call   801e81 <sys_destroy_env>
  80079b:	83 c4 10             	add    $0x10,%esp
			panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	68 14 27 80 00       	push   $0x802714
  8007a6:	68 d6 00 00 00       	push   $0xd6
  8007ab:	68 a8 24 80 00       	push   $0x8024a8
  8007b0:	e8 f6 02 00 00       	call   800aab <_panic>
		}

		if( arr[0] != -1) 						{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8007b5:	a0 60 a1 82 00       	mov    0x82a160,%al
  8007ba:	3c ff                	cmp    $0xff,%al
  8007bc:	74 25                	je     8007e3 <_main+0x7ab>
  8007be:	83 ec 0c             	sub    $0xc,%esp
  8007c1:	ff 75 b0             	pushl  -0x50(%ebp)
  8007c4:	e8 b8 16 00 00       	call   801e81 <sys_destroy_env>
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	83 ec 04             	sub    $0x4,%esp
  8007cf:	68 80 27 80 00       	push   $0x802780
  8007d4:	68 d9 00 00 00       	push   $0xd9
  8007d9:	68 a8 24 80 00       	push   $0x8024a8
  8007de:	e8 c8 02 00 00       	call   800aab <_panic>
		if( arr[PAGE_SIZE * 1024 * 1] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8007e3:	a0 60 a1 c2 00       	mov    0xc2a160,%al
  8007e8:	3c ff                	cmp    $0xff,%al
  8007ea:	74 25                	je     800811 <_main+0x7d9>
  8007ec:	83 ec 0c             	sub    $0xc,%esp
  8007ef:	ff 75 b0             	pushl  -0x50(%ebp)
  8007f2:	e8 8a 16 00 00       	call   801e81 <sys_destroy_env>
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	83 ec 04             	sub    $0x4,%esp
  8007fd:	68 80 27 80 00       	push   $0x802780
  800802:	68 da 00 00 00       	push   $0xda
  800807:	68 a8 24 80 00       	push   $0x8024a8
  80080c:	e8 9a 02 00 00       	call   800aab <_panic>
		if( arr[PAGE_SIZE * 1024 * 2] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  800811:	a0 60 a1 02 01       	mov    0x102a160,%al
  800816:	3c ff                	cmp    $0xff,%al
  800818:	74 25                	je     80083f <_main+0x807>
  80081a:	83 ec 0c             	sub    $0xc,%esp
  80081d:	ff 75 b0             	pushl  -0x50(%ebp)
  800820:	e8 5c 16 00 00       	call   801e81 <sys_destroy_env>
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 80 27 80 00       	push   $0x802780
  800830:	68 db 00 00 00       	push   $0xdb
  800835:	68 a8 24 80 00       	push   $0x8024a8
  80083a:	e8 6c 02 00 00       	call   800aab <_panic>
		if( arr[PAGE_SIZE * 1024 * 3] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80083f:	a0 60 a1 42 01       	mov    0x142a160,%al
  800844:	3c ff                	cmp    $0xff,%al
  800846:	74 25                	je     80086d <_main+0x835>
  800848:	83 ec 0c             	sub    $0xc,%esp
  80084b:	ff 75 b0             	pushl  -0x50(%ebp)
  80084e:	e8 2e 16 00 00       	call   801e81 <sys_destroy_env>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	83 ec 04             	sub    $0x4,%esp
  800859:	68 80 27 80 00       	push   $0x802780
  80085e:	68 dc 00 00 00       	push   $0xdc
  800863:	68 a8 24 80 00       	push   $0x8024a8
  800868:	e8 3e 02 00 00       	call   800aab <_panic>
		if( arr[PAGE_SIZE * 1024 * 4] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80086d:	a0 60 a1 82 01       	mov    0x182a160,%al
  800872:	3c ff                	cmp    $0xff,%al
  800874:	74 25                	je     80089b <_main+0x863>
  800876:	83 ec 0c             	sub    $0xc,%esp
  800879:	ff 75 b0             	pushl  -0x50(%ebp)
  80087c:	e8 00 16 00 00       	call   801e81 <sys_destroy_env>
  800881:	83 c4 10             	add    $0x10,%esp
  800884:	83 ec 04             	sub    $0x4,%esp
  800887:	68 80 27 80 00       	push   $0x802780
  80088c:	68 dd 00 00 00       	push   $0xdd
  800891:	68 a8 24 80 00       	push   $0x8024a8
  800896:	e8 10 02 00 00       	call   800aab <_panic>
		if( arr[PAGE_SIZE * 1024 * 5] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80089b:	a0 60 a1 c2 01       	mov    0x1c2a160,%al
  8008a0:	3c ff                	cmp    $0xff,%al
  8008a2:	74 25                	je     8008c9 <_main+0x891>
  8008a4:	83 ec 0c             	sub    $0xc,%esp
  8008a7:	ff 75 b0             	pushl  -0x50(%ebp)
  8008aa:	e8 d2 15 00 00       	call   801e81 <sys_destroy_env>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 80 27 80 00       	push   $0x802780
  8008ba:	68 de 00 00 00       	push   $0xde
  8008bf:	68 a8 24 80 00       	push   $0x8024a8
  8008c4:	e8 e2 01 00 00       	call   800aab <_panic>
		if( arr[PAGE_SIZE * 1024 * 6] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8008c9:	a0 60 a1 02 02       	mov    0x202a160,%al
  8008ce:	3c ff                	cmp    $0xff,%al
  8008d0:	74 25                	je     8008f7 <_main+0x8bf>
  8008d2:	83 ec 0c             	sub    $0xc,%esp
  8008d5:	ff 75 b0             	pushl  -0x50(%ebp)
  8008d8:	e8 a4 15 00 00       	call   801e81 <sys_destroy_env>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	83 ec 04             	sub    $0x4,%esp
  8008e3:	68 80 27 80 00       	push   $0x802780
  8008e8:	68 df 00 00 00       	push   $0xdf
  8008ed:	68 a8 24 80 00       	push   $0x8024a8
  8008f2:	e8 b4 01 00 00       	call   800aab <_panic>
		if( arr[PAGE_SIZE * 1024 * 7] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8008f7:	a0 60 a1 42 02       	mov    0x242a160,%al
  8008fc:	3c ff                	cmp    $0xff,%al
  8008fe:	74 25                	je     800925 <_main+0x8ed>
  800900:	83 ec 0c             	sub    $0xc,%esp
  800903:	ff 75 b0             	pushl  -0x50(%ebp)
  800906:	e8 76 15 00 00       	call   801e81 <sys_destroy_env>
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 80 27 80 00       	push   $0x802780
  800916:	68 e0 00 00 00       	push   $0xe0
  80091b:	68 a8 24 80 00       	push   $0x8024a8
  800920:	e8 86 01 00 00       	call   800aab <_panic>

		if (sys_calculate_modified_frames() != 0) {sys_destroy_env(envIdSlave);panic("Modified frames not removed from list (or isModified/modified bit is not updated) correctly when the modified list reaches MAX");}
  800925:	e8 c4 12 00 00       	call   801bee <sys_calculate_modified_frames>
  80092a:	85 c0                	test   %eax,%eax
  80092c:	74 25                	je     800953 <_main+0x91b>
  80092e:	83 ec 0c             	sub    $0xc,%esp
  800931:	ff 75 b0             	pushl  -0x50(%ebp)
  800934:	e8 48 15 00 00       	call   801e81 <sys_destroy_env>
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	83 ec 04             	sub    $0x4,%esp
  80093f:	68 c4 27 80 00       	push   $0x8027c4
  800944:	68 e2 00 00 00       	push   $0xe2
  800949:	68 a8 24 80 00       	push   $0x8024a8
  80094e:	e8 58 01 00 00       	call   800aab <_panic>
	}

	return;
  800953:	90                   	nop
}
  800954:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800957:	5b                   	pop    %ebx
  800958:	5e                   	pop    %esi
  800959:	5f                   	pop    %edi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800962:	e8 4e 15 00 00       	call   801eb5 <sys_getenvindex>
  800967:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80096a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096d:	89 d0                	mov    %edx,%eax
  80096f:	01 c0                	add    %eax,%eax
  800971:	01 d0                	add    %edx,%eax
  800973:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80097a:	01 c8                	add    %ecx,%eax
  80097c:	c1 e0 02             	shl    $0x2,%eax
  80097f:	01 d0                	add    %edx,%eax
  800981:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800988:	01 c8                	add    %ecx,%eax
  80098a:	c1 e0 02             	shl    $0x2,%eax
  80098d:	01 d0                	add    %edx,%eax
  80098f:	c1 e0 02             	shl    $0x2,%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	c1 e0 03             	shl    $0x3,%eax
  800997:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80099c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a6:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8009ac:	84 c0                	test   %al,%al
  8009ae:	74 0f                	je     8009bf <libmain+0x63>
		binaryname = myEnv->prog_name;
  8009b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8009b5:	05 18 da 01 00       	add    $0x1da18,%eax
  8009ba:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009c3:	7e 0a                	jle    8009cf <libmain+0x73>
		binaryname = argv[0];
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	ff 75 08             	pushl  0x8(%ebp)
  8009d8:	e8 5b f6 ff ff       	call   800038 <_main>
  8009dd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009e0:	e8 dd 12 00 00       	call   801cc2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009e5:	83 ec 0c             	sub    $0xc,%esp
  8009e8:	68 68 28 80 00       	push   $0x802868
  8009ed:	e8 6d 03 00 00       	call   800d5f <cprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8009fa:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800a00:	a1 20 30 80 00       	mov    0x803020,%eax
  800a05:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800a0b:	83 ec 04             	sub    $0x4,%esp
  800a0e:	52                   	push   %edx
  800a0f:	50                   	push   %eax
  800a10:	68 90 28 80 00       	push   $0x802890
  800a15:	e8 45 03 00 00       	call   800d5f <cprintf>
  800a1a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a1d:	a1 20 30 80 00       	mov    0x803020,%eax
  800a22:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800a28:	a1 20 30 80 00       	mov    0x803020,%eax
  800a2d:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800a33:	a1 20 30 80 00       	mov    0x803020,%eax
  800a38:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800a3e:	51                   	push   %ecx
  800a3f:	52                   	push   %edx
  800a40:	50                   	push   %eax
  800a41:	68 b8 28 80 00       	push   $0x8028b8
  800a46:	e8 14 03 00 00       	call   800d5f <cprintf>
  800a4b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a4e:	a1 20 30 80 00       	mov    0x803020,%eax
  800a53:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	50                   	push   %eax
  800a5d:	68 10 29 80 00       	push   $0x802910
  800a62:	e8 f8 02 00 00       	call   800d5f <cprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a6a:	83 ec 0c             	sub    $0xc,%esp
  800a6d:	68 68 28 80 00       	push   $0x802868
  800a72:	e8 e8 02 00 00       	call   800d5f <cprintf>
  800a77:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a7a:	e8 5d 12 00 00       	call   801cdc <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a7f:	e8 19 00 00 00       	call   800a9d <exit>
}
  800a84:	90                   	nop
  800a85:	c9                   	leave  
  800a86:	c3                   	ret    

00800a87 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a8d:	83 ec 0c             	sub    $0xc,%esp
  800a90:	6a 00                	push   $0x0
  800a92:	e8 ea 13 00 00       	call   801e81 <sys_destroy_env>
  800a97:	83 c4 10             	add    $0x10,%esp
}
  800a9a:	90                   	nop
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <exit>:

void
exit(void)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aa3:	e8 3f 14 00 00       	call   801ee7 <sys_exit_env>
}
  800aa8:	90                   	nop
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ab1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab4:	83 c0 04             	add    $0x4,%eax
  800ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800aba:	a1 58 b2 02 04       	mov    0x402b258,%eax
  800abf:	85 c0                	test   %eax,%eax
  800ac1:	74 16                	je     800ad9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ac3:	a1 58 b2 02 04       	mov    0x402b258,%eax
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	50                   	push   %eax
  800acc:	68 24 29 80 00       	push   $0x802924
  800ad1:	e8 89 02 00 00       	call   800d5f <cprintf>
  800ad6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ad9:	a1 00 30 80 00       	mov    0x803000,%eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	50                   	push   %eax
  800ae5:	68 29 29 80 00       	push   $0x802929
  800aea:	e8 70 02 00 00       	call   800d5f <cprintf>
  800aef:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 f4             	pushl  -0xc(%ebp)
  800afb:	50                   	push   %eax
  800afc:	e8 f3 01 00 00       	call   800cf4 <vcprintf>
  800b01:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	6a 00                	push   $0x0
  800b09:	68 45 29 80 00       	push   $0x802945
  800b0e:	e8 e1 01 00 00       	call   800cf4 <vcprintf>
  800b13:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b16:	e8 82 ff ff ff       	call   800a9d <exit>

	// should not return here
	while (1) ;
  800b1b:	eb fe                	jmp    800b1b <_panic+0x70>

00800b1d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b23:	a1 20 30 80 00       	mov    0x803020,%eax
  800b28:	8b 50 74             	mov    0x74(%eax),%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	39 c2                	cmp    %eax,%edx
  800b30:	74 14                	je     800b46 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b32:	83 ec 04             	sub    $0x4,%esp
  800b35:	68 48 29 80 00       	push   $0x802948
  800b3a:	6a 26                	push   $0x26
  800b3c:	68 94 29 80 00       	push   $0x802994
  800b41:	e8 65 ff ff ff       	call   800aab <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b54:	e9 c2 00 00 00       	jmp    800c1b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	01 d0                	add    %edx,%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	85 c0                	test   %eax,%eax
  800b6c:	75 08                	jne    800b76 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b6e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b71:	e9 a2 00 00 00       	jmp    800c18 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b7d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b84:	eb 69                	jmp    800bef <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b86:	a1 20 30 80 00       	mov    0x803020,%eax
  800b8b:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800b91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b94:	89 d0                	mov    %edx,%eax
  800b96:	01 c0                	add    %eax,%eax
  800b98:	01 d0                	add    %edx,%eax
  800b9a:	c1 e0 03             	shl    $0x3,%eax
  800b9d:	01 c8                	add    %ecx,%eax
  800b9f:	8a 40 04             	mov    0x4(%eax),%al
  800ba2:	84 c0                	test   %al,%al
  800ba4:	75 46                	jne    800bec <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ba6:	a1 20 30 80 00       	mov    0x803020,%eax
  800bab:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800bb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bb4:	89 d0                	mov    %edx,%eax
  800bb6:	01 c0                	add    %eax,%eax
  800bb8:	01 d0                	add    %edx,%eax
  800bba:	c1 e0 03             	shl    $0x3,%eax
  800bbd:	01 c8                	add    %ecx,%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bcc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	01 c8                	add    %ecx,%eax
  800bdd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bdf:	39 c2                	cmp    %eax,%edx
  800be1:	75 09                	jne    800bec <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800be3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bea:	eb 12                	jmp    800bfe <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bec:	ff 45 e8             	incl   -0x18(%ebp)
  800bef:	a1 20 30 80 00       	mov    0x803020,%eax
  800bf4:	8b 50 74             	mov    0x74(%eax),%edx
  800bf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bfa:	39 c2                	cmp    %eax,%edx
  800bfc:	77 88                	ja     800b86 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800bfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c02:	75 14                	jne    800c18 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c04:	83 ec 04             	sub    $0x4,%esp
  800c07:	68 a0 29 80 00       	push   $0x8029a0
  800c0c:	6a 3a                	push   $0x3a
  800c0e:	68 94 29 80 00       	push   $0x802994
  800c13:	e8 93 fe ff ff       	call   800aab <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c18:	ff 45 f0             	incl   -0x10(%ebp)
  800c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c21:	0f 8c 32 ff ff ff    	jl     800b59 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c27:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c35:	eb 26                	jmp    800c5d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c37:	a1 20 30 80 00       	mov    0x803020,%eax
  800c3c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800c42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c45:	89 d0                	mov    %edx,%eax
  800c47:	01 c0                	add    %eax,%eax
  800c49:	01 d0                	add    %edx,%eax
  800c4b:	c1 e0 03             	shl    $0x3,%eax
  800c4e:	01 c8                	add    %ecx,%eax
  800c50:	8a 40 04             	mov    0x4(%eax),%al
  800c53:	3c 01                	cmp    $0x1,%al
  800c55:	75 03                	jne    800c5a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c57:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c5a:	ff 45 e0             	incl   -0x20(%ebp)
  800c5d:	a1 20 30 80 00       	mov    0x803020,%eax
  800c62:	8b 50 74             	mov    0x74(%eax),%edx
  800c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c68:	39 c2                	cmp    %eax,%edx
  800c6a:	77 cb                	ja     800c37 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c6f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c72:	74 14                	je     800c88 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c74:	83 ec 04             	sub    $0x4,%esp
  800c77:	68 f4 29 80 00       	push   $0x8029f4
  800c7c:	6a 44                	push   $0x44
  800c7e:	68 94 29 80 00       	push   $0x802994
  800c83:	e8 23 fe ff ff       	call   800aab <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c88:	90                   	nop
  800c89:	c9                   	leave  
  800c8a:	c3                   	ret    

00800c8b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 00                	mov    (%eax),%eax
  800c96:	8d 48 01             	lea    0x1(%eax),%ecx
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	89 0a                	mov    %ecx,(%edx)
  800c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca1:	88 d1                	mov    %dl,%cl
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	8b 00                	mov    (%eax),%eax
  800caf:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cb4:	75 2c                	jne    800ce2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cb6:	a0 24 30 80 00       	mov    0x803024,%al
  800cbb:	0f b6 c0             	movzbl %al,%eax
  800cbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc1:	8b 12                	mov    (%edx),%edx
  800cc3:	89 d1                	mov    %edx,%ecx
  800cc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc8:	83 c2 08             	add    $0x8,%edx
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	50                   	push   %eax
  800ccf:	51                   	push   %ecx
  800cd0:	52                   	push   %edx
  800cd1:	e8 3e 0e 00 00       	call   801b14 <sys_cputs>
  800cd6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8b 40 04             	mov    0x4(%eax),%eax
  800ce8:	8d 50 01             	lea    0x1(%eax),%edx
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cf1:	90                   	nop
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800cfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d04:	00 00 00 
	b.cnt = 0;
  800d07:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d0e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	ff 75 08             	pushl  0x8(%ebp)
  800d17:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d1d:	50                   	push   %eax
  800d1e:	68 8b 0c 80 00       	push   $0x800c8b
  800d23:	e8 11 02 00 00       	call   800f39 <vprintfmt>
  800d28:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d2b:	a0 24 30 80 00       	mov    0x803024,%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d39:	83 ec 04             	sub    $0x4,%esp
  800d3c:	50                   	push   %eax
  800d3d:	52                   	push   %edx
  800d3e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d44:	83 c0 08             	add    $0x8,%eax
  800d47:	50                   	push   %eax
  800d48:	e8 c7 0d 00 00       	call   801b14 <sys_cputs>
  800d4d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d50:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800d57:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <cprintf>:

int cprintf(const char *fmt, ...) {
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d65:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800d6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7b:	50                   	push   %eax
  800d7c:	e8 73 ff ff ff       	call   800cf4 <vcprintf>
  800d81:	83 c4 10             	add    $0x10,%esp
  800d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d92:	e8 2b 0f 00 00       	call   801cc2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d97:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	83 ec 08             	sub    $0x8,%esp
  800da3:	ff 75 f4             	pushl  -0xc(%ebp)
  800da6:	50                   	push   %eax
  800da7:	e8 48 ff ff ff       	call   800cf4 <vcprintf>
  800dac:	83 c4 10             	add    $0x10,%esp
  800daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800db2:	e8 25 0f 00 00       	call   801cdc <sys_enable_interrupt>
	return cnt;
  800db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 14             	sub    $0x14,%esp
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dcf:	8b 45 18             	mov    0x18(%ebp),%eax
  800dd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800dda:	77 55                	ja     800e31 <printnum+0x75>
  800ddc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ddf:	72 05                	jb     800de6 <printnum+0x2a>
  800de1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800de4:	77 4b                	ja     800e31 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800de6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800de9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800dec:	8b 45 18             	mov    0x18(%ebp),%eax
  800def:	ba 00 00 00 00       	mov    $0x0,%edx
  800df4:	52                   	push   %edx
  800df5:	50                   	push   %eax
  800df6:	ff 75 f4             	pushl  -0xc(%ebp)
  800df9:	ff 75 f0             	pushl  -0x10(%ebp)
  800dfc:	e8 fb 13 00 00       	call   8021fc <__udivdi3>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	83 ec 04             	sub    $0x4,%esp
  800e07:	ff 75 20             	pushl  0x20(%ebp)
  800e0a:	53                   	push   %ebx
  800e0b:	ff 75 18             	pushl  0x18(%ebp)
  800e0e:	52                   	push   %edx
  800e0f:	50                   	push   %eax
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	ff 75 08             	pushl  0x8(%ebp)
  800e16:	e8 a1 ff ff ff       	call   800dbc <printnum>
  800e1b:	83 c4 20             	add    $0x20,%esp
  800e1e:	eb 1a                	jmp    800e3a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e20:	83 ec 08             	sub    $0x8,%esp
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	ff 75 20             	pushl  0x20(%ebp)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	ff d0                	call   *%eax
  800e2e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e31:	ff 4d 1c             	decl   0x1c(%ebp)
  800e34:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e38:	7f e6                	jg     800e20 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e3a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e48:	53                   	push   %ebx
  800e49:	51                   	push   %ecx
  800e4a:	52                   	push   %edx
  800e4b:	50                   	push   %eax
  800e4c:	e8 bb 14 00 00       	call   80230c <__umoddi3>
  800e51:	83 c4 10             	add    $0x10,%esp
  800e54:	05 54 2c 80 00       	add    $0x802c54,%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	0f be c0             	movsbl %al,%eax
  800e5e:	83 ec 08             	sub    $0x8,%esp
  800e61:	ff 75 0c             	pushl  0xc(%ebp)
  800e64:	50                   	push   %eax
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
}
  800e6d:	90                   	nop
  800e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e71:	c9                   	leave  
  800e72:	c3                   	ret    

00800e73 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e76:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e7a:	7e 1c                	jle    800e98 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8b 00                	mov    (%eax),%eax
  800e81:	8d 50 08             	lea    0x8(%eax),%edx
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 10                	mov    %edx,(%eax)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8b 00                	mov    (%eax),%eax
  800e8e:	83 e8 08             	sub    $0x8,%eax
  800e91:	8b 50 04             	mov    0x4(%eax),%edx
  800e94:	8b 00                	mov    (%eax),%eax
  800e96:	eb 40                	jmp    800ed8 <getuint+0x65>
	else if (lflag)
  800e98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e9c:	74 1e                	je     800ebc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8b 00                	mov    (%eax),%eax
  800ea3:	8d 50 04             	lea    0x4(%eax),%edx
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	89 10                	mov    %edx,(%eax)
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8b 00                	mov    (%eax),%eax
  800eb0:	83 e8 04             	sub    $0x4,%eax
  800eb3:	8b 00                	mov    (%eax),%eax
  800eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eba:	eb 1c                	jmp    800ed8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8b 00                	mov    (%eax),%eax
  800ec1:	8d 50 04             	lea    0x4(%eax),%edx
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 10                	mov    %edx,(%eax)
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8b 00                	mov    (%eax),%eax
  800ece:	83 e8 04             	sub    $0x4,%eax
  800ed1:	8b 00                	mov    (%eax),%eax
  800ed3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800edd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ee1:	7e 1c                	jle    800eff <getint+0x25>
		return va_arg(*ap, long long);
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	8b 00                	mov    (%eax),%eax
  800ee8:	8d 50 08             	lea    0x8(%eax),%edx
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	89 10                	mov    %edx,(%eax)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8b 00                	mov    (%eax),%eax
  800ef5:	83 e8 08             	sub    $0x8,%eax
  800ef8:	8b 50 04             	mov    0x4(%eax),%edx
  800efb:	8b 00                	mov    (%eax),%eax
  800efd:	eb 38                	jmp    800f37 <getint+0x5d>
	else if (lflag)
  800eff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f03:	74 1a                	je     800f1f <getint+0x45>
		return va_arg(*ap, long);
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8b 00                	mov    (%eax),%eax
  800f0a:	8d 50 04             	lea    0x4(%eax),%edx
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	89 10                	mov    %edx,(%eax)
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8b 00                	mov    (%eax),%eax
  800f17:	83 e8 04             	sub    $0x4,%eax
  800f1a:	8b 00                	mov    (%eax),%eax
  800f1c:	99                   	cltd   
  800f1d:	eb 18                	jmp    800f37 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8b 00                	mov    (%eax),%eax
  800f24:	8d 50 04             	lea    0x4(%eax),%edx
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 10                	mov    %edx,(%eax)
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8b 00                	mov    (%eax),%eax
  800f31:	83 e8 04             	sub    $0x4,%eax
  800f34:	8b 00                	mov    (%eax),%eax
  800f36:	99                   	cltd   
}
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
  800f3e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f41:	eb 17                	jmp    800f5a <vprintfmt+0x21>
			if (ch == '\0')
  800f43:	85 db                	test   %ebx,%ebx
  800f45:	0f 84 af 03 00 00    	je     8012fa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f4b:	83 ec 08             	sub    $0x8,%esp
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	53                   	push   %ebx
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	8d 50 01             	lea    0x1(%eax),%edx
  800f60:	89 55 10             	mov    %edx,0x10(%ebp)
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	0f b6 d8             	movzbl %al,%ebx
  800f68:	83 fb 25             	cmp    $0x25,%ebx
  800f6b:	75 d6                	jne    800f43 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f6d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f71:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f78:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f86:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	8d 50 01             	lea    0x1(%eax),%edx
  800f93:	89 55 10             	mov    %edx,0x10(%ebp)
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	0f b6 d8             	movzbl %al,%ebx
  800f9b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f9e:	83 f8 55             	cmp    $0x55,%eax
  800fa1:	0f 87 2b 03 00 00    	ja     8012d2 <vprintfmt+0x399>
  800fa7:	8b 04 85 78 2c 80 00 	mov    0x802c78(,%eax,4),%eax
  800fae:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fb0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fb4:	eb d7                	jmp    800f8d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fb6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fba:	eb d1                	jmp    800f8d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fbc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fc3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fc6:	89 d0                	mov    %edx,%eax
  800fc8:	c1 e0 02             	shl    $0x2,%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	01 c0                	add    %eax,%eax
  800fcf:	01 d8                	add    %ebx,%eax
  800fd1:	83 e8 30             	sub    $0x30,%eax
  800fd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fdf:	83 fb 2f             	cmp    $0x2f,%ebx
  800fe2:	7e 3e                	jle    801022 <vprintfmt+0xe9>
  800fe4:	83 fb 39             	cmp    $0x39,%ebx
  800fe7:	7f 39                	jg     801022 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fe9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fec:	eb d5                	jmp    800fc3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800fee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffa:	83 e8 04             	sub    $0x4,%eax
  800ffd:	8b 00                	mov    (%eax),%eax
  800fff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801002:	eb 1f                	jmp    801023 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801004:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801008:	79 83                	jns    800f8d <vprintfmt+0x54>
				width = 0;
  80100a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801011:	e9 77 ff ff ff       	jmp    800f8d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801016:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80101d:	e9 6b ff ff ff       	jmp    800f8d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801022:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801023:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801027:	0f 89 60 ff ff ff    	jns    800f8d <vprintfmt+0x54>
				width = precision, precision = -1;
  80102d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801030:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801033:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80103a:	e9 4e ff ff ff       	jmp    800f8d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80103f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801042:	e9 46 ff ff ff       	jmp    800f8d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801047:	8b 45 14             	mov    0x14(%ebp),%eax
  80104a:	83 c0 04             	add    $0x4,%eax
  80104d:	89 45 14             	mov    %eax,0x14(%ebp)
  801050:	8b 45 14             	mov    0x14(%ebp),%eax
  801053:	83 e8 04             	sub    $0x4,%eax
  801056:	8b 00                	mov    (%eax),%eax
  801058:	83 ec 08             	sub    $0x8,%esp
  80105b:	ff 75 0c             	pushl  0xc(%ebp)
  80105e:	50                   	push   %eax
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	ff d0                	call   *%eax
  801064:	83 c4 10             	add    $0x10,%esp
			break;
  801067:	e9 89 02 00 00       	jmp    8012f5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80106c:	8b 45 14             	mov    0x14(%ebp),%eax
  80106f:	83 c0 04             	add    $0x4,%eax
  801072:	89 45 14             	mov    %eax,0x14(%ebp)
  801075:	8b 45 14             	mov    0x14(%ebp),%eax
  801078:	83 e8 04             	sub    $0x4,%eax
  80107b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80107d:	85 db                	test   %ebx,%ebx
  80107f:	79 02                	jns    801083 <vprintfmt+0x14a>
				err = -err;
  801081:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801083:	83 fb 64             	cmp    $0x64,%ebx
  801086:	7f 0b                	jg     801093 <vprintfmt+0x15a>
  801088:	8b 34 9d c0 2a 80 00 	mov    0x802ac0(,%ebx,4),%esi
  80108f:	85 f6                	test   %esi,%esi
  801091:	75 19                	jne    8010ac <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801093:	53                   	push   %ebx
  801094:	68 65 2c 80 00       	push   $0x802c65
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	ff 75 08             	pushl  0x8(%ebp)
  80109f:	e8 5e 02 00 00       	call   801302 <printfmt>
  8010a4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010a7:	e9 49 02 00 00       	jmp    8012f5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010ac:	56                   	push   %esi
  8010ad:	68 6e 2c 80 00       	push   $0x802c6e
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	ff 75 08             	pushl  0x8(%ebp)
  8010b8:	e8 45 02 00 00       	call   801302 <printfmt>
  8010bd:	83 c4 10             	add    $0x10,%esp
			break;
  8010c0:	e9 30 02 00 00       	jmp    8012f5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c8:	83 c0 04             	add    $0x4,%eax
  8010cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8010ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d1:	83 e8 04             	sub    $0x4,%eax
  8010d4:	8b 30                	mov    (%eax),%esi
  8010d6:	85 f6                	test   %esi,%esi
  8010d8:	75 05                	jne    8010df <vprintfmt+0x1a6>
				p = "(null)";
  8010da:	be 71 2c 80 00       	mov    $0x802c71,%esi
			if (width > 0 && padc != '-')
  8010df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010e3:	7e 6d                	jle    801152 <vprintfmt+0x219>
  8010e5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010e9:	74 67                	je     801152 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010ee:	83 ec 08             	sub    $0x8,%esp
  8010f1:	50                   	push   %eax
  8010f2:	56                   	push   %esi
  8010f3:	e8 0c 03 00 00       	call   801404 <strnlen>
  8010f8:	83 c4 10             	add    $0x10,%esp
  8010fb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8010fe:	eb 16                	jmp    801116 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801100:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	50                   	push   %eax
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	ff d0                	call   *%eax
  801110:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801113:	ff 4d e4             	decl   -0x1c(%ebp)
  801116:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80111a:	7f e4                	jg     801100 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80111c:	eb 34                	jmp    801152 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80111e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801122:	74 1c                	je     801140 <vprintfmt+0x207>
  801124:	83 fb 1f             	cmp    $0x1f,%ebx
  801127:	7e 05                	jle    80112e <vprintfmt+0x1f5>
  801129:	83 fb 7e             	cmp    $0x7e,%ebx
  80112c:	7e 12                	jle    801140 <vprintfmt+0x207>
					putch('?', putdat);
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	ff 75 0c             	pushl  0xc(%ebp)
  801134:	6a 3f                	push   $0x3f
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	ff d0                	call   *%eax
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	eb 0f                	jmp    80114f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	53                   	push   %ebx
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	ff d0                	call   *%eax
  80114c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80114f:	ff 4d e4             	decl   -0x1c(%ebp)
  801152:	89 f0                	mov    %esi,%eax
  801154:	8d 70 01             	lea    0x1(%eax),%esi
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f be d8             	movsbl %al,%ebx
  80115c:	85 db                	test   %ebx,%ebx
  80115e:	74 24                	je     801184 <vprintfmt+0x24b>
  801160:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801164:	78 b8                	js     80111e <vprintfmt+0x1e5>
  801166:	ff 4d e0             	decl   -0x20(%ebp)
  801169:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80116d:	79 af                	jns    80111e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80116f:	eb 13                	jmp    801184 <vprintfmt+0x24b>
				putch(' ', putdat);
  801171:	83 ec 08             	sub    $0x8,%esp
  801174:	ff 75 0c             	pushl  0xc(%ebp)
  801177:	6a 20                	push   $0x20
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	ff d0                	call   *%eax
  80117e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801181:	ff 4d e4             	decl   -0x1c(%ebp)
  801184:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801188:	7f e7                	jg     801171 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80118a:	e9 66 01 00 00       	jmp    8012f5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	ff 75 e8             	pushl  -0x18(%ebp)
  801195:	8d 45 14             	lea    0x14(%ebp),%eax
  801198:	50                   	push   %eax
  801199:	e8 3c fd ff ff       	call   800eda <getint>
  80119e:	83 c4 10             	add    $0x10,%esp
  8011a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ad:	85 d2                	test   %edx,%edx
  8011af:	79 23                	jns    8011d4 <vprintfmt+0x29b>
				putch('-', putdat);
  8011b1:	83 ec 08             	sub    $0x8,%esp
  8011b4:	ff 75 0c             	pushl  0xc(%ebp)
  8011b7:	6a 2d                	push   $0x2d
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	ff d0                	call   *%eax
  8011be:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c7:	f7 d8                	neg    %eax
  8011c9:	83 d2 00             	adc    $0x0,%edx
  8011cc:	f7 da                	neg    %edx
  8011ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011db:	e9 bc 00 00 00       	jmp    80129c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011e0:	83 ec 08             	sub    $0x8,%esp
  8011e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8011e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8011e9:	50                   	push   %eax
  8011ea:	e8 84 fc ff ff       	call   800e73 <getuint>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8011f8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011ff:	e9 98 00 00 00       	jmp    80129c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	ff 75 0c             	pushl  0xc(%ebp)
  80120a:	6a 58                	push   $0x58
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	ff d0                	call   *%eax
  801211:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 0c             	pushl  0xc(%ebp)
  80121a:	6a 58                	push   $0x58
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	ff d0                	call   *%eax
  801221:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801224:	83 ec 08             	sub    $0x8,%esp
  801227:	ff 75 0c             	pushl  0xc(%ebp)
  80122a:	6a 58                	push   $0x58
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	ff d0                	call   *%eax
  801231:	83 c4 10             	add    $0x10,%esp
			break;
  801234:	e9 bc 00 00 00       	jmp    8012f5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801239:	83 ec 08             	sub    $0x8,%esp
  80123c:	ff 75 0c             	pushl  0xc(%ebp)
  80123f:	6a 30                	push   $0x30
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	ff d0                	call   *%eax
  801246:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	ff 75 0c             	pushl  0xc(%ebp)
  80124f:	6a 78                	push   $0x78
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	ff d0                	call   *%eax
  801256:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801259:	8b 45 14             	mov    0x14(%ebp),%eax
  80125c:	83 c0 04             	add    $0x4,%eax
  80125f:	89 45 14             	mov    %eax,0x14(%ebp)
  801262:	8b 45 14             	mov    0x14(%ebp),%eax
  801265:	83 e8 04             	sub    $0x4,%eax
  801268:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801274:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80127b:	eb 1f                	jmp    80129c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80127d:	83 ec 08             	sub    $0x8,%esp
  801280:	ff 75 e8             	pushl  -0x18(%ebp)
  801283:	8d 45 14             	lea    0x14(%ebp),%eax
  801286:	50                   	push   %eax
  801287:	e8 e7 fb ff ff       	call   800e73 <getuint>
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801292:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801295:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80129c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a3:	83 ec 04             	sub    $0x4,%esp
  8012a6:	52                   	push   %edx
  8012a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012aa:	50                   	push   %eax
  8012ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	ff 75 08             	pushl  0x8(%ebp)
  8012b7:	e8 00 fb ff ff       	call   800dbc <printnum>
  8012bc:	83 c4 20             	add    $0x20,%esp
			break;
  8012bf:	eb 34                	jmp    8012f5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	ff 75 0c             	pushl  0xc(%ebp)
  8012c7:	53                   	push   %ebx
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	ff d0                	call   *%eax
  8012cd:	83 c4 10             	add    $0x10,%esp
			break;
  8012d0:	eb 23                	jmp    8012f5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012d2:	83 ec 08             	sub    $0x8,%esp
  8012d5:	ff 75 0c             	pushl  0xc(%ebp)
  8012d8:	6a 25                	push   $0x25
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	ff d0                	call   *%eax
  8012df:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012e2:	ff 4d 10             	decl   0x10(%ebp)
  8012e5:	eb 03                	jmp    8012ea <vprintfmt+0x3b1>
  8012e7:	ff 4d 10             	decl   0x10(%ebp)
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	48                   	dec    %eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	3c 25                	cmp    $0x25,%al
  8012f2:	75 f3                	jne    8012e7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012f4:	90                   	nop
		}
	}
  8012f5:	e9 47 fc ff ff       	jmp    800f41 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8012fa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8012fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012fe:	5b                   	pop    %ebx
  8012ff:	5e                   	pop    %esi
  801300:	5d                   	pop    %ebp
  801301:	c3                   	ret    

00801302 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801308:	8d 45 10             	lea    0x10(%ebp),%eax
  80130b:	83 c0 04             	add    $0x4,%eax
  80130e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801311:	8b 45 10             	mov    0x10(%ebp),%eax
  801314:	ff 75 f4             	pushl  -0xc(%ebp)
  801317:	50                   	push   %eax
  801318:	ff 75 0c             	pushl  0xc(%ebp)
  80131b:	ff 75 08             	pushl  0x8(%ebp)
  80131e:	e8 16 fc ff ff       	call   800f39 <vprintfmt>
  801323:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801326:	90                   	nop
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	8b 40 08             	mov    0x8(%eax),%eax
  801332:	8d 50 01             	lea    0x1(%eax),%edx
  801335:	8b 45 0c             	mov    0xc(%ebp),%eax
  801338:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	8b 10                	mov    (%eax),%edx
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	8b 40 04             	mov    0x4(%eax),%eax
  801346:	39 c2                	cmp    %eax,%edx
  801348:	73 12                	jae    80135c <sprintputch+0x33>
		*b->buf++ = ch;
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8b 00                	mov    (%eax),%eax
  80134f:	8d 48 01             	lea    0x1(%eax),%ecx
  801352:	8b 55 0c             	mov    0xc(%ebp),%edx
  801355:	89 0a                	mov    %ecx,(%edx)
  801357:	8b 55 08             	mov    0x8(%ebp),%edx
  80135a:	88 10                	mov    %dl,(%eax)
}
  80135c:	90                   	nop
  80135d:	5d                   	pop    %ebp
  80135e:	c3                   	ret    

0080135f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	01 d0                	add    %edx,%eax
  801376:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801379:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801380:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801384:	74 06                	je     80138c <vsnprintf+0x2d>
  801386:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80138a:	7f 07                	jg     801393 <vsnprintf+0x34>
		return -E_INVAL;
  80138c:	b8 03 00 00 00       	mov    $0x3,%eax
  801391:	eb 20                	jmp    8013b3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801393:	ff 75 14             	pushl  0x14(%ebp)
  801396:	ff 75 10             	pushl  0x10(%ebp)
  801399:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80139c:	50                   	push   %eax
  80139d:	68 29 13 80 00       	push   $0x801329
  8013a2:	e8 92 fb ff ff       	call   800f39 <vprintfmt>
  8013a7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8013be:	83 c0 04             	add    $0x4,%eax
  8013c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ca:	50                   	push   %eax
  8013cb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ce:	ff 75 08             	pushl  0x8(%ebp)
  8013d1:	e8 89 ff ff ff       	call   80135f <vsnprintf>
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ee:	eb 06                	jmp    8013f6 <strlen+0x15>
		n++;
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f3:	ff 45 08             	incl   0x8(%ebp)
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	84 c0                	test   %al,%al
  8013fd:	75 f1                	jne    8013f0 <strlen+0xf>
		n++;
	return n;
  8013ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801411:	eb 09                	jmp    80141c <strnlen+0x18>
		n++;
  801413:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801416:	ff 45 08             	incl   0x8(%ebp)
  801419:	ff 4d 0c             	decl   0xc(%ebp)
  80141c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801420:	74 09                	je     80142b <strnlen+0x27>
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	84 c0                	test   %al,%al
  801429:	75 e8                	jne    801413 <strnlen+0xf>
		n++;
	return n;
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80143c:	90                   	nop
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8d 50 01             	lea    0x1(%eax),%edx
  801443:	89 55 08             	mov    %edx,0x8(%ebp)
  801446:	8b 55 0c             	mov    0xc(%ebp),%edx
  801449:	8d 4a 01             	lea    0x1(%edx),%ecx
  80144c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80144f:	8a 12                	mov    (%edx),%dl
  801451:	88 10                	mov    %dl,(%eax)
  801453:	8a 00                	mov    (%eax),%al
  801455:	84 c0                	test   %al,%al
  801457:	75 e4                	jne    80143d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801459:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80146a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801471:	eb 1f                	jmp    801492 <strncpy+0x34>
		*dst++ = *src;
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8d 50 01             	lea    0x1(%eax),%edx
  801479:	89 55 08             	mov    %edx,0x8(%ebp)
  80147c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147f:	8a 12                	mov    (%edx),%dl
  801481:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801483:	8b 45 0c             	mov    0xc(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	84 c0                	test   %al,%al
  80148a:	74 03                	je     80148f <strncpy+0x31>
			src++;
  80148c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80148f:	ff 45 fc             	incl   -0x4(%ebp)
  801492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801495:	3b 45 10             	cmp    0x10(%ebp),%eax
  801498:	72 d9                	jb     801473 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80149a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014af:	74 30                	je     8014e1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014b1:	eb 16                	jmp    8014c9 <strlcpy+0x2a>
			*dst++ = *src++;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8d 50 01             	lea    0x1(%eax),%edx
  8014b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8014bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014c2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014c5:	8a 12                	mov    (%edx),%dl
  8014c7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c9:	ff 4d 10             	decl   0x10(%ebp)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	74 09                	je     8014db <strlcpy+0x3c>
  8014d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	84 c0                	test   %al,%al
  8014d9:	75 d8                	jne    8014b3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e7:	29 c2                	sub    %eax,%edx
  8014e9:	89 d0                	mov    %edx,%eax
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014f0:	eb 06                	jmp    8014f8 <strcmp+0xb>
		p++, q++;
  8014f2:	ff 45 08             	incl   0x8(%ebp)
  8014f5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8a 00                	mov    (%eax),%al
  8014fd:	84 c0                	test   %al,%al
  8014ff:	74 0e                	je     80150f <strcmp+0x22>
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	8a 10                	mov    (%eax),%dl
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	38 c2                	cmp    %al,%dl
  80150d:	74 e3                	je     8014f2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 d0             	movzbl %al,%edx
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	0f b6 c0             	movzbl %al,%eax
  80151f:	29 c2                	sub    %eax,%edx
  801521:	89 d0                	mov    %edx,%eax
}
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    

00801525 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801528:	eb 09                	jmp    801533 <strncmp+0xe>
		n--, p++, q++;
  80152a:	ff 4d 10             	decl   0x10(%ebp)
  80152d:	ff 45 08             	incl   0x8(%ebp)
  801530:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801533:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801537:	74 17                	je     801550 <strncmp+0x2b>
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	84 c0                	test   %al,%al
  801540:	74 0e                	je     801550 <strncmp+0x2b>
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 10                	mov    (%eax),%dl
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	38 c2                	cmp    %al,%dl
  80154e:	74 da                	je     80152a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801550:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801554:	75 07                	jne    80155d <strncmp+0x38>
		return 0;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
  80155b:	eb 14                	jmp    801571 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f b6 d0             	movzbl %al,%edx
  801565:	8b 45 0c             	mov    0xc(%ebp),%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	0f b6 c0             	movzbl %al,%eax
  80156d:	29 c2                	sub    %eax,%edx
  80156f:	89 d0                	mov    %edx,%eax
}
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    

00801573 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80157f:	eb 12                	jmp    801593 <strchr+0x20>
		if (*s == c)
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801589:	75 05                	jne    801590 <strchr+0x1d>
			return (char *) s;
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	eb 11                	jmp    8015a1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801590:	ff 45 08             	incl   0x8(%ebp)
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	84 c0                	test   %al,%al
  80159a:	75 e5                	jne    801581 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015af:	eb 0d                	jmp    8015be <strfind+0x1b>
		if (*s == c)
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b9:	74 0e                	je     8015c9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015bb:	ff 45 08             	incl   0x8(%ebp)
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	8a 00                	mov    (%eax),%al
  8015c3:	84 c0                	test   %al,%al
  8015c5:	75 ea                	jne    8015b1 <strfind+0xe>
  8015c7:	eb 01                	jmp    8015ca <strfind+0x27>
		if (*s == c)
			break;
  8015c9:	90                   	nop
	return (char *) s;
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015e1:	eb 0e                	jmp    8015f1 <memset+0x22>
		*p++ = c;
  8015e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e6:	8d 50 01             	lea    0x1(%eax),%edx
  8015e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ef:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015f1:	ff 4d f8             	decl   -0x8(%ebp)
  8015f4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f8:	79 e9                	jns    8015e3 <memset+0x14>
		*p++ = c;

	return v;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801611:	eb 16                	jmp    801629 <memcpy+0x2a>
		*d++ = *s++;
  801613:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801616:	8d 50 01             	lea    0x1(%eax),%edx
  801619:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80161c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801622:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801625:	8a 12                	mov    (%edx),%dl
  801627:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801629:	8b 45 10             	mov    0x10(%ebp),%eax
  80162c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80162f:	89 55 10             	mov    %edx,0x10(%ebp)
  801632:	85 c0                	test   %eax,%eax
  801634:	75 dd                	jne    801613 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80164d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801650:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801653:	73 50                	jae    8016a5 <memmove+0x6a>
  801655:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801658:	8b 45 10             	mov    0x10(%ebp),%eax
  80165b:	01 d0                	add    %edx,%eax
  80165d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801660:	76 43                	jbe    8016a5 <memmove+0x6a>
		s += n;
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801668:	8b 45 10             	mov    0x10(%ebp),%eax
  80166b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80166e:	eb 10                	jmp    801680 <memmove+0x45>
			*--d = *--s;
  801670:	ff 4d f8             	decl   -0x8(%ebp)
  801673:	ff 4d fc             	decl   -0x4(%ebp)
  801676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801679:	8a 10                	mov    (%eax),%dl
  80167b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801680:	8b 45 10             	mov    0x10(%ebp),%eax
  801683:	8d 50 ff             	lea    -0x1(%eax),%edx
  801686:	89 55 10             	mov    %edx,0x10(%ebp)
  801689:	85 c0                	test   %eax,%eax
  80168b:	75 e3                	jne    801670 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80168d:	eb 23                	jmp    8016b2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80168f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801692:	8d 50 01             	lea    0x1(%eax),%edx
  801695:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801698:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80169b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016a1:	8a 12                	mov    (%edx),%dl
  8016a3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	75 dd                	jne    80168f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c9:	eb 2a                	jmp    8016f5 <memcmp+0x3e>
		if (*s1 != *s2)
  8016cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ce:	8a 10                	mov    (%eax),%dl
  8016d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	38 c2                	cmp    %al,%dl
  8016d7:	74 16                	je     8016ef <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 d0             	movzbl %al,%edx
  8016e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	0f b6 c0             	movzbl %al,%eax
  8016e9:	29 c2                	sub    %eax,%edx
  8016eb:	89 d0                	mov    %edx,%eax
  8016ed:	eb 18                	jmp    801707 <memcmp+0x50>
		s1++, s2++;
  8016ef:	ff 45 fc             	incl   -0x4(%ebp)
  8016f2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016fb:	89 55 10             	mov    %edx,0x10(%ebp)
  8016fe:	85 c0                	test   %eax,%eax
  801700:	75 c9                	jne    8016cb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80170f:	8b 55 08             	mov    0x8(%ebp),%edx
  801712:	8b 45 10             	mov    0x10(%ebp),%eax
  801715:	01 d0                	add    %edx,%eax
  801717:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80171a:	eb 15                	jmp    801731 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8a 00                	mov    (%eax),%al
  801721:	0f b6 d0             	movzbl %al,%edx
  801724:	8b 45 0c             	mov    0xc(%ebp),%eax
  801727:	0f b6 c0             	movzbl %al,%eax
  80172a:	39 c2                	cmp    %eax,%edx
  80172c:	74 0d                	je     80173b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80172e:	ff 45 08             	incl   0x8(%ebp)
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801737:	72 e3                	jb     80171c <memfind+0x13>
  801739:	eb 01                	jmp    80173c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80173b:	90                   	nop
	return (void *) s;
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801747:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80174e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801755:	eb 03                	jmp    80175a <strtol+0x19>
		s++;
  801757:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	3c 20                	cmp    $0x20,%al
  801761:	74 f4                	je     801757 <strtol+0x16>
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	8a 00                	mov    (%eax),%al
  801768:	3c 09                	cmp    $0x9,%al
  80176a:	74 eb                	je     801757 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8a 00                	mov    (%eax),%al
  801771:	3c 2b                	cmp    $0x2b,%al
  801773:	75 05                	jne    80177a <strtol+0x39>
		s++;
  801775:	ff 45 08             	incl   0x8(%ebp)
  801778:	eb 13                	jmp    80178d <strtol+0x4c>
	else if (*s == '-')
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8a 00                	mov    (%eax),%al
  80177f:	3c 2d                	cmp    $0x2d,%al
  801781:	75 0a                	jne    80178d <strtol+0x4c>
		s++, neg = 1;
  801783:	ff 45 08             	incl   0x8(%ebp)
  801786:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80178d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801791:	74 06                	je     801799 <strtol+0x58>
  801793:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801797:	75 20                	jne    8017b9 <strtol+0x78>
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	8a 00                	mov    (%eax),%al
  80179e:	3c 30                	cmp    $0x30,%al
  8017a0:	75 17                	jne    8017b9 <strtol+0x78>
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	40                   	inc    %eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 78                	cmp    $0x78,%al
  8017aa:	75 0d                	jne    8017b9 <strtol+0x78>
		s += 2, base = 16;
  8017ac:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017b0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017b7:	eb 28                	jmp    8017e1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017bd:	75 15                	jne    8017d4 <strtol+0x93>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 30                	cmp    $0x30,%al
  8017c6:	75 0c                	jne    8017d4 <strtol+0x93>
		s++, base = 8;
  8017c8:	ff 45 08             	incl   0x8(%ebp)
  8017cb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017d2:	eb 0d                	jmp    8017e1 <strtol+0xa0>
	else if (base == 0)
  8017d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d8:	75 07                	jne    8017e1 <strtol+0xa0>
		base = 10;
  8017da:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8a 00                	mov    (%eax),%al
  8017e6:	3c 2f                	cmp    $0x2f,%al
  8017e8:	7e 19                	jle    801803 <strtol+0xc2>
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8a 00                	mov    (%eax),%al
  8017ef:	3c 39                	cmp    $0x39,%al
  8017f1:	7f 10                	jg     801803 <strtol+0xc2>
			dig = *s - '0';
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	8a 00                	mov    (%eax),%al
  8017f8:	0f be c0             	movsbl %al,%eax
  8017fb:	83 e8 30             	sub    $0x30,%eax
  8017fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801801:	eb 42                	jmp    801845 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	8a 00                	mov    (%eax),%al
  801808:	3c 60                	cmp    $0x60,%al
  80180a:	7e 19                	jle    801825 <strtol+0xe4>
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	8a 00                	mov    (%eax),%al
  801811:	3c 7a                	cmp    $0x7a,%al
  801813:	7f 10                	jg     801825 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	0f be c0             	movsbl %al,%eax
  80181d:	83 e8 57             	sub    $0x57,%eax
  801820:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801823:	eb 20                	jmp    801845 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	3c 40                	cmp    $0x40,%al
  80182c:	7e 39                	jle    801867 <strtol+0x126>
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3c 5a                	cmp    $0x5a,%al
  801835:	7f 30                	jg     801867 <strtol+0x126>
			dig = *s - 'A' + 10;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	0f be c0             	movsbl %al,%eax
  80183f:	83 e8 37             	sub    $0x37,%eax
  801842:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801848:	3b 45 10             	cmp    0x10(%ebp),%eax
  80184b:	7d 19                	jge    801866 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80184d:	ff 45 08             	incl   0x8(%ebp)
  801850:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801853:	0f af 45 10          	imul   0x10(%ebp),%eax
  801857:	89 c2                	mov    %eax,%edx
  801859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185c:	01 d0                	add    %edx,%eax
  80185e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801861:	e9 7b ff ff ff       	jmp    8017e1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801866:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801867:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80186b:	74 08                	je     801875 <strtol+0x134>
		*endptr = (char *) s;
  80186d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801870:	8b 55 08             	mov    0x8(%ebp),%edx
  801873:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801875:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801879:	74 07                	je     801882 <strtol+0x141>
  80187b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187e:	f7 d8                	neg    %eax
  801880:	eb 03                	jmp    801885 <strtol+0x144>
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <ltostr>:

void
ltostr(long value, char *str)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80188d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801894:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80189b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80189f:	79 13                	jns    8018b4 <ltostr+0x2d>
	{
		neg = 1;
  8018a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ab:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018ae:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018b1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018bc:	99                   	cltd   
  8018bd:	f7 f9                	idiv   %ecx
  8018bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c5:	8d 50 01             	lea    0x1(%eax),%edx
  8018c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018cb:	89 c2                	mov    %eax,%edx
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	01 d0                	add    %edx,%eax
  8018d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018d5:	83 c2 30             	add    $0x30,%edx
  8018d8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018dd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018e2:	f7 e9                	imul   %ecx
  8018e4:	c1 fa 02             	sar    $0x2,%edx
  8018e7:	89 c8                	mov    %ecx,%eax
  8018e9:	c1 f8 1f             	sar    $0x1f,%eax
  8018ec:	29 c2                	sub    %eax,%edx
  8018ee:	89 d0                	mov    %edx,%eax
  8018f0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018fb:	f7 e9                	imul   %ecx
  8018fd:	c1 fa 02             	sar    $0x2,%edx
  801900:	89 c8                	mov    %ecx,%eax
  801902:	c1 f8 1f             	sar    $0x1f,%eax
  801905:	29 c2                	sub    %eax,%edx
  801907:	89 d0                	mov    %edx,%eax
  801909:	c1 e0 02             	shl    $0x2,%eax
  80190c:	01 d0                	add    %edx,%eax
  80190e:	01 c0                	add    %eax,%eax
  801910:	29 c1                	sub    %eax,%ecx
  801912:	89 ca                	mov    %ecx,%edx
  801914:	85 d2                	test   %edx,%edx
  801916:	75 9c                	jne    8018b4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801918:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80191f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801922:	48                   	dec    %eax
  801923:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801926:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80192a:	74 3d                	je     801969 <ltostr+0xe2>
		start = 1 ;
  80192c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801933:	eb 34                	jmp    801969 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801942:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	01 c2                	add    %eax,%edx
  80194a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	01 c8                	add    %ecx,%eax
  801952:	8a 00                	mov    (%eax),%al
  801954:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801956:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195c:	01 c2                	add    %eax,%edx
  80195e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801961:	88 02                	mov    %al,(%edx)
		start++ ;
  801963:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801966:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80196f:	7c c4                	jl     801935 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801971:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801974:	8b 45 0c             	mov    0xc(%ebp),%eax
  801977:	01 d0                	add    %edx,%eax
  801979:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	e8 54 fa ff ff       	call   8013e1 <strlen>
  80198d:	83 c4 04             	add    $0x4,%esp
  801990:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	e8 46 fa ff ff       	call   8013e1 <strlen>
  80199b:	83 c4 04             	add    $0x4,%esp
  80199e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019af:	eb 17                	jmp    8019c8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b7:	01 c2                	add    %eax,%edx
  8019b9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	01 c8                	add    %ecx,%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019c5:	ff 45 fc             	incl   -0x4(%ebp)
  8019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019ce:	7c e1                	jl     8019b1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019de:	eb 1f                	jmp    8019ff <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e3:	8d 50 01             	lea    0x1(%eax),%edx
  8019e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e9:	89 c2                	mov    %eax,%edx
  8019eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ee:	01 c2                	add    %eax,%edx
  8019f0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	01 c8                	add    %ecx,%eax
  8019f8:	8a 00                	mov    (%eax),%al
  8019fa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019fc:	ff 45 f8             	incl   -0x8(%ebp)
  8019ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a02:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a05:	7c d9                	jl     8019e0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0d:	01 d0                	add    %edx,%eax
  801a0f:	c6 00 00             	movb   $0x0,(%eax)
}
  801a12:	90                   	nop
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a18:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a21:	8b 45 14             	mov    0x14(%ebp),%eax
  801a24:	8b 00                	mov    (%eax),%eax
  801a26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a30:	01 d0                	add    %edx,%eax
  801a32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a38:	eb 0c                	jmp    801a46 <strsplit+0x31>
			*string++ = 0;
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8d 50 01             	lea    0x1(%eax),%edx
  801a40:	89 55 08             	mov    %edx,0x8(%ebp)
  801a43:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8a 00                	mov    (%eax),%al
  801a4b:	84 c0                	test   %al,%al
  801a4d:	74 18                	je     801a67 <strsplit+0x52>
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8a 00                	mov    (%eax),%al
  801a54:	0f be c0             	movsbl %al,%eax
  801a57:	50                   	push   %eax
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	e8 13 fb ff ff       	call   801573 <strchr>
  801a60:	83 c4 08             	add    $0x8,%esp
  801a63:	85 c0                	test   %eax,%eax
  801a65:	75 d3                	jne    801a3a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	84 c0                	test   %al,%al
  801a6e:	74 5a                	je     801aca <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a70:	8b 45 14             	mov    0x14(%ebp),%eax
  801a73:	8b 00                	mov    (%eax),%eax
  801a75:	83 f8 0f             	cmp    $0xf,%eax
  801a78:	75 07                	jne    801a81 <strsplit+0x6c>
		{
			return 0;
  801a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7f:	eb 66                	jmp    801ae7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a81:	8b 45 14             	mov    0x14(%ebp),%eax
  801a84:	8b 00                	mov    (%eax),%eax
  801a86:	8d 48 01             	lea    0x1(%eax),%ecx
  801a89:	8b 55 14             	mov    0x14(%ebp),%edx
  801a8c:	89 0a                	mov    %ecx,(%edx)
  801a8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a95:	8b 45 10             	mov    0x10(%ebp),%eax
  801a98:	01 c2                	add    %eax,%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9f:	eb 03                	jmp    801aa4 <strsplit+0x8f>
			string++;
  801aa1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	8a 00                	mov    (%eax),%al
  801aa9:	84 c0                	test   %al,%al
  801aab:	74 8b                	je     801a38 <strsplit+0x23>
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	8a 00                	mov    (%eax),%al
  801ab2:	0f be c0             	movsbl %al,%eax
  801ab5:	50                   	push   %eax
  801ab6:	ff 75 0c             	pushl  0xc(%ebp)
  801ab9:	e8 b5 fa ff ff       	call   801573 <strchr>
  801abe:	83 c4 08             	add    $0x8,%esp
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	74 dc                	je     801aa1 <strsplit+0x8c>
			string++;
	}
  801ac5:	e9 6e ff ff ff       	jmp    801a38 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801aca:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801acb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ace:	8b 00                	mov    (%eax),%eax
  801ad0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  801ada:	01 d0                	add    %edx,%eax
  801adc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ae2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	57                   	push   %edi
  801aed:	56                   	push   %esi
  801aee:	53                   	push   %ebx
  801aef:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801afe:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b01:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b04:	cd 30                	int    $0x30
  801b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5f                   	pop    %edi
  801b12:	5d                   	pop    %ebp
  801b13:	c3                   	ret    

00801b14 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b20:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	52                   	push   %edx
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	50                   	push   %eax
  801b30:	6a 00                	push   $0x0
  801b32:	e8 b2 ff ff ff       	call   801ae9 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_cgetc>:

int
sys_cgetc(void)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 01                	push   $0x1
  801b4c:	e8 98 ff ff ff       	call   801ae9 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 05                	push   $0x5
  801b69:	e8 7b ff ff ff       	call   801ae9 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b78:	8b 75 18             	mov    0x18(%ebp),%esi
  801b7b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	56                   	push   %esi
  801b88:	53                   	push   %ebx
  801b89:	51                   	push   %ecx
  801b8a:	52                   	push   %edx
  801b8b:	50                   	push   %eax
  801b8c:	6a 06                	push   $0x6
  801b8e:	e8 56 ff ff ff       	call   801ae9 <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    

00801b9d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	52                   	push   %edx
  801bad:	50                   	push   %eax
  801bae:	6a 07                	push   $0x7
  801bb0:	e8 34 ff ff ff       	call   801ae9 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	6a 08                	push   $0x8
  801bcb:	e8 19 ff ff ff       	call   801ae9 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 09                	push   $0x9
  801be4:	e8 00 ff ff ff       	call   801ae9 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 0a                	push   $0xa
  801bfd:	e8 e7 fe ff ff       	call   801ae9 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 0b                	push   $0xb
  801c16:	e8 ce fe ff ff       	call   801ae9 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	ff 75 08             	pushl  0x8(%ebp)
  801c2f:	6a 0f                	push   $0xf
  801c31:	e8 b3 fe ff ff       	call   801ae9 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
	return;
  801c39:	90                   	nop
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	6a 10                	push   $0x10
  801c4d:	e8 97 fe ff ff       	call   801ae9 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return ;
  801c55:	90                   	nop
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	ff 75 10             	pushl  0x10(%ebp)
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 11                	push   $0x11
  801c6a:	e8 7a fe ff ff       	call   801ae9 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c72:	90                   	nop
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 0c                	push   $0xc
  801c84:	e8 60 fe ff ff       	call   801ae9 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	6a 0d                	push   $0xd
  801c9e:	e8 46 fe ff ff       	call   801ae9 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 0e                	push   $0xe
  801cb7:	e8 2d fe ff ff       	call   801ae9 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	90                   	nop
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 13                	push   $0x13
  801cd1:	e8 13 fe ff ff       	call   801ae9 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	90                   	nop
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 14                	push   $0x14
  801ceb:	e8 f9 fd ff ff       	call   801ae9 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d02:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	50                   	push   %eax
  801d0f:	6a 15                	push   $0x15
  801d11:	e8 d3 fd ff ff       	call   801ae9 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	90                   	nop
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 16                	push   $0x16
  801d2b:	e8 b9 fd ff ff       	call   801ae9 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	90                   	nop
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	50                   	push   %eax
  801d46:	6a 17                	push   $0x17
  801d48:	e8 9c fd ff ff       	call   801ae9 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	52                   	push   %edx
  801d62:	50                   	push   %eax
  801d63:	6a 1a                	push   $0x1a
  801d65:	e8 7f fd ff ff       	call   801ae9 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	52                   	push   %edx
  801d7f:	50                   	push   %eax
  801d80:	6a 18                	push   $0x18
  801d82:	e8 62 fd ff ff       	call   801ae9 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	90                   	nop
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	52                   	push   %edx
  801d9d:	50                   	push   %eax
  801d9e:	6a 19                	push   $0x19
  801da0:	e8 44 fd ff ff       	call   801ae9 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	90                   	nop
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	8b 45 10             	mov    0x10(%ebp),%eax
  801db4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801db7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dba:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	51                   	push   %ecx
  801dc4:	52                   	push   %edx
  801dc5:	ff 75 0c             	pushl  0xc(%ebp)
  801dc8:	50                   	push   %eax
  801dc9:	6a 1b                	push   $0x1b
  801dcb:	e8 19 fd ff ff       	call   801ae9 <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	52                   	push   %edx
  801de5:	50                   	push   %eax
  801de6:	6a 1c                	push   $0x1c
  801de8:	e8 fc fc ff ff       	call   801ae9 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801df5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	51                   	push   %ecx
  801e03:	52                   	push   %edx
  801e04:	50                   	push   %eax
  801e05:	6a 1d                	push   $0x1d
  801e07:	e8 dd fc ff ff       	call   801ae9 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	52                   	push   %edx
  801e21:	50                   	push   %eax
  801e22:	6a 1e                	push   $0x1e
  801e24:	e8 c0 fc ff ff       	call   801ae9 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 1f                	push   $0x1f
  801e3d:	e8 a7 fc ff ff       	call   801ae9 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	ff 75 14             	pushl  0x14(%ebp)
  801e52:	ff 75 10             	pushl  0x10(%ebp)
  801e55:	ff 75 0c             	pushl  0xc(%ebp)
  801e58:	50                   	push   %eax
  801e59:	6a 20                	push   $0x20
  801e5b:	e8 89 fc ff ff       	call   801ae9 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	50                   	push   %eax
  801e74:	6a 21                	push   $0x21
  801e76:	e8 6e fc ff ff       	call   801ae9 <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
}
  801e7e:	90                   	nop
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	50                   	push   %eax
  801e90:	6a 22                	push   $0x22
  801e92:	e8 52 fc ff ff       	call   801ae9 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 02                	push   $0x2
  801eab:	e8 39 fc ff ff       	call   801ae9 <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 03                	push   $0x3
  801ec4:	e8 20 fc ff ff       	call   801ae9 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 04                	push   $0x4
  801edd:	e8 07 fc ff ff       	call   801ae9 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_exit_env>:


void sys_exit_env(void)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 23                	push   $0x23
  801ef6:	e8 ee fb ff ff       	call   801ae9 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	90                   	nop
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f07:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f0a:	8d 50 04             	lea    0x4(%eax),%edx
  801f0d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	6a 24                	push   $0x24
  801f1a:	e8 ca fb ff ff       	call   801ae9 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
	return result;
  801f22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f2b:	89 01                	mov    %eax,(%ecx)
  801f2d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	c9                   	leave  
  801f34:	c2 04 00             	ret    $0x4

00801f37 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	ff 75 10             	pushl  0x10(%ebp)
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	ff 75 08             	pushl  0x8(%ebp)
  801f47:	6a 12                	push   $0x12
  801f49:	e8 9b fb ff ff       	call   801ae9 <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f51:	90                   	nop
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 25                	push   $0x25
  801f63:	e8 81 fb ff ff       	call   801ae9 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f79:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	50                   	push   %eax
  801f86:	6a 26                	push   $0x26
  801f88:	e8 5c fb ff ff       	call   801ae9 <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f90:	90                   	nop
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <rsttst>:
void rsttst()
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 28                	push   $0x28
  801fa2:	e8 42 fb ff ff       	call   801ae9 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
	return ;
  801faa:	90                   	nop
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fb9:	8b 55 18             	mov    0x18(%ebp),%edx
  801fbc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fc0:	52                   	push   %edx
  801fc1:	50                   	push   %eax
  801fc2:	ff 75 10             	pushl  0x10(%ebp)
  801fc5:	ff 75 0c             	pushl  0xc(%ebp)
  801fc8:	ff 75 08             	pushl  0x8(%ebp)
  801fcb:	6a 27                	push   $0x27
  801fcd:	e8 17 fb ff ff       	call   801ae9 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd5:	90                   	nop
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <chktst>:
void chktst(uint32 n)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	ff 75 08             	pushl  0x8(%ebp)
  801fe6:	6a 29                	push   $0x29
  801fe8:	e8 fc fa ff ff       	call   801ae9 <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff0:	90                   	nop
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <inctst>:

void inctst()
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 2a                	push   $0x2a
  802002:	e8 e2 fa ff ff       	call   801ae9 <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
	return ;
  80200a:	90                   	nop
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <gettst>:
uint32 gettst()
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 2b                	push   $0x2b
  80201c:	e8 c8 fa ff ff       	call   801ae9 <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 2c                	push   $0x2c
  802038:	e8 ac fa ff ff       	call   801ae9 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
  802040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802043:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802047:	75 07                	jne    802050 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802049:	b8 01 00 00 00       	mov    $0x1,%eax
  80204e:	eb 05                	jmp    802055 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 2c                	push   $0x2c
  802069:	e8 7b fa ff ff       	call   801ae9 <syscall>
  80206e:	83 c4 18             	add    $0x18,%esp
  802071:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802074:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802078:	75 07                	jne    802081 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80207a:	b8 01 00 00 00       	mov    $0x1,%eax
  80207f:	eb 05                	jmp    802086 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802081:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 2c                	push   $0x2c
  80209a:	e8 4a fa ff ff       	call   801ae9 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
  8020a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020a5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020a9:	75 07                	jne    8020b2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b0:	eb 05                	jmp    8020b7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 2c                	push   $0x2c
  8020cb:	e8 19 fa ff ff       	call   801ae9 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
  8020d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020da:	75 07                	jne    8020e3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e1:	eb 05                	jmp    8020e8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	ff 75 08             	pushl  0x8(%ebp)
  8020f8:	6a 2d                	push   $0x2d
  8020fa:	e8 ea f9 ff ff       	call   801ae9 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802102:	90                   	nop
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802109:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80210c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80210f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	6a 00                	push   $0x0
  802117:	53                   	push   %ebx
  802118:	51                   	push   %ecx
  802119:	52                   	push   %edx
  80211a:	50                   	push   %eax
  80211b:	6a 2e                	push   $0x2e
  80211d:	e8 c7 f9 ff ff       	call   801ae9 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80212d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	52                   	push   %edx
  80213a:	50                   	push   %eax
  80213b:	6a 2f                	push   $0x2f
  80213d:	e8 a7 f9 ff ff       	call   801ae9 <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80214d:	8b 55 08             	mov    0x8(%ebp),%edx
  802150:	89 d0                	mov    %edx,%eax
  802152:	c1 e0 02             	shl    $0x2,%eax
  802155:	01 d0                	add    %edx,%eax
  802157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80215e:	01 d0                	add    %edx,%eax
  802160:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802167:	01 d0                	add    %edx,%eax
  802169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802170:	01 d0                	add    %edx,%eax
  802172:	c1 e0 04             	shl    $0x4,%eax
  802175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802178:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80217f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802182:	83 ec 0c             	sub    $0xc,%esp
  802185:	50                   	push   %eax
  802186:	e8 76 fd ff ff       	call   801f01 <sys_get_virtual_time>
  80218b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80218e:	eb 41                	jmp    8021d1 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802190:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802193:	83 ec 0c             	sub    $0xc,%esp
  802196:	50                   	push   %eax
  802197:	e8 65 fd ff ff       	call   801f01 <sys_get_virtual_time>
  80219c:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80219f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a5:	29 c2                	sub    %eax,%edx
  8021a7:	89 d0                	mov    %edx,%eax
  8021a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8021ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b2:	89 d1                	mov    %edx,%ecx
  8021b4:	29 c1                	sub    %eax,%ecx
  8021b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8021b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021bc:	39 c2                	cmp    %eax,%edx
  8021be:	0f 97 c0             	seta   %al
  8021c1:	0f b6 c0             	movzbl %al,%eax
  8021c4:	29 c1                	sub    %eax,%ecx
  8021c6:	89 c8                	mov    %ecx,%eax
  8021c8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8021cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021d7:	72 b7                	jb     802190 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8021d9:	90                   	nop
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8021e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8021e9:	eb 03                	jmp    8021ee <busy_wait+0x12>
  8021eb:	ff 45 fc             	incl   -0x4(%ebp)
  8021ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f4:	72 f5                	jb     8021eb <busy_wait+0xf>
	return i;
  8021f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    
  8021fb:	90                   	nop

008021fc <__udivdi3>:
  8021fc:	55                   	push   %ebp
  8021fd:	57                   	push   %edi
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
  802200:	83 ec 1c             	sub    $0x1c,%esp
  802203:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802207:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80220b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80220f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802213:	89 ca                	mov    %ecx,%edx
  802215:	89 f8                	mov    %edi,%eax
  802217:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80221b:	85 f6                	test   %esi,%esi
  80221d:	75 2d                	jne    80224c <__udivdi3+0x50>
  80221f:	39 cf                	cmp    %ecx,%edi
  802221:	77 65                	ja     802288 <__udivdi3+0x8c>
  802223:	89 fd                	mov    %edi,%ebp
  802225:	85 ff                	test   %edi,%edi
  802227:	75 0b                	jne    802234 <__udivdi3+0x38>
  802229:	b8 01 00 00 00       	mov    $0x1,%eax
  80222e:	31 d2                	xor    %edx,%edx
  802230:	f7 f7                	div    %edi
  802232:	89 c5                	mov    %eax,%ebp
  802234:	31 d2                	xor    %edx,%edx
  802236:	89 c8                	mov    %ecx,%eax
  802238:	f7 f5                	div    %ebp
  80223a:	89 c1                	mov    %eax,%ecx
  80223c:	89 d8                	mov    %ebx,%eax
  80223e:	f7 f5                	div    %ebp
  802240:	89 cf                	mov    %ecx,%edi
  802242:	89 fa                	mov    %edi,%edx
  802244:	83 c4 1c             	add    $0x1c,%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5f                   	pop    %edi
  80224a:	5d                   	pop    %ebp
  80224b:	c3                   	ret    
  80224c:	39 ce                	cmp    %ecx,%esi
  80224e:	77 28                	ja     802278 <__udivdi3+0x7c>
  802250:	0f bd fe             	bsr    %esi,%edi
  802253:	83 f7 1f             	xor    $0x1f,%edi
  802256:	75 40                	jne    802298 <__udivdi3+0x9c>
  802258:	39 ce                	cmp    %ecx,%esi
  80225a:	72 0a                	jb     802266 <__udivdi3+0x6a>
  80225c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802260:	0f 87 9e 00 00 00    	ja     802304 <__udivdi3+0x108>
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
  80226b:	89 fa                	mov    %edi,%edx
  80226d:	83 c4 1c             	add    $0x1c,%esp
  802270:	5b                   	pop    %ebx
  802271:	5e                   	pop    %esi
  802272:	5f                   	pop    %edi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    
  802275:	8d 76 00             	lea    0x0(%esi),%esi
  802278:	31 ff                	xor    %edi,%edi
  80227a:	31 c0                	xor    %eax,%eax
  80227c:	89 fa                	mov    %edi,%edx
  80227e:	83 c4 1c             	add    $0x1c,%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5f                   	pop    %edi
  802284:	5d                   	pop    %ebp
  802285:	c3                   	ret    
  802286:	66 90                	xchg   %ax,%ax
  802288:	89 d8                	mov    %ebx,%eax
  80228a:	f7 f7                	div    %edi
  80228c:	31 ff                	xor    %edi,%edi
  80228e:	89 fa                	mov    %edi,%edx
  802290:	83 c4 1c             	add    $0x1c,%esp
  802293:	5b                   	pop    %ebx
  802294:	5e                   	pop    %esi
  802295:	5f                   	pop    %edi
  802296:	5d                   	pop    %ebp
  802297:	c3                   	ret    
  802298:	bd 20 00 00 00       	mov    $0x20,%ebp
  80229d:	89 eb                	mov    %ebp,%ebx
  80229f:	29 fb                	sub    %edi,%ebx
  8022a1:	89 f9                	mov    %edi,%ecx
  8022a3:	d3 e6                	shl    %cl,%esi
  8022a5:	89 c5                	mov    %eax,%ebp
  8022a7:	88 d9                	mov    %bl,%cl
  8022a9:	d3 ed                	shr    %cl,%ebp
  8022ab:	89 e9                	mov    %ebp,%ecx
  8022ad:	09 f1                	or     %esi,%ecx
  8022af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022b3:	89 f9                	mov    %edi,%ecx
  8022b5:	d3 e0                	shl    %cl,%eax
  8022b7:	89 c5                	mov    %eax,%ebp
  8022b9:	89 d6                	mov    %edx,%esi
  8022bb:	88 d9                	mov    %bl,%cl
  8022bd:	d3 ee                	shr    %cl,%esi
  8022bf:	89 f9                	mov    %edi,%ecx
  8022c1:	d3 e2                	shl    %cl,%edx
  8022c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022c7:	88 d9                	mov    %bl,%cl
  8022c9:	d3 e8                	shr    %cl,%eax
  8022cb:	09 c2                	or     %eax,%edx
  8022cd:	89 d0                	mov    %edx,%eax
  8022cf:	89 f2                	mov    %esi,%edx
  8022d1:	f7 74 24 0c          	divl   0xc(%esp)
  8022d5:	89 d6                	mov    %edx,%esi
  8022d7:	89 c3                	mov    %eax,%ebx
  8022d9:	f7 e5                	mul    %ebp
  8022db:	39 d6                	cmp    %edx,%esi
  8022dd:	72 19                	jb     8022f8 <__udivdi3+0xfc>
  8022df:	74 0b                	je     8022ec <__udivdi3+0xf0>
  8022e1:	89 d8                	mov    %ebx,%eax
  8022e3:	31 ff                	xor    %edi,%edi
  8022e5:	e9 58 ff ff ff       	jmp    802242 <__udivdi3+0x46>
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022f0:	89 f9                	mov    %edi,%ecx
  8022f2:	d3 e2                	shl    %cl,%edx
  8022f4:	39 c2                	cmp    %eax,%edx
  8022f6:	73 e9                	jae    8022e1 <__udivdi3+0xe5>
  8022f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022fb:	31 ff                	xor    %edi,%edi
  8022fd:	e9 40 ff ff ff       	jmp    802242 <__udivdi3+0x46>
  802302:	66 90                	xchg   %ax,%ax
  802304:	31 c0                	xor    %eax,%eax
  802306:	e9 37 ff ff ff       	jmp    802242 <__udivdi3+0x46>
  80230b:	90                   	nop

0080230c <__umoddi3>:
  80230c:	55                   	push   %ebp
  80230d:	57                   	push   %edi
  80230e:	56                   	push   %esi
  80230f:	53                   	push   %ebx
  802310:	83 ec 1c             	sub    $0x1c,%esp
  802313:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802317:	8b 74 24 34          	mov    0x34(%esp),%esi
  80231b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80231f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802323:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802327:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80232b:	89 f3                	mov    %esi,%ebx
  80232d:	89 fa                	mov    %edi,%edx
  80232f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802333:	89 34 24             	mov    %esi,(%esp)
  802336:	85 c0                	test   %eax,%eax
  802338:	75 1a                	jne    802354 <__umoddi3+0x48>
  80233a:	39 f7                	cmp    %esi,%edi
  80233c:	0f 86 a2 00 00 00    	jbe    8023e4 <__umoddi3+0xd8>
  802342:	89 c8                	mov    %ecx,%eax
  802344:	89 f2                	mov    %esi,%edx
  802346:	f7 f7                	div    %edi
  802348:	89 d0                	mov    %edx,%eax
  80234a:	31 d2                	xor    %edx,%edx
  80234c:	83 c4 1c             	add    $0x1c,%esp
  80234f:	5b                   	pop    %ebx
  802350:	5e                   	pop    %esi
  802351:	5f                   	pop    %edi
  802352:	5d                   	pop    %ebp
  802353:	c3                   	ret    
  802354:	39 f0                	cmp    %esi,%eax
  802356:	0f 87 ac 00 00 00    	ja     802408 <__umoddi3+0xfc>
  80235c:	0f bd e8             	bsr    %eax,%ebp
  80235f:	83 f5 1f             	xor    $0x1f,%ebp
  802362:	0f 84 ac 00 00 00    	je     802414 <__umoddi3+0x108>
  802368:	bf 20 00 00 00       	mov    $0x20,%edi
  80236d:	29 ef                	sub    %ebp,%edi
  80236f:	89 fe                	mov    %edi,%esi
  802371:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802375:	89 e9                	mov    %ebp,%ecx
  802377:	d3 e0                	shl    %cl,%eax
  802379:	89 d7                	mov    %edx,%edi
  80237b:	89 f1                	mov    %esi,%ecx
  80237d:	d3 ef                	shr    %cl,%edi
  80237f:	09 c7                	or     %eax,%edi
  802381:	89 e9                	mov    %ebp,%ecx
  802383:	d3 e2                	shl    %cl,%edx
  802385:	89 14 24             	mov    %edx,(%esp)
  802388:	89 d8                	mov    %ebx,%eax
  80238a:	d3 e0                	shl    %cl,%eax
  80238c:	89 c2                	mov    %eax,%edx
  80238e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802392:	d3 e0                	shl    %cl,%eax
  802394:	89 44 24 04          	mov    %eax,0x4(%esp)
  802398:	8b 44 24 08          	mov    0x8(%esp),%eax
  80239c:	89 f1                	mov    %esi,%ecx
  80239e:	d3 e8                	shr    %cl,%eax
  8023a0:	09 d0                	or     %edx,%eax
  8023a2:	d3 eb                	shr    %cl,%ebx
  8023a4:	89 da                	mov    %ebx,%edx
  8023a6:	f7 f7                	div    %edi
  8023a8:	89 d3                	mov    %edx,%ebx
  8023aa:	f7 24 24             	mull   (%esp)
  8023ad:	89 c6                	mov    %eax,%esi
  8023af:	89 d1                	mov    %edx,%ecx
  8023b1:	39 d3                	cmp    %edx,%ebx
  8023b3:	0f 82 87 00 00 00    	jb     802440 <__umoddi3+0x134>
  8023b9:	0f 84 91 00 00 00    	je     802450 <__umoddi3+0x144>
  8023bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023c3:	29 f2                	sub    %esi,%edx
  8023c5:	19 cb                	sbb    %ecx,%ebx
  8023c7:	89 d8                	mov    %ebx,%eax
  8023c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023cd:	d3 e0                	shl    %cl,%eax
  8023cf:	89 e9                	mov    %ebp,%ecx
  8023d1:	d3 ea                	shr    %cl,%edx
  8023d3:	09 d0                	or     %edx,%eax
  8023d5:	89 e9                	mov    %ebp,%ecx
  8023d7:	d3 eb                	shr    %cl,%ebx
  8023d9:	89 da                	mov    %ebx,%edx
  8023db:	83 c4 1c             	add    $0x1c,%esp
  8023de:	5b                   	pop    %ebx
  8023df:	5e                   	pop    %esi
  8023e0:	5f                   	pop    %edi
  8023e1:	5d                   	pop    %ebp
  8023e2:	c3                   	ret    
  8023e3:	90                   	nop
  8023e4:	89 fd                	mov    %edi,%ebp
  8023e6:	85 ff                	test   %edi,%edi
  8023e8:	75 0b                	jne    8023f5 <__umoddi3+0xe9>
  8023ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ef:	31 d2                	xor    %edx,%edx
  8023f1:	f7 f7                	div    %edi
  8023f3:	89 c5                	mov    %eax,%ebp
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	31 d2                	xor    %edx,%edx
  8023f9:	f7 f5                	div    %ebp
  8023fb:	89 c8                	mov    %ecx,%eax
  8023fd:	f7 f5                	div    %ebp
  8023ff:	89 d0                	mov    %edx,%eax
  802401:	e9 44 ff ff ff       	jmp    80234a <__umoddi3+0x3e>
  802406:	66 90                	xchg   %ax,%ax
  802408:	89 c8                	mov    %ecx,%eax
  80240a:	89 f2                	mov    %esi,%edx
  80240c:	83 c4 1c             	add    $0x1c,%esp
  80240f:	5b                   	pop    %ebx
  802410:	5e                   	pop    %esi
  802411:	5f                   	pop    %edi
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    
  802414:	3b 04 24             	cmp    (%esp),%eax
  802417:	72 06                	jb     80241f <__umoddi3+0x113>
  802419:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80241d:	77 0f                	ja     80242e <__umoddi3+0x122>
  80241f:	89 f2                	mov    %esi,%edx
  802421:	29 f9                	sub    %edi,%ecx
  802423:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802427:	89 14 24             	mov    %edx,(%esp)
  80242a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80242e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802432:	8b 14 24             	mov    (%esp),%edx
  802435:	83 c4 1c             	add    $0x1c,%esp
  802438:	5b                   	pop    %ebx
  802439:	5e                   	pop    %esi
  80243a:	5f                   	pop    %edi
  80243b:	5d                   	pop    %ebp
  80243c:	c3                   	ret    
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	2b 04 24             	sub    (%esp),%eax
  802443:	19 fa                	sbb    %edi,%edx
  802445:	89 d1                	mov    %edx,%ecx
  802447:	89 c6                	mov    %eax,%esi
  802449:	e9 71 ff ff ff       	jmp    8023bf <__umoddi3+0xb3>
  80244e:	66 90                	xchg   %ax,%ax
  802450:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802454:	72 ea                	jb     802440 <__umoddi3+0x134>
  802456:	89 d9                	mov    %ebx,%ecx
  802458:	e9 62 ff ff ff       	jmp    8023bf <__umoddi3+0xb3>
