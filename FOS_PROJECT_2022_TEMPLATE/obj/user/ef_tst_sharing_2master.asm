
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 49 03 00 00       	call   80037f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  80008d:	68 c0 1f 80 00       	push   $0x801fc0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 1f 80 00       	push   $0x801fdc
  800099:	e8 30 04 00 00       	call   8004ce <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 92 16 00 00       	call   801735 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 fa 1f 80 00       	push   $0x801ffa
  8000b2:	e8 ca 14 00 00       	call   801581 <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 fc 1f 80 00       	push   $0x801ffc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 dc 1f 80 00       	push   $0x801fdc
  8000d5:	e8 f4 03 00 00       	call   8004ce <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 53 16 00 00       	call   801735 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 42 16 00 00       	call   801735 <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 3b 16 00 00       	call   801735 <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 60 20 80 00       	push   $0x802060
  800107:	6a 1b                	push   $0x1b
  800109:	68 dc 1f 80 00       	push   $0x801fdc
  80010e:	e8 bb 03 00 00       	call   8004ce <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 1d 16 00 00       	call   801735 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 f1 20 80 00       	push   $0x8020f1
  800127:	e8 55 14 00 00       	call   801581 <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 fc 1f 80 00       	push   $0x801ffc
  800143:	6a 20                	push   $0x20
  800145:	68 dc 1f 80 00       	push   $0x801fdc
  80014a:	e8 7f 03 00 00       	call   8004ce <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 de 15 00 00       	call   801735 <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 cd 15 00 00       	call   801735 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 c6 15 00 00       	call   801735 <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 60 20 80 00       	push   $0x802060
  80017c:	6a 21                	push   $0x21
  80017e:	68 dc 1f 80 00       	push   $0x801fdc
  800183:	e8 46 03 00 00       	call   8004ce <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 a8 15 00 00       	call   801735 <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 f3 20 80 00       	push   $0x8020f3
  80019c:	e8 e0 13 00 00       	call   801581 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 fc 1f 80 00       	push   $0x801ffc
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 dc 1f 80 00       	push   $0x801fdc
  8001bf:	e8 0a 03 00 00       	call   8004ce <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 69 15 00 00       	call   801735 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 f8 20 80 00       	push   $0x8020f8
  8001dd:	6a 27                	push   $0x27
  8001df:	68 dc 1f 80 00       	push   $0x801fdc
  8001e4:	e8 e5 02 00 00       	call   8004ce <_panic>

	*x = 10 ;
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f5:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800200:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	a1 20 30 80 00       	mov    0x803020,%eax
  80020d:	8b 40 74             	mov    0x74(%eax),%eax
  800210:	6a 32                	push   $0x32
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 80 21 80 00       	push   $0x802180
  800219:	e8 89 17 00 00       	call   8019a7 <sys_create_env>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800224:	a1 20 30 80 00       	mov    0x803020,%eax
  800229:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80022f:	89 c2                	mov    %eax,%edx
  800231:	a1 20 30 80 00       	mov    0x803020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	6a 32                	push   $0x32
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 80 21 80 00       	push   $0x802180
  800242:	e8 60 17 00 00       	call   8019a7 <sys_create_env>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80024d:	a1 20 30 80 00       	mov    0x803020,%eax
  800252:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	a1 20 30 80 00       	mov    0x803020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	6a 32                	push   $0x32
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 80 21 80 00       	push   $0x802180
  80026b:	e8 37 17 00 00       	call   8019a7 <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 78 18 00 00       	call   801af3 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 8e 21 80 00       	push   $0x80218e
  800287:	e8 f5 12 00 00       	call   801581 <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 28 17 00 00       	call   8019c5 <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 1a 17 00 00       	call   8019c5 <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 0c 17 00 00       	call   8019c5 <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 de 19 00 00       	call   801ca7 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 9c 18 00 00       	call   801b6d <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 9e 21 80 00       	push   $0x80219e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 dc 1f 80 00       	push   $0x801fdc
  8002e5:	e8 e4 01 00 00       	call   8004ce <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 ac 21 80 00       	push   $0x8021ac
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 dc 1f 80 00       	push   $0x801fdc
  800303:	e8 c6 01 00 00       	call   8004ce <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 fc 21 80 00       	push   $0x8021fc
  800310:	e8 6d 04 00 00       	call   800782 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 11 17 00 00       	call   801a2e <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 b5 16 00 00       	call   8019e1 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 a7 16 00 00       	call   8019e1 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 99 16 00 00       	call   8019e1 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 d7 16 00 00       	call   801a2e <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 56 22 80 00       	push   $0x802256
  80035f:	50                   	push   %eax
  800360:	e8 3c 12 00 00       	call   8015a1 <sget>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  80036b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 01             	lea    0x1(%eax),%edx
  800373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
	}
	return;
  800378:	90                   	nop
  800379:	90                   	nop
}
  80037a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800385:	e8 8b 16 00 00       	call   801a15 <sys_getenvindex>
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80038d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	01 c0                	add    %eax,%eax
  800394:	01 d0                	add    %edx,%eax
  800396:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	c1 e0 02             	shl    $0x2,%eax
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003ab:	01 c8                	add    %ecx,%eax
  8003ad:	c1 e0 02             	shl    $0x2,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	c1 e0 02             	shl    $0x2,%eax
  8003b5:	01 d0                	add    %edx,%eax
  8003b7:	c1 e0 03             	shl    $0x3,%eax
  8003ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003bf:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c9:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8003cf:	84 c0                	test   %al,%al
  8003d1:	74 0f                	je     8003e2 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8003d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d8:	05 18 da 01 00       	add    $0x1da18,%eax
  8003dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003e6:	7e 0a                	jle    8003f2 <libmain+0x73>
		binaryname = argv[0];
  8003e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003f2:	83 ec 08             	sub    $0x8,%esp
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 38 fc ff ff       	call   800038 <_main>
  800400:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800403:	e8 1a 14 00 00       	call   801822 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800408:	83 ec 0c             	sub    $0xc,%esp
  80040b:	68 7c 22 80 00       	push   $0x80227c
  800410:	e8 6d 03 00 00       	call   800782 <cprintf>
  800415:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800418:	a1 20 30 80 00       	mov    0x803020,%eax
  80041d:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800423:	a1 20 30 80 00       	mov    0x803020,%eax
  800428:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	52                   	push   %edx
  800432:	50                   	push   %eax
  800433:	68 a4 22 80 00       	push   $0x8022a4
  800438:	e8 45 03 00 00       	call   800782 <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800440:	a1 20 30 80 00       	mov    0x803020,%eax
  800445:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80044b:	a1 20 30 80 00       	mov    0x803020,%eax
  800450:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800456:	a1 20 30 80 00       	mov    0x803020,%eax
  80045b:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800461:	51                   	push   %ecx
  800462:	52                   	push   %edx
  800463:	50                   	push   %eax
  800464:	68 cc 22 80 00       	push   $0x8022cc
  800469:	e8 14 03 00 00       	call   800782 <cprintf>
  80046e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800471:	a1 20 30 80 00       	mov    0x803020,%eax
  800476:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	50                   	push   %eax
  800480:	68 24 23 80 00       	push   $0x802324
  800485:	e8 f8 02 00 00       	call   800782 <cprintf>
  80048a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	68 7c 22 80 00       	push   $0x80227c
  800495:	e8 e8 02 00 00       	call   800782 <cprintf>
  80049a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80049d:	e8 9a 13 00 00       	call   80183c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004a2:	e8 19 00 00 00       	call   8004c0 <exit>
}
  8004a7:	90                   	nop
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b0:	83 ec 0c             	sub    $0xc,%esp
  8004b3:	6a 00                	push   $0x0
  8004b5:	e8 27 15 00 00       	call   8019e1 <sys_destroy_env>
  8004ba:	83 c4 10             	add    $0x10,%esp
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <exit>:

void
exit(void)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004c6:	e8 7c 15 00 00       	call   801a47 <sys_exit_env>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8004d7:	83 c0 04             	add    $0x4,%eax
  8004da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004dd:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8004e2:	85 c0                	test   %eax,%eax
  8004e4:	74 16                	je     8004fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004e6:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	50                   	push   %eax
  8004ef:	68 38 23 80 00       	push   $0x802338
  8004f4:	e8 89 02 00 00       	call   800782 <cprintf>
  8004f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004fc:	a1 00 30 80 00       	mov    0x803000,%eax
  800501:	ff 75 0c             	pushl  0xc(%ebp)
  800504:	ff 75 08             	pushl  0x8(%ebp)
  800507:	50                   	push   %eax
  800508:	68 3d 23 80 00       	push   $0x80233d
  80050d:	e8 70 02 00 00       	call   800782 <cprintf>
  800512:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800515:	8b 45 10             	mov    0x10(%ebp),%eax
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	ff 75 f4             	pushl  -0xc(%ebp)
  80051e:	50                   	push   %eax
  80051f:	e8 f3 01 00 00       	call   800717 <vcprintf>
  800524:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	6a 00                	push   $0x0
  80052c:	68 59 23 80 00       	push   $0x802359
  800531:	e8 e1 01 00 00       	call   800717 <vcprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800539:	e8 82 ff ff ff       	call   8004c0 <exit>

	// should not return here
	while (1) ;
  80053e:	eb fe                	jmp    80053e <_panic+0x70>

00800540 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800546:	a1 20 30 80 00       	mov    0x803020,%eax
  80054b:	8b 50 74             	mov    0x74(%eax),%edx
  80054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800551:	39 c2                	cmp    %eax,%edx
  800553:	74 14                	je     800569 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 5c 23 80 00       	push   $0x80235c
  80055d:	6a 26                	push   $0x26
  80055f:	68 a8 23 80 00       	push   $0x8023a8
  800564:	e8 65 ff ff ff       	call   8004ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800569:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800570:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800577:	e9 c2 00 00 00       	jmp    80063e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	01 d0                	add    %edx,%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	85 c0                	test   %eax,%eax
  80058f:	75 08                	jne    800599 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800591:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800594:	e9 a2 00 00 00       	jmp    80063b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800599:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a7:	eb 69                	jmp    800612 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ae:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b7:	89 d0                	mov    %edx,%eax
  8005b9:	01 c0                	add    %eax,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	c1 e0 03             	shl    $0x3,%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8a 40 04             	mov    0x4(%eax),%al
  8005c5:	84 c0                	test   %al,%al
  8005c7:	75 46                	jne    80060f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ce:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005d7:	89 d0                	mov    %edx,%eax
  8005d9:	01 c0                	add    %eax,%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	c1 e0 03             	shl    $0x3,%eax
  8005e0:	01 c8                	add    %ecx,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	01 c8                	add    %ecx,%eax
  800600:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800602:	39 c2                	cmp    %eax,%edx
  800604:	75 09                	jne    80060f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800606:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80060d:	eb 12                	jmp    800621 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060f:	ff 45 e8             	incl   -0x18(%ebp)
  800612:	a1 20 30 80 00       	mov    0x803020,%eax
  800617:	8b 50 74             	mov    0x74(%eax),%edx
  80061a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	77 88                	ja     8005a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800621:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800625:	75 14                	jne    80063b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	68 b4 23 80 00       	push   $0x8023b4
  80062f:	6a 3a                	push   $0x3a
  800631:	68 a8 23 80 00       	push   $0x8023a8
  800636:	e8 93 fe ff ff       	call   8004ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80063b:	ff 45 f0             	incl   -0x10(%ebp)
  80063e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800641:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800644:	0f 8c 32 ff ff ff    	jl     80057c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80064a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800651:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800658:	eb 26                	jmp    800680 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80065a:	a1 20 30 80 00       	mov    0x803020,%eax
  80065f:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800665:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800668:	89 d0                	mov    %edx,%eax
  80066a:	01 c0                	add    %eax,%eax
  80066c:	01 d0                	add    %edx,%eax
  80066e:	c1 e0 03             	shl    $0x3,%eax
  800671:	01 c8                	add    %ecx,%eax
  800673:	8a 40 04             	mov    0x4(%eax),%al
  800676:	3c 01                	cmp    $0x1,%al
  800678:	75 03                	jne    80067d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80067a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80067d:	ff 45 e0             	incl   -0x20(%ebp)
  800680:	a1 20 30 80 00       	mov    0x803020,%eax
  800685:	8b 50 74             	mov    0x74(%eax),%edx
  800688:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068b:	39 c2                	cmp    %eax,%edx
  80068d:	77 cb                	ja     80065a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80068f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800692:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800695:	74 14                	je     8006ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800697:	83 ec 04             	sub    $0x4,%esp
  80069a:	68 08 24 80 00       	push   $0x802408
  80069f:	6a 44                	push   $0x44
  8006a1:	68 a8 23 80 00       	push   $0x8023a8
  8006a6:	e8 23 fe ff ff       	call   8004ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006ab:	90                   	nop
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8006bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bf:	89 0a                	mov    %ecx,(%edx)
  8006c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c4:	88 d1                	mov    %dl,%cl
  8006c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006d7:	75 2c                	jne    800705 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006d9:	a0 24 30 80 00       	mov    0x803024,%al
  8006de:	0f b6 c0             	movzbl %al,%eax
  8006e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e4:	8b 12                	mov    (%edx),%edx
  8006e6:	89 d1                	mov    %edx,%ecx
  8006e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006eb:	83 c2 08             	add    $0x8,%edx
  8006ee:	83 ec 04             	sub    $0x4,%esp
  8006f1:	50                   	push   %eax
  8006f2:	51                   	push   %ecx
  8006f3:	52                   	push   %edx
  8006f4:	e8 7b 0f 00 00       	call   801674 <sys_cputs>
  8006f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800705:	8b 45 0c             	mov    0xc(%ebp),%eax
  800708:	8b 40 04             	mov    0x4(%eax),%eax
  80070b:	8d 50 01             	lea    0x1(%eax),%edx
  80070e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800711:	89 50 04             	mov    %edx,0x4(%eax)
}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800720:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800727:	00 00 00 
	b.cnt = 0;
  80072a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800731:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	68 ae 06 80 00       	push   $0x8006ae
  800746:	e8 11 02 00 00       	call   80095c <vprintfmt>
  80074b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80074e:	a0 24 30 80 00       	mov    0x803024,%al
  800753:	0f b6 c0             	movzbl %al,%eax
  800756:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80075c:	83 ec 04             	sub    $0x4,%esp
  80075f:	50                   	push   %eax
  800760:	52                   	push   %edx
  800761:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800767:	83 c0 08             	add    $0x8,%eax
  80076a:	50                   	push   %eax
  80076b:	e8 04 0f 00 00       	call   801674 <sys_cputs>
  800770:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800773:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80077a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800780:	c9                   	leave  
  800781:	c3                   	ret    

00800782 <cprintf>:

int cprintf(const char *fmt, ...) {
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800788:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80078f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800792:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 f4             	pushl  -0xc(%ebp)
  80079e:	50                   	push   %eax
  80079f:	e8 73 ff ff ff       	call   800717 <vcprintf>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ad:	c9                   	leave  
  8007ae:	c3                   	ret    

008007af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007b5:	e8 68 10 00 00       	call   801822 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c9:	50                   	push   %eax
  8007ca:	e8 48 ff ff ff       	call   800717 <vcprintf>
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007d5:	e8 62 10 00 00       	call   80183c <sys_enable_interrupt>
	return cnt;
  8007da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007dd:	c9                   	leave  
  8007de:	c3                   	ret    

008007df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	53                   	push   %ebx
  8007e3:	83 ec 14             	sub    $0x14,%esp
  8007e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007fd:	77 55                	ja     800854 <printnum+0x75>
  8007ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800802:	72 05                	jb     800809 <printnum+0x2a>
  800804:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800807:	77 4b                	ja     800854 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800809:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80080c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80080f:	8b 45 18             	mov    0x18(%ebp),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
  800817:	52                   	push   %edx
  800818:	50                   	push   %eax
  800819:	ff 75 f4             	pushl  -0xc(%ebp)
  80081c:	ff 75 f0             	pushl  -0x10(%ebp)
  80081f:	e8 38 15 00 00       	call   801d5c <__udivdi3>
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	83 ec 04             	sub    $0x4,%esp
  80082a:	ff 75 20             	pushl  0x20(%ebp)
  80082d:	53                   	push   %ebx
  80082e:	ff 75 18             	pushl  0x18(%ebp)
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	e8 a1 ff ff ff       	call   8007df <printnum>
  80083e:	83 c4 20             	add    $0x20,%esp
  800841:	eb 1a                	jmp    80085d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	ff 75 20             	pushl  0x20(%ebp)
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800854:	ff 4d 1c             	decl   0x1c(%ebp)
  800857:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80085b:	7f e6                	jg     800843 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80085d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800860:	bb 00 00 00 00       	mov    $0x0,%ebx
  800865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086b:	53                   	push   %ebx
  80086c:	51                   	push   %ecx
  80086d:	52                   	push   %edx
  80086e:	50                   	push   %eax
  80086f:	e8 f8 15 00 00       	call   801e6c <__umoddi3>
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	05 74 26 80 00       	add    $0x802674,%eax
  80087c:	8a 00                	mov    (%eax),%al
  80087e:	0f be c0             	movsbl %al,%eax
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	50                   	push   %eax
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	ff d0                	call   *%eax
  80088d:	83 c4 10             	add    $0x10,%esp
}
  800890:	90                   	nop
  800891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800899:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089d:	7e 1c                	jle    8008bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	8d 50 08             	lea    0x8(%eax),%edx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	89 10                	mov    %edx,(%eax)
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	83 e8 08             	sub    $0x8,%eax
  8008b4:	8b 50 04             	mov    0x4(%eax),%edx
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	eb 40                	jmp    8008fb <getuint+0x65>
	else if (lflag)
  8008bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008bf:	74 1e                	je     8008df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 04             	lea    0x4(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 04             	sub    $0x4,%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dd:	eb 1c                	jmp    8008fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 04             	lea    0x4(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 04             	sub    $0x4,%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008fb:	5d                   	pop    %ebp
  8008fc:	c3                   	ret    

008008fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800900:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800904:	7e 1c                	jle    800922 <getint+0x25>
		return va_arg(*ap, long long);
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	8d 50 08             	lea    0x8(%eax),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 10                	mov    %edx,(%eax)
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	83 e8 08             	sub    $0x8,%eax
  80091b:	8b 50 04             	mov    0x4(%eax),%edx
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	eb 38                	jmp    80095a <getint+0x5d>
	else if (lflag)
  800922:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800926:	74 1a                	je     800942 <getint+0x45>
		return va_arg(*ap, long);
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	8d 50 04             	lea    0x4(%eax),%edx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	89 10                	mov    %edx,(%eax)
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	83 e8 04             	sub    $0x4,%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	99                   	cltd   
  800940:	eb 18                	jmp    80095a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	8d 50 04             	lea    0x4(%eax),%edx
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	89 10                	mov    %edx,(%eax)
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	83 e8 04             	sub    $0x4,%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	99                   	cltd   
}
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	56                   	push   %esi
  800960:	53                   	push   %ebx
  800961:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800964:	eb 17                	jmp    80097d <vprintfmt+0x21>
			if (ch == '\0')
  800966:	85 db                	test   %ebx,%ebx
  800968:	0f 84 af 03 00 00    	je     800d1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	53                   	push   %ebx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097d:	8b 45 10             	mov    0x10(%ebp),%eax
  800980:	8d 50 01             	lea    0x1(%eax),%edx
  800983:	89 55 10             	mov    %edx,0x10(%ebp)
  800986:	8a 00                	mov    (%eax),%al
  800988:	0f b6 d8             	movzbl %al,%ebx
  80098b:	83 fb 25             	cmp    $0x25,%ebx
  80098e:	75 d6                	jne    800966 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800990:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800994:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80099b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b3:	8d 50 01             	lea    0x1(%eax),%edx
  8009b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b9:	8a 00                	mov    (%eax),%al
  8009bb:	0f b6 d8             	movzbl %al,%ebx
  8009be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c1:	83 f8 55             	cmp    $0x55,%eax
  8009c4:	0f 87 2b 03 00 00    	ja     800cf5 <vprintfmt+0x399>
  8009ca:	8b 04 85 98 26 80 00 	mov    0x802698(,%eax,4),%eax
  8009d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009d7:	eb d7                	jmp    8009b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009dd:	eb d1                	jmp    8009b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e9:	89 d0                	mov    %edx,%eax
  8009eb:	c1 e0 02             	shl    $0x2,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	01 c0                	add    %eax,%eax
  8009f2:	01 d8                	add    %ebx,%eax
  8009f4:	83 e8 30             	sub    $0x30,%eax
  8009f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a02:	83 fb 2f             	cmp    $0x2f,%ebx
  800a05:	7e 3e                	jle    800a45 <vprintfmt+0xe9>
  800a07:	83 fb 39             	cmp    $0x39,%ebx
  800a0a:	7f 39                	jg     800a45 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a0f:	eb d5                	jmp    8009e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a11:	8b 45 14             	mov    0x14(%ebp),%eax
  800a14:	83 c0 04             	add    $0x4,%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	83 e8 04             	sub    $0x4,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a25:	eb 1f                	jmp    800a46 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2b:	79 83                	jns    8009b0 <vprintfmt+0x54>
				width = 0;
  800a2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a34:	e9 77 ff ff ff       	jmp    8009b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a39:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a40:	e9 6b ff ff ff       	jmp    8009b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a45:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4a:	0f 89 60 ff ff ff    	jns    8009b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a56:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a5d:	e9 4e ff ff ff       	jmp    8009b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a62:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a65:	e9 46 ff ff ff       	jmp    8009b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	83 c0 04             	add    $0x4,%eax
  800a70:	89 45 14             	mov    %eax,0x14(%ebp)
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	83 e8 04             	sub    $0x4,%eax
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	83 ec 08             	sub    $0x8,%esp
  800a7e:	ff 75 0c             	pushl  0xc(%ebp)
  800a81:	50                   	push   %eax
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	ff d0                	call   *%eax
  800a87:	83 c4 10             	add    $0x10,%esp
			break;
  800a8a:	e9 89 02 00 00       	jmp    800d18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	83 c0 04             	add    $0x4,%eax
  800a95:	89 45 14             	mov    %eax,0x14(%ebp)
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 e8 04             	sub    $0x4,%eax
  800a9e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa0:	85 db                	test   %ebx,%ebx
  800aa2:	79 02                	jns    800aa6 <vprintfmt+0x14a>
				err = -err;
  800aa4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aa6:	83 fb 64             	cmp    $0x64,%ebx
  800aa9:	7f 0b                	jg     800ab6 <vprintfmt+0x15a>
  800aab:	8b 34 9d e0 24 80 00 	mov    0x8024e0(,%ebx,4),%esi
  800ab2:	85 f6                	test   %esi,%esi
  800ab4:	75 19                	jne    800acf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ab6:	53                   	push   %ebx
  800ab7:	68 85 26 80 00       	push   $0x802685
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 5e 02 00 00       	call   800d25 <printfmt>
  800ac7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aca:	e9 49 02 00 00       	jmp    800d18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800acf:	56                   	push   %esi
  800ad0:	68 8e 26 80 00       	push   $0x80268e
  800ad5:	ff 75 0c             	pushl  0xc(%ebp)
  800ad8:	ff 75 08             	pushl  0x8(%ebp)
  800adb:	e8 45 02 00 00       	call   800d25 <printfmt>
  800ae0:	83 c4 10             	add    $0x10,%esp
			break;
  800ae3:	e9 30 02 00 00       	jmp    800d18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ae8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aeb:	83 c0 04             	add    $0x4,%eax
  800aee:	89 45 14             	mov    %eax,0x14(%ebp)
  800af1:	8b 45 14             	mov    0x14(%ebp),%eax
  800af4:	83 e8 04             	sub    $0x4,%eax
  800af7:	8b 30                	mov    (%eax),%esi
  800af9:	85 f6                	test   %esi,%esi
  800afb:	75 05                	jne    800b02 <vprintfmt+0x1a6>
				p = "(null)";
  800afd:	be 91 26 80 00       	mov    $0x802691,%esi
			if (width > 0 && padc != '-')
  800b02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b06:	7e 6d                	jle    800b75 <vprintfmt+0x219>
  800b08:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b0c:	74 67                	je     800b75 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	50                   	push   %eax
  800b15:	56                   	push   %esi
  800b16:	e8 0c 03 00 00       	call   800e27 <strnlen>
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b21:	eb 16                	jmp    800b39 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b23:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	50                   	push   %eax
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	ff d0                	call   *%eax
  800b33:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b36:	ff 4d e4             	decl   -0x1c(%ebp)
  800b39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3d:	7f e4                	jg     800b23 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3f:	eb 34                	jmp    800b75 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b41:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b45:	74 1c                	je     800b63 <vprintfmt+0x207>
  800b47:	83 fb 1f             	cmp    $0x1f,%ebx
  800b4a:	7e 05                	jle    800b51 <vprintfmt+0x1f5>
  800b4c:	83 fb 7e             	cmp    $0x7e,%ebx
  800b4f:	7e 12                	jle    800b63 <vprintfmt+0x207>
					putch('?', putdat);
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	6a 3f                	push   $0x3f
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ff d0                	call   *%eax
  800b5e:	83 c4 10             	add    $0x10,%esp
  800b61:	eb 0f                	jmp    800b72 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	53                   	push   %ebx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	ff d0                	call   *%eax
  800b6f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b72:	ff 4d e4             	decl   -0x1c(%ebp)
  800b75:	89 f0                	mov    %esi,%eax
  800b77:	8d 70 01             	lea    0x1(%eax),%esi
  800b7a:	8a 00                	mov    (%eax),%al
  800b7c:	0f be d8             	movsbl %al,%ebx
  800b7f:	85 db                	test   %ebx,%ebx
  800b81:	74 24                	je     800ba7 <vprintfmt+0x24b>
  800b83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b87:	78 b8                	js     800b41 <vprintfmt+0x1e5>
  800b89:	ff 4d e0             	decl   -0x20(%ebp)
  800b8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b90:	79 af                	jns    800b41 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b92:	eb 13                	jmp    800ba7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	6a 20                	push   $0x20
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	ff d0                	call   *%eax
  800ba1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bab:	7f e7                	jg     800b94 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bad:	e9 66 01 00 00       	jmp    800d18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbb:	50                   	push   %eax
  800bbc:	e8 3c fd ff ff       	call   8008fd <getint>
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd0:	85 d2                	test   %edx,%edx
  800bd2:	79 23                	jns    800bf7 <vprintfmt+0x29b>
				putch('-', putdat);
  800bd4:	83 ec 08             	sub    $0x8,%esp
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	6a 2d                	push   $0x2d
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	ff d0                	call   *%eax
  800be1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bea:	f7 d8                	neg    %eax
  800bec:	83 d2 00             	adc    $0x0,%edx
  800bef:	f7 da                	neg    %edx
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bf7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfe:	e9 bc 00 00 00       	jmp    800cbf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 e8             	pushl  -0x18(%ebp)
  800c09:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0c:	50                   	push   %eax
  800c0d:	e8 84 fc ff ff       	call   800896 <getuint>
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 98 00 00 00       	jmp    800cbf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 58                	push   $0x58
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 58                	push   $0x58
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 0c             	pushl  0xc(%ebp)
  800c4d:	6a 58                	push   $0x58
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	ff d0                	call   *%eax
  800c54:	83 c4 10             	add    $0x10,%esp
			break;
  800c57:	e9 bc 00 00 00       	jmp    800d18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	6a 30                	push   $0x30
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	ff d0                	call   *%eax
  800c69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 0c             	pushl  0xc(%ebp)
  800c72:	6a 78                	push   $0x78
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	ff d0                	call   *%eax
  800c79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7f:	83 c0 04             	add    $0x4,%eax
  800c82:	89 45 14             	mov    %eax,0x14(%ebp)
  800c85:	8b 45 14             	mov    0x14(%ebp),%eax
  800c88:	83 e8 04             	sub    $0x4,%eax
  800c8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c9e:	eb 1f                	jmp    800cbf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca0:	83 ec 08             	sub    $0x8,%esp
  800ca3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca9:	50                   	push   %eax
  800caa:	e8 e7 fb ff ff       	call   800896 <getuint>
  800caf:	83 c4 10             	add    $0x10,%esp
  800cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cb8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cbf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc6:	83 ec 04             	sub    $0x4,%esp
  800cc9:	52                   	push   %edx
  800cca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ccd:	50                   	push   %eax
  800cce:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd1:	ff 75 f0             	pushl  -0x10(%ebp)
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	ff 75 08             	pushl  0x8(%ebp)
  800cda:	e8 00 fb ff ff       	call   8007df <printnum>
  800cdf:	83 c4 20             	add    $0x20,%esp
			break;
  800ce2:	eb 34                	jmp    800d18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	53                   	push   %ebx
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
			break;
  800cf3:	eb 23                	jmp    800d18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	6a 25                	push   $0x25
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	ff d0                	call   *%eax
  800d02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d05:	ff 4d 10             	decl   0x10(%ebp)
  800d08:	eb 03                	jmp    800d0d <vprintfmt+0x3b1>
  800d0a:	ff 4d 10             	decl   0x10(%ebp)
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	48                   	dec    %eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	3c 25                	cmp    $0x25,%al
  800d15:	75 f3                	jne    800d0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d17:	90                   	nop
		}
	}
  800d18:	e9 47 fc ff ff       	jmp    800964 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2e:	83 c0 04             	add    $0x4,%eax
  800d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d34:	8b 45 10             	mov    0x10(%ebp),%eax
  800d37:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3a:	50                   	push   %eax
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	ff 75 08             	pushl  0x8(%ebp)
  800d41:	e8 16 fc ff ff       	call   80095c <vprintfmt>
  800d46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d49:	90                   	nop
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8b 40 08             	mov    0x8(%eax),%eax
  800d55:	8d 50 01             	lea    0x1(%eax),%edx
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	8b 10                	mov    (%eax),%edx
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 40 04             	mov    0x4(%eax),%eax
  800d69:	39 c2                	cmp    %eax,%edx
  800d6b:	73 12                	jae    800d7f <sprintputch+0x33>
		*b->buf++ = ch;
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	8d 48 01             	lea    0x1(%eax),%ecx
  800d75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d78:	89 0a                	mov    %ecx,(%edx)
  800d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7d:	88 10                	mov    %dl,(%eax)
}
  800d7f:	90                   	nop
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da7:	74 06                	je     800daf <vsnprintf+0x2d>
  800da9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dad:	7f 07                	jg     800db6 <vsnprintf+0x34>
		return -E_INVAL;
  800daf:	b8 03 00 00 00       	mov    $0x3,%eax
  800db4:	eb 20                	jmp    800dd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800db6:	ff 75 14             	pushl  0x14(%ebp)
  800db9:	ff 75 10             	pushl  0x10(%ebp)
  800dbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dbf:	50                   	push   %eax
  800dc0:	68 4c 0d 80 00       	push   $0x800d4c
  800dc5:	e8 92 fb ff ff       	call   80095c <vprintfmt>
  800dca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    

00800dd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dde:	8d 45 10             	lea    0x10(%ebp),%eax
  800de1:	83 c0 04             	add    $0x4,%eax
  800de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800de7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dea:	ff 75 f4             	pushl  -0xc(%ebp)
  800ded:	50                   	push   %eax
  800dee:	ff 75 0c             	pushl  0xc(%ebp)
  800df1:	ff 75 08             	pushl  0x8(%ebp)
  800df4:	e8 89 ff ff ff       	call   800d82 <vsnprintf>
  800df9:	83 c4 10             	add    $0x10,%esp
  800dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e11:	eb 06                	jmp    800e19 <strlen+0x15>
		n++;
  800e13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8a 00                	mov    (%eax),%al
  800e1e:	84 c0                	test   %al,%al
  800e20:	75 f1                	jne    800e13 <strlen+0xf>
		n++;
	return n;
  800e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e34:	eb 09                	jmp    800e3f <strnlen+0x18>
		n++;
  800e36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e39:	ff 45 08             	incl   0x8(%ebp)
  800e3c:	ff 4d 0c             	decl   0xc(%ebp)
  800e3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e43:	74 09                	je     800e4e <strnlen+0x27>
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	84 c0                	test   %al,%al
  800e4c:	75 e8                	jne    800e36 <strnlen+0xf>
		n++;
	return n;
  800e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e5f:	90                   	nop
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8d 50 01             	lea    0x1(%eax),%edx
  800e66:	89 55 08             	mov    %edx,0x8(%ebp)
  800e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e72:	8a 12                	mov    (%edx),%dl
  800e74:	88 10                	mov    %dl,(%eax)
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	84 c0                	test   %al,%al
  800e7a:	75 e4                	jne    800e60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e94:	eb 1f                	jmp    800eb5 <strncpy+0x34>
		*dst++ = *src;
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea2:	8a 12                	mov    (%edx),%dl
  800ea4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	84 c0                	test   %al,%al
  800ead:	74 03                	je     800eb2 <strncpy+0x31>
			src++;
  800eaf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
  800eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ebb:	72 d9                	jb     800e96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed2:	74 30                	je     800f04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ed4:	eb 16                	jmp    800eec <strlcpy+0x2a>
			*dst++ = *src++;
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 08             	mov    %edx,0x8(%ebp)
  800edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eec:	ff 4d 10             	decl   0x10(%ebp)
  800eef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef3:	74 09                	je     800efe <strlcpy+0x3c>
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	84 c0                	test   %al,%al
  800efc:	75 d8                	jne    800ed6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f04:	8b 55 08             	mov    0x8(%ebp),%edx
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	29 c2                	sub    %eax,%edx
  800f0c:	89 d0                	mov    %edx,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f13:	eb 06                	jmp    800f1b <strcmp+0xb>
		p++, q++;
  800f15:	ff 45 08             	incl   0x8(%ebp)
  800f18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	84 c0                	test   %al,%al
  800f22:	74 0e                	je     800f32 <strcmp+0x22>
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 10                	mov    (%eax),%dl
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	38 c2                	cmp    %al,%dl
  800f30:	74 e3                	je     800f15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f b6 d0             	movzbl %al,%edx
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 c0             	movzbl %al,%eax
  800f42:	29 c2                	sub    %eax,%edx
  800f44:	89 d0                	mov    %edx,%eax
}
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    

00800f48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f4b:	eb 09                	jmp    800f56 <strncmp+0xe>
		n--, p++, q++;
  800f4d:	ff 4d 10             	decl   0x10(%ebp)
  800f50:	ff 45 08             	incl   0x8(%ebp)
  800f53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5a:	74 17                	je     800f73 <strncmp+0x2b>
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	84 c0                	test   %al,%al
  800f63:	74 0e                	je     800f73 <strncmp+0x2b>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 10                	mov    (%eax),%dl
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	38 c2                	cmp    %al,%dl
  800f71:	74 da                	je     800f4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f77:	75 07                	jne    800f80 <strncmp+0x38>
		return 0;
  800f79:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7e:	eb 14                	jmp    800f94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f b6 d0             	movzbl %al,%edx
  800f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 c0             	movzbl %al,%eax
  800f90:	29 c2                	sub    %eax,%edx
  800f92:	89 d0                	mov    %edx,%eax
}
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 04             	sub    $0x4,%esp
  800f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa2:	eb 12                	jmp    800fb6 <strchr+0x20>
		if (*s == c)
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fac:	75 05                	jne    800fb3 <strchr+0x1d>
			return (char *) s;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	eb 11                	jmp    800fc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	84 c0                	test   %al,%al
  800fbd:	75 e5                	jne    800fa4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc4:	c9                   	leave  
  800fc5:	c3                   	ret    

00800fc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd2:	eb 0d                	jmp    800fe1 <strfind+0x1b>
		if (*s == c)
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fdc:	74 0e                	je     800fec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fde:	ff 45 08             	incl   0x8(%ebp)
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	84 c0                	test   %al,%al
  800fe8:	75 ea                	jne    800fd4 <strfind+0xe>
  800fea:	eb 01                	jmp    800fed <strfind+0x27>
		if (*s == c)
			break;
  800fec:	90                   	nop
	return (char *) s;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  801001:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801004:	eb 0e                	jmp    801014 <memset+0x22>
		*p++ = c;
  801006:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801009:	8d 50 01             	lea    0x1(%eax),%edx
  80100c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80100f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801012:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801014:	ff 4d f8             	decl   -0x8(%ebp)
  801017:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80101b:	79 e9                	jns    801006 <memset+0x14>
		*p++ = c;

	return v;
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801034:	eb 16                	jmp    80104c <memcpy+0x2a>
		*d++ = *s++;
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	8d 50 01             	lea    0x1(%eax),%edx
  80103c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801042:	8d 4a 01             	lea    0x1(%edx),%ecx
  801045:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801048:	8a 12                	mov    (%edx),%dl
  80104a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80104c:	8b 45 10             	mov    0x10(%ebp),%eax
  80104f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801052:	89 55 10             	mov    %edx,0x10(%ebp)
  801055:	85 c0                	test   %eax,%eax
  801057:	75 dd                	jne    801036 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801070:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801073:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801076:	73 50                	jae    8010c8 <memmove+0x6a>
  801078:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107b:	8b 45 10             	mov    0x10(%ebp),%eax
  80107e:	01 d0                	add    %edx,%eax
  801080:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801083:	76 43                	jbe    8010c8 <memmove+0x6a>
		s += n;
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801091:	eb 10                	jmp    8010a3 <memmove+0x45>
			*--d = *--s;
  801093:	ff 4d f8             	decl   -0x8(%ebp)
  801096:	ff 4d fc             	decl   -0x4(%ebp)
  801099:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109c:	8a 10                	mov    (%eax),%dl
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	75 e3                	jne    801093 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b0:	eb 23                	jmp    8010d5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c4:	8a 12                	mov    (%edx),%dl
  8010c6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 dd                	jne    8010b2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010ec:	eb 2a                	jmp    801118 <memcmp+0x3e>
		if (*s1 != *s2)
  8010ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f1:	8a 10                	mov    (%eax),%dl
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	38 c2                	cmp    %al,%dl
  8010fa:	74 16                	je     801112 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	0f b6 d0             	movzbl %al,%edx
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 c0             	movzbl %al,%eax
  80110c:	29 c2                	sub    %eax,%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	eb 18                	jmp    80112a <memcmp+0x50>
		s1++, s2++;
  801112:	ff 45 fc             	incl   -0x4(%ebp)
  801115:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111e:	89 55 10             	mov    %edx,0x10(%ebp)
  801121:	85 c0                	test   %eax,%eax
  801123:	75 c9                	jne    8010ee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801132:	8b 55 08             	mov    0x8(%ebp),%edx
  801135:	8b 45 10             	mov    0x10(%ebp),%eax
  801138:	01 d0                	add    %edx,%eax
  80113a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80113d:	eb 15                	jmp    801154 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f b6 d0             	movzbl %al,%edx
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	0f b6 c0             	movzbl %al,%eax
  80114d:	39 c2                	cmp    %eax,%edx
  80114f:	74 0d                	je     80115e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80115a:	72 e3                	jb     80113f <memfind+0x13>
  80115c:	eb 01                	jmp    80115f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80115e:	90                   	nop
	return (void *) s;
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80116a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801171:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801178:	eb 03                	jmp    80117d <strtol+0x19>
		s++;
  80117a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	3c 20                	cmp    $0x20,%al
  801184:	74 f4                	je     80117a <strtol+0x16>
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	3c 09                	cmp    $0x9,%al
  80118d:	74 eb                	je     80117a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3c 2b                	cmp    $0x2b,%al
  801196:	75 05                	jne    80119d <strtol+0x39>
		s++;
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	eb 13                	jmp    8011b0 <strtol+0x4c>
	else if (*s == '-')
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 2d                	cmp    $0x2d,%al
  8011a4:	75 0a                	jne    8011b0 <strtol+0x4c>
		s++, neg = 1;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b4:	74 06                	je     8011bc <strtol+0x58>
  8011b6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011ba:	75 20                	jne    8011dc <strtol+0x78>
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	3c 30                	cmp    $0x30,%al
  8011c3:	75 17                	jne    8011dc <strtol+0x78>
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	40                   	inc    %eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 78                	cmp    $0x78,%al
  8011cd:	75 0d                	jne    8011dc <strtol+0x78>
		s += 2, base = 16;
  8011cf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011d3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011da:	eb 28                	jmp    801204 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e0:	75 15                	jne    8011f7 <strtol+0x93>
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 30                	cmp    $0x30,%al
  8011e9:	75 0c                	jne    8011f7 <strtol+0x93>
		s++, base = 8;
  8011eb:	ff 45 08             	incl   0x8(%ebp)
  8011ee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011f5:	eb 0d                	jmp    801204 <strtol+0xa0>
	else if (base == 0)
  8011f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fb:	75 07                	jne    801204 <strtol+0xa0>
		base = 10;
  8011fd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	3c 2f                	cmp    $0x2f,%al
  80120b:	7e 19                	jle    801226 <strtol+0xc2>
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 39                	cmp    $0x39,%al
  801214:	7f 10                	jg     801226 <strtol+0xc2>
			dig = *s - '0';
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	0f be c0             	movsbl %al,%eax
  80121e:	83 e8 30             	sub    $0x30,%eax
  801221:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801224:	eb 42                	jmp    801268 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	3c 60                	cmp    $0x60,%al
  80122d:	7e 19                	jle    801248 <strtol+0xe4>
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3c 7a                	cmp    $0x7a,%al
  801236:	7f 10                	jg     801248 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	0f be c0             	movsbl %al,%eax
  801240:	83 e8 57             	sub    $0x57,%eax
  801243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801246:	eb 20                	jmp    801268 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 40                	cmp    $0x40,%al
  80124f:	7e 39                	jle    80128a <strtol+0x126>
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	3c 5a                	cmp    $0x5a,%al
  801258:	7f 30                	jg     80128a <strtol+0x126>
			dig = *s - 'A' + 10;
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	83 e8 37             	sub    $0x37,%eax
  801265:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80126e:	7d 19                	jge    801289 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801270:	ff 45 08             	incl   0x8(%ebp)
  801273:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801276:	0f af 45 10          	imul   0x10(%ebp),%eax
  80127a:	89 c2                	mov    %eax,%edx
  80127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801284:	e9 7b ff ff ff       	jmp    801204 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801289:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80128a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80128e:	74 08                	je     801298 <strtol+0x134>
		*endptr = (char *) s;
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	8b 55 08             	mov    0x8(%ebp),%edx
  801296:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801298:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80129c:	74 07                	je     8012a5 <strtol+0x141>
  80129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a1:	f7 d8                	neg    %eax
  8012a3:	eb 03                	jmp    8012a8 <strtol+0x144>
  8012a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <ltostr>:

void
ltostr(long value, char *str)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012c2:	79 13                	jns    8012d7 <ltostr+0x2d>
	{
		neg = 1;
  8012c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012df:	99                   	cltd   
  8012e0:	f7 f9                	idiv   %ecx
  8012e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e8:	8d 50 01             	lea    0x1(%eax),%edx
  8012eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ee:	89 c2                	mov    %eax,%edx
  8012f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f8:	83 c2 30             	add    $0x30,%edx
  8012fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801300:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801305:	f7 e9                	imul   %ecx
  801307:	c1 fa 02             	sar    $0x2,%edx
  80130a:	89 c8                	mov    %ecx,%eax
  80130c:	c1 f8 1f             	sar    $0x1f,%eax
  80130f:	29 c2                	sub    %eax,%edx
  801311:	89 d0                	mov    %edx,%eax
  801313:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801316:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801319:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80131e:	f7 e9                	imul   %ecx
  801320:	c1 fa 02             	sar    $0x2,%edx
  801323:	89 c8                	mov    %ecx,%eax
  801325:	c1 f8 1f             	sar    $0x1f,%eax
  801328:	29 c2                	sub    %eax,%edx
  80132a:	89 d0                	mov    %edx,%eax
  80132c:	c1 e0 02             	shl    $0x2,%eax
  80132f:	01 d0                	add    %edx,%eax
  801331:	01 c0                	add    %eax,%eax
  801333:	29 c1                	sub    %eax,%ecx
  801335:	89 ca                	mov    %ecx,%edx
  801337:	85 d2                	test   %edx,%edx
  801339:	75 9c                	jne    8012d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80133b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801342:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801345:	48                   	dec    %eax
  801346:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801349:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80134d:	74 3d                	je     80138c <ltostr+0xe2>
		start = 1 ;
  80134f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801356:	eb 34                	jmp    80138c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801358:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	8a 00                	mov    (%eax),%al
  801362:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c8                	add    %ecx,%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801379:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80137c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137f:	01 c2                	add    %eax,%edx
  801381:	8a 45 eb             	mov    -0x15(%ebp),%al
  801384:	88 02                	mov    %al,(%edx)
		start++ ;
  801386:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801389:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80138c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801392:	7c c4                	jl     801358 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801394:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	01 d0                	add    %edx,%eax
  80139c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80139f:	90                   	nop
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013a8:	ff 75 08             	pushl  0x8(%ebp)
  8013ab:	e8 54 fa ff ff       	call   800e04 <strlen>
  8013b0:	83 c4 04             	add    $0x4,%esp
  8013b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	e8 46 fa ff ff       	call   800e04 <strlen>
  8013be:	83 c4 04             	add    $0x4,%esp
  8013c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013d2:	eb 17                	jmp    8013eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8013d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013da:	01 c2                	add    %eax,%edx
  8013dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	01 c8                	add    %ecx,%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013e8:	ff 45 fc             	incl   -0x4(%ebp)
  8013eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f1:	7c e1                	jl     8013d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801401:	eb 1f                	jmp    801422 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801403:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801406:	8d 50 01             	lea    0x1(%eax),%edx
  801409:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80140c:	89 c2                	mov    %eax,%edx
  80140e:	8b 45 10             	mov    0x10(%ebp),%eax
  801411:	01 c2                	add    %eax,%edx
  801413:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	01 c8                	add    %ecx,%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80141f:	ff 45 f8             	incl   -0x8(%ebp)
  801422:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801425:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801428:	7c d9                	jl     801403 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80142a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142d:	8b 45 10             	mov    0x10(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	c6 00 00             	movb   $0x0,(%eax)
}
  801435:	90                   	nop
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80143b:	8b 45 14             	mov    0x14(%ebp),%eax
  80143e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801444:	8b 45 14             	mov    0x14(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801450:	8b 45 10             	mov    0x10(%ebp),%eax
  801453:	01 d0                	add    %edx,%eax
  801455:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80145b:	eb 0c                	jmp    801469 <strsplit+0x31>
			*string++ = 0;
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8d 50 01             	lea    0x1(%eax),%edx
  801463:	89 55 08             	mov    %edx,0x8(%ebp)
  801466:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	84 c0                	test   %al,%al
  801470:	74 18                	je     80148a <strsplit+0x52>
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	0f be c0             	movsbl %al,%eax
  80147a:	50                   	push   %eax
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	e8 13 fb ff ff       	call   800f96 <strchr>
  801483:	83 c4 08             	add    $0x8,%esp
  801486:	85 c0                	test   %eax,%eax
  801488:	75 d3                	jne    80145d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	84 c0                	test   %al,%al
  801491:	74 5a                	je     8014ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801493:	8b 45 14             	mov    0x14(%ebp),%eax
  801496:	8b 00                	mov    (%eax),%eax
  801498:	83 f8 0f             	cmp    $0xf,%eax
  80149b:	75 07                	jne    8014a4 <strsplit+0x6c>
		{
			return 0;
  80149d:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a2:	eb 66                	jmp    80150a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a7:	8b 00                	mov    (%eax),%eax
  8014a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8014ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8014af:	89 0a                	mov    %ecx,(%edx)
  8014b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 c2                	add    %eax,%edx
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014c2:	eb 03                	jmp    8014c7 <strsplit+0x8f>
			string++;
  8014c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	84 c0                	test   %al,%al
  8014ce:	74 8b                	je     80145b <strsplit+0x23>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	0f be c0             	movsbl %al,%eax
  8014d8:	50                   	push   %eax
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	e8 b5 fa ff ff       	call   800f96 <strchr>
  8014e1:	83 c4 08             	add    $0x8,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	74 dc                	je     8014c4 <strsplit+0x8c>
			string++;
	}
  8014e8:	e9 6e ff ff ff       	jmp    80145b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f1:	8b 00                	mov    (%eax),%eax
  8014f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fd:	01 d0                	add    %edx,%eax
  8014ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801505:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	68 f0 27 80 00       	push   $0x8027f0
  80151a:	6a 0e                	push   $0xe
  80151c:	68 2a 28 80 00       	push   $0x80282a
  801521:	e8 a8 ef ff ff       	call   8004ce <_panic>

00801526 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80152c:	a1 04 30 80 00       	mov    0x803004,%eax
  801531:	85 c0                	test   %eax,%eax
  801533:	74 0f                	je     801544 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801535:	e8 d2 ff ff ff       	call   80150c <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80153a:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801541:	00 00 00 
	}
	if (size == 0) return NULL ;
  801544:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801548:	75 07                	jne    801551 <malloc+0x2b>
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	eb 14                	jmp    801565 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801551:	83 ec 04             	sub    $0x4,%esp
  801554:	68 38 28 80 00       	push   $0x802838
  801559:	6a 2e                	push   $0x2e
  80155b:	68 2a 28 80 00       	push   $0x80282a
  801560:	e8 69 ef ff ff       	call   8004ce <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	68 60 28 80 00       	push   $0x802860
  801575:	6a 49                	push   $0x49
  801577:	68 2a 28 80 00       	push   $0x80282a
  80157c:	e8 4d ef ff ff       	call   8004ce <_panic>

00801581 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 18             	sub    $0x18,%esp
  801587:	8b 45 10             	mov    0x10(%ebp),%eax
  80158a:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	68 84 28 80 00       	push   $0x802884
  801595:	6a 57                	push   $0x57
  801597:	68 2a 28 80 00       	push   $0x80282a
  80159c:	e8 2d ef ff ff       	call   8004ce <_panic>

008015a1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	68 ac 28 80 00       	push   $0x8028ac
  8015af:	6a 60                	push   $0x60
  8015b1:	68 2a 28 80 00       	push   $0x80282a
  8015b6:	e8 13 ef ff ff       	call   8004ce <_panic>

008015bb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 d0 28 80 00       	push   $0x8028d0
  8015c9:	6a 7c                	push   $0x7c
  8015cb:	68 2a 28 80 00       	push   $0x80282a
  8015d0:	e8 f9 ee ff ff       	call   8004ce <_panic>

008015d5 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 f8 28 80 00       	push   $0x8028f8
  8015e3:	68 86 00 00 00       	push   $0x86
  8015e8:	68 2a 28 80 00       	push   $0x80282a
  8015ed:	e8 dc ee ff ff       	call   8004ce <_panic>

008015f2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 1c 29 80 00       	push   $0x80291c
  801600:	68 91 00 00 00       	push   $0x91
  801605:	68 2a 28 80 00       	push   $0x80282a
  80160a:	e8 bf ee ff ff       	call   8004ce <_panic>

0080160f <shrink>:

}
void shrink(uint32 newSize)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	68 1c 29 80 00       	push   $0x80291c
  80161d:	68 96 00 00 00       	push   $0x96
  801622:	68 2a 28 80 00       	push   $0x80282a
  801627:	e8 a2 ee ff ff       	call   8004ce <_panic>

0080162c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	68 1c 29 80 00       	push   $0x80291c
  80163a:	68 9b 00 00 00       	push   $0x9b
  80163f:	68 2a 28 80 00       	push   $0x80282a
  801644:	e8 85 ee ff ff       	call   8004ce <_panic>

00801649 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	57                   	push   %edi
  80164d:	56                   	push   %esi
  80164e:	53                   	push   %ebx
  80164f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80165e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801661:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801664:	cd 30                	int    $0x30
  801666:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801669:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5f                   	pop    %edi
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    

00801674 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	8b 45 10             	mov    0x10(%ebp),%eax
  80167d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801680:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	52                   	push   %edx
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	50                   	push   %eax
  801690:	6a 00                	push   $0x0
  801692:	e8 b2 ff ff ff       	call   801649 <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	90                   	nop
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_cgetc>:

int
sys_cgetc(void)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 01                	push   $0x1
  8016ac:	e8 98 ff ff ff       	call   801649 <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	52                   	push   %edx
  8016c6:	50                   	push   %eax
  8016c7:	6a 05                	push   $0x5
  8016c9:	e8 7b ff ff ff       	call   801649 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	56                   	push   %esi
  8016d7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8016db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	56                   	push   %esi
  8016e8:	53                   	push   %ebx
  8016e9:	51                   	push   %ecx
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	6a 06                	push   $0x6
  8016ee:	e8 56 ff ff ff       	call   801649 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f9:	5b                   	pop    %ebx
  8016fa:	5e                   	pop    %esi
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    

008016fd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	52                   	push   %edx
  80170d:	50                   	push   %eax
  80170e:	6a 07                	push   $0x7
  801710:	e8 34 ff ff ff       	call   801649 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	6a 08                	push   $0x8
  80172b:	e8 19 ff ff ff       	call   801649 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 09                	push   $0x9
  801744:	e8 00 ff ff ff       	call   801649 <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 0a                	push   $0xa
  80175d:	e8 e7 fe ff ff       	call   801649 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 0b                	push   $0xb
  801776:	e8 ce fe ff ff       	call   801649 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 0f                	push   $0xf
  801791:	e8 b3 fe ff ff       	call   801649 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	ff 75 0c             	pushl  0xc(%ebp)
  8017a8:	ff 75 08             	pushl  0x8(%ebp)
  8017ab:	6a 10                	push   $0x10
  8017ad:	e8 97 fe ff ff       	call   801649 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b5:	90                   	nop
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	ff 75 10             	pushl  0x10(%ebp)
  8017c2:	ff 75 0c             	pushl  0xc(%ebp)
  8017c5:	ff 75 08             	pushl  0x8(%ebp)
  8017c8:	6a 11                	push   $0x11
  8017ca:	e8 7a fe ff ff       	call   801649 <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d2:	90                   	nop
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 0c                	push   $0xc
  8017e4:	e8 60 fe ff ff       	call   801649 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	6a 0d                	push   $0xd
  8017fe:	e8 46 fe ff ff       	call   801649 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 0e                	push   $0xe
  801817:	e8 2d fe ff ff       	call   801649 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 13                	push   $0x13
  801831:	e8 13 fe ff ff       	call   801649 <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	90                   	nop
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 14                	push   $0x14
  80184b:	e8 f9 fd ff ff       	call   801649 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	90                   	nop
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_cputc>:


void
sys_cputc(const char c)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801862:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	50                   	push   %eax
  80186f:	6a 15                	push   $0x15
  801871:	e8 d3 fd ff ff       	call   801649 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	90                   	nop
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 16                	push   $0x16
  80188b:	e8 b9 fd ff ff       	call   801649 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	50                   	push   %eax
  8018a6:	6a 17                	push   $0x17
  8018a8:	e8 9c fd ff ff       	call   801649 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	52                   	push   %edx
  8018c2:	50                   	push   %eax
  8018c3:	6a 1a                	push   $0x1a
  8018c5:	e8 7f fd ff ff       	call   801649 <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	52                   	push   %edx
  8018df:	50                   	push   %eax
  8018e0:	6a 18                	push   $0x18
  8018e2:	e8 62 fd ff ff       	call   801649 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	90                   	nop
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	52                   	push   %edx
  8018fd:	50                   	push   %eax
  8018fe:	6a 19                	push   $0x19
  801900:	e8 44 fd ff ff       	call   801649 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801917:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80191a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	51                   	push   %ecx
  801924:	52                   	push   %edx
  801925:	ff 75 0c             	pushl  0xc(%ebp)
  801928:	50                   	push   %eax
  801929:	6a 1b                	push   $0x1b
  80192b:	e8 19 fd ff ff       	call   801649 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	52                   	push   %edx
  801945:	50                   	push   %eax
  801946:	6a 1c                	push   $0x1c
  801948:	e8 fc fc ff ff       	call   801649 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801955:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	51                   	push   %ecx
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 1d                	push   $0x1d
  801967:	e8 dd fc ff ff       	call   801649 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801974:	8b 55 0c             	mov    0xc(%ebp),%edx
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	52                   	push   %edx
  801981:	50                   	push   %eax
  801982:	6a 1e                	push   $0x1e
  801984:	e8 c0 fc ff ff       	call   801649 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 1f                	push   $0x1f
  80199d:	e8 a7 fc ff ff       	call   801649 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 14             	pushl  0x14(%ebp)
  8019b2:	ff 75 10             	pushl  0x10(%ebp)
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	50                   	push   %eax
  8019b9:	6a 20                	push   $0x20
  8019bb:	e8 89 fc ff ff       	call   801649 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	50                   	push   %eax
  8019d4:	6a 21                	push   $0x21
  8019d6:	e8 6e fc ff ff       	call   801649 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	50                   	push   %eax
  8019f0:	6a 22                	push   $0x22
  8019f2:	e8 52 fc ff ff       	call   801649 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 02                	push   $0x2
  801a0b:	e8 39 fc ff ff       	call   801649 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 03                	push   $0x3
  801a24:	e8 20 fc ff ff       	call   801649 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 04                	push   $0x4
  801a3d:	e8 07 fc ff ff       	call   801649 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_exit_env>:


void sys_exit_env(void)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 23                	push   $0x23
  801a56:	e8 ee fb ff ff       	call   801649 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	90                   	nop
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6a:	8d 50 04             	lea    0x4(%eax),%edx
  801a6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	52                   	push   %edx
  801a77:	50                   	push   %eax
  801a78:	6a 24                	push   $0x24
  801a7a:	e8 ca fb ff ff       	call   801649 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
	return result;
  801a82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8b:	89 01                	mov    %eax,(%ecx)
  801a8d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	c9                   	leave  
  801a94:	c2 04 00             	ret    $0x4

00801a97 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	ff 75 10             	pushl  0x10(%ebp)
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	ff 75 08             	pushl  0x8(%ebp)
  801aa7:	6a 12                	push   $0x12
  801aa9:	e8 9b fb ff ff       	call   801649 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab1:	90                   	nop
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 25                	push   $0x25
  801ac3:	e8 81 fb ff ff       	call   801649 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 04             	sub    $0x4,%esp
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ad9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	50                   	push   %eax
  801ae6:	6a 26                	push   $0x26
  801ae8:	e8 5c fb ff ff       	call   801649 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
	return ;
  801af0:	90                   	nop
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <rsttst>:
void rsttst()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 28                	push   $0x28
  801b02:	e8 42 fb ff ff       	call   801649 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0a:	90                   	nop
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	8b 45 14             	mov    0x14(%ebp),%eax
  801b16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b19:	8b 55 18             	mov    0x18(%ebp),%edx
  801b1c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b20:	52                   	push   %edx
  801b21:	50                   	push   %eax
  801b22:	ff 75 10             	pushl  0x10(%ebp)
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	6a 27                	push   $0x27
  801b2d:	e8 17 fb ff ff       	call   801649 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <chktst>:
void chktst(uint32 n)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	6a 29                	push   $0x29
  801b48:	e8 fc fa ff ff       	call   801649 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <inctst>:

void inctst()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 2a                	push   $0x2a
  801b62:	e8 e2 fa ff ff       	call   801649 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6a:	90                   	nop
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <gettst>:
uint32 gettst()
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 2b                	push   $0x2b
  801b7c:	e8 c8 fa ff ff       	call   801649 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 2c                	push   $0x2c
  801b98:	e8 ac fa ff ff       	call   801649 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
  801ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ba3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ba7:	75 07                	jne    801bb0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bae:	eb 05                	jmp    801bb5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 2c                	push   $0x2c
  801bc9:	e8 7b fa ff ff       	call   801649 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
  801bd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bd4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bd8:	75 07                	jne    801be1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bda:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdf:	eb 05                	jmp    801be6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 2c                	push   $0x2c
  801bfa:	e8 4a fa ff ff       	call   801649 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
  801c02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c05:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c09:	75 07                	jne    801c12 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c10:	eb 05                	jmp    801c17 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 2c                	push   $0x2c
  801c2b:	e8 19 fa ff ff       	call   801649 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
  801c33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c36:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c3a:	75 07                	jne    801c43 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c41:	eb 05                	jmp    801c48 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	ff 75 08             	pushl  0x8(%ebp)
  801c58:	6a 2d                	push   $0x2d
  801c5a:	e8 ea f9 ff ff       	call   801649 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c62:	90                   	nop
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c69:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	53                   	push   %ebx
  801c78:	51                   	push   %ecx
  801c79:	52                   	push   %edx
  801c7a:	50                   	push   %eax
  801c7b:	6a 2e                	push   $0x2e
  801c7d:	e8 c7 f9 ff ff       	call   801649 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	52                   	push   %edx
  801c9a:	50                   	push   %eax
  801c9b:	6a 2f                	push   $0x2f
  801c9d:	e8 a7 f9 ff ff       	call   801649 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801cad:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb0:	89 d0                	mov    %edx,%eax
  801cb2:	c1 e0 02             	shl    $0x2,%eax
  801cb5:	01 d0                	add    %edx,%eax
  801cb7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cbe:	01 d0                	add    %edx,%eax
  801cc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cc7:	01 d0                	add    %edx,%eax
  801cc9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd0:	01 d0                	add    %edx,%eax
  801cd2:	c1 e0 04             	shl    $0x4,%eax
  801cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801cdf:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801ce2:	83 ec 0c             	sub    $0xc,%esp
  801ce5:	50                   	push   %eax
  801ce6:	e8 76 fd ff ff       	call   801a61 <sys_get_virtual_time>
  801ceb:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801cee:	eb 41                	jmp    801d31 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801cf0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801cf3:	83 ec 0c             	sub    $0xc,%esp
  801cf6:	50                   	push   %eax
  801cf7:	e8 65 fd ff ff       	call   801a61 <sys_get_virtual_time>
  801cfc:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801cff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d05:	29 c2                	sub    %eax,%edx
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d12:	89 d1                	mov    %edx,%ecx
  801d14:	29 c1                	sub    %eax,%ecx
  801d16:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d1c:	39 c2                	cmp    %eax,%edx
  801d1e:	0f 97 c0             	seta   %al
  801d21:	0f b6 c0             	movzbl %al,%eax
  801d24:	29 c1                	sub    %eax,%ecx
  801d26:	89 c8                	mov    %ecx,%eax
  801d28:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d37:	72 b7                	jb     801cf0 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d39:	90                   	nop
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801d49:	eb 03                	jmp    801d4e <busy_wait+0x12>
  801d4b:	ff 45 fc             	incl   -0x4(%ebp)
  801d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d51:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d54:	72 f5                	jb     801d4b <busy_wait+0xf>
	return i;
  801d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    
  801d5b:	90                   	nop

00801d5c <__udivdi3>:
  801d5c:	55                   	push   %ebp
  801d5d:	57                   	push   %edi
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 1c             	sub    $0x1c,%esp
  801d63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d73:	89 ca                	mov    %ecx,%edx
  801d75:	89 f8                	mov    %edi,%eax
  801d77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d7b:	85 f6                	test   %esi,%esi
  801d7d:	75 2d                	jne    801dac <__udivdi3+0x50>
  801d7f:	39 cf                	cmp    %ecx,%edi
  801d81:	77 65                	ja     801de8 <__udivdi3+0x8c>
  801d83:	89 fd                	mov    %edi,%ebp
  801d85:	85 ff                	test   %edi,%edi
  801d87:	75 0b                	jne    801d94 <__udivdi3+0x38>
  801d89:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8e:	31 d2                	xor    %edx,%edx
  801d90:	f7 f7                	div    %edi
  801d92:	89 c5                	mov    %eax,%ebp
  801d94:	31 d2                	xor    %edx,%edx
  801d96:	89 c8                	mov    %ecx,%eax
  801d98:	f7 f5                	div    %ebp
  801d9a:	89 c1                	mov    %eax,%ecx
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	f7 f5                	div    %ebp
  801da0:	89 cf                	mov    %ecx,%edi
  801da2:	89 fa                	mov    %edi,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	39 ce                	cmp    %ecx,%esi
  801dae:	77 28                	ja     801dd8 <__udivdi3+0x7c>
  801db0:	0f bd fe             	bsr    %esi,%edi
  801db3:	83 f7 1f             	xor    $0x1f,%edi
  801db6:	75 40                	jne    801df8 <__udivdi3+0x9c>
  801db8:	39 ce                	cmp    %ecx,%esi
  801dba:	72 0a                	jb     801dc6 <__udivdi3+0x6a>
  801dbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801dc0:	0f 87 9e 00 00 00    	ja     801e64 <__udivdi3+0x108>
  801dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcb:	89 fa                	mov    %edi,%edx
  801dcd:	83 c4 1c             	add    $0x1c,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
  801dd5:	8d 76 00             	lea    0x0(%esi),%esi
  801dd8:	31 ff                	xor    %edi,%edi
  801dda:	31 c0                	xor    %eax,%eax
  801ddc:	89 fa                	mov    %edi,%edx
  801dde:	83 c4 1c             	add    $0x1c,%esp
  801de1:	5b                   	pop    %ebx
  801de2:	5e                   	pop    %esi
  801de3:	5f                   	pop    %edi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    
  801de6:	66 90                	xchg   %ax,%ax
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	f7 f7                	div    %edi
  801dec:	31 ff                	xor    %edi,%edi
  801dee:	89 fa                	mov    %edi,%edx
  801df0:	83 c4 1c             	add    $0x1c,%esp
  801df3:	5b                   	pop    %ebx
  801df4:	5e                   	pop    %esi
  801df5:	5f                   	pop    %edi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    
  801df8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dfd:	89 eb                	mov    %ebp,%ebx
  801dff:	29 fb                	sub    %edi,%ebx
  801e01:	89 f9                	mov    %edi,%ecx
  801e03:	d3 e6                	shl    %cl,%esi
  801e05:	89 c5                	mov    %eax,%ebp
  801e07:	88 d9                	mov    %bl,%cl
  801e09:	d3 ed                	shr    %cl,%ebp
  801e0b:	89 e9                	mov    %ebp,%ecx
  801e0d:	09 f1                	or     %esi,%ecx
  801e0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e13:	89 f9                	mov    %edi,%ecx
  801e15:	d3 e0                	shl    %cl,%eax
  801e17:	89 c5                	mov    %eax,%ebp
  801e19:	89 d6                	mov    %edx,%esi
  801e1b:	88 d9                	mov    %bl,%cl
  801e1d:	d3 ee                	shr    %cl,%esi
  801e1f:	89 f9                	mov    %edi,%ecx
  801e21:	d3 e2                	shl    %cl,%edx
  801e23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e27:	88 d9                	mov    %bl,%cl
  801e29:	d3 e8                	shr    %cl,%eax
  801e2b:	09 c2                	or     %eax,%edx
  801e2d:	89 d0                	mov    %edx,%eax
  801e2f:	89 f2                	mov    %esi,%edx
  801e31:	f7 74 24 0c          	divl   0xc(%esp)
  801e35:	89 d6                	mov    %edx,%esi
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	f7 e5                	mul    %ebp
  801e3b:	39 d6                	cmp    %edx,%esi
  801e3d:	72 19                	jb     801e58 <__udivdi3+0xfc>
  801e3f:	74 0b                	je     801e4c <__udivdi3+0xf0>
  801e41:	89 d8                	mov    %ebx,%eax
  801e43:	31 ff                	xor    %edi,%edi
  801e45:	e9 58 ff ff ff       	jmp    801da2 <__udivdi3+0x46>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e50:	89 f9                	mov    %edi,%ecx
  801e52:	d3 e2                	shl    %cl,%edx
  801e54:	39 c2                	cmp    %eax,%edx
  801e56:	73 e9                	jae    801e41 <__udivdi3+0xe5>
  801e58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e5b:	31 ff                	xor    %edi,%edi
  801e5d:	e9 40 ff ff ff       	jmp    801da2 <__udivdi3+0x46>
  801e62:	66 90                	xchg   %ax,%ax
  801e64:	31 c0                	xor    %eax,%eax
  801e66:	e9 37 ff ff ff       	jmp    801da2 <__udivdi3+0x46>
  801e6b:	90                   	nop

00801e6c <__umoddi3>:
  801e6c:	55                   	push   %ebp
  801e6d:	57                   	push   %edi
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 1c             	sub    $0x1c,%esp
  801e73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e8b:	89 f3                	mov    %esi,%ebx
  801e8d:	89 fa                	mov    %edi,%edx
  801e8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e93:	89 34 24             	mov    %esi,(%esp)
  801e96:	85 c0                	test   %eax,%eax
  801e98:	75 1a                	jne    801eb4 <__umoddi3+0x48>
  801e9a:	39 f7                	cmp    %esi,%edi
  801e9c:	0f 86 a2 00 00 00    	jbe    801f44 <__umoddi3+0xd8>
  801ea2:	89 c8                	mov    %ecx,%eax
  801ea4:	89 f2                	mov    %esi,%edx
  801ea6:	f7 f7                	div    %edi
  801ea8:	89 d0                	mov    %edx,%eax
  801eaa:	31 d2                	xor    %edx,%edx
  801eac:	83 c4 1c             	add    $0x1c,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5f                   	pop    %edi
  801eb2:	5d                   	pop    %ebp
  801eb3:	c3                   	ret    
  801eb4:	39 f0                	cmp    %esi,%eax
  801eb6:	0f 87 ac 00 00 00    	ja     801f68 <__umoddi3+0xfc>
  801ebc:	0f bd e8             	bsr    %eax,%ebp
  801ebf:	83 f5 1f             	xor    $0x1f,%ebp
  801ec2:	0f 84 ac 00 00 00    	je     801f74 <__umoddi3+0x108>
  801ec8:	bf 20 00 00 00       	mov    $0x20,%edi
  801ecd:	29 ef                	sub    %ebp,%edi
  801ecf:	89 fe                	mov    %edi,%esi
  801ed1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ed5:	89 e9                	mov    %ebp,%ecx
  801ed7:	d3 e0                	shl    %cl,%eax
  801ed9:	89 d7                	mov    %edx,%edi
  801edb:	89 f1                	mov    %esi,%ecx
  801edd:	d3 ef                	shr    %cl,%edi
  801edf:	09 c7                	or     %eax,%edi
  801ee1:	89 e9                	mov    %ebp,%ecx
  801ee3:	d3 e2                	shl    %cl,%edx
  801ee5:	89 14 24             	mov    %edx,(%esp)
  801ee8:	89 d8                	mov    %ebx,%eax
  801eea:	d3 e0                	shl    %cl,%eax
  801eec:	89 c2                	mov    %eax,%edx
  801eee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ef2:	d3 e0                	shl    %cl,%eax
  801ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801efc:	89 f1                	mov    %esi,%ecx
  801efe:	d3 e8                	shr    %cl,%eax
  801f00:	09 d0                	or     %edx,%eax
  801f02:	d3 eb                	shr    %cl,%ebx
  801f04:	89 da                	mov    %ebx,%edx
  801f06:	f7 f7                	div    %edi
  801f08:	89 d3                	mov    %edx,%ebx
  801f0a:	f7 24 24             	mull   (%esp)
  801f0d:	89 c6                	mov    %eax,%esi
  801f0f:	89 d1                	mov    %edx,%ecx
  801f11:	39 d3                	cmp    %edx,%ebx
  801f13:	0f 82 87 00 00 00    	jb     801fa0 <__umoddi3+0x134>
  801f19:	0f 84 91 00 00 00    	je     801fb0 <__umoddi3+0x144>
  801f1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f23:	29 f2                	sub    %esi,%edx
  801f25:	19 cb                	sbb    %ecx,%ebx
  801f27:	89 d8                	mov    %ebx,%eax
  801f29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f2d:	d3 e0                	shl    %cl,%eax
  801f2f:	89 e9                	mov    %ebp,%ecx
  801f31:	d3 ea                	shr    %cl,%edx
  801f33:	09 d0                	or     %edx,%eax
  801f35:	89 e9                	mov    %ebp,%ecx
  801f37:	d3 eb                	shr    %cl,%ebx
  801f39:	89 da                	mov    %ebx,%edx
  801f3b:	83 c4 1c             	add    $0x1c,%esp
  801f3e:	5b                   	pop    %ebx
  801f3f:	5e                   	pop    %esi
  801f40:	5f                   	pop    %edi
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    
  801f43:	90                   	nop
  801f44:	89 fd                	mov    %edi,%ebp
  801f46:	85 ff                	test   %edi,%edi
  801f48:	75 0b                	jne    801f55 <__umoddi3+0xe9>
  801f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4f:	31 d2                	xor    %edx,%edx
  801f51:	f7 f7                	div    %edi
  801f53:	89 c5                	mov    %eax,%ebp
  801f55:	89 f0                	mov    %esi,%eax
  801f57:	31 d2                	xor    %edx,%edx
  801f59:	f7 f5                	div    %ebp
  801f5b:	89 c8                	mov    %ecx,%eax
  801f5d:	f7 f5                	div    %ebp
  801f5f:	89 d0                	mov    %edx,%eax
  801f61:	e9 44 ff ff ff       	jmp    801eaa <__umoddi3+0x3e>
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	89 c8                	mov    %ecx,%eax
  801f6a:	89 f2                	mov    %esi,%edx
  801f6c:	83 c4 1c             	add    $0x1c,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5f                   	pop    %edi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    
  801f74:	3b 04 24             	cmp    (%esp),%eax
  801f77:	72 06                	jb     801f7f <__umoddi3+0x113>
  801f79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f7d:	77 0f                	ja     801f8e <__umoddi3+0x122>
  801f7f:	89 f2                	mov    %esi,%edx
  801f81:	29 f9                	sub    %edi,%ecx
  801f83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f87:	89 14 24             	mov    %edx,(%esp)
  801f8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f92:	8b 14 24             	mov    (%esp),%edx
  801f95:	83 c4 1c             	add    $0x1c,%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5f                   	pop    %edi
  801f9b:	5d                   	pop    %ebp
  801f9c:	c3                   	ret    
  801f9d:	8d 76 00             	lea    0x0(%esi),%esi
  801fa0:	2b 04 24             	sub    (%esp),%eax
  801fa3:	19 fa                	sbb    %edi,%edx
  801fa5:	89 d1                	mov    %edx,%ecx
  801fa7:	89 c6                	mov    %eax,%esi
  801fa9:	e9 71 ff ff ff       	jmp    801f1f <__umoddi3+0xb3>
  801fae:	66 90                	xchg   %ax,%ax
  801fb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fb4:	72 ea                	jb     801fa0 <__umoddi3+0x134>
  801fb6:	89 d9                	mov    %ebx,%ecx
  801fb8:	e9 62 ff ff ff       	jmp    801f1f <__umoddi3+0xb3>
