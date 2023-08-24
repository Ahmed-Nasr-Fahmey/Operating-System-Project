
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 03 03 00 00       	call   800339 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
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
  80008d:	68 e0 1e 80 00       	push   $0x801ee0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 1e 80 00       	push   $0x801efc
  800099:	e8 ea 03 00 00       	call   800488 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 14 1f 80 00       	push   $0x801f14
  8000a6:	e8 91 06 00 00       	call   80073c <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 3c 16 00 00       	call   8016ef <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 4b 1f 80 00       	push   $0x801f4b
  8000c5:	e8 71 14 00 00       	call   80153b <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 50 1f 80 00       	push   $0x801f50
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 fc 1e 80 00       	push   $0x801efc
  8000e8:	e8 9b 03 00 00       	call   800488 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 fa 15 00 00       	call   8016ef <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 bc 1f 80 00       	push   $0x801fbc
  800106:	6a 1b                	push   $0x1b
  800108:	68 fc 1e 80 00       	push   $0x801efc
  80010d:	e8 76 03 00 00       	call   800488 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800112:	e8 d8 15 00 00       	call   8016ef <sys_calculate_free_frames>
  800117:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80011a:	83 ec 04             	sub    $0x4,%esp
  80011d:	6a 01                	push   $0x1
  80011f:	68 04 10 00 00       	push   $0x1004
  800124:	68 3a 20 80 00       	push   $0x80203a
  800129:	e8 0d 14 00 00       	call   80153b <smalloc>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800134:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 50 1f 80 00       	push   $0x801f50
  800145:	6a 1f                	push   $0x1f
  800147:	68 fc 1e 80 00       	push   $0x801efc
  80014c:	e8 37 03 00 00       	call   800488 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800151:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800154:	e8 96 15 00 00       	call   8016ef <sys_calculate_free_frames>
  800159:	29 c3                	sub    %eax,%ebx
  80015b:	89 d8                	mov    %ebx,%eax
  80015d:	83 f8 04             	cmp    $0x4,%eax
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 bc 1f 80 00       	push   $0x801fbc
  80016a:	6a 20                	push   $0x20
  80016c:	68 fc 1e 80 00       	push   $0x801efc
  800171:	e8 12 03 00 00       	call   800488 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800176:	e8 74 15 00 00       	call   8016ef <sys_calculate_free_frames>
  80017b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  80017e:	83 ec 04             	sub    $0x4,%esp
  800181:	6a 01                	push   $0x1
  800183:	6a 04                	push   $0x4
  800185:	68 3c 20 80 00       	push   $0x80203c
  80018a:	e8 ac 13 00 00       	call   80153b <smalloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800195:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  80019c:	74 14                	je     8001b2 <_main+0x17a>
  80019e:	83 ec 04             	sub    $0x4,%esp
  8001a1:	68 50 1f 80 00       	push   $0x801f50
  8001a6:	6a 24                	push   $0x24
  8001a8:	68 fc 1e 80 00       	push   $0x801efc
  8001ad:	e8 d6 02 00 00       	call   800488 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001b5:	e8 35 15 00 00       	call   8016ef <sys_calculate_free_frames>
  8001ba:	29 c3                	sub    %eax,%ebx
  8001bc:	89 d8                	mov    %ebx,%eax
  8001be:	83 f8 03             	cmp    $0x3,%eax
  8001c1:	74 14                	je     8001d7 <_main+0x19f>
  8001c3:	83 ec 04             	sub    $0x4,%esp
  8001c6:	68 bc 1f 80 00       	push   $0x801fbc
  8001cb:	6a 25                	push   $0x25
  8001cd:	68 fc 1e 80 00       	push   $0x801efc
  8001d2:	e8 b1 02 00 00       	call   800488 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 40 20 80 00       	push   $0x802040
  8001df:	e8 58 05 00 00       	call   80073c <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	68 68 20 80 00       	push   $0x802068
  8001ef:	e8 48 05 00 00       	call   80073c <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8001f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  8001fe:	eb 2d                	jmp    80022d <_main+0x1f5>
		{
			x[i] = -1;
  800200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800203:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800215:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800218:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800222:	01 d0                	add    %edx,%eax
  800224:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80022a:	ff 45 ec             	incl   -0x14(%ebp)
  80022d:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800234:	7e ca                	jle    800200 <_main+0x1c8>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800236:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80023d:	eb 18                	jmp    800257 <_main+0x21f>
		{
			z[i] = -1;
  80023f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800249:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024c:	01 d0                	add    %edx,%eax
  80024e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800254:	ff 45 ec             	incl   -0x14(%ebp)
  800257:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  80025e:	7e df                	jle    80023f <_main+0x207>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800263:	8b 00                	mov    (%eax),%eax
  800265:	83 f8 ff             	cmp    $0xffffffff,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 90 20 80 00       	push   $0x802090
  800272:	6a 39                	push   $0x39
  800274:	68 fc 1e 80 00       	push   $0x801efc
  800279:	e8 0a 02 00 00       	call   800488 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  80027e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800281:	05 fc 0f 00 00       	add    $0xffc,%eax
  800286:	8b 00                	mov    (%eax),%eax
  800288:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028b:	74 14                	je     8002a1 <_main+0x269>
  80028d:	83 ec 04             	sub    $0x4,%esp
  800290:	68 90 20 80 00       	push   $0x802090
  800295:	6a 3a                	push   $0x3a
  800297:	68 fc 1e 80 00       	push   $0x801efc
  80029c:	e8 e7 01 00 00       	call   800488 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a4:	8b 00                	mov    (%eax),%eax
  8002a6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002a9:	74 14                	je     8002bf <_main+0x287>
  8002ab:	83 ec 04             	sub    $0x4,%esp
  8002ae:	68 90 20 80 00       	push   $0x802090
  8002b3:	6a 3c                	push   $0x3c
  8002b5:	68 fc 1e 80 00       	push   $0x801efc
  8002ba:	e8 c9 01 00 00       	call   800488 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c2:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002c7:	8b 00                	mov    (%eax),%eax
  8002c9:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cc:	74 14                	je     8002e2 <_main+0x2aa>
  8002ce:	83 ec 04             	sub    $0x4,%esp
  8002d1:	68 90 20 80 00       	push   $0x802090
  8002d6:	6a 3d                	push   $0x3d
  8002d8:	68 fc 1e 80 00       	push   $0x801efc
  8002dd:	e8 a6 01 00 00       	call   800488 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	8b 00                	mov    (%eax),%eax
  8002e7:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 90 20 80 00       	push   $0x802090
  8002f4:	6a 3f                	push   $0x3f
  8002f6:	68 fc 1e 80 00       	push   $0x801efc
  8002fb:	e8 88 01 00 00       	call   800488 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800303:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 90 20 80 00       	push   $0x802090
  800317:	6a 40                	push   $0x40
  800319:	68 fc 1e 80 00       	push   $0x801efc
  80031e:	e8 65 01 00 00       	call   800488 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	68 bc 20 80 00       	push   $0x8020bc
  80032b:	e8 0c 04 00 00       	call   80073c <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp

	return;
  800333:	90                   	nop
}
  800334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80033f:	e8 8b 16 00 00       	call   8019cf <sys_getenvindex>
  800344:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800347:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80034a:	89 d0                	mov    %edx,%eax
  80034c:	01 c0                	add    %eax,%eax
  80034e:	01 d0                	add    %edx,%eax
  800350:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800357:	01 c8                	add    %ecx,%eax
  800359:	c1 e0 02             	shl    $0x2,%eax
  80035c:	01 d0                	add    %edx,%eax
  80035e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800365:	01 c8                	add    %ecx,%eax
  800367:	c1 e0 02             	shl    $0x2,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	c1 e0 02             	shl    $0x2,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800379:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80037e:	a1 20 30 80 00       	mov    0x803020,%eax
  800383:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800389:	84 c0                	test   %al,%al
  80038b:	74 0f                	je     80039c <libmain+0x63>
		binaryname = myEnv->prog_name;
  80038d:	a1 20 30 80 00       	mov    0x803020,%eax
  800392:	05 18 da 01 00       	add    $0x1da18,%eax
  800397:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80039c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003a0:	7e 0a                	jle    8003ac <libmain+0x73>
		binaryname = argv[0];
  8003a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003ac:	83 ec 08             	sub    $0x8,%esp
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 7e fc ff ff       	call   800038 <_main>
  8003ba:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003bd:	e8 1a 14 00 00       	call   8017dc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003c2:	83 ec 0c             	sub    $0xc,%esp
  8003c5:	68 28 21 80 00       	push   $0x802128
  8003ca:	e8 6d 03 00 00       	call   80073c <cprintf>
  8003cf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d7:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  8003dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e2:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	52                   	push   %edx
  8003ec:	50                   	push   %eax
  8003ed:	68 50 21 80 00       	push   $0x802150
  8003f2:	e8 45 03 00 00       	call   80073c <cprintf>
  8003f7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ff:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800405:	a1 20 30 80 00       	mov    0x803020,%eax
  80040a:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800410:	a1 20 30 80 00       	mov    0x803020,%eax
  800415:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80041b:	51                   	push   %ecx
  80041c:	52                   	push   %edx
  80041d:	50                   	push   %eax
  80041e:	68 78 21 80 00       	push   $0x802178
  800423:	e8 14 03 00 00       	call   80073c <cprintf>
  800428:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80042b:	a1 20 30 80 00       	mov    0x803020,%eax
  800430:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	50                   	push   %eax
  80043a:	68 d0 21 80 00       	push   $0x8021d0
  80043f:	e8 f8 02 00 00       	call   80073c <cprintf>
  800444:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 28 21 80 00       	push   $0x802128
  80044f:	e8 e8 02 00 00       	call   80073c <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800457:	e8 9a 13 00 00       	call   8017f6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80045c:	e8 19 00 00 00       	call   80047a <exit>
}
  800461:	90                   	nop
  800462:	c9                   	leave  
  800463:	c3                   	ret    

00800464 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80046a:	83 ec 0c             	sub    $0xc,%esp
  80046d:	6a 00                	push   $0x0
  80046f:	e8 27 15 00 00       	call   80199b <sys_destroy_env>
  800474:	83 c4 10             	add    $0x10,%esp
}
  800477:	90                   	nop
  800478:	c9                   	leave  
  800479:	c3                   	ret    

0080047a <exit>:

void
exit(void)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800480:	e8 7c 15 00 00       	call   801a01 <sys_exit_env>
}
  800485:	90                   	nop
  800486:	c9                   	leave  
  800487:	c3                   	ret    

00800488 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
  80048b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80048e:	8d 45 10             	lea    0x10(%ebp),%eax
  800491:	83 c0 04             	add    $0x4,%eax
  800494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800497:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80049c:	85 c0                	test   %eax,%eax
  80049e:	74 16                	je     8004b6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004a0:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	50                   	push   %eax
  8004a9:	68 e4 21 80 00       	push   $0x8021e4
  8004ae:	e8 89 02 00 00       	call   80073c <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004b6:	a1 00 30 80 00       	mov    0x803000,%eax
  8004bb:	ff 75 0c             	pushl  0xc(%ebp)
  8004be:	ff 75 08             	pushl  0x8(%ebp)
  8004c1:	50                   	push   %eax
  8004c2:	68 e9 21 80 00       	push   $0x8021e9
  8004c7:	e8 70 02 00 00       	call   80073c <cprintf>
  8004cc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d8:	50                   	push   %eax
  8004d9:	e8 f3 01 00 00       	call   8006d1 <vcprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	6a 00                	push   $0x0
  8004e6:	68 05 22 80 00       	push   $0x802205
  8004eb:	e8 e1 01 00 00       	call   8006d1 <vcprintf>
  8004f0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f3:	e8 82 ff ff ff       	call   80047a <exit>

	// should not return here
	while (1) ;
  8004f8:	eb fe                	jmp    8004f8 <_panic+0x70>

008004fa <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800500:	a1 20 30 80 00       	mov    0x803020,%eax
  800505:	8b 50 74             	mov    0x74(%eax),%edx
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	39 c2                	cmp    %eax,%edx
  80050d:	74 14                	je     800523 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	68 08 22 80 00       	push   $0x802208
  800517:	6a 26                	push   $0x26
  800519:	68 54 22 80 00       	push   $0x802254
  80051e:	e8 65 ff ff ff       	call   800488 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800523:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80052a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800531:	e9 c2 00 00 00       	jmp    8005f8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800539:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	85 c0                	test   %eax,%eax
  800549:	75 08                	jne    800553 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80054b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80054e:	e9 a2 00 00 00       	jmp    8005f5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800553:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800561:	eb 69                	jmp    8005cc <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800563:	a1 20 30 80 00       	mov    0x803020,%eax
  800568:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80056e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800571:	89 d0                	mov    %edx,%eax
  800573:	01 c0                	add    %eax,%eax
  800575:	01 d0                	add    %edx,%eax
  800577:	c1 e0 03             	shl    $0x3,%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	8a 40 04             	mov    0x4(%eax),%al
  80057f:	84 c0                	test   %al,%al
  800581:	75 46                	jne    8005c9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800583:	a1 20 30 80 00       	mov    0x803020,%eax
  800588:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80058e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	01 c0                	add    %eax,%eax
  800595:	01 d0                	add    %edx,%eax
  800597:	c1 e0 03             	shl    $0x3,%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	01 c8                	add    %ecx,%eax
  8005ba:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005bc:	39 c2                	cmp    %eax,%edx
  8005be:	75 09                	jne    8005c9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005c0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005c7:	eb 12                	jmp    8005db <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c9:	ff 45 e8             	incl   -0x18(%ebp)
  8005cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d1:	8b 50 74             	mov    0x74(%eax),%edx
  8005d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d7:	39 c2                	cmp    %eax,%edx
  8005d9:	77 88                	ja     800563 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005df:	75 14                	jne    8005f5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005e1:	83 ec 04             	sub    $0x4,%esp
  8005e4:	68 60 22 80 00       	push   $0x802260
  8005e9:	6a 3a                	push   $0x3a
  8005eb:	68 54 22 80 00       	push   $0x802254
  8005f0:	e8 93 fe ff ff       	call   800488 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005f5:	ff 45 f0             	incl   -0x10(%ebp)
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005fe:	0f 8c 32 ff ff ff    	jl     800536 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800604:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800612:	eb 26                	jmp    80063a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800614:	a1 20 30 80 00       	mov    0x803020,%eax
  800619:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80061f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800622:	89 d0                	mov    %edx,%eax
  800624:	01 c0                	add    %eax,%eax
  800626:	01 d0                	add    %edx,%eax
  800628:	c1 e0 03             	shl    $0x3,%eax
  80062b:	01 c8                	add    %ecx,%eax
  80062d:	8a 40 04             	mov    0x4(%eax),%al
  800630:	3c 01                	cmp    $0x1,%al
  800632:	75 03                	jne    800637 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800634:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800637:	ff 45 e0             	incl   -0x20(%ebp)
  80063a:	a1 20 30 80 00       	mov    0x803020,%eax
  80063f:	8b 50 74             	mov    0x74(%eax),%edx
  800642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800645:	39 c2                	cmp    %eax,%edx
  800647:	77 cb                	ja     800614 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80064f:	74 14                	je     800665 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 b4 22 80 00       	push   $0x8022b4
  800659:	6a 44                	push   $0x44
  80065b:	68 54 22 80 00       	push   $0x802254
  800660:	e8 23 fe ff ff       	call   800488 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800665:	90                   	nop
  800666:	c9                   	leave  
  800667:	c3                   	ret    

00800668 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	8d 48 01             	lea    0x1(%eax),%ecx
  800676:	8b 55 0c             	mov    0xc(%ebp),%edx
  800679:	89 0a                	mov    %ecx,(%edx)
  80067b:	8b 55 08             	mov    0x8(%ebp),%edx
  80067e:	88 d1                	mov    %dl,%cl
  800680:	8b 55 0c             	mov    0xc(%ebp),%edx
  800683:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800691:	75 2c                	jne    8006bf <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800693:	a0 24 30 80 00       	mov    0x803024,%al
  800698:	0f b6 c0             	movzbl %al,%eax
  80069b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069e:	8b 12                	mov    (%edx),%edx
  8006a0:	89 d1                	mov    %edx,%ecx
  8006a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a5:	83 c2 08             	add    $0x8,%edx
  8006a8:	83 ec 04             	sub    $0x4,%esp
  8006ab:	50                   	push   %eax
  8006ac:	51                   	push   %ecx
  8006ad:	52                   	push   %edx
  8006ae:	e8 7b 0f 00 00       	call   80162e <sys_cputs>
  8006b3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c2:	8b 40 04             	mov    0x4(%eax),%eax
  8006c5:	8d 50 01             	lea    0x1(%eax),%edx
  8006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ce:	90                   	nop
  8006cf:	c9                   	leave  
  8006d0:	c3                   	ret    

008006d1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d1:	55                   	push   %ebp
  8006d2:	89 e5                	mov    %esp,%ebp
  8006d4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e1:	00 00 00 
	b.cnt = 0;
  8006e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006eb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ee:	ff 75 0c             	pushl  0xc(%ebp)
  8006f1:	ff 75 08             	pushl  0x8(%ebp)
  8006f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fa:	50                   	push   %eax
  8006fb:	68 68 06 80 00       	push   $0x800668
  800700:	e8 11 02 00 00       	call   800916 <vprintfmt>
  800705:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800708:	a0 24 30 80 00       	mov    0x803024,%al
  80070d:	0f b6 c0             	movzbl %al,%eax
  800710:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	50                   	push   %eax
  80071a:	52                   	push   %edx
  80071b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800721:	83 c0 08             	add    $0x8,%eax
  800724:	50                   	push   %eax
  800725:	e8 04 0f 00 00       	call   80162e <sys_cputs>
  80072a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800734:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <cprintf>:

int cprintf(const char *fmt, ...) {
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800742:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800749:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 f4             	pushl  -0xc(%ebp)
  800758:	50                   	push   %eax
  800759:	e8 73 ff ff ff       	call   8006d1 <vcprintf>
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800764:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076f:	e8 68 10 00 00       	call   8017dc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800774:	8d 45 0c             	lea    0xc(%ebp),%eax
  800777:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 f4             	pushl  -0xc(%ebp)
  800783:	50                   	push   %eax
  800784:	e8 48 ff ff ff       	call   8006d1 <vcprintf>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80078f:	e8 62 10 00 00       	call   8017f6 <sys_enable_interrupt>
	return cnt;
  800794:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800797:	c9                   	leave  
  800798:	c3                   	ret    

00800799 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	53                   	push   %ebx
  80079d:	83 ec 14             	sub    $0x14,%esp
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ac:	8b 45 18             	mov    0x18(%ebp),%eax
  8007af:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b7:	77 55                	ja     80080e <printnum+0x75>
  8007b9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bc:	72 05                	jb     8007c3 <printnum+0x2a>
  8007be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c1:	77 4b                	ja     80080e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d1:	52                   	push   %edx
  8007d2:	50                   	push   %eax
  8007d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8007d9:	e8 86 14 00 00       	call   801c64 <__udivdi3>
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	83 ec 04             	sub    $0x4,%esp
  8007e4:	ff 75 20             	pushl  0x20(%ebp)
  8007e7:	53                   	push   %ebx
  8007e8:	ff 75 18             	pushl  0x18(%ebp)
  8007eb:	52                   	push   %edx
  8007ec:	50                   	push   %eax
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	ff 75 08             	pushl  0x8(%ebp)
  8007f3:	e8 a1 ff ff ff       	call   800799 <printnum>
  8007f8:	83 c4 20             	add    $0x20,%esp
  8007fb:	eb 1a                	jmp    800817 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	ff 75 20             	pushl  0x20(%ebp)
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080e:	ff 4d 1c             	decl   0x1c(%ebp)
  800811:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800815:	7f e6                	jg     8007fd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800817:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80081f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800825:	53                   	push   %ebx
  800826:	51                   	push   %ecx
  800827:	52                   	push   %edx
  800828:	50                   	push   %eax
  800829:	e8 46 15 00 00       	call   801d74 <__umoddi3>
  80082e:	83 c4 10             	add    $0x10,%esp
  800831:	05 14 25 80 00       	add    $0x802514,%eax
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f be c0             	movsbl %al,%eax
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	50                   	push   %eax
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
}
  80084a:	90                   	nop
  80084b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    

00800850 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800853:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800857:	7e 1c                	jle    800875 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	8d 50 08             	lea    0x8(%eax),%edx
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	89 10                	mov    %edx,(%eax)
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	83 e8 08             	sub    $0x8,%eax
  80086e:	8b 50 04             	mov    0x4(%eax),%edx
  800871:	8b 00                	mov    (%eax),%eax
  800873:	eb 40                	jmp    8008b5 <getuint+0x65>
	else if (lflag)
  800875:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800879:	74 1e                	je     800899 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	8d 50 04             	lea    0x4(%eax),%edx
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	89 10                	mov    %edx,(%eax)
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	83 e8 04             	sub    $0x4,%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	ba 00 00 00 00       	mov    $0x0,%edx
  800897:	eb 1c                	jmp    8008b5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	8d 50 04             	lea    0x4(%eax),%edx
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	89 10                	mov    %edx,(%eax)
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	83 e8 04             	sub    $0x4,%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008be:	7e 1c                	jle    8008dc <getint+0x25>
		return va_arg(*ap, long long);
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	8d 50 08             	lea    0x8(%eax),%edx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	89 10                	mov    %edx,(%eax)
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	83 e8 08             	sub    $0x8,%eax
  8008d5:	8b 50 04             	mov    0x4(%eax),%edx
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	eb 38                	jmp    800914 <getint+0x5d>
	else if (lflag)
  8008dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e0:	74 1a                	je     8008fc <getint+0x45>
		return va_arg(*ap, long);
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	8d 50 04             	lea    0x4(%eax),%edx
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	89 10                	mov    %edx,(%eax)
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	99                   	cltd   
  8008fa:	eb 18                	jmp    800914 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	8d 50 04             	lea    0x4(%eax),%edx
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	89 10                	mov    %edx,(%eax)
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	83 e8 04             	sub    $0x4,%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	99                   	cltd   
}
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	56                   	push   %esi
  80091a:	53                   	push   %ebx
  80091b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091e:	eb 17                	jmp    800937 <vprintfmt+0x21>
			if (ch == '\0')
  800920:	85 db                	test   %ebx,%ebx
  800922:	0f 84 af 03 00 00    	je     800cd7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	53                   	push   %ebx
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	ff d0                	call   *%eax
  800934:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800937:	8b 45 10             	mov    0x10(%ebp),%eax
  80093a:	8d 50 01             	lea    0x1(%eax),%edx
  80093d:	89 55 10             	mov    %edx,0x10(%ebp)
  800940:	8a 00                	mov    (%eax),%al
  800942:	0f b6 d8             	movzbl %al,%ebx
  800945:	83 fb 25             	cmp    $0x25,%ebx
  800948:	75 d6                	jne    800920 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800955:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800963:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 10             	mov    %edx,0x10(%ebp)
  800973:	8a 00                	mov    (%eax),%al
  800975:	0f b6 d8             	movzbl %al,%ebx
  800978:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097b:	83 f8 55             	cmp    $0x55,%eax
  80097e:	0f 87 2b 03 00 00    	ja     800caf <vprintfmt+0x399>
  800984:	8b 04 85 38 25 80 00 	mov    0x802538(,%eax,4),%eax
  80098b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800991:	eb d7                	jmp    80096a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800993:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800997:	eb d1                	jmp    80096a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800999:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a3:	89 d0                	mov    %edx,%eax
  8009a5:	c1 e0 02             	shl    $0x2,%eax
  8009a8:	01 d0                	add    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d8                	add    %ebx,%eax
  8009ae:	83 e8 30             	sub    $0x30,%eax
  8009b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b7:	8a 00                	mov    (%eax),%al
  8009b9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bc:	83 fb 2f             	cmp    $0x2f,%ebx
  8009bf:	7e 3e                	jle    8009ff <vprintfmt+0xe9>
  8009c1:	83 fb 39             	cmp    $0x39,%ebx
  8009c4:	7f 39                	jg     8009ff <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c9:	eb d5                	jmp    8009a0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ce:	83 c0 04             	add    $0x4,%eax
  8009d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	83 e8 04             	sub    $0x4,%eax
  8009da:	8b 00                	mov    (%eax),%eax
  8009dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009df:	eb 1f                	jmp    800a00 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e5:	79 83                	jns    80096a <vprintfmt+0x54>
				width = 0;
  8009e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ee:	e9 77 ff ff ff       	jmp    80096a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fa:	e9 6b ff ff ff       	jmp    80096a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009ff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	0f 89 60 ff ff ff    	jns    80096a <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a10:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a17:	e9 4e ff ff ff       	jmp    80096a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a1f:	e9 46 ff ff ff       	jmp    80096a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 e8 04             	sub    $0x4,%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	ff 75 0c             	pushl  0xc(%ebp)
  800a3b:	50                   	push   %eax
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			break;
  800a44:	e9 89 02 00 00       	jmp    800cd2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	83 c0 04             	add    $0x4,%eax
  800a4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	83 e8 04             	sub    $0x4,%eax
  800a58:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5a:	85 db                	test   %ebx,%ebx
  800a5c:	79 02                	jns    800a60 <vprintfmt+0x14a>
				err = -err;
  800a5e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a60:	83 fb 64             	cmp    $0x64,%ebx
  800a63:	7f 0b                	jg     800a70 <vprintfmt+0x15a>
  800a65:	8b 34 9d 80 23 80 00 	mov    0x802380(,%ebx,4),%esi
  800a6c:	85 f6                	test   %esi,%esi
  800a6e:	75 19                	jne    800a89 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a70:	53                   	push   %ebx
  800a71:	68 25 25 80 00       	push   $0x802525
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	ff 75 08             	pushl  0x8(%ebp)
  800a7c:	e8 5e 02 00 00       	call   800cdf <printfmt>
  800a81:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a84:	e9 49 02 00 00       	jmp    800cd2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a89:	56                   	push   %esi
  800a8a:	68 2e 25 80 00       	push   $0x80252e
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	ff 75 08             	pushl  0x8(%ebp)
  800a95:	e8 45 02 00 00       	call   800cdf <printfmt>
  800a9a:	83 c4 10             	add    $0x10,%esp
			break;
  800a9d:	e9 30 02 00 00       	jmp    800cd2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa5:	83 c0 04             	add    $0x4,%eax
  800aa8:	89 45 14             	mov    %eax,0x14(%ebp)
  800aab:	8b 45 14             	mov    0x14(%ebp),%eax
  800aae:	83 e8 04             	sub    $0x4,%eax
  800ab1:	8b 30                	mov    (%eax),%esi
  800ab3:	85 f6                	test   %esi,%esi
  800ab5:	75 05                	jne    800abc <vprintfmt+0x1a6>
				p = "(null)";
  800ab7:	be 31 25 80 00       	mov    $0x802531,%esi
			if (width > 0 && padc != '-')
  800abc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac0:	7e 6d                	jle    800b2f <vprintfmt+0x219>
  800ac2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac6:	74 67                	je     800b2f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	50                   	push   %eax
  800acf:	56                   	push   %esi
  800ad0:	e8 0c 03 00 00       	call   800de1 <strnlen>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adb:	eb 16                	jmp    800af3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800add:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	50                   	push   %eax
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	ff d0                	call   *%eax
  800aed:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af0:	ff 4d e4             	decl   -0x1c(%ebp)
  800af3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af7:	7f e4                	jg     800add <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af9:	eb 34                	jmp    800b2f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aff:	74 1c                	je     800b1d <vprintfmt+0x207>
  800b01:	83 fb 1f             	cmp    $0x1f,%ebx
  800b04:	7e 05                	jle    800b0b <vprintfmt+0x1f5>
  800b06:	83 fb 7e             	cmp    $0x7e,%ebx
  800b09:	7e 12                	jle    800b1d <vprintfmt+0x207>
					putch('?', putdat);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	6a 3f                	push   $0x3f
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
  800b1b:	eb 0f                	jmp    800b2c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	53                   	push   %ebx
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2f:	89 f0                	mov    %esi,%eax
  800b31:	8d 70 01             	lea    0x1(%eax),%esi
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	0f be d8             	movsbl %al,%ebx
  800b39:	85 db                	test   %ebx,%ebx
  800b3b:	74 24                	je     800b61 <vprintfmt+0x24b>
  800b3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b41:	78 b8                	js     800afb <vprintfmt+0x1e5>
  800b43:	ff 4d e0             	decl   -0x20(%ebp)
  800b46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4a:	79 af                	jns    800afb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4c:	eb 13                	jmp    800b61 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	6a 20                	push   $0x20
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	ff d0                	call   *%eax
  800b5b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b65:	7f e7                	jg     800b4e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b67:	e9 66 01 00 00       	jmp    800cd2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b72:	8d 45 14             	lea    0x14(%ebp),%eax
  800b75:	50                   	push   %eax
  800b76:	e8 3c fd ff ff       	call   8008b7 <getint>
  800b7b:	83 c4 10             	add    $0x10,%esp
  800b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8a:	85 d2                	test   %edx,%edx
  800b8c:	79 23                	jns    800bb1 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	6a 2d                	push   $0x2d
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	ff d0                	call   *%eax
  800b9b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba4:	f7 d8                	neg    %eax
  800ba6:	83 d2 00             	adc    $0x0,%edx
  800ba9:	f7 da                	neg    %edx
  800bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb8:	e9 bc 00 00 00       	jmp    800c79 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc6:	50                   	push   %eax
  800bc7:	e8 84 fc ff ff       	call   800850 <getuint>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdc:	e9 98 00 00 00       	jmp    800c79 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	6a 58                	push   $0x58
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	ff d0                	call   *%eax
  800bee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	ff 75 0c             	pushl  0xc(%ebp)
  800bf7:	6a 58                	push   $0x58
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	ff d0                	call   *%eax
  800bfe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	6a 58                	push   $0x58
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	ff d0                	call   *%eax
  800c0e:	83 c4 10             	add    $0x10,%esp
			break;
  800c11:	e9 bc 00 00 00       	jmp    800cd2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	6a 30                	push   $0x30
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	6a 78                	push   $0x78
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	ff d0                	call   *%eax
  800c33:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c51:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c58:	eb 1f                	jmp    800c79 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5a:	83 ec 08             	sub    $0x8,%esp
  800c5d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c60:	8d 45 14             	lea    0x14(%ebp),%eax
  800c63:	50                   	push   %eax
  800c64:	e8 e7 fb ff ff       	call   800850 <getuint>
  800c69:	83 c4 10             	add    $0x10,%esp
  800c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c72:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c79:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c80:	83 ec 04             	sub    $0x4,%esp
  800c83:	52                   	push   %edx
  800c84:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c87:	50                   	push   %eax
  800c88:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8b:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 00 fb ff ff       	call   800799 <printnum>
  800c99:	83 c4 20             	add    $0x20,%esp
			break;
  800c9c:	eb 34                	jmp    800cd2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9e:	83 ec 08             	sub    $0x8,%esp
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	53                   	push   %ebx
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	ff d0                	call   *%eax
  800caa:	83 c4 10             	add    $0x10,%esp
			break;
  800cad:	eb 23                	jmp    800cd2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	6a 25                	push   $0x25
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	ff d0                	call   *%eax
  800cbc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cbf:	ff 4d 10             	decl   0x10(%ebp)
  800cc2:	eb 03                	jmp    800cc7 <vprintfmt+0x3b1>
  800cc4:	ff 4d 10             	decl   0x10(%ebp)
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	48                   	dec    %eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	3c 25                	cmp    $0x25,%al
  800ccf:	75 f3                	jne    800cc4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd1:	90                   	nop
		}
	}
  800cd2:	e9 47 fc ff ff       	jmp    80091e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce8:	83 c0 04             	add    $0x4,%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf4:	50                   	push   %eax
  800cf5:	ff 75 0c             	pushl  0xc(%ebp)
  800cf8:	ff 75 08             	pushl  0x8(%ebp)
  800cfb:	e8 16 fc ff ff       	call   800916 <vprintfmt>
  800d00:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d03:	90                   	nop
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	8b 40 08             	mov    0x8(%eax),%eax
  800d0f:	8d 50 01             	lea    0x1(%eax),%edx
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8b 10                	mov    (%eax),%edx
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8b 40 04             	mov    0x4(%eax),%eax
  800d23:	39 c2                	cmp    %eax,%edx
  800d25:	73 12                	jae    800d39 <sprintputch+0x33>
		*b->buf++ = ch;
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8b 00                	mov    (%eax),%eax
  800d2c:	8d 48 01             	lea    0x1(%eax),%ecx
  800d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d32:	89 0a                	mov    %ecx,(%edx)
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	88 10                	mov    %dl,(%eax)
}
  800d39:	90                   	nop
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d61:	74 06                	je     800d69 <vsnprintf+0x2d>
  800d63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d67:	7f 07                	jg     800d70 <vsnprintf+0x34>
		return -E_INVAL;
  800d69:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6e:	eb 20                	jmp    800d90 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d70:	ff 75 14             	pushl  0x14(%ebp)
  800d73:	ff 75 10             	pushl  0x10(%ebp)
  800d76:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d79:	50                   	push   %eax
  800d7a:	68 06 0d 80 00       	push   $0x800d06
  800d7f:	e8 92 fb ff ff       	call   800916 <vprintfmt>
  800d84:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d98:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9b:	83 c0 04             	add    $0x4,%eax
  800d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	ff 75 f4             	pushl  -0xc(%ebp)
  800da7:	50                   	push   %eax
  800da8:	ff 75 0c             	pushl  0xc(%ebp)
  800dab:	ff 75 08             	pushl  0x8(%ebp)
  800dae:	e8 89 ff ff ff       	call   800d3c <vsnprintf>
  800db3:	83 c4 10             	add    $0x10,%esp
  800db6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcb:	eb 06                	jmp    800dd3 <strlen+0x15>
		n++;
  800dcd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd0:	ff 45 08             	incl   0x8(%ebp)
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	84 c0                	test   %al,%al
  800dda:	75 f1                	jne    800dcd <strlen+0xf>
		n++;
	return n;
  800ddc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dee:	eb 09                	jmp    800df9 <strnlen+0x18>
		n++;
  800df0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df3:	ff 45 08             	incl   0x8(%ebp)
  800df6:	ff 4d 0c             	decl   0xc(%ebp)
  800df9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfd:	74 09                	je     800e08 <strnlen+0x27>
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	84 c0                	test   %al,%al
  800e06:	75 e8                	jne    800df0 <strnlen+0xf>
		n++;
	return n;
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e19:	90                   	nop
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 08             	mov    %edx,0x8(%ebp)
  800e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 e4                	jne    800e1a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4e:	eb 1f                	jmp    800e6f <strncpy+0x34>
		*dst++ = *src;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8d 50 01             	lea    0x1(%eax),%edx
  800e56:	89 55 08             	mov    %edx,0x8(%ebp)
  800e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5c:	8a 12                	mov    (%edx),%dl
  800e5e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	74 03                	je     800e6c <strncpy+0x31>
			src++;
  800e69:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6c:	ff 45 fc             	incl   -0x4(%ebp)
  800e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e72:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e75:	72 d9                	jb     800e50 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e77:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8c:	74 30                	je     800ebe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e8e:	eb 16                	jmp    800ea6 <strlcpy+0x2a>
			*dst++ = *src++;
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8d 50 01             	lea    0x1(%eax),%edx
  800e96:	89 55 08             	mov    %edx,0x8(%ebp)
  800e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea2:	8a 12                	mov    (%edx),%dl
  800ea4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea6:	ff 4d 10             	decl   0x10(%ebp)
  800ea9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ead:	74 09                	je     800eb8 <strlcpy+0x3c>
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	84 c0                	test   %al,%al
  800eb6:	75 d8                	jne    800e90 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec4:	29 c2                	sub    %eax,%edx
  800ec6:	89 d0                	mov    %edx,%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ecd:	eb 06                	jmp    800ed5 <strcmp+0xb>
		p++, q++;
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	84 c0                	test   %al,%al
  800edc:	74 0e                	je     800eec <strcmp+0x22>
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 10                	mov    (%eax),%dl
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	38 c2                	cmp    %al,%dl
  800eea:	74 e3                	je     800ecf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 d0             	movzbl %al,%edx
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	0f b6 c0             	movzbl %al,%eax
  800efc:	29 c2                	sub    %eax,%edx
  800efe:	89 d0                	mov    %edx,%eax
}
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    

00800f02 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f05:	eb 09                	jmp    800f10 <strncmp+0xe>
		n--, p++, q++;
  800f07:	ff 4d 10             	decl   0x10(%ebp)
  800f0a:	ff 45 08             	incl   0x8(%ebp)
  800f0d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f14:	74 17                	je     800f2d <strncmp+0x2b>
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	84 c0                	test   %al,%al
  800f1d:	74 0e                	je     800f2d <strncmp+0x2b>
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 10                	mov    (%eax),%dl
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	38 c2                	cmp    %al,%dl
  800f2b:	74 da                	je     800f07 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f31:	75 07                	jne    800f3a <strncmp+0x38>
		return 0;
  800f33:	b8 00 00 00 00       	mov    $0x0,%eax
  800f38:	eb 14                	jmp    800f4e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 04             	sub    $0x4,%esp
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5c:	eb 12                	jmp    800f70 <strchr+0x20>
		if (*s == c)
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f66:	75 05                	jne    800f6d <strchr+0x1d>
			return (char *) s;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	eb 11                	jmp    800f7e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f6d:	ff 45 08             	incl   0x8(%ebp)
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	84 c0                	test   %al,%al
  800f77:	75 e5                	jne    800f5e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 04             	sub    $0x4,%esp
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8c:	eb 0d                	jmp    800f9b <strfind+0x1b>
		if (*s == c)
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f96:	74 0e                	je     800fa6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	84 c0                	test   %al,%al
  800fa2:	75 ea                	jne    800f8e <strfind+0xe>
  800fa4:	eb 01                	jmp    800fa7 <strfind+0x27>
		if (*s == c)
			break;
  800fa6:	90                   	nop
	return (char *) s;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800faa:	c9                   	leave  
  800fab:	c3                   	ret    

00800fac <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fbe:	eb 0e                	jmp    800fce <memset+0x22>
		*p++ = c;
  800fc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc3:	8d 50 01             	lea    0x1(%eax),%edx
  800fc6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fce:	ff 4d f8             	decl   -0x8(%ebp)
  800fd1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd5:	79 e9                	jns    800fc0 <memset+0x14>
		*p++ = c;

	return v;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fee:	eb 16                	jmp    801006 <memcpy+0x2a>
		*d++ = *s++;
  800ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff3:	8d 50 01             	lea    0x1(%eax),%edx
  800ff6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801002:	8a 12                	mov    (%edx),%dl
  801004:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100c:	89 55 10             	mov    %edx,0x10(%ebp)
  80100f:	85 c0                	test   %eax,%eax
  801011:	75 dd                	jne    800ff0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801030:	73 50                	jae    801082 <memmove+0x6a>
  801032:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801035:	8b 45 10             	mov    0x10(%ebp),%eax
  801038:	01 d0                	add    %edx,%eax
  80103a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103d:	76 43                	jbe    801082 <memmove+0x6a>
		s += n;
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801045:	8b 45 10             	mov    0x10(%ebp),%eax
  801048:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104b:	eb 10                	jmp    80105d <memmove+0x45>
			*--d = *--s;
  80104d:	ff 4d f8             	decl   -0x8(%ebp)
  801050:	ff 4d fc             	decl   -0x4(%ebp)
  801053:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801056:	8a 10                	mov    (%eax),%dl
  801058:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	8d 50 ff             	lea    -0x1(%eax),%edx
  801063:	89 55 10             	mov    %edx,0x10(%ebp)
  801066:	85 c0                	test   %eax,%eax
  801068:	75 e3                	jne    80104d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106a:	eb 23                	jmp    80108f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106f:	8d 50 01             	lea    0x1(%eax),%edx
  801072:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801075:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801078:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107e:	8a 12                	mov    (%edx),%dl
  801080:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801082:	8b 45 10             	mov    0x10(%ebp),%eax
  801085:	8d 50 ff             	lea    -0x1(%eax),%edx
  801088:	89 55 10             	mov    %edx,0x10(%ebp)
  80108b:	85 c0                	test   %eax,%eax
  80108d:	75 dd                	jne    80106c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a6:	eb 2a                	jmp    8010d2 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ab:	8a 10                	mov    (%eax),%dl
  8010ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	38 c2                	cmp    %al,%dl
  8010b4:	74 16                	je     8010cc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f b6 d0             	movzbl %al,%edx
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	0f b6 c0             	movzbl %al,%eax
  8010c6:	29 c2                	sub    %eax,%edx
  8010c8:	89 d0                	mov    %edx,%eax
  8010ca:	eb 18                	jmp    8010e4 <memcmp+0x50>
		s1++, s2++;
  8010cc:	ff 45 fc             	incl   -0x4(%ebp)
  8010cf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d8:	89 55 10             	mov    %edx,0x10(%ebp)
  8010db:	85 c0                	test   %eax,%eax
  8010dd:	75 c9                	jne    8010a8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	01 d0                	add    %edx,%eax
  8010f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f7:	eb 15                	jmp    80110e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d0             	movzbl %al,%edx
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	0f b6 c0             	movzbl %al,%eax
  801107:	39 c2                	cmp    %eax,%edx
  801109:	74 0d                	je     801118 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110b:	ff 45 08             	incl   0x8(%ebp)
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801114:	72 e3                	jb     8010f9 <memfind+0x13>
  801116:	eb 01                	jmp    801119 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801118:	90                   	nop
	return (void *) s;
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801132:	eb 03                	jmp    801137 <strtol+0x19>
		s++;
  801134:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	3c 20                	cmp    $0x20,%al
  80113e:	74 f4                	je     801134 <strtol+0x16>
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	3c 09                	cmp    $0x9,%al
  801147:	74 eb                	je     801134 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 2b                	cmp    $0x2b,%al
  801150:	75 05                	jne    801157 <strtol+0x39>
		s++;
  801152:	ff 45 08             	incl   0x8(%ebp)
  801155:	eb 13                	jmp    80116a <strtol+0x4c>
	else if (*s == '-')
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 2d                	cmp    $0x2d,%al
  80115e:	75 0a                	jne    80116a <strtol+0x4c>
		s++, neg = 1;
  801160:	ff 45 08             	incl   0x8(%ebp)
  801163:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116e:	74 06                	je     801176 <strtol+0x58>
  801170:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801174:	75 20                	jne    801196 <strtol+0x78>
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 30                	cmp    $0x30,%al
  80117d:	75 17                	jne    801196 <strtol+0x78>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	40                   	inc    %eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 78                	cmp    $0x78,%al
  801187:	75 0d                	jne    801196 <strtol+0x78>
		s += 2, base = 16;
  801189:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801194:	eb 28                	jmp    8011be <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801196:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119a:	75 15                	jne    8011b1 <strtol+0x93>
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	3c 30                	cmp    $0x30,%al
  8011a3:	75 0c                	jne    8011b1 <strtol+0x93>
		s++, base = 8;
  8011a5:	ff 45 08             	incl   0x8(%ebp)
  8011a8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011af:	eb 0d                	jmp    8011be <strtol+0xa0>
	else if (base == 0)
  8011b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b5:	75 07                	jne    8011be <strtol+0xa0>
		base = 10;
  8011b7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3c 2f                	cmp    $0x2f,%al
  8011c5:	7e 19                	jle    8011e0 <strtol+0xc2>
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 39                	cmp    $0x39,%al
  8011ce:	7f 10                	jg     8011e0 <strtol+0xc2>
			dig = *s - '0';
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f be c0             	movsbl %al,%eax
  8011d8:	83 e8 30             	sub    $0x30,%eax
  8011db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011de:	eb 42                	jmp    801222 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 60                	cmp    $0x60,%al
  8011e7:	7e 19                	jle    801202 <strtol+0xe4>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 7a                	cmp    $0x7a,%al
  8011f0:	7f 10                	jg     801202 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f be c0             	movsbl %al,%eax
  8011fa:	83 e8 57             	sub    $0x57,%eax
  8011fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801200:	eb 20                	jmp    801222 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 40                	cmp    $0x40,%al
  801209:	7e 39                	jle    801244 <strtol+0x126>
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 5a                	cmp    $0x5a,%al
  801212:	7f 30                	jg     801244 <strtol+0x126>
			dig = *s - 'A' + 10;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	0f be c0             	movsbl %al,%eax
  80121c:	83 e8 37             	sub    $0x37,%eax
  80121f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801225:	3b 45 10             	cmp    0x10(%ebp),%eax
  801228:	7d 19                	jge    801243 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122a:	ff 45 08             	incl   0x8(%ebp)
  80122d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801230:	0f af 45 10          	imul   0x10(%ebp),%eax
  801234:	89 c2                	mov    %eax,%edx
  801236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801239:	01 d0                	add    %edx,%eax
  80123b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123e:	e9 7b ff ff ff       	jmp    8011be <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801243:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801244:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801248:	74 08                	je     801252 <strtol+0x134>
		*endptr = (char *) s;
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	8b 55 08             	mov    0x8(%ebp),%edx
  801250:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801252:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801256:	74 07                	je     80125f <strtol+0x141>
  801258:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125b:	f7 d8                	neg    %eax
  80125d:	eb 03                	jmp    801262 <strtol+0x144>
  80125f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <ltostr>:

void
ltostr(long value, char *str)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801271:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801278:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127c:	79 13                	jns    801291 <ltostr+0x2d>
	{
		neg = 1;
  80127e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801299:	99                   	cltd   
  80129a:	f7 f9                	idiv   %ecx
  80129c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b2:	83 c2 30             	add    $0x30,%edx
  8012b5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ba:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012bf:	f7 e9                	imul   %ecx
  8012c1:	c1 fa 02             	sar    $0x2,%edx
  8012c4:	89 c8                	mov    %ecx,%eax
  8012c6:	c1 f8 1f             	sar    $0x1f,%eax
  8012c9:	29 c2                	sub    %eax,%edx
  8012cb:	89 d0                	mov    %edx,%eax
  8012cd:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d8:	f7 e9                	imul   %ecx
  8012da:	c1 fa 02             	sar    $0x2,%edx
  8012dd:	89 c8                	mov    %ecx,%eax
  8012df:	c1 f8 1f             	sar    $0x1f,%eax
  8012e2:	29 c2                	sub    %eax,%edx
  8012e4:	89 d0                	mov    %edx,%eax
  8012e6:	c1 e0 02             	shl    $0x2,%eax
  8012e9:	01 d0                	add    %edx,%eax
  8012eb:	01 c0                	add    %eax,%eax
  8012ed:	29 c1                	sub    %eax,%ecx
  8012ef:	89 ca                	mov    %ecx,%edx
  8012f1:	85 d2                	test   %edx,%edx
  8012f3:	75 9c                	jne    801291 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ff:	48                   	dec    %eax
  801300:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801303:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801307:	74 3d                	je     801346 <ltostr+0xe2>
		start = 1 ;
  801309:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801310:	eb 34                	jmp    801346 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801315:	8b 45 0c             	mov    0xc(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80131f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	01 c2                	add    %eax,%edx
  801327:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	01 c8                	add    %ecx,%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801333:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	01 c2                	add    %eax,%edx
  80133b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133e:	88 02                	mov    %al,(%edx)
		start++ ;
  801340:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801343:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801349:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134c:	7c c4                	jl     801312 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801359:	90                   	nop
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801362:	ff 75 08             	pushl  0x8(%ebp)
  801365:	e8 54 fa ff ff       	call   800dbe <strlen>
  80136a:	83 c4 04             	add    $0x4,%esp
  80136d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	e8 46 fa ff ff       	call   800dbe <strlen>
  801378:	83 c4 04             	add    $0x4,%esp
  80137b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138c:	eb 17                	jmp    8013a5 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	01 c2                	add    %eax,%edx
  801396:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a2:	ff 45 fc             	incl   -0x4(%ebp)
  8013a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ab:	7c e1                	jl     80138e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bb:	eb 1f                	jmp    8013dc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c0:	8d 50 01             	lea    0x1(%eax),%edx
  8013c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c6:	89 c2                	mov    %eax,%edx
  8013c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cb:	01 c2                	add    %eax,%edx
  8013cd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d3:	01 c8                	add    %ecx,%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013d9:	ff 45 f8             	incl   -0x8(%ebp)
  8013dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e2:	7c d9                	jl     8013bd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	c6 00 00             	movb   $0x0,(%eax)
}
  8013ef:	90                   	nop
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801401:	8b 00                	mov    (%eax),%eax
  801403:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140a:	8b 45 10             	mov    0x10(%ebp),%eax
  80140d:	01 d0                	add    %edx,%eax
  80140f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801415:	eb 0c                	jmp    801423 <strsplit+0x31>
			*string++ = 0;
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 08             	mov    %edx,0x8(%ebp)
  801420:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	84 c0                	test   %al,%al
  80142a:	74 18                	je     801444 <strsplit+0x52>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	0f be c0             	movsbl %al,%eax
  801434:	50                   	push   %eax
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	e8 13 fb ff ff       	call   800f50 <strchr>
  80143d:	83 c4 08             	add    $0x8,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	75 d3                	jne    801417 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	84 c0                	test   %al,%al
  80144b:	74 5a                	je     8014a7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144d:	8b 45 14             	mov    0x14(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	83 f8 0f             	cmp    $0xf,%eax
  801455:	75 07                	jne    80145e <strsplit+0x6c>
		{
			return 0;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
  80145c:	eb 66                	jmp    8014c4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	8d 48 01             	lea    0x1(%eax),%ecx
  801466:	8b 55 14             	mov    0x14(%ebp),%edx
  801469:	89 0a                	mov    %ecx,(%edx)
  80146b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801472:	8b 45 10             	mov    0x10(%ebp),%eax
  801475:	01 c2                	add    %eax,%edx
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147c:	eb 03                	jmp    801481 <strsplit+0x8f>
			string++;
  80147e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	84 c0                	test   %al,%al
  801488:	74 8b                	je     801415 <strsplit+0x23>
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	0f be c0             	movsbl %al,%eax
  801492:	50                   	push   %eax
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	e8 b5 fa ff ff       	call   800f50 <strchr>
  80149b:	83 c4 08             	add    $0x8,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	74 dc                	je     80147e <strsplit+0x8c>
			string++;
	}
  8014a2:	e9 6e ff ff ff       	jmp    801415 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ab:	8b 00                	mov    (%eax),%eax
  8014ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	68 90 26 80 00       	push   $0x802690
  8014d4:	6a 0e                	push   $0xe
  8014d6:	68 ca 26 80 00       	push   $0x8026ca
  8014db:	e8 a8 ef ff ff       	call   800488 <_panic>

008014e0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8014e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	74 0f                	je     8014fe <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8014ef:	e8 d2 ff ff ff       	call   8014c6 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014f4:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8014fb:	00 00 00 
	}
	if (size == 0) return NULL ;
  8014fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801502:	75 07                	jne    80150b <malloc+0x2b>
  801504:	b8 00 00 00 00       	mov    $0x0,%eax
  801509:	eb 14                	jmp    80151f <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80150b:	83 ec 04             	sub    $0x4,%esp
  80150e:	68 d8 26 80 00       	push   $0x8026d8
  801513:	6a 2e                	push   $0x2e
  801515:	68 ca 26 80 00       	push   $0x8026ca
  80151a:	e8 69 ef ff ff       	call   800488 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	68 00 27 80 00       	push   $0x802700
  80152f:	6a 49                	push   $0x49
  801531:	68 ca 26 80 00       	push   $0x8026ca
  801536:	e8 4d ef ff ff       	call   800488 <_panic>

0080153b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
  801541:	8b 45 10             	mov    0x10(%ebp),%eax
  801544:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	68 24 27 80 00       	push   $0x802724
  80154f:	6a 57                	push   $0x57
  801551:	68 ca 26 80 00       	push   $0x8026ca
  801556:	e8 2d ef ff ff       	call   800488 <_panic>

0080155b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	68 4c 27 80 00       	push   $0x80274c
  801569:	6a 60                	push   $0x60
  80156b:	68 ca 26 80 00       	push   $0x8026ca
  801570:	e8 13 ef ff ff       	call   800488 <_panic>

00801575 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 70 27 80 00       	push   $0x802770
  801583:	6a 7c                	push   $0x7c
  801585:	68 ca 26 80 00       	push   $0x8026ca
  80158a:	e8 f9 ee ff ff       	call   800488 <_panic>

0080158f <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	68 98 27 80 00       	push   $0x802798
  80159d:	68 86 00 00 00       	push   $0x86
  8015a2:	68 ca 26 80 00       	push   $0x8026ca
  8015a7:	e8 dc ee ff ff       	call   800488 <_panic>

008015ac <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 bc 27 80 00       	push   $0x8027bc
  8015ba:	68 91 00 00 00       	push   $0x91
  8015bf:	68 ca 26 80 00       	push   $0x8026ca
  8015c4:	e8 bf ee ff ff       	call   800488 <_panic>

008015c9 <shrink>:

}
void shrink(uint32 newSize)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	68 bc 27 80 00       	push   $0x8027bc
  8015d7:	68 96 00 00 00       	push   $0x96
  8015dc:	68 ca 26 80 00       	push   $0x8026ca
  8015e1:	e8 a2 ee ff ff       	call   800488 <_panic>

008015e6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	68 bc 27 80 00       	push   $0x8027bc
  8015f4:	68 9b 00 00 00       	push   $0x9b
  8015f9:	68 ca 26 80 00       	push   $0x8026ca
  8015fe:	e8 85 ee ff ff       	call   800488 <_panic>

00801603 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801612:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801615:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801618:	8b 7d 18             	mov    0x18(%ebp),%edi
  80161b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80161e:	cd 30                	int    $0x30
  801620:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5f                   	pop    %edi
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    

0080162e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	8b 45 10             	mov    0x10(%ebp),%eax
  801637:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80163a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	52                   	push   %edx
  801646:	ff 75 0c             	pushl  0xc(%ebp)
  801649:	50                   	push   %eax
  80164a:	6a 00                	push   $0x0
  80164c:	e8 b2 ff ff ff       	call   801603 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	90                   	nop
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_cgetc>:

int
sys_cgetc(void)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 01                	push   $0x1
  801666:	e8 98 ff ff ff       	call   801603 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	52                   	push   %edx
  801680:	50                   	push   %eax
  801681:	6a 05                	push   $0x5
  801683:	e8 7b ff ff ff       	call   801603 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	56                   	push   %esi
  801691:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801692:	8b 75 18             	mov    0x18(%ebp),%esi
  801695:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801698:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80169b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
  8016a3:	51                   	push   %ecx
  8016a4:	52                   	push   %edx
  8016a5:	50                   	push   %eax
  8016a6:	6a 06                	push   $0x6
  8016a8:	e8 56 ff ff ff       	call   801603 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b3:	5b                   	pop    %ebx
  8016b4:	5e                   	pop    %esi
  8016b5:	5d                   	pop    %ebp
  8016b6:	c3                   	ret    

008016b7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	52                   	push   %edx
  8016c7:	50                   	push   %eax
  8016c8:	6a 07                	push   $0x7
  8016ca:	e8 34 ff ff ff       	call   801603 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	ff 75 08             	pushl  0x8(%ebp)
  8016e3:	6a 08                	push   $0x8
  8016e5:	e8 19 ff ff ff       	call   801603 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 09                	push   $0x9
  8016fe:	e8 00 ff ff ff       	call   801603 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 0a                	push   $0xa
  801717:	e8 e7 fe ff ff       	call   801603 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 0b                	push   $0xb
  801730:	e8 ce fe ff ff       	call   801603 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	6a 0f                	push   $0xf
  80174b:	e8 b3 fe ff ff       	call   801603 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
	return;
  801753:	90                   	nop
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	6a 10                	push   $0x10
  801767:	e8 97 fe ff ff       	call   801603 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
	return ;
  80176f:	90                   	nop
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	ff 75 10             	pushl  0x10(%ebp)
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	ff 75 08             	pushl  0x8(%ebp)
  801782:	6a 11                	push   $0x11
  801784:	e8 7a fe ff ff       	call   801603 <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
	return ;
  80178c:	90                   	nop
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 0c                	push   $0xc
  80179e:	e8 60 fe ff ff       	call   801603 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	6a 0d                	push   $0xd
  8017b8:	e8 46 fe ff ff       	call   801603 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 0e                	push   $0xe
  8017d1:	e8 2d fe ff ff       	call   801603 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	90                   	nop
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 13                	push   $0x13
  8017eb:	e8 13 fe ff ff       	call   801603 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	90                   	nop
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 14                	push   $0x14
  801805:	e8 f9 fd ff ff       	call   801603 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	90                   	nop
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_cputc>:


void
sys_cputc(const char c)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80181c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	50                   	push   %eax
  801829:	6a 15                	push   $0x15
  80182b:	e8 d3 fd ff ff       	call   801603 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	90                   	nop
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 16                	push   $0x16
  801845:	e8 b9 fd ff ff       	call   801603 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	90                   	nop
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	6a 17                	push   $0x17
  801862:	e8 9c fd ff ff       	call   801603 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 1a                	push   $0x1a
  80187f:	e8 7f fd ff ff       	call   801603 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 18                	push   $0x18
  80189c:	e8 62 fd ff ff       	call   801603 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	90                   	nop
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 19                	push   $0x19
  8018ba:	e8 44 fd ff ff       	call   801603 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	90                   	nop
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 04             	sub    $0x4,%esp
  8018cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018d4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	6a 00                	push   $0x0
  8018dd:	51                   	push   %ecx
  8018de:	52                   	push   %edx
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	50                   	push   %eax
  8018e3:	6a 1b                	push   $0x1b
  8018e5:	e8 19 fd ff ff       	call   801603 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	52                   	push   %edx
  8018ff:	50                   	push   %eax
  801900:	6a 1c                	push   $0x1c
  801902:	e8 fc fc ff ff       	call   801603 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80190f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801912:	8b 55 0c             	mov    0xc(%ebp),%edx
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	51                   	push   %ecx
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 1d                	push   $0x1d
  801921:	e8 dd fc ff ff       	call   801603 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80192e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	52                   	push   %edx
  80193b:	50                   	push   %eax
  80193c:	6a 1e                	push   $0x1e
  80193e:	e8 c0 fc ff ff       	call   801603 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 1f                	push   $0x1f
  801957:	e8 a7 fc ff ff       	call   801603 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	6a 00                	push   $0x0
  801969:	ff 75 14             	pushl  0x14(%ebp)
  80196c:	ff 75 10             	pushl  0x10(%ebp)
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	50                   	push   %eax
  801973:	6a 20                	push   $0x20
  801975:	e8 89 fc ff ff       	call   801603 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	50                   	push   %eax
  80198e:	6a 21                	push   $0x21
  801990:	e8 6e fc ff ff       	call   801603 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	50                   	push   %eax
  8019aa:	6a 22                	push   $0x22
  8019ac:	e8 52 fc ff ff       	call   801603 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 02                	push   $0x2
  8019c5:	e8 39 fc ff ff       	call   801603 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 03                	push   $0x3
  8019de:	e8 20 fc ff ff       	call   801603 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 04                	push   $0x4
  8019f7:	e8 07 fc ff ff       	call   801603 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_exit_env>:


void sys_exit_env(void)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 23                	push   $0x23
  801a10:	e8 ee fb ff ff       	call   801603 <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	90                   	nop
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a21:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a24:	8d 50 04             	lea    0x4(%eax),%edx
  801a27:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	52                   	push   %edx
  801a31:	50                   	push   %eax
  801a32:	6a 24                	push   $0x24
  801a34:	e8 ca fb ff ff       	call   801603 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
	return result;
  801a3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a45:	89 01                	mov    %eax,(%ecx)
  801a47:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	c9                   	leave  
  801a4e:	c2 04 00             	ret    $0x4

00801a51 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	ff 75 10             	pushl  0x10(%ebp)
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	6a 12                	push   $0x12
  801a63:	e8 9b fb ff ff       	call   801603 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6b:	90                   	nop
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_rcr2>:
uint32 sys_rcr2()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 25                	push   $0x25
  801a7d:	e8 81 fb ff ff       	call   801603 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a93:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	50                   	push   %eax
  801aa0:	6a 26                	push   $0x26
  801aa2:	e8 5c fb ff ff       	call   801603 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aaa:	90                   	nop
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <rsttst>:
void rsttst()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 28                	push   $0x28
  801abc:	e8 42 fb ff ff       	call   801603 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac4:	90                   	nop
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ad3:	8b 55 18             	mov    0x18(%ebp),%edx
  801ad6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ada:	52                   	push   %edx
  801adb:	50                   	push   %eax
  801adc:	ff 75 10             	pushl  0x10(%ebp)
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	6a 27                	push   $0x27
  801ae7:	e8 17 fb ff ff       	call   801603 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
	return ;
  801aef:	90                   	nop
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <chktst>:
void chktst(uint32 n)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 08             	pushl  0x8(%ebp)
  801b00:	6a 29                	push   $0x29
  801b02:	e8 fc fa ff ff       	call   801603 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0a:	90                   	nop
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <inctst>:

void inctst()
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 2a                	push   $0x2a
  801b1c:	e8 e2 fa ff ff       	call   801603 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
	return ;
  801b24:	90                   	nop
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <gettst>:
uint32 gettst()
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 2b                	push   $0x2b
  801b36:	e8 c8 fa ff ff       	call   801603 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 2c                	push   $0x2c
  801b52:	e8 ac fa ff ff       	call   801603 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
  801b5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b5d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b61:	75 07                	jne    801b6a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b63:	b8 01 00 00 00       	mov    $0x1,%eax
  801b68:	eb 05                	jmp    801b6f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 2c                	push   $0x2c
  801b83:	e8 7b fa ff ff       	call   801603 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
  801b8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b8e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b92:	75 07                	jne    801b9b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b94:	b8 01 00 00 00       	mov    $0x1,%eax
  801b99:	eb 05                	jmp    801ba0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 2c                	push   $0x2c
  801bb4:	e8 4a fa ff ff       	call   801603 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
  801bbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bbf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bc3:	75 07                	jne    801bcc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bca:	eb 05                	jmp    801bd1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 2c                	push   $0x2c
  801be5:	e8 19 fa ff ff       	call   801603 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
  801bed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bf0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bf4:	75 07                	jne    801bfd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfb:	eb 05                	jmp    801c02 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	6a 2d                	push   $0x2d
  801c14:	e8 ea f9 ff ff       	call   801603 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1c:	90                   	nop
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c23:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	53                   	push   %ebx
  801c32:	51                   	push   %ecx
  801c33:	52                   	push   %edx
  801c34:	50                   	push   %eax
  801c35:	6a 2e                	push   $0x2e
  801c37:	e8 c7 f9 ff ff       	call   801603 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	52                   	push   %edx
  801c54:	50                   	push   %eax
  801c55:	6a 2f                	push   $0x2f
  801c57:	e8 a7 f9 ff ff       	call   801603 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    
  801c61:	66 90                	xchg   %ax,%ax
  801c63:	90                   	nop

00801c64 <__udivdi3>:
  801c64:	55                   	push   %ebp
  801c65:	57                   	push   %edi
  801c66:	56                   	push   %esi
  801c67:	53                   	push   %ebx
  801c68:	83 ec 1c             	sub    $0x1c,%esp
  801c6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7b:	89 ca                	mov    %ecx,%edx
  801c7d:	89 f8                	mov    %edi,%eax
  801c7f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c83:	85 f6                	test   %esi,%esi
  801c85:	75 2d                	jne    801cb4 <__udivdi3+0x50>
  801c87:	39 cf                	cmp    %ecx,%edi
  801c89:	77 65                	ja     801cf0 <__udivdi3+0x8c>
  801c8b:	89 fd                	mov    %edi,%ebp
  801c8d:	85 ff                	test   %edi,%edi
  801c8f:	75 0b                	jne    801c9c <__udivdi3+0x38>
  801c91:	b8 01 00 00 00       	mov    $0x1,%eax
  801c96:	31 d2                	xor    %edx,%edx
  801c98:	f7 f7                	div    %edi
  801c9a:	89 c5                	mov    %eax,%ebp
  801c9c:	31 d2                	xor    %edx,%edx
  801c9e:	89 c8                	mov    %ecx,%eax
  801ca0:	f7 f5                	div    %ebp
  801ca2:	89 c1                	mov    %eax,%ecx
  801ca4:	89 d8                	mov    %ebx,%eax
  801ca6:	f7 f5                	div    %ebp
  801ca8:	89 cf                	mov    %ecx,%edi
  801caa:	89 fa                	mov    %edi,%edx
  801cac:	83 c4 1c             	add    $0x1c,%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5f                   	pop    %edi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
  801cb4:	39 ce                	cmp    %ecx,%esi
  801cb6:	77 28                	ja     801ce0 <__udivdi3+0x7c>
  801cb8:	0f bd fe             	bsr    %esi,%edi
  801cbb:	83 f7 1f             	xor    $0x1f,%edi
  801cbe:	75 40                	jne    801d00 <__udivdi3+0x9c>
  801cc0:	39 ce                	cmp    %ecx,%esi
  801cc2:	72 0a                	jb     801cce <__udivdi3+0x6a>
  801cc4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cc8:	0f 87 9e 00 00 00    	ja     801d6c <__udivdi3+0x108>
  801cce:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd3:	89 fa                	mov    %edi,%edx
  801cd5:	83 c4 1c             	add    $0x1c,%esp
  801cd8:	5b                   	pop    %ebx
  801cd9:	5e                   	pop    %esi
  801cda:	5f                   	pop    %edi
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    
  801cdd:	8d 76 00             	lea    0x0(%esi),%esi
  801ce0:	31 ff                	xor    %edi,%edi
  801ce2:	31 c0                	xor    %eax,%eax
  801ce4:	89 fa                	mov    %edi,%edx
  801ce6:	83 c4 1c             	add    $0x1c,%esp
  801ce9:	5b                   	pop    %ebx
  801cea:	5e                   	pop    %esi
  801ceb:	5f                   	pop    %edi
  801cec:	5d                   	pop    %ebp
  801ced:	c3                   	ret    
  801cee:	66 90                	xchg   %ax,%ax
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	f7 f7                	div    %edi
  801cf4:	31 ff                	xor    %edi,%edi
  801cf6:	89 fa                	mov    %edi,%edx
  801cf8:	83 c4 1c             	add    $0x1c,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    
  801d00:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d05:	89 eb                	mov    %ebp,%ebx
  801d07:	29 fb                	sub    %edi,%ebx
  801d09:	89 f9                	mov    %edi,%ecx
  801d0b:	d3 e6                	shl    %cl,%esi
  801d0d:	89 c5                	mov    %eax,%ebp
  801d0f:	88 d9                	mov    %bl,%cl
  801d11:	d3 ed                	shr    %cl,%ebp
  801d13:	89 e9                	mov    %ebp,%ecx
  801d15:	09 f1                	or     %esi,%ecx
  801d17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d1b:	89 f9                	mov    %edi,%ecx
  801d1d:	d3 e0                	shl    %cl,%eax
  801d1f:	89 c5                	mov    %eax,%ebp
  801d21:	89 d6                	mov    %edx,%esi
  801d23:	88 d9                	mov    %bl,%cl
  801d25:	d3 ee                	shr    %cl,%esi
  801d27:	89 f9                	mov    %edi,%ecx
  801d29:	d3 e2                	shl    %cl,%edx
  801d2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d2f:	88 d9                	mov    %bl,%cl
  801d31:	d3 e8                	shr    %cl,%eax
  801d33:	09 c2                	or     %eax,%edx
  801d35:	89 d0                	mov    %edx,%eax
  801d37:	89 f2                	mov    %esi,%edx
  801d39:	f7 74 24 0c          	divl   0xc(%esp)
  801d3d:	89 d6                	mov    %edx,%esi
  801d3f:	89 c3                	mov    %eax,%ebx
  801d41:	f7 e5                	mul    %ebp
  801d43:	39 d6                	cmp    %edx,%esi
  801d45:	72 19                	jb     801d60 <__udivdi3+0xfc>
  801d47:	74 0b                	je     801d54 <__udivdi3+0xf0>
  801d49:	89 d8                	mov    %ebx,%eax
  801d4b:	31 ff                	xor    %edi,%edi
  801d4d:	e9 58 ff ff ff       	jmp    801caa <__udivdi3+0x46>
  801d52:	66 90                	xchg   %ax,%ax
  801d54:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d58:	89 f9                	mov    %edi,%ecx
  801d5a:	d3 e2                	shl    %cl,%edx
  801d5c:	39 c2                	cmp    %eax,%edx
  801d5e:	73 e9                	jae    801d49 <__udivdi3+0xe5>
  801d60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d63:	31 ff                	xor    %edi,%edi
  801d65:	e9 40 ff ff ff       	jmp    801caa <__udivdi3+0x46>
  801d6a:	66 90                	xchg   %ax,%ax
  801d6c:	31 c0                	xor    %eax,%eax
  801d6e:	e9 37 ff ff ff       	jmp    801caa <__udivdi3+0x46>
  801d73:	90                   	nop

00801d74 <__umoddi3>:
  801d74:	55                   	push   %ebp
  801d75:	57                   	push   %edi
  801d76:	56                   	push   %esi
  801d77:	53                   	push   %ebx
  801d78:	83 ec 1c             	sub    $0x1c,%esp
  801d7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d93:	89 f3                	mov    %esi,%ebx
  801d95:	89 fa                	mov    %edi,%edx
  801d97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d9b:	89 34 24             	mov    %esi,(%esp)
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	75 1a                	jne    801dbc <__umoddi3+0x48>
  801da2:	39 f7                	cmp    %esi,%edi
  801da4:	0f 86 a2 00 00 00    	jbe    801e4c <__umoddi3+0xd8>
  801daa:	89 c8                	mov    %ecx,%eax
  801dac:	89 f2                	mov    %esi,%edx
  801dae:	f7 f7                	div    %edi
  801db0:	89 d0                	mov    %edx,%eax
  801db2:	31 d2                	xor    %edx,%edx
  801db4:	83 c4 1c             	add    $0x1c,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    
  801dbc:	39 f0                	cmp    %esi,%eax
  801dbe:	0f 87 ac 00 00 00    	ja     801e70 <__umoddi3+0xfc>
  801dc4:	0f bd e8             	bsr    %eax,%ebp
  801dc7:	83 f5 1f             	xor    $0x1f,%ebp
  801dca:	0f 84 ac 00 00 00    	je     801e7c <__umoddi3+0x108>
  801dd0:	bf 20 00 00 00       	mov    $0x20,%edi
  801dd5:	29 ef                	sub    %ebp,%edi
  801dd7:	89 fe                	mov    %edi,%esi
  801dd9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ddd:	89 e9                	mov    %ebp,%ecx
  801ddf:	d3 e0                	shl    %cl,%eax
  801de1:	89 d7                	mov    %edx,%edi
  801de3:	89 f1                	mov    %esi,%ecx
  801de5:	d3 ef                	shr    %cl,%edi
  801de7:	09 c7                	or     %eax,%edi
  801de9:	89 e9                	mov    %ebp,%ecx
  801deb:	d3 e2                	shl    %cl,%edx
  801ded:	89 14 24             	mov    %edx,(%esp)
  801df0:	89 d8                	mov    %ebx,%eax
  801df2:	d3 e0                	shl    %cl,%eax
  801df4:	89 c2                	mov    %eax,%edx
  801df6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dfa:	d3 e0                	shl    %cl,%eax
  801dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e00:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e04:	89 f1                	mov    %esi,%ecx
  801e06:	d3 e8                	shr    %cl,%eax
  801e08:	09 d0                	or     %edx,%eax
  801e0a:	d3 eb                	shr    %cl,%ebx
  801e0c:	89 da                	mov    %ebx,%edx
  801e0e:	f7 f7                	div    %edi
  801e10:	89 d3                	mov    %edx,%ebx
  801e12:	f7 24 24             	mull   (%esp)
  801e15:	89 c6                	mov    %eax,%esi
  801e17:	89 d1                	mov    %edx,%ecx
  801e19:	39 d3                	cmp    %edx,%ebx
  801e1b:	0f 82 87 00 00 00    	jb     801ea8 <__umoddi3+0x134>
  801e21:	0f 84 91 00 00 00    	je     801eb8 <__umoddi3+0x144>
  801e27:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e2b:	29 f2                	sub    %esi,%edx
  801e2d:	19 cb                	sbb    %ecx,%ebx
  801e2f:	89 d8                	mov    %ebx,%eax
  801e31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e35:	d3 e0                	shl    %cl,%eax
  801e37:	89 e9                	mov    %ebp,%ecx
  801e39:	d3 ea                	shr    %cl,%edx
  801e3b:	09 d0                	or     %edx,%eax
  801e3d:	89 e9                	mov    %ebp,%ecx
  801e3f:	d3 eb                	shr    %cl,%ebx
  801e41:	89 da                	mov    %ebx,%edx
  801e43:	83 c4 1c             	add    $0x1c,%esp
  801e46:	5b                   	pop    %ebx
  801e47:	5e                   	pop    %esi
  801e48:	5f                   	pop    %edi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    
  801e4b:	90                   	nop
  801e4c:	89 fd                	mov    %edi,%ebp
  801e4e:	85 ff                	test   %edi,%edi
  801e50:	75 0b                	jne    801e5d <__umoddi3+0xe9>
  801e52:	b8 01 00 00 00       	mov    $0x1,%eax
  801e57:	31 d2                	xor    %edx,%edx
  801e59:	f7 f7                	div    %edi
  801e5b:	89 c5                	mov    %eax,%ebp
  801e5d:	89 f0                	mov    %esi,%eax
  801e5f:	31 d2                	xor    %edx,%edx
  801e61:	f7 f5                	div    %ebp
  801e63:	89 c8                	mov    %ecx,%eax
  801e65:	f7 f5                	div    %ebp
  801e67:	89 d0                	mov    %edx,%eax
  801e69:	e9 44 ff ff ff       	jmp    801db2 <__umoddi3+0x3e>
  801e6e:	66 90                	xchg   %ax,%ax
  801e70:	89 c8                	mov    %ecx,%eax
  801e72:	89 f2                	mov    %esi,%edx
  801e74:	83 c4 1c             	add    $0x1c,%esp
  801e77:	5b                   	pop    %ebx
  801e78:	5e                   	pop    %esi
  801e79:	5f                   	pop    %edi
  801e7a:	5d                   	pop    %ebp
  801e7b:	c3                   	ret    
  801e7c:	3b 04 24             	cmp    (%esp),%eax
  801e7f:	72 06                	jb     801e87 <__umoddi3+0x113>
  801e81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e85:	77 0f                	ja     801e96 <__umoddi3+0x122>
  801e87:	89 f2                	mov    %esi,%edx
  801e89:	29 f9                	sub    %edi,%ecx
  801e8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e8f:	89 14 24             	mov    %edx,(%esp)
  801e92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e96:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e9a:	8b 14 24             	mov    (%esp),%edx
  801e9d:	83 c4 1c             	add    $0x1c,%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    
  801ea5:	8d 76 00             	lea    0x0(%esi),%esi
  801ea8:	2b 04 24             	sub    (%esp),%eax
  801eab:	19 fa                	sbb    %edi,%edx
  801ead:	89 d1                	mov    %edx,%ecx
  801eaf:	89 c6                	mov    %eax,%esi
  801eb1:	e9 71 ff ff ff       	jmp    801e27 <__umoddi3+0xb3>
  801eb6:	66 90                	xchg   %ax,%ax
  801eb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ebc:	72 ea                	jb     801ea8 <__umoddi3+0x134>
  801ebe:	89 d9                	mov    %ebx,%ecx
  801ec0:	e9 62 ff ff ff       	jmp    801e27 <__umoddi3+0xb3>
