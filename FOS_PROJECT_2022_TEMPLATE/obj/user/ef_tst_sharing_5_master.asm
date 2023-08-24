
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
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
  80008d:	68 c0 20 80 00       	push   $0x8020c0
  800092:	6a 12                	push   $0x12
  800094:	68 dc 20 80 00       	push   $0x8020dc
  800099:	e8 24 05 00 00       	call   8005c2 <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 fc 20 80 00       	push   $0x8020fc
  8000a6:	e8 cb 07 00 00       	call   800876 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 30 21 80 00       	push   $0x802130
  8000b6:	e8 bb 07 00 00       	call   800876 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 8c 21 80 00       	push   $0x80218c
  8000c6:	e8 ab 07 00 00       	call   800876 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 1d 1a 00 00       	call   801af0 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 c0 21 80 00       	push   $0x8021c0
  8000de:	e8 93 07 00 00       	call   800876 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000eb:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f8:	8b 40 74             	mov    0x74(%eax),%eax
  8000fb:	6a 32                	push   $0x32
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 01 22 80 00       	push   $0x802201
  800104:	e8 92 19 00 00       	call   801a9b <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010f:	a1 20 30 80 00       	mov    0x803020,%eax
  800114:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	a1 20 30 80 00       	mov    0x803020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 01 22 80 00       	push   $0x802201
  80012d:	e8 69 19 00 00       	call   801a9b <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 ec 16 00 00       	call   801829 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 0f 22 80 00       	push   $0x80220f
  80014f:	e8 21 15 00 00       	call   801675 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 14 22 80 00       	push   $0x802214
  800162:	e8 0f 07 00 00       	call   800876 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 34 22 80 00       	push   $0x802234
  80017b:	6a 26                	push   $0x26
  80017d:	68 dc 20 80 00       	push   $0x8020dc
  800182:	e8 3b 04 00 00       	call   8005c2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 9a 16 00 00       	call   801829 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 a0 22 80 00       	push   $0x8022a0
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 dc 20 80 00       	push   $0x8020dc
  8001a7:	e8 16 04 00 00       	call   8005c2 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 36 1a 00 00       	call   801be7 <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 fd 18 00 00       	call   801ab9 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 ef 18 00 00       	call   801ab9 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 1e 23 80 00       	push   $0x80231e
  8001d5:	e8 9c 06 00 00       	call   800876 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 b1 1b 00 00       	call   801d9b <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 6f 1a 00 00       	call   801c61 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 35 23 80 00       	push   $0x802335
  8001ff:	6a 33                	push   $0x33
  800201:	68 dc 20 80 00       	push   $0x8020dc
  800206:	e8 b7 03 00 00       	call   8005c2 <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 b3 14 00 00       	call   8016c9 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 44 23 80 00       	push   $0x802344
  800221:	e8 50 06 00 00       	call   800876 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 fb 15 00 00       	call   801829 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 64 23 80 00       	push   $0x802364
  800248:	6a 38                	push   $0x38
  80024a:	68 dc 20 80 00       	push   $0x8020dc
  80024f:	e8 6e 03 00 00       	call   8005c2 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 94 23 80 00       	push   $0x802394
  80025c:	e8 15 06 00 00       	call   800876 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 b8 23 80 00       	push   $0x8023b8
  80026c:	e8 05 06 00 00       	call   800876 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800274:	a1 20 30 80 00       	mov    0x803020,%eax
  800279:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80027f:	89 c2                	mov    %eax,%edx
  800281:	a1 20 30 80 00       	mov    0x803020,%eax
  800286:	8b 40 74             	mov    0x74(%eax),%eax
  800289:	6a 32                	push   $0x32
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 e8 23 80 00       	push   $0x8023e8
  800292:	e8 04 18 00 00       	call   801a9b <sys_create_env>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  80029d:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a2:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8002af:	8b 40 74             	mov    0x74(%eax),%eax
  8002b2:	6a 32                	push   $0x32
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	68 f8 23 80 00       	push   $0x8023f8
  8002bb:	e8 db 17 00 00       	call   801a9b <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 08 24 80 00       	push   $0x802408
  8002d5:	e8 9b 13 00 00       	call   801675 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 0c 24 80 00       	push   $0x80240c
  8002e8:	e8 89 05 00 00       	call   800876 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 0f 22 80 00       	push   $0x80220f
  8002ff:	e8 71 13 00 00       	call   801675 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 14 22 80 00       	push   $0x802214
  800312:	e8 5f 05 00 00       	call   800876 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 c8 18 00 00       	call   801be7 <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 8f 17 00 00       	call   801ab9 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 81 17 00 00       	call   801ab9 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 53 1a 00 00       	call   801d9b <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 d9 14 00 00       	call   801829 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 6b 13 00 00       	call   8016c9 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 2c 24 80 00       	push   $0x80242c
  800369:	e8 08 05 00 00       	call   800876 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 4d 13 00 00       	call   8016c9 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 42 24 80 00       	push   $0x802442
  800387:	e8 ea 04 00 00       	call   800876 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 95 14 00 00       	call   801829 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 58 24 80 00       	push   $0x802458
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 dc 20 80 00       	push   $0x8020dc
  8003b5:	e8 08 02 00 00       	call   8005c2 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 88 18 00 00       	call   801c47 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 fd 24 80 00       	push   $0x8024fd
  8003cb:	e8 a5 12 00 00       	call   801675 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 3e 17 00 00       	call   801b22 <sys_getparentenvid>
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	0f 8e 81 00 00 00    	jle    80046d <_main+0x435>
			while(*finish_children != 1);
  8003ec:	90                   	nop
  8003ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	75 f6                	jne    8003ed <_main+0x3b5>
			cprintf("done\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 0d 25 80 00       	push   $0x80250d
  8003ff:	e8 72 04 00 00       	call   800876 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 c3 16 00 00       	call   801ad5 <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 b5 16 00 00       	call   801ad5 <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 a7 16 00 00       	call   801ad5 <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 99 16 00 00       	call   801ad5 <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 d7 16 00 00       	call   801b22 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 13 25 80 00       	push   $0x802513
  800453:	50                   	push   %eax
  800454:	e8 3c 12 00 00       	call   801695 <sget>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80045f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 01             	lea    0x1(%eax),%edx
  800467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80046c:	90                   	nop
  80046d:	90                   	nop
}
  80046e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 8b 16 00 00       	call   801b09 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	01 c0                	add    %eax,%eax
  800488:	01 d0                	add    %edx,%eax
  80048a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800491:	01 c8                	add    %ecx,%eax
  800493:	c1 e0 02             	shl    $0x2,%eax
  800496:	01 d0                	add    %edx,%eax
  800498:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80049f:	01 c8                	add    %ecx,%eax
  8004a1:	c1 e0 02             	shl    $0x2,%eax
  8004a4:	01 d0                	add    %edx,%eax
  8004a6:	c1 e0 02             	shl    $0x2,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	c1 e0 03             	shl    $0x3,%eax
  8004ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004b3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8004bd:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8004c3:	84 c0                	test   %al,%al
  8004c5:	74 0f                	je     8004d6 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8004c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004cc:	05 18 da 01 00       	add    $0x1da18,%eax
  8004d1:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004da:	7e 0a                	jle    8004e6 <libmain+0x73>
		binaryname = argv[0];
  8004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	ff 75 0c             	pushl  0xc(%ebp)
  8004ec:	ff 75 08             	pushl  0x8(%ebp)
  8004ef:	e8 44 fb ff ff       	call   800038 <_main>
  8004f4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004f7:	e8 1a 14 00 00       	call   801916 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004fc:	83 ec 0c             	sub    $0xc,%esp
  8004ff:	68 3c 25 80 00       	push   $0x80253c
  800504:	e8 6d 03 00 00       	call   800876 <cprintf>
  800509:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80050c:	a1 20 30 80 00       	mov    0x803020,%eax
  800511:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800517:	a1 20 30 80 00       	mov    0x803020,%eax
  80051c:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	52                   	push   %edx
  800526:	50                   	push   %eax
  800527:	68 64 25 80 00       	push   $0x802564
  80052c:	e8 45 03 00 00       	call   800876 <cprintf>
  800531:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800534:	a1 20 30 80 00       	mov    0x803020,%eax
  800539:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80053f:	a1 20 30 80 00       	mov    0x803020,%eax
  800544:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80054a:	a1 20 30 80 00       	mov    0x803020,%eax
  80054f:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800555:	51                   	push   %ecx
  800556:	52                   	push   %edx
  800557:	50                   	push   %eax
  800558:	68 8c 25 80 00       	push   $0x80258c
  80055d:	e8 14 03 00 00       	call   800876 <cprintf>
  800562:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800565:	a1 20 30 80 00       	mov    0x803020,%eax
  80056a:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	50                   	push   %eax
  800574:	68 e4 25 80 00       	push   $0x8025e4
  800579:	e8 f8 02 00 00       	call   800876 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	68 3c 25 80 00       	push   $0x80253c
  800589:	e8 e8 02 00 00       	call   800876 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800591:	e8 9a 13 00 00       	call   801930 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800596:	e8 19 00 00 00       	call   8005b4 <exit>
}
  80059b:	90                   	nop
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005a4:	83 ec 0c             	sub    $0xc,%esp
  8005a7:	6a 00                	push   $0x0
  8005a9:	e8 27 15 00 00       	call   801ad5 <sys_destroy_env>
  8005ae:	83 c4 10             	add    $0x10,%esp
}
  8005b1:	90                   	nop
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <exit>:

void
exit(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005ba:	e8 7c 15 00 00       	call   801b3b <sys_exit_env>
}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8005cb:	83 c0 04             	add    $0x4,%eax
  8005ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005d1:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	74 16                	je     8005f0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005da:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	50                   	push   %eax
  8005e3:	68 f8 25 80 00       	push   $0x8025f8
  8005e8:	e8 89 02 00 00       	call   800876 <cprintf>
  8005ed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005f0:	a1 00 30 80 00       	mov    0x803000,%eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	50                   	push   %eax
  8005fc:	68 fd 25 80 00       	push   $0x8025fd
  800601:	e8 70 02 00 00       	call   800876 <cprintf>
  800606:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800609:	8b 45 10             	mov    0x10(%ebp),%eax
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	ff 75 f4             	pushl  -0xc(%ebp)
  800612:	50                   	push   %eax
  800613:	e8 f3 01 00 00       	call   80080b <vcprintf>
  800618:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	6a 00                	push   $0x0
  800620:	68 19 26 80 00       	push   $0x802619
  800625:	e8 e1 01 00 00       	call   80080b <vcprintf>
  80062a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80062d:	e8 82 ff ff ff       	call   8005b4 <exit>

	// should not return here
	while (1) ;
  800632:	eb fe                	jmp    800632 <_panic+0x70>

00800634 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80063a:	a1 20 30 80 00       	mov    0x803020,%eax
  80063f:	8b 50 74             	mov    0x74(%eax),%edx
  800642:	8b 45 0c             	mov    0xc(%ebp),%eax
  800645:	39 c2                	cmp    %eax,%edx
  800647:	74 14                	je     80065d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 1c 26 80 00       	push   $0x80261c
  800651:	6a 26                	push   $0x26
  800653:	68 68 26 80 00       	push   $0x802668
  800658:	e8 65 ff ff ff       	call   8005c2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80065d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800664:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80066b:	e9 c2 00 00 00       	jmp    800732 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	85 c0                	test   %eax,%eax
  800683:	75 08                	jne    80068d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800685:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800688:	e9 a2 00 00 00       	jmp    80072f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80068d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800694:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80069b:	eb 69                	jmp    800706 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80069d:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8006a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006ab:	89 d0                	mov    %edx,%eax
  8006ad:	01 c0                	add    %eax,%eax
  8006af:	01 d0                	add    %edx,%eax
  8006b1:	c1 e0 03             	shl    $0x3,%eax
  8006b4:	01 c8                	add    %ecx,%eax
  8006b6:	8a 40 04             	mov    0x4(%eax),%al
  8006b9:	84 c0                	test   %al,%al
  8006bb:	75 46                	jne    800703 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8006c2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8006c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006cb:	89 d0                	mov    %edx,%eax
  8006cd:	01 c0                	add    %eax,%eax
  8006cf:	01 d0                	add    %edx,%eax
  8006d1:	c1 e0 03             	shl    $0x3,%eax
  8006d4:	01 c8                	add    %ecx,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006e3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	01 c8                	add    %ecx,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006f6:	39 c2                	cmp    %eax,%edx
  8006f8:	75 09                	jne    800703 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8006fa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800701:	eb 12                	jmp    800715 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800703:	ff 45 e8             	incl   -0x18(%ebp)
  800706:	a1 20 30 80 00       	mov    0x803020,%eax
  80070b:	8b 50 74             	mov    0x74(%eax),%edx
  80070e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800711:	39 c2                	cmp    %eax,%edx
  800713:	77 88                	ja     80069d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800715:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800719:	75 14                	jne    80072f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80071b:	83 ec 04             	sub    $0x4,%esp
  80071e:	68 74 26 80 00       	push   $0x802674
  800723:	6a 3a                	push   $0x3a
  800725:	68 68 26 80 00       	push   $0x802668
  80072a:	e8 93 fe ff ff       	call   8005c2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80072f:	ff 45 f0             	incl   -0x10(%ebp)
  800732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800735:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800738:	0f 8c 32 ff ff ff    	jl     800670 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80073e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800745:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80074c:	eb 26                	jmp    800774 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80074e:	a1 20 30 80 00       	mov    0x803020,%eax
  800753:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800759:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80075c:	89 d0                	mov    %edx,%eax
  80075e:	01 c0                	add    %eax,%eax
  800760:	01 d0                	add    %edx,%eax
  800762:	c1 e0 03             	shl    $0x3,%eax
  800765:	01 c8                	add    %ecx,%eax
  800767:	8a 40 04             	mov    0x4(%eax),%al
  80076a:	3c 01                	cmp    $0x1,%al
  80076c:	75 03                	jne    800771 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80076e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800771:	ff 45 e0             	incl   -0x20(%ebp)
  800774:	a1 20 30 80 00       	mov    0x803020,%eax
  800779:	8b 50 74             	mov    0x74(%eax),%edx
  80077c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80077f:	39 c2                	cmp    %eax,%edx
  800781:	77 cb                	ja     80074e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800786:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800789:	74 14                	je     80079f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80078b:	83 ec 04             	sub    $0x4,%esp
  80078e:	68 c8 26 80 00       	push   $0x8026c8
  800793:	6a 44                	push   $0x44
  800795:	68 68 26 80 00       	push   $0x802668
  80079a:	e8 23 fe ff ff       	call   8005c2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80079f:	90                   	nop
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8007a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8007b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b3:	89 0a                	mov    %ecx,(%edx)
  8007b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8007b8:	88 d1                	mov    %dl,%cl
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007cb:	75 2c                	jne    8007f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007cd:	a0 24 30 80 00       	mov    0x803024,%al
  8007d2:	0f b6 c0             	movzbl %al,%eax
  8007d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d8:	8b 12                	mov    (%edx),%edx
  8007da:	89 d1                	mov    %edx,%ecx
  8007dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007df:	83 c2 08             	add    $0x8,%edx
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	50                   	push   %eax
  8007e6:	51                   	push   %ecx
  8007e7:	52                   	push   %edx
  8007e8:	e8 7b 0f 00 00       	call   801768 <sys_cputs>
  8007ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fc:	8b 40 04             	mov    0x4(%eax),%eax
  8007ff:	8d 50 01             	lea    0x1(%eax),%edx
  800802:	8b 45 0c             	mov    0xc(%ebp),%eax
  800805:	89 50 04             	mov    %edx,0x4(%eax)
}
  800808:	90                   	nop
  800809:	c9                   	leave  
  80080a:	c3                   	ret    

0080080b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800814:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80081b:	00 00 00 
	b.cnt = 0;
  80081e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800825:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800834:	50                   	push   %eax
  800835:	68 a2 07 80 00       	push   $0x8007a2
  80083a:	e8 11 02 00 00       	call   800a50 <vprintfmt>
  80083f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800842:	a0 24 30 80 00       	mov    0x803024,%al
  800847:	0f b6 c0             	movzbl %al,%eax
  80084a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800850:	83 ec 04             	sub    $0x4,%esp
  800853:	50                   	push   %eax
  800854:	52                   	push   %edx
  800855:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80085b:	83 c0 08             	add    $0x8,%eax
  80085e:	50                   	push   %eax
  80085f:	e8 04 0f 00 00       	call   801768 <sys_cputs>
  800864:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800867:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80086e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800874:	c9                   	leave  
  800875:	c3                   	ret    

00800876 <cprintf>:

int cprintf(const char *fmt, ...) {
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80087c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800883:	8d 45 0c             	lea    0xc(%ebp),%eax
  800886:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 f4             	pushl  -0xc(%ebp)
  800892:	50                   	push   %eax
  800893:	e8 73 ff ff ff       	call   80080b <vcprintf>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80089e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008a1:	c9                   	leave  
  8008a2:	c3                   	ret    

008008a3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8008a9:	e8 68 10 00 00       	call   801916 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8008bd:	50                   	push   %eax
  8008be:	e8 48 ff ff ff       	call   80080b <vcprintf>
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008c9:	e8 62 10 00 00       	call   801930 <sys_enable_interrupt>
	return cnt;
  8008ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008d1:	c9                   	leave  
  8008d2:	c3                   	ret    

008008d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	53                   	push   %ebx
  8008d7:	83 ec 14             	sub    $0x14,%esp
  8008da:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008f1:	77 55                	ja     800948 <printnum+0x75>
  8008f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008f6:	72 05                	jb     8008fd <printnum+0x2a>
  8008f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008fb:	77 4b                	ja     800948 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800900:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800903:	8b 45 18             	mov    0x18(%ebp),%eax
  800906:	ba 00 00 00 00       	mov    $0x0,%edx
  80090b:	52                   	push   %edx
  80090c:	50                   	push   %eax
  80090d:	ff 75 f4             	pushl  -0xc(%ebp)
  800910:	ff 75 f0             	pushl  -0x10(%ebp)
  800913:	e8 38 15 00 00       	call   801e50 <__udivdi3>
  800918:	83 c4 10             	add    $0x10,%esp
  80091b:	83 ec 04             	sub    $0x4,%esp
  80091e:	ff 75 20             	pushl  0x20(%ebp)
  800921:	53                   	push   %ebx
  800922:	ff 75 18             	pushl  0x18(%ebp)
  800925:	52                   	push   %edx
  800926:	50                   	push   %eax
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	ff 75 08             	pushl  0x8(%ebp)
  80092d:	e8 a1 ff ff ff       	call   8008d3 <printnum>
  800932:	83 c4 20             	add    $0x20,%esp
  800935:	eb 1a                	jmp    800951 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	ff 75 20             	pushl  0x20(%ebp)
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800948:	ff 4d 1c             	decl   0x1c(%ebp)
  80094b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80094f:	7f e6                	jg     800937 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800951:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800954:	bb 00 00 00 00       	mov    $0x0,%ebx
  800959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095f:	53                   	push   %ebx
  800960:	51                   	push   %ecx
  800961:	52                   	push   %edx
  800962:	50                   	push   %eax
  800963:	e8 f8 15 00 00       	call   801f60 <__umoddi3>
  800968:	83 c4 10             	add    $0x10,%esp
  80096b:	05 34 29 80 00       	add    $0x802934,%eax
  800970:	8a 00                	mov    (%eax),%al
  800972:	0f be c0             	movsbl %al,%eax
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	50                   	push   %eax
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	ff d0                	call   *%eax
  800981:	83 c4 10             	add    $0x10,%esp
}
  800984:	90                   	nop
  800985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80098d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800991:	7e 1c                	jle    8009af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	8d 50 08             	lea    0x8(%eax),%edx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	89 10                	mov    %edx,(%eax)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	83 e8 08             	sub    $0x8,%eax
  8009a8:	8b 50 04             	mov    0x4(%eax),%edx
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	eb 40                	jmp    8009ef <getuint+0x65>
	else if (lflag)
  8009af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b3:	74 1e                	je     8009d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	8d 50 04             	lea    0x4(%eax),%edx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	89 10                	mov    %edx,(%eax)
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8b 00                	mov    (%eax),%eax
  8009c7:	83 e8 04             	sub    $0x4,%eax
  8009ca:	8b 00                	mov    (%eax),%eax
  8009cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d1:	eb 1c                	jmp    8009ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	8d 50 04             	lea    0x4(%eax),%edx
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	89 10                	mov    %edx,(%eax)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	83 e8 04             	sub    $0x4,%eax
  8009e8:	8b 00                	mov    (%eax),%eax
  8009ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009f8:	7e 1c                	jle    800a16 <getint+0x25>
		return va_arg(*ap, long long);
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	8d 50 08             	lea    0x8(%eax),%edx
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	89 10                	mov    %edx,(%eax)
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 00                	mov    (%eax),%eax
  800a0c:	83 e8 08             	sub    $0x8,%eax
  800a0f:	8b 50 04             	mov    0x4(%eax),%edx
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	eb 38                	jmp    800a4e <getint+0x5d>
	else if (lflag)
  800a16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1a:	74 1a                	je     800a36 <getint+0x45>
		return va_arg(*ap, long);
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	8d 50 04             	lea    0x4(%eax),%edx
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	89 10                	mov    %edx,(%eax)
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 00                	mov    (%eax),%eax
  800a2e:	83 e8 04             	sub    $0x4,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	99                   	cltd   
  800a34:	eb 18                	jmp    800a4e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8b 00                	mov    (%eax),%eax
  800a3b:	8d 50 04             	lea    0x4(%eax),%edx
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	89 10                	mov    %edx,(%eax)
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	8b 00                	mov    (%eax),%eax
  800a48:	83 e8 04             	sub    $0x4,%eax
  800a4b:	8b 00                	mov    (%eax),%eax
  800a4d:	99                   	cltd   
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a58:	eb 17                	jmp    800a71 <vprintfmt+0x21>
			if (ch == '\0')
  800a5a:	85 db                	test   %ebx,%ebx
  800a5c:	0f 84 af 03 00 00    	je     800e11 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	53                   	push   %ebx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	ff d0                	call   *%eax
  800a6e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	8d 50 01             	lea    0x1(%eax),%edx
  800a77:	89 55 10             	mov    %edx,0x10(%ebp)
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	0f b6 d8             	movzbl %al,%ebx
  800a7f:	83 fb 25             	cmp    $0x25,%ebx
  800a82:	75 d6                	jne    800a5a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a84:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a88:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a8f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a96:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a9d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa7:	8d 50 01             	lea    0x1(%eax),%edx
  800aaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800aad:	8a 00                	mov    (%eax),%al
  800aaf:	0f b6 d8             	movzbl %al,%ebx
  800ab2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ab5:	83 f8 55             	cmp    $0x55,%eax
  800ab8:	0f 87 2b 03 00 00    	ja     800de9 <vprintfmt+0x399>
  800abe:	8b 04 85 58 29 80 00 	mov    0x802958(,%eax,4),%eax
  800ac5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ac7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800acb:	eb d7                	jmp    800aa4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800acd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ad1:	eb d1                	jmp    800aa4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ad3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ada:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800add:	89 d0                	mov    %edx,%eax
  800adf:	c1 e0 02             	shl    $0x2,%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d8                	add    %ebx,%eax
  800ae8:	83 e8 30             	sub    $0x30,%eax
  800aeb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800aee:	8b 45 10             	mov    0x10(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800af6:	83 fb 2f             	cmp    $0x2f,%ebx
  800af9:	7e 3e                	jle    800b39 <vprintfmt+0xe9>
  800afb:	83 fb 39             	cmp    $0x39,%ebx
  800afe:	7f 39                	jg     800b39 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b00:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b03:	eb d5                	jmp    800ada <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b05:	8b 45 14             	mov    0x14(%ebp),%eax
  800b08:	83 c0 04             	add    $0x4,%eax
  800b0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	83 e8 04             	sub    $0x4,%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b19:	eb 1f                	jmp    800b3a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1f:	79 83                	jns    800aa4 <vprintfmt+0x54>
				width = 0;
  800b21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b28:	e9 77 ff ff ff       	jmp    800aa4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b2d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b34:	e9 6b ff ff ff       	jmp    800aa4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b39:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3e:	0f 89 60 ff ff ff    	jns    800aa4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b4a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b51:	e9 4e ff ff ff       	jmp    800aa4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b56:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b59:	e9 46 ff ff ff       	jmp    800aa4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b61:	83 c0 04             	add    $0x4,%eax
  800b64:	89 45 14             	mov    %eax,0x14(%ebp)
  800b67:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6a:	83 e8 04             	sub    $0x4,%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
			break;
  800b7e:	e9 89 02 00 00       	jmp    800e0c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b83:	8b 45 14             	mov    0x14(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8f:	83 e8 04             	sub    $0x4,%eax
  800b92:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b94:	85 db                	test   %ebx,%ebx
  800b96:	79 02                	jns    800b9a <vprintfmt+0x14a>
				err = -err;
  800b98:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b9a:	83 fb 64             	cmp    $0x64,%ebx
  800b9d:	7f 0b                	jg     800baa <vprintfmt+0x15a>
  800b9f:	8b 34 9d a0 27 80 00 	mov    0x8027a0(,%ebx,4),%esi
  800ba6:	85 f6                	test   %esi,%esi
  800ba8:	75 19                	jne    800bc3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800baa:	53                   	push   %ebx
  800bab:	68 45 29 80 00       	push   $0x802945
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 5e 02 00 00       	call   800e19 <printfmt>
  800bbb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bbe:	e9 49 02 00 00       	jmp    800e0c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bc3:	56                   	push   %esi
  800bc4:	68 4e 29 80 00       	push   $0x80294e
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	ff 75 08             	pushl  0x8(%ebp)
  800bcf:	e8 45 02 00 00       	call   800e19 <printfmt>
  800bd4:	83 c4 10             	add    $0x10,%esp
			break;
  800bd7:	e9 30 02 00 00       	jmp    800e0c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdf:	83 c0 04             	add    $0x4,%eax
  800be2:	89 45 14             	mov    %eax,0x14(%ebp)
  800be5:	8b 45 14             	mov    0x14(%ebp),%eax
  800be8:	83 e8 04             	sub    $0x4,%eax
  800beb:	8b 30                	mov    (%eax),%esi
  800bed:	85 f6                	test   %esi,%esi
  800bef:	75 05                	jne    800bf6 <vprintfmt+0x1a6>
				p = "(null)";
  800bf1:	be 51 29 80 00       	mov    $0x802951,%esi
			if (width > 0 && padc != '-')
  800bf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bfa:	7e 6d                	jle    800c69 <vprintfmt+0x219>
  800bfc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c00:	74 67                	je     800c69 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	50                   	push   %eax
  800c09:	56                   	push   %esi
  800c0a:	e8 0c 03 00 00       	call   800f1b <strnlen>
  800c0f:	83 c4 10             	add    $0x10,%esp
  800c12:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c15:	eb 16                	jmp    800c2d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c17:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	50                   	push   %eax
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c2a:	ff 4d e4             	decl   -0x1c(%ebp)
  800c2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c31:	7f e4                	jg     800c17 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c33:	eb 34                	jmp    800c69 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c35:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c39:	74 1c                	je     800c57 <vprintfmt+0x207>
  800c3b:	83 fb 1f             	cmp    $0x1f,%ebx
  800c3e:	7e 05                	jle    800c45 <vprintfmt+0x1f5>
  800c40:	83 fb 7e             	cmp    $0x7e,%ebx
  800c43:	7e 12                	jle    800c57 <vprintfmt+0x207>
					putch('?', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 3f                	push   $0x3f
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	eb 0f                	jmp    800c66 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	53                   	push   %ebx
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	ff d0                	call   *%eax
  800c63:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c66:	ff 4d e4             	decl   -0x1c(%ebp)
  800c69:	89 f0                	mov    %esi,%eax
  800c6b:	8d 70 01             	lea    0x1(%eax),%esi
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	0f be d8             	movsbl %al,%ebx
  800c73:	85 db                	test   %ebx,%ebx
  800c75:	74 24                	je     800c9b <vprintfmt+0x24b>
  800c77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c7b:	78 b8                	js     800c35 <vprintfmt+0x1e5>
  800c7d:	ff 4d e0             	decl   -0x20(%ebp)
  800c80:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c84:	79 af                	jns    800c35 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c86:	eb 13                	jmp    800c9b <vprintfmt+0x24b>
				putch(' ', putdat);
  800c88:	83 ec 08             	sub    $0x8,%esp
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	6a 20                	push   $0x20
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	ff d0                	call   *%eax
  800c95:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c98:	ff 4d e4             	decl   -0x1c(%ebp)
  800c9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9f:	7f e7                	jg     800c88 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ca1:	e9 66 01 00 00       	jmp    800e0c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 e8             	pushl  -0x18(%ebp)
  800cac:	8d 45 14             	lea    0x14(%ebp),%eax
  800caf:	50                   	push   %eax
  800cb0:	e8 3c fd ff ff       	call   8009f1 <getint>
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc4:	85 d2                	test   %edx,%edx
  800cc6:	79 23                	jns    800ceb <vprintfmt+0x29b>
				putch('-', putdat);
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	6a 2d                	push   $0x2d
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	ff d0                	call   *%eax
  800cd5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cde:	f7 d8                	neg    %eax
  800ce0:	83 d2 00             	adc    $0x0,%edx
  800ce3:	f7 da                	neg    %edx
  800ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ceb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cf2:	e9 bc 00 00 00       	jmp    800db3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cf7:	83 ec 08             	sub    $0x8,%esp
  800cfa:	ff 75 e8             	pushl  -0x18(%ebp)
  800cfd:	8d 45 14             	lea    0x14(%ebp),%eax
  800d00:	50                   	push   %eax
  800d01:	e8 84 fc ff ff       	call   80098a <getuint>
  800d06:	83 c4 10             	add    $0x10,%esp
  800d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d16:	e9 98 00 00 00       	jmp    800db3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d1b:	83 ec 08             	sub    $0x8,%esp
  800d1e:	ff 75 0c             	pushl  0xc(%ebp)
  800d21:	6a 58                	push   $0x58
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	ff d0                	call   *%eax
  800d28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d2b:	83 ec 08             	sub    $0x8,%esp
  800d2e:	ff 75 0c             	pushl  0xc(%ebp)
  800d31:	6a 58                	push   $0x58
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	ff d0                	call   *%eax
  800d38:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	6a 58                	push   $0x58
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	ff d0                	call   *%eax
  800d48:	83 c4 10             	add    $0x10,%esp
			break;
  800d4b:	e9 bc 00 00 00       	jmp    800e0c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d50:	83 ec 08             	sub    $0x8,%esp
  800d53:	ff 75 0c             	pushl  0xc(%ebp)
  800d56:	6a 30                	push   $0x30
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	ff d0                	call   *%eax
  800d5d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	6a 78                	push   $0x78
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	ff d0                	call   *%eax
  800d6d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d70:	8b 45 14             	mov    0x14(%ebp),%eax
  800d73:	83 c0 04             	add    $0x4,%eax
  800d76:	89 45 14             	mov    %eax,0x14(%ebp)
  800d79:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7c:	83 e8 04             	sub    $0x4,%eax
  800d7f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d92:	eb 1f                	jmp    800db3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d94:	83 ec 08             	sub    $0x8,%esp
  800d97:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9a:	8d 45 14             	lea    0x14(%ebp),%eax
  800d9d:	50                   	push   %eax
  800d9e:	e8 e7 fb ff ff       	call   80098a <getuint>
  800da3:	83 c4 10             	add    $0x10,%esp
  800da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800dac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800db3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dba:	83 ec 04             	sub    $0x4,%esp
  800dbd:	52                   	push   %edx
  800dbe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dc1:	50                   	push   %eax
  800dc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc5:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	ff 75 08             	pushl  0x8(%ebp)
  800dce:	e8 00 fb ff ff       	call   8008d3 <printnum>
  800dd3:	83 c4 20             	add    $0x20,%esp
			break;
  800dd6:	eb 34                	jmp    800e0c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dd8:	83 ec 08             	sub    $0x8,%esp
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	53                   	push   %ebx
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	ff d0                	call   *%eax
  800de4:	83 c4 10             	add    $0x10,%esp
			break;
  800de7:	eb 23                	jmp    800e0c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800de9:	83 ec 08             	sub    $0x8,%esp
  800dec:	ff 75 0c             	pushl  0xc(%ebp)
  800def:	6a 25                	push   $0x25
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	ff d0                	call   *%eax
  800df6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800df9:	ff 4d 10             	decl   0x10(%ebp)
  800dfc:	eb 03                	jmp    800e01 <vprintfmt+0x3b1>
  800dfe:	ff 4d 10             	decl   0x10(%ebp)
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	48                   	dec    %eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	3c 25                	cmp    $0x25,%al
  800e09:	75 f3                	jne    800dfe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800e0b:	90                   	nop
		}
	}
  800e0c:	e9 47 fc ff ff       	jmp    800a58 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e11:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e1f:	8d 45 10             	lea    0x10(%ebp),%eax
  800e22:	83 c0 04             	add    $0x4,%eax
  800e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2e:	50                   	push   %eax
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	ff 75 08             	pushl  0x8(%ebp)
  800e35:	e8 16 fc ff ff       	call   800a50 <vprintfmt>
  800e3a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e3d:	90                   	nop
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 40 08             	mov    0x8(%eax),%eax
  800e49:	8d 50 01             	lea    0x1(%eax),%edx
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e55:	8b 10                	mov    (%eax),%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8b 40 04             	mov    0x4(%eax),%eax
  800e5d:	39 c2                	cmp    %eax,%edx
  800e5f:	73 12                	jae    800e73 <sprintputch+0x33>
		*b->buf++ = ch;
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8b 00                	mov    (%eax),%eax
  800e66:	8d 48 01             	lea    0x1(%eax),%ecx
  800e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6c:	89 0a                	mov    %ecx,(%edx)
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	88 10                	mov    %dl,(%eax)
}
  800e73:	90                   	nop
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	01 d0                	add    %edx,%eax
  800e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e9b:	74 06                	je     800ea3 <vsnprintf+0x2d>
  800e9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea1:	7f 07                	jg     800eaa <vsnprintf+0x34>
		return -E_INVAL;
  800ea3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ea8:	eb 20                	jmp    800eca <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800eaa:	ff 75 14             	pushl  0x14(%ebp)
  800ead:	ff 75 10             	pushl  0x10(%ebp)
  800eb0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800eb3:	50                   	push   %eax
  800eb4:	68 40 0e 80 00       	push   $0x800e40
  800eb9:	e8 92 fb ff ff       	call   800a50 <vprintfmt>
  800ebe:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ed2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ed5:	83 c0 04             	add    $0x4,%eax
  800ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800edb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ede:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee1:	50                   	push   %eax
  800ee2:	ff 75 0c             	pushl  0xc(%ebp)
  800ee5:	ff 75 08             	pushl  0x8(%ebp)
  800ee8:	e8 89 ff ff ff       	call   800e76 <vsnprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
  800ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800efe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f05:	eb 06                	jmp    800f0d <strlen+0x15>
		n++;
  800f07:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f0a:	ff 45 08             	incl   0x8(%ebp)
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	84 c0                	test   %al,%al
  800f14:	75 f1                	jne    800f07 <strlen+0xf>
		n++;
	return n;
  800f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f28:	eb 09                	jmp    800f33 <strnlen+0x18>
		n++;
  800f2a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f2d:	ff 45 08             	incl   0x8(%ebp)
  800f30:	ff 4d 0c             	decl   0xc(%ebp)
  800f33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f37:	74 09                	je     800f42 <strnlen+0x27>
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	84 c0                	test   %al,%al
  800f40:	75 e8                	jne    800f2a <strnlen+0xf>
		n++;
	return n;
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f53:	90                   	nop
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8d 50 01             	lea    0x1(%eax),%edx
  800f5a:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f63:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f66:	8a 12                	mov    (%edx),%dl
  800f68:	88 10                	mov    %dl,(%eax)
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	84 c0                	test   %al,%al
  800f6e:	75 e4                	jne    800f54 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f73:	c9                   	leave  
  800f74:	c3                   	ret    

00800f75 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f88:	eb 1f                	jmp    800fa9 <strncpy+0x34>
		*dst++ = *src;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8d 50 01             	lea    0x1(%eax),%edx
  800f90:	89 55 08             	mov    %edx,0x8(%ebp)
  800f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f96:	8a 12                	mov    (%edx),%dl
  800f98:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	84 c0                	test   %al,%al
  800fa1:	74 03                	je     800fa6 <strncpy+0x31>
			src++;
  800fa3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fa6:	ff 45 fc             	incl   -0x4(%ebp)
  800fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fac:	3b 45 10             	cmp    0x10(%ebp),%eax
  800faf:	72 d9                	jb     800f8a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc6:	74 30                	je     800ff8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fc8:	eb 16                	jmp    800fe0 <strlcpy+0x2a>
			*dst++ = *src++;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8d 50 01             	lea    0x1(%eax),%edx
  800fd0:	89 55 08             	mov    %edx,0x8(%ebp)
  800fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fdc:	8a 12                	mov    (%edx),%dl
  800fde:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fe0:	ff 4d 10             	decl   0x10(%ebp)
  800fe3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe7:	74 09                	je     800ff2 <strlcpy+0x3c>
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 d8                	jne    800fca <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ff8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffe:	29 c2                	sub    %eax,%edx
  801000:	89 d0                	mov    %edx,%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801007:	eb 06                	jmp    80100f <strcmp+0xb>
		p++, q++;
  801009:	ff 45 08             	incl   0x8(%ebp)
  80100c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	84 c0                	test   %al,%al
  801016:	74 0e                	je     801026 <strcmp+0x22>
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8a 10                	mov    (%eax),%dl
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	38 c2                	cmp    %al,%dl
  801024:	74 e3                	je     801009 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	0f b6 d0             	movzbl %al,%edx
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	0f b6 c0             	movzbl %al,%eax
  801036:	29 c2                	sub    %eax,%edx
  801038:	89 d0                	mov    %edx,%eax
}
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80103f:	eb 09                	jmp    80104a <strncmp+0xe>
		n--, p++, q++;
  801041:	ff 4d 10             	decl   0x10(%ebp)
  801044:	ff 45 08             	incl   0x8(%ebp)
  801047:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80104a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104e:	74 17                	je     801067 <strncmp+0x2b>
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	84 c0                	test   %al,%al
  801057:	74 0e                	je     801067 <strncmp+0x2b>
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 10                	mov    (%eax),%dl
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	38 c2                	cmp    %al,%dl
  801065:	74 da                	je     801041 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801067:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106b:	75 07                	jne    801074 <strncmp+0x38>
		return 0;
  80106d:	b8 00 00 00 00       	mov    $0x0,%eax
  801072:	eb 14                	jmp    801088 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f b6 d0             	movzbl %al,%edx
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	0f b6 c0             	movzbl %al,%eax
  801084:	29 c2                	sub    %eax,%edx
  801086:	89 d0                	mov    %edx,%eax
}
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    

0080108a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 04             	sub    $0x4,%esp
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801096:	eb 12                	jmp    8010aa <strchr+0x20>
		if (*s == c)
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010a0:	75 05                	jne    8010a7 <strchr+0x1d>
			return (char *) s;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	eb 11                	jmp    8010b8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	84 c0                	test   %al,%al
  8010b1:	75 e5                	jne    801098 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010c6:	eb 0d                	jmp    8010d5 <strfind+0x1b>
		if (*s == c)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010d0:	74 0e                	je     8010e0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	84 c0                	test   %al,%al
  8010dc:	75 ea                	jne    8010c8 <strfind+0xe>
  8010de:	eb 01                	jmp    8010e1 <strfind+0x27>
		if (*s == c)
			break;
  8010e0:	90                   	nop
	return (char *) s;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010f8:	eb 0e                	jmp    801108 <memset+0x22>
		*p++ = c;
  8010fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fd:	8d 50 01             	lea    0x1(%eax),%edx
  801100:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801103:	8b 55 0c             	mov    0xc(%ebp),%edx
  801106:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801108:	ff 4d f8             	decl   -0x8(%ebp)
  80110b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80110f:	79 e9                	jns    8010fa <memset+0x14>
		*p++ = c;

	return v;
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801128:	eb 16                	jmp    801140 <memcpy+0x2a>
		*d++ = *s++;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	8d 50 01             	lea    0x1(%eax),%edx
  801130:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801133:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801136:	8d 4a 01             	lea    0x1(%edx),%ecx
  801139:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80113c:	8a 12                	mov    (%edx),%dl
  80113e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	8d 50 ff             	lea    -0x1(%eax),%edx
  801146:	89 55 10             	mov    %edx,0x10(%ebp)
  801149:	85 c0                	test   %eax,%eax
  80114b:	75 dd                	jne    80112a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801164:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801167:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80116a:	73 50                	jae    8011bc <memmove+0x6a>
  80116c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	01 d0                	add    %edx,%eax
  801174:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801177:	76 43                	jbe    8011bc <memmove+0x6a>
		s += n;
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801185:	eb 10                	jmp    801197 <memmove+0x45>
			*--d = *--s;
  801187:	ff 4d f8             	decl   -0x8(%ebp)
  80118a:	ff 4d fc             	decl   -0x4(%ebp)
  80118d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801190:	8a 10                	mov    (%eax),%dl
  801192:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801195:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	75 e3                	jne    801187 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011a4:	eb 23                	jmp    8011c9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011b8:	8a 12                	mov    (%edx),%dl
  8011ba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	75 dd                	jne    8011a6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011e0:	eb 2a                	jmp    80120c <memcmp+0x3e>
		if (*s1 != *s2)
  8011e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e5:	8a 10                	mov    (%eax),%dl
  8011e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	38 c2                	cmp    %al,%dl
  8011ee:	74 16                	je     801206 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	0f b6 d0             	movzbl %al,%edx
  8011f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	0f b6 c0             	movzbl %al,%eax
  801200:	29 c2                	sub    %eax,%edx
  801202:	89 d0                	mov    %edx,%eax
  801204:	eb 18                	jmp    80121e <memcmp+0x50>
		s1++, s2++;
  801206:	ff 45 fc             	incl   -0x4(%ebp)
  801209:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801212:	89 55 10             	mov    %edx,0x10(%ebp)
  801215:	85 c0                	test   %eax,%eax
  801217:	75 c9                	jne    8011e2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801219:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 d0                	add    %edx,%eax
  80122e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801231:	eb 15                	jmp    801248 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f b6 d0             	movzbl %al,%edx
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	0f b6 c0             	movzbl %al,%eax
  801241:	39 c2                	cmp    %eax,%edx
  801243:	74 0d                	je     801252 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801245:	ff 45 08             	incl   0x8(%ebp)
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80124e:	72 e3                	jb     801233 <memfind+0x13>
  801250:	eb 01                	jmp    801253 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801252:	90                   	nop
	return (void *) s;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80125e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801265:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80126c:	eb 03                	jmp    801271 <strtol+0x19>
		s++;
  80126e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3c 20                	cmp    $0x20,%al
  801278:	74 f4                	je     80126e <strtol+0x16>
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	3c 09                	cmp    $0x9,%al
  801281:	74 eb                	je     80126e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	3c 2b                	cmp    $0x2b,%al
  80128a:	75 05                	jne    801291 <strtol+0x39>
		s++;
  80128c:	ff 45 08             	incl   0x8(%ebp)
  80128f:	eb 13                	jmp    8012a4 <strtol+0x4c>
	else if (*s == '-')
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	3c 2d                	cmp    $0x2d,%al
  801298:	75 0a                	jne    8012a4 <strtol+0x4c>
		s++, neg = 1;
  80129a:	ff 45 08             	incl   0x8(%ebp)
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a8:	74 06                	je     8012b0 <strtol+0x58>
  8012aa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012ae:	75 20                	jne    8012d0 <strtol+0x78>
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	3c 30                	cmp    $0x30,%al
  8012b7:	75 17                	jne    8012d0 <strtol+0x78>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	40                   	inc    %eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	3c 78                	cmp    $0x78,%al
  8012c1:	75 0d                	jne    8012d0 <strtol+0x78>
		s += 2, base = 16;
  8012c3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012c7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ce:	eb 28                	jmp    8012f8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d4:	75 15                	jne    8012eb <strtol+0x93>
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	3c 30                	cmp    $0x30,%al
  8012dd:	75 0c                	jne    8012eb <strtol+0x93>
		s++, base = 8;
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012e9:	eb 0d                	jmp    8012f8 <strtol+0xa0>
	else if (base == 0)
  8012eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ef:	75 07                	jne    8012f8 <strtol+0xa0>
		base = 10;
  8012f1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	3c 2f                	cmp    $0x2f,%al
  8012ff:	7e 19                	jle    80131a <strtol+0xc2>
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 39                	cmp    $0x39,%al
  801308:	7f 10                	jg     80131a <strtol+0xc2>
			dig = *s - '0';
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	0f be c0             	movsbl %al,%eax
  801312:	83 e8 30             	sub    $0x30,%eax
  801315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801318:	eb 42                	jmp    80135c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	3c 60                	cmp    $0x60,%al
  801321:	7e 19                	jle    80133c <strtol+0xe4>
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 7a                	cmp    $0x7a,%al
  80132a:	7f 10                	jg     80133c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	0f be c0             	movsbl %al,%eax
  801334:	83 e8 57             	sub    $0x57,%eax
  801337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80133a:	eb 20                	jmp    80135c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	3c 40                	cmp    $0x40,%al
  801343:	7e 39                	jle    80137e <strtol+0x126>
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	3c 5a                	cmp    $0x5a,%al
  80134c:	7f 30                	jg     80137e <strtol+0x126>
			dig = *s - 'A' + 10;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	0f be c0             	movsbl %al,%eax
  801356:	83 e8 37             	sub    $0x37,%eax
  801359:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80135c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801362:	7d 19                	jge    80137d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80136e:	89 c2                	mov    %eax,%edx
  801370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801378:	e9 7b ff ff ff       	jmp    8012f8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80137d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80137e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801382:	74 08                	je     80138c <strtol+0x134>
		*endptr = (char *) s;
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	8b 55 08             	mov    0x8(%ebp),%edx
  80138a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80138c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801390:	74 07                	je     801399 <strtol+0x141>
  801392:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801395:	f7 d8                	neg    %eax
  801397:	eb 03                	jmp    80139c <strtol+0x144>
  801399:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <ltostr>:

void
ltostr(long value, char *str)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b6:	79 13                	jns    8013cb <ltostr+0x2d>
	{
		neg = 1;
  8013b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013c5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013c8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013d3:	99                   	cltd   
  8013d4:	f7 f9                	idiv   %ecx
  8013d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013dc:	8d 50 01             	lea    0x1(%eax),%edx
  8013df:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013e2:	89 c2                	mov    %eax,%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ec:	83 c2 30             	add    $0x30,%edx
  8013ef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f9:	f7 e9                	imul   %ecx
  8013fb:	c1 fa 02             	sar    $0x2,%edx
  8013fe:	89 c8                	mov    %ecx,%eax
  801400:	c1 f8 1f             	sar    $0x1f,%eax
  801403:	29 c2                	sub    %eax,%edx
  801405:	89 d0                	mov    %edx,%eax
  801407:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80140a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801412:	f7 e9                	imul   %ecx
  801414:	c1 fa 02             	sar    $0x2,%edx
  801417:	89 c8                	mov    %ecx,%eax
  801419:	c1 f8 1f             	sar    $0x1f,%eax
  80141c:	29 c2                	sub    %eax,%edx
  80141e:	89 d0                	mov    %edx,%eax
  801420:	c1 e0 02             	shl    $0x2,%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	01 c0                	add    %eax,%eax
  801427:	29 c1                	sub    %eax,%ecx
  801429:	89 ca                	mov    %ecx,%edx
  80142b:	85 d2                	test   %edx,%edx
  80142d:	75 9c                	jne    8013cb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80142f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801436:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801439:	48                   	dec    %eax
  80143a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80143d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801441:	74 3d                	je     801480 <ltostr+0xe2>
		start = 1 ;
  801443:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80144a:	eb 34                	jmp    801480 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80144c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801459:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	01 c2                	add    %eax,%edx
  801461:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	01 c8                	add    %ecx,%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80146d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 c2                	add    %eax,%edx
  801475:	8a 45 eb             	mov    -0x15(%ebp),%al
  801478:	88 02                	mov    %al,(%edx)
		start++ ;
  80147a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80147d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801486:	7c c4                	jl     80144c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801488:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80149c:	ff 75 08             	pushl  0x8(%ebp)
  80149f:	e8 54 fa ff ff       	call   800ef8 <strlen>
  8014a4:	83 c4 04             	add    $0x4,%esp
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014aa:	ff 75 0c             	pushl  0xc(%ebp)
  8014ad:	e8 46 fa ff ff       	call   800ef8 <strlen>
  8014b2:	83 c4 04             	add    $0x4,%esp
  8014b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c6:	eb 17                	jmp    8014df <strcconcat+0x49>
		final[s] = str1[s] ;
  8014c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ce:	01 c2                	add    %eax,%edx
  8014d0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	01 c8                	add    %ecx,%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014dc:	ff 45 fc             	incl   -0x4(%ebp)
  8014df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014e5:	7c e1                	jl     8014c8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014f5:	eb 1f                	jmp    801516 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8d 50 01             	lea    0x1(%eax),%edx
  8014fd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801500:	89 c2                	mov    %eax,%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 c2                	add    %eax,%edx
  801507:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	01 c8                	add    %ecx,%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801513:	ff 45 f8             	incl   -0x8(%ebp)
  801516:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801519:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80151c:	7c d9                	jl     8014f7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80151e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801521:	8b 45 10             	mov    0x10(%ebp),%eax
  801524:	01 d0                	add    %edx,%eax
  801526:	c6 00 00             	movb   $0x0,(%eax)
}
  801529:	90                   	nop
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80152f:	8b 45 14             	mov    0x14(%ebp),%eax
  801532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801538:	8b 45 14             	mov    0x14(%ebp),%eax
  80153b:	8b 00                	mov    (%eax),%eax
  80153d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154f:	eb 0c                	jmp    80155d <strsplit+0x31>
			*string++ = 0;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	8d 50 01             	lea    0x1(%eax),%edx
  801557:	89 55 08             	mov    %edx,0x8(%ebp)
  80155a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	84 c0                	test   %al,%al
  801564:	74 18                	je     80157e <strsplit+0x52>
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	0f be c0             	movsbl %al,%eax
  80156e:	50                   	push   %eax
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	e8 13 fb ff ff       	call   80108a <strchr>
  801577:	83 c4 08             	add    $0x8,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	75 d3                	jne    801551 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	84 c0                	test   %al,%al
  801585:	74 5a                	je     8015e1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801587:	8b 45 14             	mov    0x14(%ebp),%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	83 f8 0f             	cmp    $0xf,%eax
  80158f:	75 07                	jne    801598 <strsplit+0x6c>
		{
			return 0;
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
  801596:	eb 66                	jmp    8015fe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801598:	8b 45 14             	mov    0x14(%ebp),%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	8d 48 01             	lea    0x1(%eax),%ecx
  8015a0:	8b 55 14             	mov    0x14(%ebp),%edx
  8015a3:	89 0a                	mov    %ecx,(%edx)
  8015a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8015af:	01 c2                	add    %eax,%edx
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b6:	eb 03                	jmp    8015bb <strsplit+0x8f>
			string++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	74 8b                	je     80154f <strsplit+0x23>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	0f be c0             	movsbl %al,%eax
  8015cc:	50                   	push   %eax
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	e8 b5 fa ff ff       	call   80108a <strchr>
  8015d5:	83 c4 08             	add    $0x8,%esp
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	74 dc                	je     8015b8 <strsplit+0x8c>
			string++;
	}
  8015dc:	e9 6e ff ff ff       	jmp    80154f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015e1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015f9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	68 b0 2a 80 00       	push   $0x802ab0
  80160e:	6a 0e                	push   $0xe
  801610:	68 ea 2a 80 00       	push   $0x802aea
  801615:	e8 a8 ef ff ff       	call   8005c2 <_panic>

0080161a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801620:	a1 04 30 80 00       	mov    0x803004,%eax
  801625:	85 c0                	test   %eax,%eax
  801627:	74 0f                	je     801638 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801629:	e8 d2 ff ff ff       	call   801600 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80162e:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801635:	00 00 00 
	}
	if (size == 0) return NULL ;
  801638:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80163c:	75 07                	jne    801645 <malloc+0x2b>
  80163e:	b8 00 00 00 00       	mov    $0x0,%eax
  801643:	eb 14                	jmp    801659 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	68 f8 2a 80 00       	push   $0x802af8
  80164d:	6a 2e                	push   $0x2e
  80164f:	68 ea 2a 80 00       	push   $0x802aea
  801654:	e8 69 ef ff ff       	call   8005c2 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	68 20 2b 80 00       	push   $0x802b20
  801669:	6a 49                	push   $0x49
  80166b:	68 ea 2a 80 00       	push   $0x802aea
  801670:	e8 4d ef ff ff       	call   8005c2 <_panic>

00801675 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 18             	sub    $0x18,%esp
  80167b:	8b 45 10             	mov    0x10(%ebp),%eax
  80167e:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801681:	83 ec 04             	sub    $0x4,%esp
  801684:	68 44 2b 80 00       	push   $0x802b44
  801689:	6a 57                	push   $0x57
  80168b:	68 ea 2a 80 00       	push   $0x802aea
  801690:	e8 2d ef ff ff       	call   8005c2 <_panic>

00801695 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	68 6c 2b 80 00       	push   $0x802b6c
  8016a3:	6a 60                	push   $0x60
  8016a5:	68 ea 2a 80 00       	push   $0x802aea
  8016aa:	e8 13 ef ff ff       	call   8005c2 <_panic>

008016af <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 90 2b 80 00       	push   $0x802b90
  8016bd:	6a 7c                	push   $0x7c
  8016bf:	68 ea 2a 80 00       	push   $0x802aea
  8016c4:	e8 f9 ee ff ff       	call   8005c2 <_panic>

008016c9 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016cf:	83 ec 04             	sub    $0x4,%esp
  8016d2:	68 b8 2b 80 00       	push   $0x802bb8
  8016d7:	68 86 00 00 00       	push   $0x86
  8016dc:	68 ea 2a 80 00       	push   $0x802aea
  8016e1:	e8 dc ee ff ff       	call   8005c2 <_panic>

008016e6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	68 dc 2b 80 00       	push   $0x802bdc
  8016f4:	68 91 00 00 00       	push   $0x91
  8016f9:	68 ea 2a 80 00       	push   $0x802aea
  8016fe:	e8 bf ee ff ff       	call   8005c2 <_panic>

00801703 <shrink>:

}
void shrink(uint32 newSize)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801709:	83 ec 04             	sub    $0x4,%esp
  80170c:	68 dc 2b 80 00       	push   $0x802bdc
  801711:	68 96 00 00 00       	push   $0x96
  801716:	68 ea 2a 80 00       	push   $0x802aea
  80171b:	e8 a2 ee ff ff       	call   8005c2 <_panic>

00801720 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	68 dc 2b 80 00       	push   $0x802bdc
  80172e:	68 9b 00 00 00       	push   $0x9b
  801733:	68 ea 2a 80 00       	push   $0x802aea
  801738:	e8 85 ee ff ff       	call   8005c2 <_panic>

0080173d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	57                   	push   %edi
  801741:	56                   	push   %esi
  801742:	53                   	push   %ebx
  801743:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801752:	8b 7d 18             	mov    0x18(%ebp),%edi
  801755:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801758:	cd 30                	int    $0x30
  80175a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5f                   	pop    %edi
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    

00801768 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	8b 45 10             	mov    0x10(%ebp),%eax
  801771:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801774:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	52                   	push   %edx
  801780:	ff 75 0c             	pushl  0xc(%ebp)
  801783:	50                   	push   %eax
  801784:	6a 00                	push   $0x0
  801786:	e8 b2 ff ff ff       	call   80173d <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	90                   	nop
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_cgetc>:

int
sys_cgetc(void)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 01                	push   $0x1
  8017a0:	e8 98 ff ff ff       	call   80173d <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	52                   	push   %edx
  8017ba:	50                   	push   %eax
  8017bb:	6a 05                	push   $0x5
  8017bd:	e8 7b ff ff ff       	call   80173d <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	56                   	push   %esi
  8017cb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017cc:	8b 75 18             	mov    0x18(%ebp),%esi
  8017cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	56                   	push   %esi
  8017dc:	53                   	push   %ebx
  8017dd:	51                   	push   %ecx
  8017de:	52                   	push   %edx
  8017df:	50                   	push   %eax
  8017e0:	6a 06                	push   $0x6
  8017e2:	e8 56 ff ff ff       	call   80173d <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5e                   	pop    %esi
  8017ef:	5d                   	pop    %ebp
  8017f0:	c3                   	ret    

008017f1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	52                   	push   %edx
  801801:	50                   	push   %eax
  801802:	6a 07                	push   $0x7
  801804:	e8 34 ff ff ff       	call   80173d <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	ff 75 08             	pushl  0x8(%ebp)
  80181d:	6a 08                	push   $0x8
  80181f:	e8 19 ff ff ff       	call   80173d <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 09                	push   $0x9
  801838:	e8 00 ff ff ff       	call   80173d <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 0a                	push   $0xa
  801851:	e8 e7 fe ff ff       	call   80173d <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 0b                	push   $0xb
  80186a:	e8 ce fe ff ff       	call   80173d <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	ff 75 0c             	pushl  0xc(%ebp)
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	6a 0f                	push   $0xf
  801885:	e8 b3 fe ff ff       	call   80173d <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
	return;
  80188d:	90                   	nop
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	6a 10                	push   $0x10
  8018a1:	e8 97 fe ff ff       	call   80173d <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a9:	90                   	nop
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	ff 75 10             	pushl  0x10(%ebp)
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	ff 75 08             	pushl  0x8(%ebp)
  8018bc:	6a 11                	push   $0x11
  8018be:	e8 7a fe ff ff       	call   80173d <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c6:	90                   	nop
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 0c                	push   $0xc
  8018d8:	e8 60 fe ff ff       	call   80173d <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	6a 0d                	push   $0xd
  8018f2:	e8 46 fe ff ff       	call   80173d <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 0e                	push   $0xe
  80190b:	e8 2d fe ff ff       	call   80173d <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 13                	push   $0x13
  801925:	e8 13 fe ff ff       	call   80173d <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	90                   	nop
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 14                	push   $0x14
  80193f:	e8 f9 fd ff ff       	call   80173d <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	90                   	nop
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_cputc>:


void
sys_cputc(const char c)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801956:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	50                   	push   %eax
  801963:	6a 15                	push   $0x15
  801965:	e8 d3 fd ff ff       	call   80173d <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	90                   	nop
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 16                	push   $0x16
  80197f:	e8 b9 fd ff ff       	call   80173d <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	90                   	nop
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	50                   	push   %eax
  80199a:	6a 17                	push   $0x17
  80199c:	e8 9c fd ff ff       	call   80173d <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	52                   	push   %edx
  8019b6:	50                   	push   %eax
  8019b7:	6a 1a                	push   $0x1a
  8019b9:	e8 7f fd ff ff       	call   80173d <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	52                   	push   %edx
  8019d3:	50                   	push   %eax
  8019d4:	6a 18                	push   $0x18
  8019d6:	e8 62 fd ff ff       	call   80173d <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	52                   	push   %edx
  8019f1:	50                   	push   %eax
  8019f2:	6a 19                	push   $0x19
  8019f4:	e8 44 fd ff ff       	call   80173d <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	90                   	nop
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a0b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	51                   	push   %ecx
  801a18:	52                   	push   %edx
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	50                   	push   %eax
  801a1d:	6a 1b                	push   $0x1b
  801a1f:	e8 19 fd ff ff       	call   80173d <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 1c                	push   $0x1c
  801a3c:	e8 fc fc ff ff       	call   80173d <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	51                   	push   %ecx
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	6a 1d                	push   $0x1d
  801a5b:	e8 dd fc ff ff       	call   80173d <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	52                   	push   %edx
  801a75:	50                   	push   %eax
  801a76:	6a 1e                	push   $0x1e
  801a78:	e8 c0 fc ff ff       	call   80173d <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 1f                	push   $0x1f
  801a91:	e8 a7 fc ff ff       	call   80173d <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	ff 75 14             	pushl  0x14(%ebp)
  801aa6:	ff 75 10             	pushl  0x10(%ebp)
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	50                   	push   %eax
  801aad:	6a 20                	push   $0x20
  801aaf:	e8 89 fc ff ff       	call   80173d <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	50                   	push   %eax
  801ac8:	6a 21                	push   $0x21
  801aca:	e8 6e fc ff ff       	call   80173d <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	90                   	nop
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	50                   	push   %eax
  801ae4:	6a 22                	push   $0x22
  801ae6:	e8 52 fc ff ff       	call   80173d <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 02                	push   $0x2
  801aff:	e8 39 fc ff ff       	call   80173d <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 03                	push   $0x3
  801b18:	e8 20 fc ff ff       	call   80173d <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 04                	push   $0x4
  801b31:	e8 07 fc ff ff       	call   80173d <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_exit_env>:


void sys_exit_env(void)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 23                	push   $0x23
  801b4a:	e8 ee fb ff ff       	call   80173d <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	90                   	nop
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b5b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b5e:	8d 50 04             	lea    0x4(%eax),%edx
  801b61:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	6a 24                	push   $0x24
  801b6e:	e8 ca fb ff ff       	call   80173d <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
	return result;
  801b76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b7f:	89 01                	mov    %eax,(%ecx)
  801b81:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	c9                   	leave  
  801b88:	c2 04 00             	ret    $0x4

00801b8b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	ff 75 10             	pushl  0x10(%ebp)
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	6a 12                	push   $0x12
  801b9d:	e8 9b fb ff ff       	call   80173d <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba5:	90                   	nop
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 25                	push   $0x25
  801bb7:	e8 81 fb ff ff       	call   80173d <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bcd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	50                   	push   %eax
  801bda:	6a 26                	push   $0x26
  801bdc:	e8 5c fb ff ff       	call   80173d <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return ;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <rsttst>:
void rsttst()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 28                	push   $0x28
  801bf6:	e8 42 fb ff ff       	call   80173d <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c0d:	8b 55 18             	mov    0x18(%ebp),%edx
  801c10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	ff 75 10             	pushl  0x10(%ebp)
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 27                	push   $0x27
  801c21:	e8 17 fb ff ff       	call   80173d <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return ;
  801c29:	90                   	nop
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <chktst>:
void chktst(uint32 n)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	ff 75 08             	pushl  0x8(%ebp)
  801c3a:	6a 29                	push   $0x29
  801c3c:	e8 fc fa ff ff       	call   80173d <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return ;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <inctst>:

void inctst()
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 2a                	push   $0x2a
  801c56:	e8 e2 fa ff ff       	call   80173d <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5e:	90                   	nop
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <gettst>:
uint32 gettst()
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 2b                	push   $0x2b
  801c70:	e8 c8 fa ff ff       	call   80173d <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 2c                	push   $0x2c
  801c8c:	e8 ac fa ff ff       	call   80173d <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
  801c94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c97:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c9b:	75 07                	jne    801ca4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca2:	eb 05                	jmp    801ca9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 2c                	push   $0x2c
  801cbd:	e8 7b fa ff ff       	call   80173d <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
  801cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cc8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ccc:	75 07                	jne    801cd5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cce:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd3:	eb 05                	jmp    801cda <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 2c                	push   $0x2c
  801cee:	e8 4a fa ff ff       	call   80173d <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
  801cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cf9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cfd:	75 07                	jne    801d06 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cff:	b8 01 00 00 00       	mov    $0x1,%eax
  801d04:	eb 05                	jmp    801d0b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 2c                	push   $0x2c
  801d1f:	e8 19 fa ff ff       	call   80173d <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
  801d27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d2a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d2e:	75 07                	jne    801d37 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d30:	b8 01 00 00 00       	mov    $0x1,%eax
  801d35:	eb 05                	jmp    801d3c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	ff 75 08             	pushl  0x8(%ebp)
  801d4c:	6a 2d                	push   $0x2d
  801d4e:	e8 ea f9 ff ff       	call   80173d <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d5d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	6a 00                	push   $0x0
  801d6b:	53                   	push   %ebx
  801d6c:	51                   	push   %ecx
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 2e                	push   $0x2e
  801d71:	e8 c7 f9 ff ff       	call   80173d <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	52                   	push   %edx
  801d8e:	50                   	push   %eax
  801d8f:	6a 2f                	push   $0x2f
  801d91:	e8 a7 f9 ff ff       	call   80173d <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801da1:	8b 55 08             	mov    0x8(%ebp),%edx
  801da4:	89 d0                	mov    %edx,%eax
  801da6:	c1 e0 02             	shl    $0x2,%eax
  801da9:	01 d0                	add    %edx,%eax
  801dab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801db2:	01 d0                	add    %edx,%eax
  801db4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dbb:	01 d0                	add    %edx,%eax
  801dbd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dc4:	01 d0                	add    %edx,%eax
  801dc6:	c1 e0 04             	shl    $0x4,%eax
  801dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801dcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801dd3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	50                   	push   %eax
  801dda:	e8 76 fd ff ff       	call   801b55 <sys_get_virtual_time>
  801ddf:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801de2:	eb 41                	jmp    801e25 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801de4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	50                   	push   %eax
  801deb:	e8 65 fd ff ff       	call   801b55 <sys_get_virtual_time>
  801df0:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801df3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801df9:	29 c2                	sub    %eax,%edx
  801dfb:	89 d0                	mov    %edx,%eax
  801dfd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e06:	89 d1                	mov    %edx,%ecx
  801e08:	29 c1                	sub    %eax,%ecx
  801e0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e10:	39 c2                	cmp    %eax,%edx
  801e12:	0f 97 c0             	seta   %al
  801e15:	0f b6 c0             	movzbl %al,%eax
  801e18:	29 c1                	sub    %eax,%ecx
  801e1a:	89 c8                	mov    %ecx,%eax
  801e1c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e2b:	72 b7                	jb     801de4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e2d:	90                   	nop
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e3d:	eb 03                	jmp    801e42 <busy_wait+0x12>
  801e3f:	ff 45 fc             	incl   -0x4(%ebp)
  801e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e45:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e48:	72 f5                	jb     801e3f <busy_wait+0xf>
	return i;
  801e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    
  801e4f:	90                   	nop

00801e50 <__udivdi3>:
  801e50:	55                   	push   %ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	53                   	push   %ebx
  801e54:	83 ec 1c             	sub    $0x1c,%esp
  801e57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e67:	89 ca                	mov    %ecx,%edx
  801e69:	89 f8                	mov    %edi,%eax
  801e6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e6f:	85 f6                	test   %esi,%esi
  801e71:	75 2d                	jne    801ea0 <__udivdi3+0x50>
  801e73:	39 cf                	cmp    %ecx,%edi
  801e75:	77 65                	ja     801edc <__udivdi3+0x8c>
  801e77:	89 fd                	mov    %edi,%ebp
  801e79:	85 ff                	test   %edi,%edi
  801e7b:	75 0b                	jne    801e88 <__udivdi3+0x38>
  801e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e82:	31 d2                	xor    %edx,%edx
  801e84:	f7 f7                	div    %edi
  801e86:	89 c5                	mov    %eax,%ebp
  801e88:	31 d2                	xor    %edx,%edx
  801e8a:	89 c8                	mov    %ecx,%eax
  801e8c:	f7 f5                	div    %ebp
  801e8e:	89 c1                	mov    %eax,%ecx
  801e90:	89 d8                	mov    %ebx,%eax
  801e92:	f7 f5                	div    %ebp
  801e94:	89 cf                	mov    %ecx,%edi
  801e96:	89 fa                	mov    %edi,%edx
  801e98:	83 c4 1c             	add    $0x1c,%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5f                   	pop    %edi
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    
  801ea0:	39 ce                	cmp    %ecx,%esi
  801ea2:	77 28                	ja     801ecc <__udivdi3+0x7c>
  801ea4:	0f bd fe             	bsr    %esi,%edi
  801ea7:	83 f7 1f             	xor    $0x1f,%edi
  801eaa:	75 40                	jne    801eec <__udivdi3+0x9c>
  801eac:	39 ce                	cmp    %ecx,%esi
  801eae:	72 0a                	jb     801eba <__udivdi3+0x6a>
  801eb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801eb4:	0f 87 9e 00 00 00    	ja     801f58 <__udivdi3+0x108>
  801eba:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebf:	89 fa                	mov    %edi,%edx
  801ec1:	83 c4 1c             	add    $0x1c,%esp
  801ec4:	5b                   	pop    %ebx
  801ec5:	5e                   	pop    %esi
  801ec6:	5f                   	pop    %edi
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    
  801ec9:	8d 76 00             	lea    0x0(%esi),%esi
  801ecc:	31 ff                	xor    %edi,%edi
  801ece:	31 c0                	xor    %eax,%eax
  801ed0:	89 fa                	mov    %edi,%edx
  801ed2:	83 c4 1c             	add    $0x1c,%esp
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5f                   	pop    %edi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    
  801eda:	66 90                	xchg   %ax,%ax
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	f7 f7                	div    %edi
  801ee0:	31 ff                	xor    %edi,%edi
  801ee2:	89 fa                	mov    %edi,%edx
  801ee4:	83 c4 1c             	add    $0x1c,%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    
  801eec:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ef1:	89 eb                	mov    %ebp,%ebx
  801ef3:	29 fb                	sub    %edi,%ebx
  801ef5:	89 f9                	mov    %edi,%ecx
  801ef7:	d3 e6                	shl    %cl,%esi
  801ef9:	89 c5                	mov    %eax,%ebp
  801efb:	88 d9                	mov    %bl,%cl
  801efd:	d3 ed                	shr    %cl,%ebp
  801eff:	89 e9                	mov    %ebp,%ecx
  801f01:	09 f1                	or     %esi,%ecx
  801f03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f07:	89 f9                	mov    %edi,%ecx
  801f09:	d3 e0                	shl    %cl,%eax
  801f0b:	89 c5                	mov    %eax,%ebp
  801f0d:	89 d6                	mov    %edx,%esi
  801f0f:	88 d9                	mov    %bl,%cl
  801f11:	d3 ee                	shr    %cl,%esi
  801f13:	89 f9                	mov    %edi,%ecx
  801f15:	d3 e2                	shl    %cl,%edx
  801f17:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f1b:	88 d9                	mov    %bl,%cl
  801f1d:	d3 e8                	shr    %cl,%eax
  801f1f:	09 c2                	or     %eax,%edx
  801f21:	89 d0                	mov    %edx,%eax
  801f23:	89 f2                	mov    %esi,%edx
  801f25:	f7 74 24 0c          	divl   0xc(%esp)
  801f29:	89 d6                	mov    %edx,%esi
  801f2b:	89 c3                	mov    %eax,%ebx
  801f2d:	f7 e5                	mul    %ebp
  801f2f:	39 d6                	cmp    %edx,%esi
  801f31:	72 19                	jb     801f4c <__udivdi3+0xfc>
  801f33:	74 0b                	je     801f40 <__udivdi3+0xf0>
  801f35:	89 d8                	mov    %ebx,%eax
  801f37:	31 ff                	xor    %edi,%edi
  801f39:	e9 58 ff ff ff       	jmp    801e96 <__udivdi3+0x46>
  801f3e:	66 90                	xchg   %ax,%ax
  801f40:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f44:	89 f9                	mov    %edi,%ecx
  801f46:	d3 e2                	shl    %cl,%edx
  801f48:	39 c2                	cmp    %eax,%edx
  801f4a:	73 e9                	jae    801f35 <__udivdi3+0xe5>
  801f4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f4f:	31 ff                	xor    %edi,%edi
  801f51:	e9 40 ff ff ff       	jmp    801e96 <__udivdi3+0x46>
  801f56:	66 90                	xchg   %ax,%ax
  801f58:	31 c0                	xor    %eax,%eax
  801f5a:	e9 37 ff ff ff       	jmp    801e96 <__udivdi3+0x46>
  801f5f:	90                   	nop

00801f60 <__umoddi3>:
  801f60:	55                   	push   %ebp
  801f61:	57                   	push   %edi
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	83 ec 1c             	sub    $0x1c,%esp
  801f67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f7f:	89 f3                	mov    %esi,%ebx
  801f81:	89 fa                	mov    %edi,%edx
  801f83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f87:	89 34 24             	mov    %esi,(%esp)
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	75 1a                	jne    801fa8 <__umoddi3+0x48>
  801f8e:	39 f7                	cmp    %esi,%edi
  801f90:	0f 86 a2 00 00 00    	jbe    802038 <__umoddi3+0xd8>
  801f96:	89 c8                	mov    %ecx,%eax
  801f98:	89 f2                	mov    %esi,%edx
  801f9a:	f7 f7                	div    %edi
  801f9c:	89 d0                	mov    %edx,%eax
  801f9e:	31 d2                	xor    %edx,%edx
  801fa0:	83 c4 1c             	add    $0x1c,%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5f                   	pop    %edi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    
  801fa8:	39 f0                	cmp    %esi,%eax
  801faa:	0f 87 ac 00 00 00    	ja     80205c <__umoddi3+0xfc>
  801fb0:	0f bd e8             	bsr    %eax,%ebp
  801fb3:	83 f5 1f             	xor    $0x1f,%ebp
  801fb6:	0f 84 ac 00 00 00    	je     802068 <__umoddi3+0x108>
  801fbc:	bf 20 00 00 00       	mov    $0x20,%edi
  801fc1:	29 ef                	sub    %ebp,%edi
  801fc3:	89 fe                	mov    %edi,%esi
  801fc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fc9:	89 e9                	mov    %ebp,%ecx
  801fcb:	d3 e0                	shl    %cl,%eax
  801fcd:	89 d7                	mov    %edx,%edi
  801fcf:	89 f1                	mov    %esi,%ecx
  801fd1:	d3 ef                	shr    %cl,%edi
  801fd3:	09 c7                	or     %eax,%edi
  801fd5:	89 e9                	mov    %ebp,%ecx
  801fd7:	d3 e2                	shl    %cl,%edx
  801fd9:	89 14 24             	mov    %edx,(%esp)
  801fdc:	89 d8                	mov    %ebx,%eax
  801fde:	d3 e0                	shl    %cl,%eax
  801fe0:	89 c2                	mov    %eax,%edx
  801fe2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fe6:	d3 e0                	shl    %cl,%eax
  801fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fec:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ff0:	89 f1                	mov    %esi,%ecx
  801ff2:	d3 e8                	shr    %cl,%eax
  801ff4:	09 d0                	or     %edx,%eax
  801ff6:	d3 eb                	shr    %cl,%ebx
  801ff8:	89 da                	mov    %ebx,%edx
  801ffa:	f7 f7                	div    %edi
  801ffc:	89 d3                	mov    %edx,%ebx
  801ffe:	f7 24 24             	mull   (%esp)
  802001:	89 c6                	mov    %eax,%esi
  802003:	89 d1                	mov    %edx,%ecx
  802005:	39 d3                	cmp    %edx,%ebx
  802007:	0f 82 87 00 00 00    	jb     802094 <__umoddi3+0x134>
  80200d:	0f 84 91 00 00 00    	je     8020a4 <__umoddi3+0x144>
  802013:	8b 54 24 04          	mov    0x4(%esp),%edx
  802017:	29 f2                	sub    %esi,%edx
  802019:	19 cb                	sbb    %ecx,%ebx
  80201b:	89 d8                	mov    %ebx,%eax
  80201d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802021:	d3 e0                	shl    %cl,%eax
  802023:	89 e9                	mov    %ebp,%ecx
  802025:	d3 ea                	shr    %cl,%edx
  802027:	09 d0                	or     %edx,%eax
  802029:	89 e9                	mov    %ebp,%ecx
  80202b:	d3 eb                	shr    %cl,%ebx
  80202d:	89 da                	mov    %ebx,%edx
  80202f:	83 c4 1c             	add    $0x1c,%esp
  802032:	5b                   	pop    %ebx
  802033:	5e                   	pop    %esi
  802034:	5f                   	pop    %edi
  802035:	5d                   	pop    %ebp
  802036:	c3                   	ret    
  802037:	90                   	nop
  802038:	89 fd                	mov    %edi,%ebp
  80203a:	85 ff                	test   %edi,%edi
  80203c:	75 0b                	jne    802049 <__umoddi3+0xe9>
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	31 d2                	xor    %edx,%edx
  802045:	f7 f7                	div    %edi
  802047:	89 c5                	mov    %eax,%ebp
  802049:	89 f0                	mov    %esi,%eax
  80204b:	31 d2                	xor    %edx,%edx
  80204d:	f7 f5                	div    %ebp
  80204f:	89 c8                	mov    %ecx,%eax
  802051:	f7 f5                	div    %ebp
  802053:	89 d0                	mov    %edx,%eax
  802055:	e9 44 ff ff ff       	jmp    801f9e <__umoddi3+0x3e>
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	89 c8                	mov    %ecx,%eax
  80205e:	89 f2                	mov    %esi,%edx
  802060:	83 c4 1c             	add    $0x1c,%esp
  802063:	5b                   	pop    %ebx
  802064:	5e                   	pop    %esi
  802065:	5f                   	pop    %edi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    
  802068:	3b 04 24             	cmp    (%esp),%eax
  80206b:	72 06                	jb     802073 <__umoddi3+0x113>
  80206d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802071:	77 0f                	ja     802082 <__umoddi3+0x122>
  802073:	89 f2                	mov    %esi,%edx
  802075:	29 f9                	sub    %edi,%ecx
  802077:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80207b:	89 14 24             	mov    %edx,(%esp)
  80207e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802082:	8b 44 24 04          	mov    0x4(%esp),%eax
  802086:	8b 14 24             	mov    (%esp),%edx
  802089:	83 c4 1c             	add    $0x1c,%esp
  80208c:	5b                   	pop    %ebx
  80208d:	5e                   	pop    %esi
  80208e:	5f                   	pop    %edi
  80208f:	5d                   	pop    %ebp
  802090:	c3                   	ret    
  802091:	8d 76 00             	lea    0x0(%esi),%esi
  802094:	2b 04 24             	sub    (%esp),%eax
  802097:	19 fa                	sbb    %edi,%edx
  802099:	89 d1                	mov    %edx,%ecx
  80209b:	89 c6                	mov    %eax,%esi
  80209d:	e9 71 ff ff ff       	jmp    802013 <__umoddi3+0xb3>
  8020a2:	66 90                	xchg   %ax,%ax
  8020a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020a8:	72 ea                	jb     802094 <__umoddi3+0x134>
  8020aa:	89 d9                	mov    %ebx,%ecx
  8020ac:	e9 62 ff ff ff       	jmp    802013 <__umoddi3+0xb3>
