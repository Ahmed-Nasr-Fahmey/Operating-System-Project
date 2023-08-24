
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 b7 03 00 00       	call   8003ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
  800051:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 30 80 00       	mov    0x803020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 40 20 80 00       	push   $0x802040
  800092:	6a 12                	push   $0x12
  800094:	68 5c 20 80 00       	push   $0x80205c
  800099:	e8 9e 04 00 00       	call   80053c <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 78 20 80 00       	push   $0x802078
  8000a6:	e8 45 07 00 00       	call   8007f0 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 ac 20 80 00       	push   $0x8020ac
  8000b6:	e8 35 07 00 00       	call   8007f0 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 08 21 80 00       	push   $0x802108
  8000c6:	e8 25 07 00 00       	call   8007f0 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 97 19 00 00       	call   801a6a <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 3c 21 80 00       	push   $0x80213c
  8000de:	e8 0d 07 00 00       	call   8007f0 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000eb:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  8000f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f6:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8000fc:	89 c1                	mov    %eax,%ecx
  8000fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800103:	8b 40 74             	mov    0x74(%eax),%eax
  800106:	52                   	push   %edx
  800107:	51                   	push   %ecx
  800108:	50                   	push   %eax
  800109:	68 7d 21 80 00       	push   $0x80217d
  80010e:	e8 02 19 00 00       	call   801a15 <sys_create_env>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  800124:	a1 20 30 80 00       	mov    0x803020,%eax
  800129:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80012f:	89 c1                	mov    %eax,%ecx
  800131:	a1 20 30 80 00       	mov    0x803020,%eax
  800136:	8b 40 74             	mov    0x74(%eax),%eax
  800139:	52                   	push   %edx
  80013a:	51                   	push   %ecx
  80013b:	50                   	push   %eax
  80013c:	68 7d 21 80 00       	push   $0x80217d
  800141:	e8 cf 18 00 00       	call   801a15 <sys_create_env>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  80014c:	e8 52 16 00 00       	call   8017a3 <sys_calculate_free_frames>
  800151:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	6a 01                	push   $0x1
  800159:	68 00 10 00 00       	push   $0x1000
  80015e:	68 88 21 80 00       	push   $0x802188
  800163:	e8 87 14 00 00       	call   8015ef <smalloc>
  800168:	83 c4 10             	add    $0x10,%esp
  80016b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 8c 21 80 00       	push   $0x80218c
  800176:	e8 75 06 00 00       	call   8007f0 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80017e:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800185:	74 14                	je     80019b <_main+0x163>
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	68 ac 21 80 00       	push   $0x8021ac
  80018f:	6a 24                	push   $0x24
  800191:	68 5c 20 80 00       	push   $0x80205c
  800196:	e8 a1 03 00 00       	call   80053c <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80019b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80019e:	e8 00 16 00 00       	call   8017a3 <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 04             	cmp    $0x4,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 18 22 80 00       	push   $0x802218
  8001b4:	6a 25                	push   $0x25
  8001b6:	68 5c 20 80 00       	push   $0x80205c
  8001bb:	e8 7c 03 00 00       	call   80053c <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c0:	e8 9c 19 00 00       	call   801b61 <rsttst>

		sys_run_env(envIdSlave1);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001cb:	e8 63 18 00 00       	call   801a33 <sys_run_env>
  8001d0:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d9:	e8 55 18 00 00       	call   801a33 <sys_run_env>
  8001de:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 96 22 80 00       	push   $0x802296
  8001e9:	e8 02 06 00 00       	call   8007f0 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	68 b8 0b 00 00       	push   $0xbb8
  8001f9:	e8 17 1b 00 00       	call   801d15 <env_sleep>
  8001fe:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  800201:	e8 d5 19 00 00       	call   801bdb <gettst>
  800206:	83 f8 02             	cmp    $0x2,%eax
  800209:	74 14                	je     80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 ad 22 80 00       	push   $0x8022ad
  800213:	6a 31                	push   $0x31
  800215:	68 5c 20 80 00       	push   $0x80205c
  80021a:	e8 1d 03 00 00       	call   80053c <_panic>

		sfree(x);
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	ff 75 dc             	pushl  -0x24(%ebp)
  800225:	e8 19 14 00 00       	call   801643 <sfree>
  80022a:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	68 bc 22 80 00       	push   $0x8022bc
  800235:	e8 b6 05 00 00       	call   8007f0 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  80023d:	e8 61 15 00 00       	call   8017a3 <sys_calculate_free_frames>
  800242:	89 c2                	mov    %eax,%edx
  800244:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800247:	29 c2                	sub    %eax,%edx
  800249:	89 d0                	mov    %edx,%eax
  80024b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80024e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800252:	74 14                	je     800268 <_main+0x230>
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	68 dc 22 80 00       	push   $0x8022dc
  80025c:	6a 36                	push   $0x36
  80025e:	68 5c 20 80 00       	push   $0x80205c
  800263:	e8 d4 02 00 00       	call   80053c <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 0c 23 80 00       	push   $0x80230c
  800270:	e8 7b 05 00 00       	call   8007f0 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	68 30 23 80 00       	push   $0x802330
  800280:	e8 6b 05 00 00       	call   8007f0 <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800288:	a1 20 30 80 00       	mov    0x803020,%eax
  80028d:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  800293:	a1 20 30 80 00       	mov    0x803020,%eax
  800298:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80029e:	89 c1                	mov    %eax,%ecx
  8002a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a5:	8b 40 74             	mov    0x74(%eax),%eax
  8002a8:	52                   	push   %edx
  8002a9:	51                   	push   %ecx
  8002aa:	50                   	push   %eax
  8002ab:	68 60 23 80 00       	push   $0x802360
  8002b0:	e8 60 17 00 00       	call   801a15 <sys_create_env>
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c0:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  8002c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cb:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8002d1:	89 c1                	mov    %eax,%ecx
  8002d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d8:	8b 40 74             	mov    0x74(%eax),%eax
  8002db:	52                   	push   %edx
  8002dc:	51                   	push   %ecx
  8002dd:	50                   	push   %eax
  8002de:	68 6d 23 80 00       	push   $0x80236d
  8002e3:	e8 2d 17 00 00       	call   801a15 <sys_create_env>
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	6a 01                	push   $0x1
  8002f3:	68 00 10 00 00       	push   $0x1000
  8002f8:	68 7a 23 80 00       	push   $0x80237a
  8002fd:	e8 ed 12 00 00       	call   8015ef <smalloc>
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 7c 23 80 00       	push   $0x80237c
  800310:	e8 db 04 00 00       	call   8007f0 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	6a 01                	push   $0x1
  80031d:	68 00 10 00 00       	push   $0x1000
  800322:	68 88 21 80 00       	push   $0x802188
  800327:	e8 c3 12 00 00       	call   8015ef <smalloc>
  80032c:	83 c4 10             	add    $0x10,%esp
  80032f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  800332:	83 ec 0c             	sub    $0xc,%esp
  800335:	68 8c 21 80 00       	push   $0x80218c
  80033a:	e8 b1 04 00 00       	call   8007f0 <cprintf>
  80033f:	83 c4 10             	add    $0x10,%esp

		rsttst();
  800342:	e8 1a 18 00 00       	call   801b61 <rsttst>

		sys_run_env(envIdSlaveB1);
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80034d:	e8 e1 16 00 00       	call   801a33 <sys_run_env>
  800352:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800355:	83 ec 0c             	sub    $0xc,%esp
  800358:	ff 75 d0             	pushl  -0x30(%ebp)
  80035b:	e8 d3 16 00 00       	call   801a33 <sys_run_env>
  800360:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 a0 0f 00 00       	push   $0xfa0
  80036b:	e8 a5 19 00 00       	call   801d15 <env_sleep>
  800370:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  800373:	e8 2b 14 00 00       	call   8017a3 <sys_calculate_free_frames>
  800378:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	ff 75 cc             	pushl  -0x34(%ebp)
  800381:	e8 bd 12 00 00       	call   801643 <sfree>
  800386:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800389:	83 ec 0c             	sub    $0xc,%esp
  80038c:	68 9c 23 80 00       	push   $0x80239c
  800391:	e8 5a 04 00 00       	call   8007f0 <cprintf>
  800396:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	ff 75 c8             	pushl  -0x38(%ebp)
  80039f:	e8 9f 12 00 00       	call   801643 <sfree>
  8003a4:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 b2 23 80 00       	push   $0x8023b2
  8003af:	e8 3c 04 00 00       	call   8007f0 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003b7:	e8 e7 13 00 00       	call   8017a3 <sys_calculate_free_frames>
  8003bc:	89 c2                	mov    %eax,%edx
  8003be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003c1:	29 c2                	sub    %eax,%edx
  8003c3:	89 d0                	mov    %edx,%eax
  8003c5:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003c8:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003cc:	74 14                	je     8003e2 <_main+0x3aa>
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	68 c8 23 80 00       	push   $0x8023c8
  8003d6:	6a 57                	push   $0x57
  8003d8:	68 5c 20 80 00       	push   $0x80205c
  8003dd:	e8 5a 01 00 00       	call   80053c <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003e2:	e8 da 17 00 00       	call   801bc1 <inctst>


	}


	return;
  8003e7:	90                   	nop
}
  8003e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003eb:	c9                   	leave  
  8003ec:	c3                   	ret    

008003ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003f3:	e8 8b 16 00 00       	call   801a83 <sys_getenvindex>
  8003f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80040b:	01 c8                	add    %ecx,%eax
  80040d:	c1 e0 02             	shl    $0x2,%eax
  800410:	01 d0                	add    %edx,%eax
  800412:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800419:	01 c8                	add    %ecx,%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	01 d0                	add    %edx,%eax
  800420:	c1 e0 02             	shl    $0x2,%eax
  800423:	01 d0                	add    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80042d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800432:	a1 20 30 80 00       	mov    0x803020,%eax
  800437:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  80043d:	84 c0                	test   %al,%al
  80043f:	74 0f                	je     800450 <libmain+0x63>
		binaryname = myEnv->prog_name;
  800441:	a1 20 30 80 00       	mov    0x803020,%eax
  800446:	05 18 da 01 00       	add    $0x1da18,%eax
  80044b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800450:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800454:	7e 0a                	jle    800460 <libmain+0x73>
		binaryname = argv[0];
  800456:	8b 45 0c             	mov    0xc(%ebp),%eax
  800459:	8b 00                	mov    (%eax),%eax
  80045b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	ff 75 0c             	pushl  0xc(%ebp)
  800466:	ff 75 08             	pushl  0x8(%ebp)
  800469:	e8 ca fb ff ff       	call   800038 <_main>
  80046e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800471:	e8 1a 14 00 00       	call   801890 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800476:	83 ec 0c             	sub    $0xc,%esp
  800479:	68 88 24 80 00       	push   $0x802488
  80047e:	e8 6d 03 00 00       	call   8007f0 <cprintf>
  800483:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800486:	a1 20 30 80 00       	mov    0x803020,%eax
  80048b:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800491:	a1 20 30 80 00       	mov    0x803020,%eax
  800496:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80049c:	83 ec 04             	sub    $0x4,%esp
  80049f:	52                   	push   %edx
  8004a0:	50                   	push   %eax
  8004a1:	68 b0 24 80 00       	push   $0x8024b0
  8004a6:	e8 45 03 00 00       	call   8007f0 <cprintf>
  8004ab:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b3:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  8004b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004be:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  8004c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c9:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  8004cf:	51                   	push   %ecx
  8004d0:	52                   	push   %edx
  8004d1:	50                   	push   %eax
  8004d2:	68 d8 24 80 00       	push   $0x8024d8
  8004d7:	e8 14 03 00 00       	call   8007f0 <cprintf>
  8004dc:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004df:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e4:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	50                   	push   %eax
  8004ee:	68 30 25 80 00       	push   $0x802530
  8004f3:	e8 f8 02 00 00       	call   8007f0 <cprintf>
  8004f8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	68 88 24 80 00       	push   $0x802488
  800503:	e8 e8 02 00 00       	call   8007f0 <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80050b:	e8 9a 13 00 00       	call   8018aa <sys_enable_interrupt>

	// exit gracefully
	exit();
  800510:	e8 19 00 00 00       	call   80052e <exit>
}
  800515:	90                   	nop
  800516:	c9                   	leave  
  800517:	c3                   	ret    

00800518 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800518:	55                   	push   %ebp
  800519:	89 e5                	mov    %esp,%ebp
  80051b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	6a 00                	push   $0x0
  800523:	e8 27 15 00 00       	call   801a4f <sys_destroy_env>
  800528:	83 c4 10             	add    $0x10,%esp
}
  80052b:	90                   	nop
  80052c:	c9                   	leave  
  80052d:	c3                   	ret    

0080052e <exit>:

void
exit(void)
{
  80052e:	55                   	push   %ebp
  80052f:	89 e5                	mov    %esp,%ebp
  800531:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800534:	e8 7c 15 00 00       	call   801ab5 <sys_exit_env>
}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800542:	8d 45 10             	lea    0x10(%ebp),%eax
  800545:	83 c0 04             	add    $0x4,%eax
  800548:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80054b:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800550:	85 c0                	test   %eax,%eax
  800552:	74 16                	je     80056a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800554:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	50                   	push   %eax
  80055d:	68 44 25 80 00       	push   $0x802544
  800562:	e8 89 02 00 00       	call   8007f0 <cprintf>
  800567:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80056a:	a1 00 30 80 00       	mov    0x803000,%eax
  80056f:	ff 75 0c             	pushl  0xc(%ebp)
  800572:	ff 75 08             	pushl  0x8(%ebp)
  800575:	50                   	push   %eax
  800576:	68 49 25 80 00       	push   $0x802549
  80057b:	e8 70 02 00 00       	call   8007f0 <cprintf>
  800580:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800583:	8b 45 10             	mov    0x10(%ebp),%eax
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	ff 75 f4             	pushl  -0xc(%ebp)
  80058c:	50                   	push   %eax
  80058d:	e8 f3 01 00 00       	call   800785 <vcprintf>
  800592:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	6a 00                	push   $0x0
  80059a:	68 65 25 80 00       	push   $0x802565
  80059f:	e8 e1 01 00 00       	call   800785 <vcprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005a7:	e8 82 ff ff ff       	call   80052e <exit>

	// should not return here
	while (1) ;
  8005ac:	eb fe                	jmp    8005ac <_panic+0x70>

008005ae <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b9:	8b 50 74             	mov    0x74(%eax),%edx
  8005bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 14                	je     8005d7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 68 25 80 00       	push   $0x802568
  8005cb:	6a 26                	push   $0x26
  8005cd:	68 b4 25 80 00       	push   $0x8025b4
  8005d2:	e8 65 ff ff ff       	call   80053c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005e5:	e9 c2 00 00 00       	jmp    8006ac <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	85 c0                	test   %eax,%eax
  8005fd:	75 08                	jne    800607 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005ff:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800602:	e9 a2 00 00 00       	jmp    8006a9 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800607:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800615:	eb 69                	jmp    800680 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800617:	a1 20 30 80 00       	mov    0x803020,%eax
  80061c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800622:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800625:	89 d0                	mov    %edx,%eax
  800627:	01 c0                	add    %eax,%eax
  800629:	01 d0                	add    %edx,%eax
  80062b:	c1 e0 03             	shl    $0x3,%eax
  80062e:	01 c8                	add    %ecx,%eax
  800630:	8a 40 04             	mov    0x4(%eax),%al
  800633:	84 c0                	test   %al,%al
  800635:	75 46                	jne    80067d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800637:	a1 20 30 80 00       	mov    0x803020,%eax
  80063c:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800642:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800645:	89 d0                	mov    %edx,%eax
  800647:	01 c0                	add    %eax,%eax
  800649:	01 d0                	add    %edx,%eax
  80064b:	c1 e0 03             	shl    $0x3,%eax
  80064e:	01 c8                	add    %ecx,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800655:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800658:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80065d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80065f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800662:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	01 c8                	add    %ecx,%eax
  80066e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800670:	39 c2                	cmp    %eax,%edx
  800672:	75 09                	jne    80067d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800674:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80067b:	eb 12                	jmp    80068f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80067d:	ff 45 e8             	incl   -0x18(%ebp)
  800680:	a1 20 30 80 00       	mov    0x803020,%eax
  800685:	8b 50 74             	mov    0x74(%eax),%edx
  800688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80068b:	39 c2                	cmp    %eax,%edx
  80068d:	77 88                	ja     800617 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80068f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800693:	75 14                	jne    8006a9 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	68 c0 25 80 00       	push   $0x8025c0
  80069d:	6a 3a                	push   $0x3a
  80069f:	68 b4 25 80 00       	push   $0x8025b4
  8006a4:	e8 93 fe ff ff       	call   80053c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006a9:	ff 45 f0             	incl   -0x10(%ebp)
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006b2:	0f 8c 32 ff ff ff    	jl     8005ea <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006c6:	eb 26                	jmp    8006ee <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8006cd:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8006d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d6:	89 d0                	mov    %edx,%eax
  8006d8:	01 c0                	add    %eax,%eax
  8006da:	01 d0                	add    %edx,%eax
  8006dc:	c1 e0 03             	shl    $0x3,%eax
  8006df:	01 c8                	add    %ecx,%eax
  8006e1:	8a 40 04             	mov    0x4(%eax),%al
  8006e4:	3c 01                	cmp    $0x1,%al
  8006e6:	75 03                	jne    8006eb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006e8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006eb:	ff 45 e0             	incl   -0x20(%ebp)
  8006ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8006f3:	8b 50 74             	mov    0x74(%eax),%edx
  8006f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f9:	39 c2                	cmp    %eax,%edx
  8006fb:	77 cb                	ja     8006c8 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800700:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800703:	74 14                	je     800719 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 14 26 80 00       	push   $0x802614
  80070d:	6a 44                	push   $0x44
  80070f:	68 b4 25 80 00       	push   $0x8025b4
  800714:	e8 23 fe ff ff       	call   80053c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800719:	90                   	nop
  80071a:	c9                   	leave  
  80071b:	c3                   	ret    

0080071c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800722:	8b 45 0c             	mov    0xc(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	8d 48 01             	lea    0x1(%eax),%ecx
  80072a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072d:	89 0a                	mov    %ecx,(%edx)
  80072f:	8b 55 08             	mov    0x8(%ebp),%edx
  800732:	88 d1                	mov    %dl,%cl
  800734:	8b 55 0c             	mov    0xc(%ebp),%edx
  800737:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	3d ff 00 00 00       	cmp    $0xff,%eax
  800745:	75 2c                	jne    800773 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800747:	a0 24 30 80 00       	mov    0x803024,%al
  80074c:	0f b6 c0             	movzbl %al,%eax
  80074f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800752:	8b 12                	mov    (%edx),%edx
  800754:	89 d1                	mov    %edx,%ecx
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
  800759:	83 c2 08             	add    $0x8,%edx
  80075c:	83 ec 04             	sub    $0x4,%esp
  80075f:	50                   	push   %eax
  800760:	51                   	push   %ecx
  800761:	52                   	push   %edx
  800762:	e8 7b 0f 00 00       	call   8016e2 <sys_cputs>
  800767:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800773:	8b 45 0c             	mov    0xc(%ebp),%eax
  800776:	8b 40 04             	mov    0x4(%eax),%eax
  800779:	8d 50 01             	lea    0x1(%eax),%edx
  80077c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800782:	90                   	nop
  800783:	c9                   	leave  
  800784:	c3                   	ret    

00800785 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
  800788:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80078e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800795:	00 00 00 
	b.cnt = 0;
  800798:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80079f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	ff 75 08             	pushl  0x8(%ebp)
  8007a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ae:	50                   	push   %eax
  8007af:	68 1c 07 80 00       	push   $0x80071c
  8007b4:	e8 11 02 00 00       	call   8009ca <vprintfmt>
  8007b9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007bc:	a0 24 30 80 00       	mov    0x803024,%al
  8007c1:	0f b6 c0             	movzbl %al,%eax
  8007c4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007ca:	83 ec 04             	sub    $0x4,%esp
  8007cd:	50                   	push   %eax
  8007ce:	52                   	push   %edx
  8007cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007d5:	83 c0 08             	add    $0x8,%eax
  8007d8:	50                   	push   %eax
  8007d9:	e8 04 0f 00 00       	call   8016e2 <sys_cputs>
  8007de:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007e1:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007f6:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800800:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 73 ff ff ff       	call   800785 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800818:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80081b:	c9                   	leave  
  80081c:	c3                   	ret    

0080081d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800823:	e8 68 10 00 00       	call   801890 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800828:	8d 45 0c             	lea    0xc(%ebp),%eax
  80082b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 f4             	pushl  -0xc(%ebp)
  800837:	50                   	push   %eax
  800838:	e8 48 ff ff ff       	call   800785 <vcprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800843:	e8 62 10 00 00       	call   8018aa <sys_enable_interrupt>
	return cnt;
  800848:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    

0080084d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	53                   	push   %ebx
  800851:	83 ec 14             	sub    $0x14,%esp
  800854:	8b 45 10             	mov    0x10(%ebp),%eax
  800857:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800860:	8b 45 18             	mov    0x18(%ebp),%eax
  800863:	ba 00 00 00 00       	mov    $0x0,%edx
  800868:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80086b:	77 55                	ja     8008c2 <printnum+0x75>
  80086d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800870:	72 05                	jb     800877 <printnum+0x2a>
  800872:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800875:	77 4b                	ja     8008c2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800877:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80087a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80087d:	8b 45 18             	mov    0x18(%ebp),%eax
  800880:	ba 00 00 00 00       	mov    $0x0,%edx
  800885:	52                   	push   %edx
  800886:	50                   	push   %eax
  800887:	ff 75 f4             	pushl  -0xc(%ebp)
  80088a:	ff 75 f0             	pushl  -0x10(%ebp)
  80088d:	e8 3a 15 00 00       	call   801dcc <__udivdi3>
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	ff 75 20             	pushl  0x20(%ebp)
  80089b:	53                   	push   %ebx
  80089c:	ff 75 18             	pushl  0x18(%ebp)
  80089f:	52                   	push   %edx
  8008a0:	50                   	push   %eax
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	ff 75 08             	pushl  0x8(%ebp)
  8008a7:	e8 a1 ff ff ff       	call   80084d <printnum>
  8008ac:	83 c4 20             	add    $0x20,%esp
  8008af:	eb 1a                	jmp    8008cb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008b1:	83 ec 08             	sub    $0x8,%esp
  8008b4:	ff 75 0c             	pushl  0xc(%ebp)
  8008b7:	ff 75 20             	pushl  0x20(%ebp)
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008c2:	ff 4d 1c             	decl   0x1c(%ebp)
  8008c5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008c9:	7f e6                	jg     8008b1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008cb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d9:	53                   	push   %ebx
  8008da:	51                   	push   %ecx
  8008db:	52                   	push   %edx
  8008dc:	50                   	push   %eax
  8008dd:	e8 fa 15 00 00       	call   801edc <__umoddi3>
  8008e2:	83 c4 10             	add    $0x10,%esp
  8008e5:	05 74 28 80 00       	add    $0x802874,%eax
  8008ea:	8a 00                	mov    (%eax),%al
  8008ec:	0f be c0             	movsbl %al,%eax
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
}
  8008fe:	90                   	nop
  8008ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800907:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090b:	7e 1c                	jle    800929 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 08             	lea    0x8(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 08             	sub    $0x8,%eax
  800922:	8b 50 04             	mov    0x4(%eax),%edx
  800925:	8b 00                	mov    (%eax),%eax
  800927:	eb 40                	jmp    800969 <getuint+0x65>
	else if (lflag)
  800929:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092d:	74 1e                	je     80094d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	ba 00 00 00 00       	mov    $0x0,%edx
  80094b:	eb 1c                	jmp    800969 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	8d 50 04             	lea    0x4(%eax),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	89 10                	mov    %edx,(%eax)
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	83 e8 04             	sub    $0x4,%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80096e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800972:	7e 1c                	jle    800990 <getint+0x25>
		return va_arg(*ap, long long);
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	8d 50 08             	lea    0x8(%eax),%edx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	89 10                	mov    %edx,(%eax)
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	83 e8 08             	sub    $0x8,%eax
  800989:	8b 50 04             	mov    0x4(%eax),%edx
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	eb 38                	jmp    8009c8 <getint+0x5d>
	else if (lflag)
  800990:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800994:	74 1a                	je     8009b0 <getint+0x45>
		return va_arg(*ap, long);
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	8d 50 04             	lea    0x4(%eax),%edx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	89 10                	mov    %edx,(%eax)
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8b 00                	mov    (%eax),%eax
  8009a8:	83 e8 04             	sub    $0x4,%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	99                   	cltd   
  8009ae:	eb 18                	jmp    8009c8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	8d 50 04             	lea    0x4(%eax),%edx
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	89 10                	mov    %edx,(%eax)
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	83 e8 04             	sub    $0x4,%eax
  8009c5:	8b 00                	mov    (%eax),%eax
  8009c7:	99                   	cltd   
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	56                   	push   %esi
  8009ce:	53                   	push   %ebx
  8009cf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d2:	eb 17                	jmp    8009eb <vprintfmt+0x21>
			if (ch == '\0')
  8009d4:	85 db                	test   %ebx,%ebx
  8009d6:	0f 84 af 03 00 00    	je     800d8b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ee:	8d 50 01             	lea    0x1(%eax),%edx
  8009f1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f4:	8a 00                	mov    (%eax),%al
  8009f6:	0f b6 d8             	movzbl %al,%ebx
  8009f9:	83 fb 25             	cmp    $0x25,%ebx
  8009fc:	75 d6                	jne    8009d4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009fe:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a02:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a09:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a10:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a17:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8d 50 01             	lea    0x1(%eax),%edx
  800a24:	89 55 10             	mov    %edx,0x10(%ebp)
  800a27:	8a 00                	mov    (%eax),%al
  800a29:	0f b6 d8             	movzbl %al,%ebx
  800a2c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a2f:	83 f8 55             	cmp    $0x55,%eax
  800a32:	0f 87 2b 03 00 00    	ja     800d63 <vprintfmt+0x399>
  800a38:	8b 04 85 98 28 80 00 	mov    0x802898(,%eax,4),%eax
  800a3f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a41:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a45:	eb d7                	jmp    800a1e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a47:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a4b:	eb d1                	jmp    800a1e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a54:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a57:	89 d0                	mov    %edx,%eax
  800a59:	c1 e0 02             	shl    $0x2,%eax
  800a5c:	01 d0                	add    %edx,%eax
  800a5e:	01 c0                	add    %eax,%eax
  800a60:	01 d8                	add    %ebx,%eax
  800a62:	83 e8 30             	sub    $0x30,%eax
  800a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a68:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6b:	8a 00                	mov    (%eax),%al
  800a6d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a70:	83 fb 2f             	cmp    $0x2f,%ebx
  800a73:	7e 3e                	jle    800ab3 <vprintfmt+0xe9>
  800a75:	83 fb 39             	cmp    $0x39,%ebx
  800a78:	7f 39                	jg     800ab3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a7a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a7d:	eb d5                	jmp    800a54 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 e8 04             	sub    $0x4,%eax
  800a8e:	8b 00                	mov    (%eax),%eax
  800a90:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a93:	eb 1f                	jmp    800ab4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a99:	79 83                	jns    800a1e <vprintfmt+0x54>
				width = 0;
  800a9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800aa2:	e9 77 ff ff ff       	jmp    800a1e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800aa7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aae:	e9 6b ff ff ff       	jmp    800a1e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ab3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ab4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab8:	0f 89 60 ff ff ff    	jns    800a1e <vprintfmt+0x54>
				width = precision, precision = -1;
  800abe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ac4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800acb:	e9 4e ff ff ff       	jmp    800a1e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ad0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ad3:	e9 46 ff ff ff       	jmp    800a1e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	83 c0 04             	add    $0x4,%eax
  800ade:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 e8 04             	sub    $0x4,%eax
  800ae7:	8b 00                	mov    (%eax),%eax
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	50                   	push   %eax
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	ff d0                	call   *%eax
  800af5:	83 c4 10             	add    $0x10,%esp
			break;
  800af8:	e9 89 02 00 00       	jmp    800d86 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800afd:	8b 45 14             	mov    0x14(%ebp),%eax
  800b00:	83 c0 04             	add    $0x4,%eax
  800b03:	89 45 14             	mov    %eax,0x14(%ebp)
  800b06:	8b 45 14             	mov    0x14(%ebp),%eax
  800b09:	83 e8 04             	sub    $0x4,%eax
  800b0c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b0e:	85 db                	test   %ebx,%ebx
  800b10:	79 02                	jns    800b14 <vprintfmt+0x14a>
				err = -err;
  800b12:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b14:	83 fb 64             	cmp    $0x64,%ebx
  800b17:	7f 0b                	jg     800b24 <vprintfmt+0x15a>
  800b19:	8b 34 9d e0 26 80 00 	mov    0x8026e0(,%ebx,4),%esi
  800b20:	85 f6                	test   %esi,%esi
  800b22:	75 19                	jne    800b3d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b24:	53                   	push   %ebx
  800b25:	68 85 28 80 00       	push   $0x802885
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 5e 02 00 00       	call   800d93 <printfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b38:	e9 49 02 00 00       	jmp    800d86 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b3d:	56                   	push   %esi
  800b3e:	68 8e 28 80 00       	push   $0x80288e
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	ff 75 08             	pushl  0x8(%ebp)
  800b49:	e8 45 02 00 00       	call   800d93 <printfmt>
  800b4e:	83 c4 10             	add    $0x10,%esp
			break;
  800b51:	e9 30 02 00 00       	jmp    800d86 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b56:	8b 45 14             	mov    0x14(%ebp),%eax
  800b59:	83 c0 04             	add    $0x4,%eax
  800b5c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b62:	83 e8 04             	sub    $0x4,%eax
  800b65:	8b 30                	mov    (%eax),%esi
  800b67:	85 f6                	test   %esi,%esi
  800b69:	75 05                	jne    800b70 <vprintfmt+0x1a6>
				p = "(null)";
  800b6b:	be 91 28 80 00       	mov    $0x802891,%esi
			if (width > 0 && padc != '-')
  800b70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b74:	7e 6d                	jle    800be3 <vprintfmt+0x219>
  800b76:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b7a:	74 67                	je     800be3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7f:	83 ec 08             	sub    $0x8,%esp
  800b82:	50                   	push   %eax
  800b83:	56                   	push   %esi
  800b84:	e8 0c 03 00 00       	call   800e95 <strnlen>
  800b89:	83 c4 10             	add    $0x10,%esp
  800b8c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b8f:	eb 16                	jmp    800ba7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b91:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	50                   	push   %eax
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	ff d0                	call   *%eax
  800ba1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bab:	7f e4                	jg     800b91 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bad:	eb 34                	jmp    800be3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800baf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bb3:	74 1c                	je     800bd1 <vprintfmt+0x207>
  800bb5:	83 fb 1f             	cmp    $0x1f,%ebx
  800bb8:	7e 05                	jle    800bbf <vprintfmt+0x1f5>
  800bba:	83 fb 7e             	cmp    $0x7e,%ebx
  800bbd:	7e 12                	jle    800bd1 <vprintfmt+0x207>
					putch('?', putdat);
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	6a 3f                	push   $0x3f
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	ff d0                	call   *%eax
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	eb 0f                	jmp    800be0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	53                   	push   %ebx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff d0                	call   *%eax
  800bdd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be0:	ff 4d e4             	decl   -0x1c(%ebp)
  800be3:	89 f0                	mov    %esi,%eax
  800be5:	8d 70 01             	lea    0x1(%eax),%esi
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	0f be d8             	movsbl %al,%ebx
  800bed:	85 db                	test   %ebx,%ebx
  800bef:	74 24                	je     800c15 <vprintfmt+0x24b>
  800bf1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf5:	78 b8                	js     800baf <vprintfmt+0x1e5>
  800bf7:	ff 4d e0             	decl   -0x20(%ebp)
  800bfa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bfe:	79 af                	jns    800baf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c00:	eb 13                	jmp    800c15 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 20                	push   $0x20
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c12:	ff 4d e4             	decl   -0x1c(%ebp)
  800c15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c19:	7f e7                	jg     800c02 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c1b:	e9 66 01 00 00       	jmp    800d86 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 e8             	pushl  -0x18(%ebp)
  800c26:	8d 45 14             	lea    0x14(%ebp),%eax
  800c29:	50                   	push   %eax
  800c2a:	e8 3c fd ff ff       	call   80096b <getint>
  800c2f:	83 c4 10             	add    $0x10,%esp
  800c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3e:	85 d2                	test   %edx,%edx
  800c40:	79 23                	jns    800c65 <vprintfmt+0x29b>
				putch('-', putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	6a 2d                	push   $0x2d
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	ff d0                	call   *%eax
  800c4f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c58:	f7 d8                	neg    %eax
  800c5a:	83 d2 00             	adc    $0x0,%edx
  800c5d:	f7 da                	neg    %edx
  800c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c62:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c65:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c6c:	e9 bc 00 00 00       	jmp    800d2d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c71:	83 ec 08             	sub    $0x8,%esp
  800c74:	ff 75 e8             	pushl  -0x18(%ebp)
  800c77:	8d 45 14             	lea    0x14(%ebp),%eax
  800c7a:	50                   	push   %eax
  800c7b:	e8 84 fc ff ff       	call   800904 <getuint>
  800c80:	83 c4 10             	add    $0x10,%esp
  800c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c86:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c89:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c90:	e9 98 00 00 00       	jmp    800d2d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	6a 58                	push   $0x58
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	ff d0                	call   *%eax
  800ca2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	6a 58                	push   $0x58
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 58                	push   $0x58
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
			break;
  800cc5:	e9 bc 00 00 00       	jmp    800d86 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	ff 75 0c             	pushl  0xc(%ebp)
  800cd0:	6a 30                	push   $0x30
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	6a 78                	push   $0x78
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	ff d0                	call   *%eax
  800ce7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cea:	8b 45 14             	mov    0x14(%ebp),%eax
  800ced:	83 c0 04             	add    $0x4,%eax
  800cf0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf6:	83 e8 04             	sub    $0x4,%eax
  800cf9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d05:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d0c:	eb 1f                	jmp    800d2d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d0e:	83 ec 08             	sub    $0x8,%esp
  800d11:	ff 75 e8             	pushl  -0x18(%ebp)
  800d14:	8d 45 14             	lea    0x14(%ebp),%eax
  800d17:	50                   	push   %eax
  800d18:	e8 e7 fb ff ff       	call   800904 <getuint>
  800d1d:	83 c4 10             	add    $0x10,%esp
  800d20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d23:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d26:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d2d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d34:	83 ec 04             	sub    $0x4,%esp
  800d37:	52                   	push   %edx
  800d38:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d3b:	50                   	push   %eax
  800d3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3f:	ff 75 f0             	pushl  -0x10(%ebp)
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	ff 75 08             	pushl  0x8(%ebp)
  800d48:	e8 00 fb ff ff       	call   80084d <printnum>
  800d4d:	83 c4 20             	add    $0x20,%esp
			break;
  800d50:	eb 34                	jmp    800d86 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	53                   	push   %ebx
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	ff d0                	call   *%eax
  800d5e:	83 c4 10             	add    $0x10,%esp
			break;
  800d61:	eb 23                	jmp    800d86 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d63:	83 ec 08             	sub    $0x8,%esp
  800d66:	ff 75 0c             	pushl  0xc(%ebp)
  800d69:	6a 25                	push   $0x25
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d73:	ff 4d 10             	decl   0x10(%ebp)
  800d76:	eb 03                	jmp    800d7b <vprintfmt+0x3b1>
  800d78:	ff 4d 10             	decl   0x10(%ebp)
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	48                   	dec    %eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	3c 25                	cmp    $0x25,%al
  800d83:	75 f3                	jne    800d78 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d85:	90                   	nop
		}
	}
  800d86:	e9 47 fc ff ff       	jmp    8009d2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d8b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d99:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9c:	83 c0 04             	add    $0x4,%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	ff 75 f4             	pushl  -0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 16 fc ff ff       	call   8009ca <vprintfmt>
  800db4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800db7:	90                   	nop
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	8b 40 08             	mov    0x8(%eax),%eax
  800dc3:	8d 50 01             	lea    0x1(%eax),%edx
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8b 10                	mov    (%eax),%edx
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8b 40 04             	mov    0x4(%eax),%eax
  800dd7:	39 c2                	cmp    %eax,%edx
  800dd9:	73 12                	jae    800ded <sprintputch+0x33>
		*b->buf++ = ch;
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	8b 00                	mov    (%eax),%eax
  800de0:	8d 48 01             	lea    0x1(%eax),%ecx
  800de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de6:	89 0a                	mov    %ecx,(%edx)
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	88 10                	mov    %dl,(%eax)
}
  800ded:	90                   	nop
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	01 d0                	add    %edx,%eax
  800e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e15:	74 06                	je     800e1d <vsnprintf+0x2d>
  800e17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1b:	7f 07                	jg     800e24 <vsnprintf+0x34>
		return -E_INVAL;
  800e1d:	b8 03 00 00 00       	mov    $0x3,%eax
  800e22:	eb 20                	jmp    800e44 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e24:	ff 75 14             	pushl  0x14(%ebp)
  800e27:	ff 75 10             	pushl  0x10(%ebp)
  800e2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e2d:	50                   	push   %eax
  800e2e:	68 ba 0d 80 00       	push   $0x800dba
  800e33:	e8 92 fb ff ff       	call   8009ca <vprintfmt>
  800e38:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e3e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e4c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e4f:	83 c0 04             	add    $0x4,%eax
  800e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5b:	50                   	push   %eax
  800e5c:	ff 75 0c             	pushl  0xc(%ebp)
  800e5f:	ff 75 08             	pushl  0x8(%ebp)
  800e62:	e8 89 ff ff ff       	call   800df0 <vsnprintf>
  800e67:	83 c4 10             	add    $0x10,%esp
  800e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7f:	eb 06                	jmp    800e87 <strlen+0x15>
		n++;
  800e81:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e84:	ff 45 08             	incl   0x8(%ebp)
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	75 f1                	jne    800e81 <strlen+0xf>
		n++;
	return n;
  800e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea2:	eb 09                	jmp    800ead <strnlen+0x18>
		n++;
  800ea4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea7:	ff 45 08             	incl   0x8(%ebp)
  800eaa:	ff 4d 0c             	decl   0xc(%ebp)
  800ead:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb1:	74 09                	je     800ebc <strnlen+0x27>
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	84 c0                	test   %al,%al
  800eba:	75 e8                	jne    800ea4 <strnlen+0xf>
		n++;
	return n;
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ecd:	90                   	nop
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8d 50 01             	lea    0x1(%eax),%edx
  800ed4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee0:	8a 12                	mov    (%edx),%dl
  800ee2:	88 10                	mov    %dl,(%eax)
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	84 c0                	test   %al,%al
  800ee8:	75 e4                	jne    800ece <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eed:	c9                   	leave  
  800eee:	c3                   	ret    

00800eef <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800efb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f02:	eb 1f                	jmp    800f23 <strncpy+0x34>
		*dst++ = *src;
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8d 50 01             	lea    0x1(%eax),%edx
  800f0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f10:	8a 12                	mov    (%edx),%dl
  800f12:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	84 c0                	test   %al,%al
  800f1b:	74 03                	je     800f20 <strncpy+0x31>
			src++;
  800f1d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f20:	ff 45 fc             	incl   -0x4(%ebp)
  800f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f26:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f29:	72 d9                	jb     800f04 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f40:	74 30                	je     800f72 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f42:	eb 16                	jmp    800f5a <strlcpy+0x2a>
			*dst++ = *src++;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8d 50 01             	lea    0x1(%eax),%edx
  800f4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f56:	8a 12                	mov    (%edx),%dl
  800f58:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f61:	74 09                	je     800f6c <strlcpy+0x3c>
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	84 c0                	test   %al,%al
  800f6a:	75 d8                	jne    800f44 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f78:	29 c2                	sub    %eax,%edx
  800f7a:	89 d0                	mov    %edx,%eax
}
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f81:	eb 06                	jmp    800f89 <strcmp+0xb>
		p++, q++;
  800f83:	ff 45 08             	incl   0x8(%ebp)
  800f86:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	84 c0                	test   %al,%al
  800f90:	74 0e                	je     800fa0 <strcmp+0x22>
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 10                	mov    (%eax),%dl
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	38 c2                	cmp    %al,%dl
  800f9e:	74 e3                	je     800f83 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 d0             	movzbl %al,%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	29 c2                	sub    %eax,%edx
  800fb2:	89 d0                	mov    %edx,%eax
}
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fb9:	eb 09                	jmp    800fc4 <strncmp+0xe>
		n--, p++, q++;
  800fbb:	ff 4d 10             	decl   0x10(%ebp)
  800fbe:	ff 45 08             	incl   0x8(%ebp)
  800fc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	74 17                	je     800fe1 <strncmp+0x2b>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	84 c0                	test   %al,%al
  800fd1:	74 0e                	je     800fe1 <strncmp+0x2b>
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 10                	mov    (%eax),%dl
  800fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	38 c2                	cmp    %al,%dl
  800fdf:	74 da                	je     800fbb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fe1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe5:	75 07                	jne    800fee <strncmp+0x38>
		return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fec:	eb 14                	jmp    801002 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	0f b6 d0             	movzbl %al,%edx
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	0f b6 c0             	movzbl %al,%eax
  800ffe:	29 c2                	sub    %eax,%edx
  801000:	89 d0                	mov    %edx,%eax
}
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    

00801004 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 04             	sub    $0x4,%esp
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801010:	eb 12                	jmp    801024 <strchr+0x20>
		if (*s == c)
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101a:	75 05                	jne    801021 <strchr+0x1d>
			return (char *) s;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	eb 11                	jmp    801032 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	84 c0                	test   %al,%al
  80102b:	75 e5                	jne    801012 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80102d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 04             	sub    $0x4,%esp
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801040:	eb 0d                	jmp    80104f <strfind+0x1b>
		if (*s == c)
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80104a:	74 0e                	je     80105a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	84 c0                	test   %al,%al
  801056:	75 ea                	jne    801042 <strfind+0xe>
  801058:	eb 01                	jmp    80105b <strfind+0x27>
		if (*s == c)
			break;
  80105a:	90                   	nop
	return (char *) s;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    

00801060 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80106c:	8b 45 10             	mov    0x10(%ebp),%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801072:	eb 0e                	jmp    801082 <memset+0x22>
		*p++ = c;
  801074:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801077:	8d 50 01             	lea    0x1(%eax),%edx
  80107a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80107d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801080:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801082:	ff 4d f8             	decl   -0x8(%ebp)
  801085:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801089:	79 e9                	jns    801074 <memset+0x14>
		*p++ = c;

	return v;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010a2:	eb 16                	jmp    8010ba <memcpy+0x2a>
		*d++ = *s++;
  8010a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a7:	8d 50 01             	lea    0x1(%eax),%edx
  8010aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b6:	8a 12                	mov    (%edx),%dl
  8010b8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	75 dd                	jne    8010a4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e4:	73 50                	jae    801136 <memmove+0x6a>
  8010e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	01 d0                	add    %edx,%eax
  8010ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f1:	76 43                	jbe    801136 <memmove+0x6a>
		s += n;
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ff:	eb 10                	jmp    801111 <memmove+0x45>
			*--d = *--s;
  801101:	ff 4d f8             	decl   -0x8(%ebp)
  801104:	ff 4d fc             	decl   -0x4(%ebp)
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110a:	8a 10                	mov    (%eax),%dl
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801111:	8b 45 10             	mov    0x10(%ebp),%eax
  801114:	8d 50 ff             	lea    -0x1(%eax),%edx
  801117:	89 55 10             	mov    %edx,0x10(%ebp)
  80111a:	85 c0                	test   %eax,%eax
  80111c:	75 e3                	jne    801101 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80111e:	eb 23                	jmp    801143 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801120:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801123:	8d 50 01             	lea    0x1(%eax),%edx
  801126:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801129:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801132:	8a 12                	mov    (%edx),%dl
  801134:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 ff             	lea    -0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	85 c0                	test   %eax,%eax
  801141:	75 dd                	jne    801120 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80115a:	eb 2a                	jmp    801186 <memcmp+0x3e>
		if (*s1 != *s2)
  80115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115f:	8a 10                	mov    (%eax),%dl
  801161:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	38 c2                	cmp    %al,%dl
  801168:	74 16                	je     801180 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	0f b6 d0             	movzbl %al,%edx
  801172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f b6 c0             	movzbl %al,%eax
  80117a:	29 c2                	sub    %eax,%edx
  80117c:	89 d0                	mov    %edx,%eax
  80117e:	eb 18                	jmp    801198 <memcmp+0x50>
		s1++, s2++;
  801180:	ff 45 fc             	incl   -0x4(%ebp)
  801183:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118c:	89 55 10             	mov    %edx,0x10(%ebp)
  80118f:	85 c0                	test   %eax,%eax
  801191:	75 c9                	jne    80115c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801193:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801198:	c9                   	leave  
  801199:	c3                   	ret    

0080119a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011ab:	eb 15                	jmp    8011c2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	0f b6 d0             	movzbl %al,%edx
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	0f b6 c0             	movzbl %al,%eax
  8011bb:	39 c2                	cmp    %eax,%edx
  8011bd:	74 0d                	je     8011cc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011bf:	ff 45 08             	incl   0x8(%ebp)
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011c8:	72 e3                	jb     8011ad <memfind+0x13>
  8011ca:	eb 01                	jmp    8011cd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011cc:	90                   	nop
	return (void *) s;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e6:	eb 03                	jmp    8011eb <strtol+0x19>
		s++;
  8011e8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	3c 20                	cmp    $0x20,%al
  8011f2:	74 f4                	je     8011e8 <strtol+0x16>
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3c 09                	cmp    $0x9,%al
  8011fb:	74 eb                	je     8011e8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 2b                	cmp    $0x2b,%al
  801204:	75 05                	jne    80120b <strtol+0x39>
		s++;
  801206:	ff 45 08             	incl   0x8(%ebp)
  801209:	eb 13                	jmp    80121e <strtol+0x4c>
	else if (*s == '-')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 2d                	cmp    $0x2d,%al
  801212:	75 0a                	jne    80121e <strtol+0x4c>
		s++, neg = 1;
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80121e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801222:	74 06                	je     80122a <strtol+0x58>
  801224:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801228:	75 20                	jne    80124a <strtol+0x78>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 30                	cmp    $0x30,%al
  801231:	75 17                	jne    80124a <strtol+0x78>
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	40                   	inc    %eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	3c 78                	cmp    $0x78,%al
  80123b:	75 0d                	jne    80124a <strtol+0x78>
		s += 2, base = 16;
  80123d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801241:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801248:	eb 28                	jmp    801272 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80124a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124e:	75 15                	jne    801265 <strtol+0x93>
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 30                	cmp    $0x30,%al
  801257:	75 0c                	jne    801265 <strtol+0x93>
		s++, base = 8;
  801259:	ff 45 08             	incl   0x8(%ebp)
  80125c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801263:	eb 0d                	jmp    801272 <strtol+0xa0>
	else if (base == 0)
  801265:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801269:	75 07                	jne    801272 <strtol+0xa0>
		base = 10;
  80126b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 2f                	cmp    $0x2f,%al
  801279:	7e 19                	jle    801294 <strtol+0xc2>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	3c 39                	cmp    $0x39,%al
  801282:	7f 10                	jg     801294 <strtol+0xc2>
			dig = *s - '0';
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	83 e8 30             	sub    $0x30,%eax
  80128f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801292:	eb 42                	jmp    8012d6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 60                	cmp    $0x60,%al
  80129b:	7e 19                	jle    8012b6 <strtol+0xe4>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 7a                	cmp    $0x7a,%al
  8012a4:	7f 10                	jg     8012b6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8a 00                	mov    (%eax),%al
  8012ab:	0f be c0             	movsbl %al,%eax
  8012ae:	83 e8 57             	sub    $0x57,%eax
  8012b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b4:	eb 20                	jmp    8012d6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 40                	cmp    $0x40,%al
  8012bd:	7e 39                	jle    8012f8 <strtol+0x126>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 5a                	cmp    $0x5a,%al
  8012c6:	7f 30                	jg     8012f8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	0f be c0             	movsbl %al,%eax
  8012d0:	83 e8 37             	sub    $0x37,%eax
  8012d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012dc:	7d 19                	jge    8012f7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012de:	ff 45 08             	incl   0x8(%ebp)
  8012e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012e8:	89 c2                	mov    %eax,%edx
  8012ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ed:	01 d0                	add    %edx,%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012f2:	e9 7b ff ff ff       	jmp    801272 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012f7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fc:	74 08                	je     801306 <strtol+0x134>
		*endptr = (char *) s;
  8012fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801301:	8b 55 08             	mov    0x8(%ebp),%edx
  801304:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801306:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80130a:	74 07                	je     801313 <strtol+0x141>
  80130c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130f:	f7 d8                	neg    %eax
  801311:	eb 03                	jmp    801316 <strtol+0x144>
  801313:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <ltostr>:

void
ltostr(long value, char *str)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80131e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801325:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80132c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801330:	79 13                	jns    801345 <ltostr+0x2d>
	{
		neg = 1;
  801332:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80133f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801342:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80134d:	99                   	cltd   
  80134e:	f7 f9                	idiv   %ecx
  801350:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801353:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801356:	8d 50 01             	lea    0x1(%eax),%edx
  801359:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80135c:	89 c2                	mov    %eax,%edx
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	01 d0                	add    %edx,%eax
  801363:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801366:	83 c2 30             	add    $0x30,%edx
  801369:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80136b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801373:	f7 e9                	imul   %ecx
  801375:	c1 fa 02             	sar    $0x2,%edx
  801378:	89 c8                	mov    %ecx,%eax
  80137a:	c1 f8 1f             	sar    $0x1f,%eax
  80137d:	29 c2                	sub    %eax,%edx
  80137f:	89 d0                	mov    %edx,%eax
  801381:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801384:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801387:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80138c:	f7 e9                	imul   %ecx
  80138e:	c1 fa 02             	sar    $0x2,%edx
  801391:	89 c8                	mov    %ecx,%eax
  801393:	c1 f8 1f             	sar    $0x1f,%eax
  801396:	29 c2                	sub    %eax,%edx
  801398:	89 d0                	mov    %edx,%eax
  80139a:	c1 e0 02             	shl    $0x2,%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	01 c0                	add    %eax,%eax
  8013a1:	29 c1                	sub    %eax,%ecx
  8013a3:	89 ca                	mov    %ecx,%edx
  8013a5:	85 d2                	test   %edx,%edx
  8013a7:	75 9c                	jne    801345 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b3:	48                   	dec    %eax
  8013b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013bb:	74 3d                	je     8013fa <ltostr+0xe2>
		start = 1 ;
  8013bd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013c4:	eb 34                	jmp    8013fa <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	8a 00                	mov    (%eax),%al
  8013d0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d9:	01 c2                	add    %eax,%edx
  8013db:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e1:	01 c8                	add    %ecx,%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ed:	01 c2                	add    %eax,%edx
  8013ef:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013f2:	88 02                	mov    %al,(%edx)
		start++ ;
  8013f4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013f7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801400:	7c c4                	jl     8013c6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801402:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	01 d0                	add    %edx,%eax
  80140a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80140d:	90                   	nop
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801416:	ff 75 08             	pushl  0x8(%ebp)
  801419:	e8 54 fa ff ff       	call   800e72 <strlen>
  80141e:	83 c4 04             	add    $0x4,%esp
  801421:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801424:	ff 75 0c             	pushl  0xc(%ebp)
  801427:	e8 46 fa ff ff       	call   800e72 <strlen>
  80142c:	83 c4 04             	add    $0x4,%esp
  80142f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801432:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801439:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801440:	eb 17                	jmp    801459 <strcconcat+0x49>
		final[s] = str1[s] ;
  801442:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801445:	8b 45 10             	mov    0x10(%ebp),%eax
  801448:	01 c2                	add    %eax,%edx
  80144a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	01 c8                	add    %ecx,%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801456:	ff 45 fc             	incl   -0x4(%ebp)
  801459:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80145f:	7c e1                	jl     801442 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801461:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801468:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80146f:	eb 1f                	jmp    801490 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801471:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801474:	8d 50 01             	lea    0x1(%eax),%edx
  801477:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80147a:	89 c2                	mov    %eax,%edx
  80147c:	8b 45 10             	mov    0x10(%ebp),%eax
  80147f:	01 c2                	add    %eax,%edx
  801481:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	01 c8                	add    %ecx,%eax
  801489:	8a 00                	mov    (%eax),%al
  80148b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80148d:	ff 45 f8             	incl   -0x8(%ebp)
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801493:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801496:	7c d9                	jl     801471 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801498:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149b:	8b 45 10             	mov    0x10(%ebp),%eax
  80149e:	01 d0                	add    %edx,%eax
  8014a0:	c6 00 00             	movb   $0x0,(%eax)
}
  8014a3:	90                   	nop
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b5:	8b 00                	mov    (%eax),%eax
  8014b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c9:	eb 0c                	jmp    8014d7 <strsplit+0x31>
			*string++ = 0;
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8d 50 01             	lea    0x1(%eax),%edx
  8014d1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	84 c0                	test   %al,%al
  8014de:	74 18                	je     8014f8 <strsplit+0x52>
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	0f be c0             	movsbl %al,%eax
  8014e8:	50                   	push   %eax
  8014e9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ec:	e8 13 fb ff ff       	call   801004 <strchr>
  8014f1:	83 c4 08             	add    $0x8,%esp
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	75 d3                	jne    8014cb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8a 00                	mov    (%eax),%al
  8014fd:	84 c0                	test   %al,%al
  8014ff:	74 5a                	je     80155b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801501:	8b 45 14             	mov    0x14(%ebp),%eax
  801504:	8b 00                	mov    (%eax),%eax
  801506:	83 f8 0f             	cmp    $0xf,%eax
  801509:	75 07                	jne    801512 <strsplit+0x6c>
		{
			return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
  801510:	eb 66                	jmp    801578 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 48 01             	lea    0x1(%eax),%ecx
  80151a:	8b 55 14             	mov    0x14(%ebp),%edx
  80151d:	89 0a                	mov    %ecx,(%edx)
  80151f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	01 c2                	add    %eax,%edx
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801530:	eb 03                	jmp    801535 <strsplit+0x8f>
			string++;
  801532:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	8a 00                	mov    (%eax),%al
  80153a:	84 c0                	test   %al,%al
  80153c:	74 8b                	je     8014c9 <strsplit+0x23>
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	0f be c0             	movsbl %al,%eax
  801546:	50                   	push   %eax
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	e8 b5 fa ff ff       	call   801004 <strchr>
  80154f:	83 c4 08             	add    $0x8,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	74 dc                	je     801532 <strsplit+0x8c>
			string++;
	}
  801556:	e9 6e ff ff ff       	jmp    8014c9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80155b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80155c:	8b 45 14             	mov    0x14(%ebp),%eax
  80155f:	8b 00                	mov    (%eax),%eax
  801561:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801568:	8b 45 10             	mov    0x10(%ebp),%eax
  80156b:	01 d0                	add    %edx,%eax
  80156d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801573:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	68 f0 29 80 00       	push   $0x8029f0
  801588:	6a 0e                	push   $0xe
  80158a:	68 2a 2a 80 00       	push   $0x802a2a
  80158f:	e8 a8 ef ff ff       	call   80053c <_panic>

00801594 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80159a:	a1 04 30 80 00       	mov    0x803004,%eax
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	74 0f                	je     8015b2 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8015a3:	e8 d2 ff ff ff       	call   80157a <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8015a8:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8015af:	00 00 00 
	}
	if (size == 0) return NULL ;
  8015b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b6:	75 07                	jne    8015bf <malloc+0x2b>
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bd:	eb 14                	jmp    8015d3 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 38 2a 80 00       	push   $0x802a38
  8015c7:	6a 2e                	push   $0x2e
  8015c9:	68 2a 2a 80 00       	push   $0x802a2a
  8015ce:	e8 69 ef ff ff       	call   80053c <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 60 2a 80 00       	push   $0x802a60
  8015e3:	6a 49                	push   $0x49
  8015e5:	68 2a 2a 80 00       	push   $0x802a2a
  8015ea:	e8 4d ef ff ff       	call   80053c <_panic>

008015ef <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 18             	sub    $0x18,%esp
  8015f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f8:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8015fb:	83 ec 04             	sub    $0x4,%esp
  8015fe:	68 84 2a 80 00       	push   $0x802a84
  801603:	6a 57                	push   $0x57
  801605:	68 2a 2a 80 00       	push   $0x802a2a
  80160a:	e8 2d ef ff ff       	call   80053c <_panic>

0080160f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	68 ac 2a 80 00       	push   $0x802aac
  80161d:	6a 60                	push   $0x60
  80161f:	68 2a 2a 80 00       	push   $0x802a2a
  801624:	e8 13 ef ff ff       	call   80053c <_panic>

00801629 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	68 d0 2a 80 00       	push   $0x802ad0
  801637:	6a 7c                	push   $0x7c
  801639:	68 2a 2a 80 00       	push   $0x802a2a
  80163e:	e8 f9 ee ff ff       	call   80053c <_panic>

00801643 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	68 f8 2a 80 00       	push   $0x802af8
  801651:	68 86 00 00 00       	push   $0x86
  801656:	68 2a 2a 80 00       	push   $0x802a2a
  80165b:	e8 dc ee ff ff       	call   80053c <_panic>

00801660 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801666:	83 ec 04             	sub    $0x4,%esp
  801669:	68 1c 2b 80 00       	push   $0x802b1c
  80166e:	68 91 00 00 00       	push   $0x91
  801673:	68 2a 2a 80 00       	push   $0x802a2a
  801678:	e8 bf ee ff ff       	call   80053c <_panic>

0080167d <shrink>:

}
void shrink(uint32 newSize)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	68 1c 2b 80 00       	push   $0x802b1c
  80168b:	68 96 00 00 00       	push   $0x96
  801690:	68 2a 2a 80 00       	push   $0x802a2a
  801695:	e8 a2 ee ff ff       	call   80053c <_panic>

0080169a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	68 1c 2b 80 00       	push   $0x802b1c
  8016a8:	68 9b 00 00 00       	push   $0x9b
  8016ad:	68 2a 2a 80 00       	push   $0x802a2a
  8016b2:	e8 85 ee ff ff       	call   80053c <_panic>

008016b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	57                   	push   %edi
  8016bb:	56                   	push   %esi
  8016bc:	53                   	push   %ebx
  8016bd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016cf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016d2:	cd 30                	int    $0x30
  8016d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	5b                   	pop    %ebx
  8016de:	5e                   	pop    %esi
  8016df:	5f                   	pop    %edi
  8016e0:	5d                   	pop    %ebp
  8016e1:	c3                   	ret    

008016e2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	52                   	push   %edx
  8016fa:	ff 75 0c             	pushl  0xc(%ebp)
  8016fd:	50                   	push   %eax
  8016fe:	6a 00                	push   $0x0
  801700:	e8 b2 ff ff ff       	call   8016b7 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	90                   	nop
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_cgetc>:

int
sys_cgetc(void)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 01                	push   $0x1
  80171a:	e8 98 ff ff ff       	call   8016b7 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	52                   	push   %edx
  801734:	50                   	push   %eax
  801735:	6a 05                	push   $0x5
  801737:	e8 7b ff ff ff       	call   8016b7 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	56                   	push   %esi
  801745:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801746:	8b 75 18             	mov    0x18(%ebp),%esi
  801749:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	56                   	push   %esi
  801756:	53                   	push   %ebx
  801757:	51                   	push   %ecx
  801758:	52                   	push   %edx
  801759:	50                   	push   %eax
  80175a:	6a 06                	push   $0x6
  80175c:	e8 56 ff ff ff       	call   8016b7 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801767:	5b                   	pop    %ebx
  801768:	5e                   	pop    %esi
  801769:	5d                   	pop    %ebp
  80176a:	c3                   	ret    

0080176b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80176e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	52                   	push   %edx
  80177b:	50                   	push   %eax
  80177c:	6a 07                	push   $0x7
  80177e:	e8 34 ff ff ff       	call   8016b7 <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	ff 75 08             	pushl  0x8(%ebp)
  801797:	6a 08                	push   $0x8
  801799:	e8 19 ff ff ff       	call   8016b7 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 09                	push   $0x9
  8017b2:	e8 00 ff ff ff       	call   8016b7 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 0a                	push   $0xa
  8017cb:	e8 e7 fe ff ff       	call   8016b7 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 0b                	push   $0xb
  8017e4:	e8 ce fe ff ff       	call   8016b7 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	ff 75 08             	pushl  0x8(%ebp)
  8017fd:	6a 0f                	push   $0xf
  8017ff:	e8 b3 fe ff ff       	call   8016b7 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
	return;
  801807:	90                   	nop
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	6a 10                	push   $0x10
  80181b:	e8 97 fe ff ff       	call   8016b7 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
	return ;
  801823:	90                   	nop
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	ff 75 10             	pushl  0x10(%ebp)
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	6a 11                	push   $0x11
  801838:	e8 7a fe ff ff       	call   8016b7 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
	return ;
  801840:	90                   	nop
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 0c                	push   $0xc
  801852:	e8 60 fe ff ff       	call   8016b7 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	ff 75 08             	pushl  0x8(%ebp)
  80186a:	6a 0d                	push   $0xd
  80186c:	e8 46 fe ff ff       	call   8016b7 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 0e                	push   $0xe
  801885:	e8 2d fe ff ff       	call   8016b7 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	90                   	nop
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 13                	push   $0x13
  80189f:	e8 13 fe ff ff       	call   8016b7 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	90                   	nop
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 14                	push   $0x14
  8018b9:	e8 f9 fd ff ff       	call   8016b7 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	90                   	nop
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	50                   	push   %eax
  8018dd:	6a 15                	push   $0x15
  8018df:	e8 d3 fd ff ff       	call   8016b7 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	90                   	nop
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 16                	push   $0x16
  8018f9:	e8 b9 fd ff ff       	call   8016b7 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	90                   	nop
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	50                   	push   %eax
  801914:	6a 17                	push   $0x17
  801916:	e8 9c fd ff ff       	call   8016b7 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 1a                	push   $0x1a
  801933:	e8 7f fd ff ff       	call   8016b7 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801940:	8b 55 0c             	mov    0xc(%ebp),%edx
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 18                	push   $0x18
  801950:	e8 62 fd ff ff       	call   8016b7 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	90                   	nop
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	6a 19                	push   $0x19
  80196e:	e8 44 fd ff ff       	call   8016b7 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	90                   	nop
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	8b 45 10             	mov    0x10(%ebp),%eax
  801982:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801985:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801988:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	51                   	push   %ecx
  801992:	52                   	push   %edx
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	50                   	push   %eax
  801997:	6a 1b                	push   $0x1b
  801999:	e8 19 fd ff ff       	call   8016b7 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	52                   	push   %edx
  8019b3:	50                   	push   %eax
  8019b4:	6a 1c                	push   $0x1c
  8019b6:	e8 fc fc ff ff       	call   8016b7 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	51                   	push   %ecx
  8019d1:	52                   	push   %edx
  8019d2:	50                   	push   %eax
  8019d3:	6a 1d                	push   $0x1d
  8019d5:	e8 dd fc ff ff       	call   8016b7 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	6a 1e                	push   $0x1e
  8019f2:	e8 c0 fc ff ff       	call   8016b7 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 1f                	push   $0x1f
  801a0b:	e8 a7 fc ff ff       	call   8016b7 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	ff 75 14             	pushl  0x14(%ebp)
  801a20:	ff 75 10             	pushl  0x10(%ebp)
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	50                   	push   %eax
  801a27:	6a 20                	push   $0x20
  801a29:	e8 89 fc ff ff       	call   8016b7 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	50                   	push   %eax
  801a42:	6a 21                	push   $0x21
  801a44:	e8 6e fc ff ff       	call   8016b7 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	50                   	push   %eax
  801a5e:	6a 22                	push   $0x22
  801a60:	e8 52 fc ff ff       	call   8016b7 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 02                	push   $0x2
  801a79:	e8 39 fc ff ff       	call   8016b7 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 03                	push   $0x3
  801a92:	e8 20 fc ff ff       	call   8016b7 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 04                	push   $0x4
  801aab:	e8 07 fc ff ff       	call   8016b7 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_exit_env>:


void sys_exit_env(void)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 23                	push   $0x23
  801ac4:	e8 ee fb ff ff       	call   8016b7 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	90                   	nop
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ad5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad8:	8d 50 04             	lea    0x4(%eax),%edx
  801adb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	52                   	push   %edx
  801ae5:	50                   	push   %eax
  801ae6:	6a 24                	push   $0x24
  801ae8:	e8 ca fb ff ff       	call   8016b7 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
	return result;
  801af0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801af9:	89 01                	mov    %eax,(%ecx)
  801afb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	c9                   	leave  
  801b02:	c2 04 00             	ret    $0x4

00801b05 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	ff 75 10             	pushl  0x10(%ebp)
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	ff 75 08             	pushl  0x8(%ebp)
  801b15:	6a 12                	push   $0x12
  801b17:	e8 9b fb ff ff       	call   8016b7 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1f:	90                   	nop
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 25                	push   $0x25
  801b31:	e8 81 fb ff ff       	call   8016b7 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b47:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	50                   	push   %eax
  801b54:	6a 26                	push   $0x26
  801b56:	e8 5c fb ff ff       	call   8016b7 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5e:	90                   	nop
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <rsttst>:
void rsttst()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 28                	push   $0x28
  801b70:	e8 42 fb ff ff       	call   8016b7 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
	return ;
  801b78:	90                   	nop
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	8b 45 14             	mov    0x14(%ebp),%eax
  801b84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b87:	8b 55 18             	mov    0x18(%ebp),%edx
  801b8a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8e:	52                   	push   %edx
  801b8f:	50                   	push   %eax
  801b90:	ff 75 10             	pushl  0x10(%ebp)
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	ff 75 08             	pushl  0x8(%ebp)
  801b99:	6a 27                	push   $0x27
  801b9b:	e8 17 fb ff ff       	call   8016b7 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba3:	90                   	nop
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <chktst>:
void chktst(uint32 n)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	6a 29                	push   $0x29
  801bb6:	e8 fc fa ff ff       	call   8016b7 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbe:	90                   	nop
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <inctst>:

void inctst()
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 2a                	push   $0x2a
  801bd0:	e8 e2 fa ff ff       	call   8016b7 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd8:	90                   	nop
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <gettst>:
uint32 gettst()
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 2b                	push   $0x2b
  801bea:	e8 c8 fa ff ff       	call   8016b7 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 2c                	push   $0x2c
  801c06:	e8 ac fa ff ff       	call   8016b7 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
  801c0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c11:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c15:	75 07                	jne    801c1e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c17:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1c:	eb 05                	jmp    801c23 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 2c                	push   $0x2c
  801c37:	e8 7b fa ff ff       	call   8016b7 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
  801c3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c42:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c46:	75 07                	jne    801c4f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c48:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4d:	eb 05                	jmp    801c54 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 2c                	push   $0x2c
  801c68:	e8 4a fa ff ff       	call   8016b7 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
  801c70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c73:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c77:	75 07                	jne    801c80 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c79:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7e:	eb 05                	jmp    801c85 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 2c                	push   $0x2c
  801c99:	e8 19 fa ff ff       	call   8016b7 <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
  801ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ca4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ca8:	75 07                	jne    801cb1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	eb 05                	jmp    801cb6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	6a 2d                	push   $0x2d
  801cc8:	e8 ea f9 ff ff       	call   8016b7 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd0:	90                   	nop
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cd7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	53                   	push   %ebx
  801ce6:	51                   	push   %ecx
  801ce7:	52                   	push   %edx
  801ce8:	50                   	push   %eax
  801ce9:	6a 2e                	push   $0x2e
  801ceb:	e8 c7 f9 ff ff       	call   8016b7 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 2f                	push   $0x2f
  801d0b:	e8 a7 f9 ff ff       	call   8016b7 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d1e:	89 d0                	mov    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d2c:	01 d0                	add    %edx,%eax
  801d2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d35:	01 d0                	add    %edx,%eax
  801d37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d3e:	01 d0                	add    %edx,%eax
  801d40:	c1 e0 04             	shl    $0x4,%eax
  801d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801d46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801d4d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	50                   	push   %eax
  801d54:	e8 76 fd ff ff       	call   801acf <sys_get_virtual_time>
  801d59:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801d5c:	eb 41                	jmp    801d9f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801d5e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	50                   	push   %eax
  801d65:	e8 65 fd ff ff       	call   801acf <sys_get_virtual_time>
  801d6a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d73:	29 c2                	sub    %eax,%edx
  801d75:	89 d0                	mov    %edx,%eax
  801d77:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d80:	89 d1                	mov    %edx,%ecx
  801d82:	29 c1                	sub    %eax,%ecx
  801d84:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8a:	39 c2                	cmp    %eax,%edx
  801d8c:	0f 97 c0             	seta   %al
  801d8f:	0f b6 c0             	movzbl %al,%eax
  801d92:	29 c1                	sub    %eax,%ecx
  801d94:	89 c8                	mov    %ecx,%eax
  801d96:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d99:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801da5:	72 b7                	jb     801d5e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801da7:	90                   	nop
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801db0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801db7:	eb 03                	jmp    801dbc <busy_wait+0x12>
  801db9:	ff 45 fc             	incl   -0x4(%ebp)
  801dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dbf:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dc2:	72 f5                	jb     801db9 <busy_wait+0xf>
	return i;
  801dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    
  801dc9:	66 90                	xchg   %ax,%ax
  801dcb:	90                   	nop

00801dcc <__udivdi3>:
  801dcc:	55                   	push   %ebp
  801dcd:	57                   	push   %edi
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 1c             	sub    $0x1c,%esp
  801dd3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801dd7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ddb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ddf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801de3:	89 ca                	mov    %ecx,%edx
  801de5:	89 f8                	mov    %edi,%eax
  801de7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801deb:	85 f6                	test   %esi,%esi
  801ded:	75 2d                	jne    801e1c <__udivdi3+0x50>
  801def:	39 cf                	cmp    %ecx,%edi
  801df1:	77 65                	ja     801e58 <__udivdi3+0x8c>
  801df3:	89 fd                	mov    %edi,%ebp
  801df5:	85 ff                	test   %edi,%edi
  801df7:	75 0b                	jne    801e04 <__udivdi3+0x38>
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	31 d2                	xor    %edx,%edx
  801e00:	f7 f7                	div    %edi
  801e02:	89 c5                	mov    %eax,%ebp
  801e04:	31 d2                	xor    %edx,%edx
  801e06:	89 c8                	mov    %ecx,%eax
  801e08:	f7 f5                	div    %ebp
  801e0a:	89 c1                	mov    %eax,%ecx
  801e0c:	89 d8                	mov    %ebx,%eax
  801e0e:	f7 f5                	div    %ebp
  801e10:	89 cf                	mov    %ecx,%edi
  801e12:	89 fa                	mov    %edi,%edx
  801e14:	83 c4 1c             	add    $0x1c,%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
  801e1c:	39 ce                	cmp    %ecx,%esi
  801e1e:	77 28                	ja     801e48 <__udivdi3+0x7c>
  801e20:	0f bd fe             	bsr    %esi,%edi
  801e23:	83 f7 1f             	xor    $0x1f,%edi
  801e26:	75 40                	jne    801e68 <__udivdi3+0x9c>
  801e28:	39 ce                	cmp    %ecx,%esi
  801e2a:	72 0a                	jb     801e36 <__udivdi3+0x6a>
  801e2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e30:	0f 87 9e 00 00 00    	ja     801ed4 <__udivdi3+0x108>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	89 fa                	mov    %edi,%edx
  801e3d:	83 c4 1c             	add    $0x1c,%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5e                   	pop    %esi
  801e42:	5f                   	pop    %edi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    
  801e45:	8d 76 00             	lea    0x0(%esi),%esi
  801e48:	31 ff                	xor    %edi,%edi
  801e4a:	31 c0                	xor    %eax,%eax
  801e4c:	89 fa                	mov    %edi,%edx
  801e4e:	83 c4 1c             	add    $0x1c,%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5f                   	pop    %edi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    
  801e56:	66 90                	xchg   %ax,%ax
  801e58:	89 d8                	mov    %ebx,%eax
  801e5a:	f7 f7                	div    %edi
  801e5c:	31 ff                	xor    %edi,%edi
  801e5e:	89 fa                	mov    %edi,%edx
  801e60:	83 c4 1c             	add    $0x1c,%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5f                   	pop    %edi
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    
  801e68:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e6d:	89 eb                	mov    %ebp,%ebx
  801e6f:	29 fb                	sub    %edi,%ebx
  801e71:	89 f9                	mov    %edi,%ecx
  801e73:	d3 e6                	shl    %cl,%esi
  801e75:	89 c5                	mov    %eax,%ebp
  801e77:	88 d9                	mov    %bl,%cl
  801e79:	d3 ed                	shr    %cl,%ebp
  801e7b:	89 e9                	mov    %ebp,%ecx
  801e7d:	09 f1                	or     %esi,%ecx
  801e7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e83:	89 f9                	mov    %edi,%ecx
  801e85:	d3 e0                	shl    %cl,%eax
  801e87:	89 c5                	mov    %eax,%ebp
  801e89:	89 d6                	mov    %edx,%esi
  801e8b:	88 d9                	mov    %bl,%cl
  801e8d:	d3 ee                	shr    %cl,%esi
  801e8f:	89 f9                	mov    %edi,%ecx
  801e91:	d3 e2                	shl    %cl,%edx
  801e93:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e97:	88 d9                	mov    %bl,%cl
  801e99:	d3 e8                	shr    %cl,%eax
  801e9b:	09 c2                	or     %eax,%edx
  801e9d:	89 d0                	mov    %edx,%eax
  801e9f:	89 f2                	mov    %esi,%edx
  801ea1:	f7 74 24 0c          	divl   0xc(%esp)
  801ea5:	89 d6                	mov    %edx,%esi
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	f7 e5                	mul    %ebp
  801eab:	39 d6                	cmp    %edx,%esi
  801ead:	72 19                	jb     801ec8 <__udivdi3+0xfc>
  801eaf:	74 0b                	je     801ebc <__udivdi3+0xf0>
  801eb1:	89 d8                	mov    %ebx,%eax
  801eb3:	31 ff                	xor    %edi,%edi
  801eb5:	e9 58 ff ff ff       	jmp    801e12 <__udivdi3+0x46>
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ec0:	89 f9                	mov    %edi,%ecx
  801ec2:	d3 e2                	shl    %cl,%edx
  801ec4:	39 c2                	cmp    %eax,%edx
  801ec6:	73 e9                	jae    801eb1 <__udivdi3+0xe5>
  801ec8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ecb:	31 ff                	xor    %edi,%edi
  801ecd:	e9 40 ff ff ff       	jmp    801e12 <__udivdi3+0x46>
  801ed2:	66 90                	xchg   %ax,%ax
  801ed4:	31 c0                	xor    %eax,%eax
  801ed6:	e9 37 ff ff ff       	jmp    801e12 <__udivdi3+0x46>
  801edb:	90                   	nop

00801edc <__umoddi3>:
  801edc:	55                   	push   %ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 1c             	sub    $0x1c,%esp
  801ee3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ee7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801eeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ef3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ef7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801efb:	89 f3                	mov    %esi,%ebx
  801efd:	89 fa                	mov    %edi,%edx
  801eff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f03:	89 34 24             	mov    %esi,(%esp)
  801f06:	85 c0                	test   %eax,%eax
  801f08:	75 1a                	jne    801f24 <__umoddi3+0x48>
  801f0a:	39 f7                	cmp    %esi,%edi
  801f0c:	0f 86 a2 00 00 00    	jbe    801fb4 <__umoddi3+0xd8>
  801f12:	89 c8                	mov    %ecx,%eax
  801f14:	89 f2                	mov    %esi,%edx
  801f16:	f7 f7                	div    %edi
  801f18:	89 d0                	mov    %edx,%eax
  801f1a:	31 d2                	xor    %edx,%edx
  801f1c:	83 c4 1c             	add    $0x1c,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5f                   	pop    %edi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    
  801f24:	39 f0                	cmp    %esi,%eax
  801f26:	0f 87 ac 00 00 00    	ja     801fd8 <__umoddi3+0xfc>
  801f2c:	0f bd e8             	bsr    %eax,%ebp
  801f2f:	83 f5 1f             	xor    $0x1f,%ebp
  801f32:	0f 84 ac 00 00 00    	je     801fe4 <__umoddi3+0x108>
  801f38:	bf 20 00 00 00       	mov    $0x20,%edi
  801f3d:	29 ef                	sub    %ebp,%edi
  801f3f:	89 fe                	mov    %edi,%esi
  801f41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f45:	89 e9                	mov    %ebp,%ecx
  801f47:	d3 e0                	shl    %cl,%eax
  801f49:	89 d7                	mov    %edx,%edi
  801f4b:	89 f1                	mov    %esi,%ecx
  801f4d:	d3 ef                	shr    %cl,%edi
  801f4f:	09 c7                	or     %eax,%edi
  801f51:	89 e9                	mov    %ebp,%ecx
  801f53:	d3 e2                	shl    %cl,%edx
  801f55:	89 14 24             	mov    %edx,(%esp)
  801f58:	89 d8                	mov    %ebx,%eax
  801f5a:	d3 e0                	shl    %cl,%eax
  801f5c:	89 c2                	mov    %eax,%edx
  801f5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f62:	d3 e0                	shl    %cl,%eax
  801f64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f68:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f6c:	89 f1                	mov    %esi,%ecx
  801f6e:	d3 e8                	shr    %cl,%eax
  801f70:	09 d0                	or     %edx,%eax
  801f72:	d3 eb                	shr    %cl,%ebx
  801f74:	89 da                	mov    %ebx,%edx
  801f76:	f7 f7                	div    %edi
  801f78:	89 d3                	mov    %edx,%ebx
  801f7a:	f7 24 24             	mull   (%esp)
  801f7d:	89 c6                	mov    %eax,%esi
  801f7f:	89 d1                	mov    %edx,%ecx
  801f81:	39 d3                	cmp    %edx,%ebx
  801f83:	0f 82 87 00 00 00    	jb     802010 <__umoddi3+0x134>
  801f89:	0f 84 91 00 00 00    	je     802020 <__umoddi3+0x144>
  801f8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f93:	29 f2                	sub    %esi,%edx
  801f95:	19 cb                	sbb    %ecx,%ebx
  801f97:	89 d8                	mov    %ebx,%eax
  801f99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f9d:	d3 e0                	shl    %cl,%eax
  801f9f:	89 e9                	mov    %ebp,%ecx
  801fa1:	d3 ea                	shr    %cl,%edx
  801fa3:	09 d0                	or     %edx,%eax
  801fa5:	89 e9                	mov    %ebp,%ecx
  801fa7:	d3 eb                	shr    %cl,%ebx
  801fa9:	89 da                	mov    %ebx,%edx
  801fab:	83 c4 1c             	add    $0x1c,%esp
  801fae:	5b                   	pop    %ebx
  801faf:	5e                   	pop    %esi
  801fb0:	5f                   	pop    %edi
  801fb1:	5d                   	pop    %ebp
  801fb2:	c3                   	ret    
  801fb3:	90                   	nop
  801fb4:	89 fd                	mov    %edi,%ebp
  801fb6:	85 ff                	test   %edi,%edi
  801fb8:	75 0b                	jne    801fc5 <__umoddi3+0xe9>
  801fba:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbf:	31 d2                	xor    %edx,%edx
  801fc1:	f7 f7                	div    %edi
  801fc3:	89 c5                	mov    %eax,%ebp
  801fc5:	89 f0                	mov    %esi,%eax
  801fc7:	31 d2                	xor    %edx,%edx
  801fc9:	f7 f5                	div    %ebp
  801fcb:	89 c8                	mov    %ecx,%eax
  801fcd:	f7 f5                	div    %ebp
  801fcf:	89 d0                	mov    %edx,%eax
  801fd1:	e9 44 ff ff ff       	jmp    801f1a <__umoddi3+0x3e>
  801fd6:	66 90                	xchg   %ax,%ax
  801fd8:	89 c8                	mov    %ecx,%eax
  801fda:	89 f2                	mov    %esi,%edx
  801fdc:	83 c4 1c             	add    $0x1c,%esp
  801fdf:	5b                   	pop    %ebx
  801fe0:	5e                   	pop    %esi
  801fe1:	5f                   	pop    %edi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    
  801fe4:	3b 04 24             	cmp    (%esp),%eax
  801fe7:	72 06                	jb     801fef <__umoddi3+0x113>
  801fe9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fed:	77 0f                	ja     801ffe <__umoddi3+0x122>
  801fef:	89 f2                	mov    %esi,%edx
  801ff1:	29 f9                	sub    %edi,%ecx
  801ff3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ff7:	89 14 24             	mov    %edx,(%esp)
  801ffa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ffe:	8b 44 24 04          	mov    0x4(%esp),%eax
  802002:	8b 14 24             	mov    (%esp),%edx
  802005:	83 c4 1c             	add    $0x1c,%esp
  802008:	5b                   	pop    %ebx
  802009:	5e                   	pop    %esi
  80200a:	5f                   	pop    %edi
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    
  80200d:	8d 76 00             	lea    0x0(%esi),%esi
  802010:	2b 04 24             	sub    (%esp),%eax
  802013:	19 fa                	sbb    %edi,%edx
  802015:	89 d1                	mov    %edx,%ecx
  802017:	89 c6                	mov    %eax,%esi
  802019:	e9 71 ff ff ff       	jmp    801f8f <__umoddi3+0xb3>
  80201e:	66 90                	xchg   %ax,%ax
  802020:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802024:	72 ea                	jb     802010 <__umoddi3+0x134>
  802026:	89 d9                	mov    %ebx,%ecx
  802028:	e9 62 ff ff ff       	jmp    801f8f <__umoddi3+0xb3>
