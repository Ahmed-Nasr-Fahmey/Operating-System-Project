
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 28 03 00 00       	call   80035e <libmain>
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
  80008d:	68 a0 1f 80 00       	push   $0x801fa0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 1f 80 00       	push   $0x801fbc
  800099:	e8 0f 04 00 00       	call   8004ad <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 71 16 00 00       	call   801714 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 d7 1f 80 00       	push   $0x801fd7
  8000b2:	e8 a9 14 00 00       	call   801560 <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 dc 1f 80 00       	push   $0x801fdc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 bc 1f 80 00       	push   $0x801fbc
  8000d5:	e8 d3 03 00 00       	call   8004ad <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 32 16 00 00       	call   801714 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 14                	je     8000ff <_main+0xc7>
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	68 40 20 80 00       	push   $0x802040
  8000f3:	6a 1b                	push   $0x1b
  8000f5:	68 bc 1f 80 00       	push   $0x801fbc
  8000fa:	e8 ae 03 00 00       	call   8004ad <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  8000ff:	e8 10 16 00 00       	call   801714 <sys_calculate_free_frames>
  800104:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	6a 00                	push   $0x0
  80010c:	6a 04                	push   $0x4
  80010e:	68 c8 20 80 00       	push   $0x8020c8
  800113:	e8 48 14 00 00       	call   801560 <smalloc>
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80011e:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800125:	74 14                	je     80013b <_main+0x103>
  800127:	83 ec 04             	sub    $0x4,%esp
  80012a:	68 dc 1f 80 00       	push   $0x801fdc
  80012f:	6a 20                	push   $0x20
  800131:	68 bc 1f 80 00       	push   $0x801fbc
  800136:	e8 72 03 00 00       	call   8004ad <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80013b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80013e:	e8 d1 15 00 00       	call   801714 <sys_calculate_free_frames>
  800143:	29 c3                	sub    %eax,%ebx
  800145:	89 d8                	mov    %ebx,%eax
  800147:	83 f8 03             	cmp    $0x3,%eax
  80014a:	74 14                	je     800160 <_main+0x128>
  80014c:	83 ec 04             	sub    $0x4,%esp
  80014f:	68 40 20 80 00       	push   $0x802040
  800154:	6a 21                	push   $0x21
  800156:	68 bc 1f 80 00       	push   $0x801fbc
  80015b:	e8 4d 03 00 00       	call   8004ad <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800160:	e8 af 15 00 00       	call   801714 <sys_calculate_free_frames>
  800165:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	6a 04                	push   $0x4
  80016f:	68 ca 20 80 00       	push   $0x8020ca
  800174:	e8 e7 13 00 00       	call   801560 <smalloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80017f:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800186:	74 14                	je     80019c <_main+0x164>
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	68 dc 1f 80 00       	push   $0x801fdc
  800190:	6a 26                	push   $0x26
  800192:	68 bc 1f 80 00       	push   $0x801fbc
  800197:	e8 11 03 00 00       	call   8004ad <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80019c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80019f:	e8 70 15 00 00       	call   801714 <sys_calculate_free_frames>
  8001a4:	29 c3                	sub    %eax,%ebx
  8001a6:	89 d8                	mov    %ebx,%eax
  8001a8:	83 f8 03             	cmp    $0x3,%eax
  8001ab:	74 14                	je     8001c1 <_main+0x189>
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 40 20 80 00       	push   $0x802040
  8001b5:	6a 27                	push   $0x27
  8001b7:	68 bc 1f 80 00       	push   $0x801fbc
  8001bc:	e8 ec 02 00 00       	call   8004ad <_panic>

	*x = 10 ;
  8001c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c4:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cd:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d8:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  8001de:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e3:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  8001e9:	89 c1                	mov    %eax,%ecx
  8001eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f0:	8b 40 74             	mov    0x74(%eax),%eax
  8001f3:	52                   	push   %edx
  8001f4:	51                   	push   %ecx
  8001f5:	50                   	push   %eax
  8001f6:	68 cc 20 80 00       	push   $0x8020cc
  8001fb:	e8 86 17 00 00       	call   801986 <sys_create_env>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80021c:	89 c1                	mov    %eax,%ecx
  80021e:	a1 20 30 80 00       	mov    0x803020,%eax
  800223:	8b 40 74             	mov    0x74(%eax),%eax
  800226:	52                   	push   %edx
  800227:	51                   	push   %ecx
  800228:	50                   	push   %eax
  800229:	68 cc 20 80 00       	push   $0x8020cc
  80022e:	e8 53 17 00 00       	call   801986 <sys_create_env>
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  800244:	a1 20 30 80 00       	mov    0x803020,%eax
  800249:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80024f:	89 c1                	mov    %eax,%ecx
  800251:	a1 20 30 80 00       	mov    0x803020,%eax
  800256:	8b 40 74             	mov    0x74(%eax),%eax
  800259:	52                   	push   %edx
  80025a:	51                   	push   %ecx
  80025b:	50                   	push   %eax
  80025c:	68 cc 20 80 00       	push   $0x8020cc
  800261:	e8 20 17 00 00       	call   801986 <sys_create_env>
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  80026c:	e8 61 18 00 00       	call   801ad2 <rsttst>

	sys_run_env(id1);
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	ff 75 dc             	pushl  -0x24(%ebp)
  800277:	e8 28 17 00 00       	call   8019a4 <sys_run_env>
  80027c:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 d8             	pushl  -0x28(%ebp)
  800285:	e8 1a 17 00 00       	call   8019a4 <sys_run_env>
  80028a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	ff 75 d4             	pushl  -0x2c(%ebp)
  800293:	e8 0c 17 00 00       	call   8019a4 <sys_run_env>
  800298:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  80029b:	83 ec 0c             	sub    $0xc,%esp
  80029e:	68 e0 2e 00 00       	push   $0x2ee0
  8002a3:	e8 de 19 00 00       	call   801c86 <env_sleep>
  8002a8:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002ab:	e8 9c 18 00 00       	call   801b4c <gettst>
  8002b0:	83 f8 03             	cmp    $0x3,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 d7 20 80 00       	push   $0x8020d7
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 bc 1f 80 00       	push   $0x801fbc
  8002c4:	e8 e4 01 00 00       	call   8004ad <_panic>


	if (*z != 30)
  8002c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 1e             	cmp    $0x1e,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 e4 20 80 00       	push   $0x8020e4
  8002db:	6a 3f                	push   $0x3f
  8002dd:	68 bc 1f 80 00       	push   $0x801fbc
  8002e2:	e8 c6 01 00 00       	call   8004ad <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 30 21 80 00       	push   $0x802130
  8002ef:	e8 6d 04 00 00       	call   800761 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 8c 21 80 00       	push   $0x80218c
  8002ff:	e8 5d 04 00 00       	call   800761 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800307:	a1 20 30 80 00       	mov    0x803020,%eax
  80030c:	8b 90 5c da 01 00    	mov    0x1da5c(%eax),%edx
  800312:	a1 20 30 80 00       	mov    0x803020,%eax
  800317:	8b 80 a4 ea 01 00    	mov    0x1eaa4(%eax),%eax
  80031d:	89 c1                	mov    %eax,%ecx
  80031f:	a1 20 30 80 00       	mov    0x803020,%eax
  800324:	8b 40 74             	mov    0x74(%eax),%eax
  800327:	52                   	push   %edx
  800328:	51                   	push   %ecx
  800329:	50                   	push   %eax
  80032a:	68 e7 21 80 00       	push   $0x8021e7
  80032f:	e8 52 16 00 00       	call   801986 <sys_create_env>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	68 b8 0b 00 00       	push   $0xbb8
  800342:	e8 3f 19 00 00       	call   801c86 <env_sleep>
  800347:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	ff 75 dc             	pushl  -0x24(%ebp)
  800350:	e8 4f 16 00 00       	call   8019a4 <sys_run_env>
  800355:	83 c4 10             	add    $0x10,%esp

	return;
  800358:	90                   	nop
}
  800359:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    

0080035e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800364:	e8 8b 16 00 00       	call   8019f4 <sys_getenvindex>
  800369:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80036c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036f:	89 d0                	mov    %edx,%eax
  800371:	01 c0                	add    %eax,%eax
  800373:	01 d0                	add    %edx,%eax
  800375:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80037c:	01 c8                	add    %ecx,%eax
  80037e:	c1 e0 02             	shl    $0x2,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80038a:	01 c8                	add    %ecx,%eax
  80038c:	c1 e0 02             	shl    $0x2,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 02             	shl    $0x2,%eax
  800394:	01 d0                	add    %edx,%eax
  800396:	c1 e0 03             	shl    $0x3,%eax
  800399:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80039e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8003ae:	84 c0                	test   %al,%al
  8003b0:	74 0f                	je     8003c1 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	05 18 da 01 00       	add    $0x1da18,%eax
  8003bc:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003c5:	7e 0a                	jle    8003d1 <libmain+0x73>
		binaryname = argv[0];
  8003c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	ff 75 0c             	pushl  0xc(%ebp)
  8003d7:	ff 75 08             	pushl  0x8(%ebp)
  8003da:	e8 59 fc ff ff       	call   800038 <_main>
  8003df:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003e2:	e8 1a 14 00 00       	call   801801 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e7:	83 ec 0c             	sub    $0xc,%esp
  8003ea:	68 0c 22 80 00       	push   $0x80220c
  8003ef:	e8 6d 03 00 00       	call   800761 <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fc:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800402:	a1 20 30 80 00       	mov    0x803020,%eax
  800407:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	68 34 22 80 00       	push   $0x802234
  800417:	e8 45 03 00 00       	call   800761 <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80041f:	a1 20 30 80 00       	mov    0x803020,%eax
  800424:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80042a:	a1 20 30 80 00       	mov    0x803020,%eax
  80042f:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800435:	a1 20 30 80 00       	mov    0x803020,%eax
  80043a:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800440:	51                   	push   %ecx
  800441:	52                   	push   %edx
  800442:	50                   	push   %eax
  800443:	68 5c 22 80 00       	push   $0x80225c
  800448:	e8 14 03 00 00       	call   800761 <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800450:	a1 20 30 80 00       	mov    0x803020,%eax
  800455:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	50                   	push   %eax
  80045f:	68 b4 22 80 00       	push   $0x8022b4
  800464:	e8 f8 02 00 00       	call   800761 <cprintf>
  800469:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80046c:	83 ec 0c             	sub    $0xc,%esp
  80046f:	68 0c 22 80 00       	push   $0x80220c
  800474:	e8 e8 02 00 00       	call   800761 <cprintf>
  800479:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80047c:	e8 9a 13 00 00       	call   80181b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800481:	e8 19 00 00 00       	call   80049f <exit>
}
  800486:	90                   	nop
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80048f:	83 ec 0c             	sub    $0xc,%esp
  800492:	6a 00                	push   $0x0
  800494:	e8 27 15 00 00       	call   8019c0 <sys_destroy_env>
  800499:	83 c4 10             	add    $0x10,%esp
}
  80049c:	90                   	nop
  80049d:	c9                   	leave  
  80049e:	c3                   	ret    

0080049f <exit>:

void
exit(void)
{
  80049f:	55                   	push   %ebp
  8004a0:	89 e5                	mov    %esp,%ebp
  8004a2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004a5:	e8 7c 15 00 00       	call   801a26 <sys_exit_env>
}
  8004aa:	90                   	nop
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004b3:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b6:	83 c0 04             	add    $0x4,%eax
  8004b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004bc:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8004c1:	85 c0                	test   %eax,%eax
  8004c3:	74 16                	je     8004db <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004c5:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	50                   	push   %eax
  8004ce:	68 c8 22 80 00       	push   $0x8022c8
  8004d3:	e8 89 02 00 00       	call   800761 <cprintf>
  8004d8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004db:	a1 00 30 80 00       	mov    0x803000,%eax
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	68 cd 22 80 00       	push   $0x8022cd
  8004ec:	e8 70 02 00 00       	call   800761 <cprintf>
  8004f1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fd:	50                   	push   %eax
  8004fe:	e8 f3 01 00 00       	call   8006f6 <vcprintf>
  800503:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	6a 00                	push   $0x0
  80050b:	68 e9 22 80 00       	push   $0x8022e9
  800510:	e8 e1 01 00 00       	call   8006f6 <vcprintf>
  800515:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800518:	e8 82 ff ff ff       	call   80049f <exit>

	// should not return here
	while (1) ;
  80051d:	eb fe                	jmp    80051d <_panic+0x70>

0080051f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800525:	a1 20 30 80 00       	mov    0x803020,%eax
  80052a:	8b 50 74             	mov    0x74(%eax),%edx
  80052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800530:	39 c2                	cmp    %eax,%edx
  800532:	74 14                	je     800548 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800534:	83 ec 04             	sub    $0x4,%esp
  800537:	68 ec 22 80 00       	push   $0x8022ec
  80053c:	6a 26                	push   $0x26
  80053e:	68 38 23 80 00       	push   $0x802338
  800543:	e8 65 ff ff ff       	call   8004ad <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800548:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80054f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800556:	e9 c2 00 00 00       	jmp    80061d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	85 c0                	test   %eax,%eax
  80056e:	75 08                	jne    800578 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800570:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800573:	e9 a2 00 00 00       	jmp    80061a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800578:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800586:	eb 69                	jmp    8005f1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800588:	a1 20 30 80 00       	mov    0x803020,%eax
  80058d:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800593:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 c8                	add    %ecx,%eax
  8005a1:	8a 40 04             	mov    0x4(%eax),%al
  8005a4:	84 c0                	test   %al,%al
  8005a6:	75 46                	jne    8005ee <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ad:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	01 c0                	add    %eax,%eax
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	c1 e0 03             	shl    $0x3,%eax
  8005bf:	01 c8                	add    %ecx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ce:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	01 c8                	add    %ecx,%eax
  8005df:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005e1:	39 c2                	cmp    %eax,%edx
  8005e3:	75 09                	jne    8005ee <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005e5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ec:	eb 12                	jmp    800600 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ee:	ff 45 e8             	incl   -0x18(%ebp)
  8005f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f6:	8b 50 74             	mov    0x74(%eax),%edx
  8005f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005fc:	39 c2                	cmp    %eax,%edx
  8005fe:	77 88                	ja     800588 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800600:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800604:	75 14                	jne    80061a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 44 23 80 00       	push   $0x802344
  80060e:	6a 3a                	push   $0x3a
  800610:	68 38 23 80 00       	push   $0x802338
  800615:	e8 93 fe ff ff       	call   8004ad <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80061a:	ff 45 f0             	incl   -0x10(%ebp)
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800623:	0f 8c 32 ff ff ff    	jl     80055b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800629:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800630:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800637:	eb 26                	jmp    80065f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800639:	a1 20 30 80 00       	mov    0x803020,%eax
  80063e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800644:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800647:	89 d0                	mov    %edx,%eax
  800649:	01 c0                	add    %eax,%eax
  80064b:	01 d0                	add    %edx,%eax
  80064d:	c1 e0 03             	shl    $0x3,%eax
  800650:	01 c8                	add    %ecx,%eax
  800652:	8a 40 04             	mov    0x4(%eax),%al
  800655:	3c 01                	cmp    $0x1,%al
  800657:	75 03                	jne    80065c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800659:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065c:	ff 45 e0             	incl   -0x20(%ebp)
  80065f:	a1 20 30 80 00       	mov    0x803020,%eax
  800664:	8b 50 74             	mov    0x74(%eax),%edx
  800667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066a:	39 c2                	cmp    %eax,%edx
  80066c:	77 cb                	ja     800639 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80066e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800671:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800674:	74 14                	je     80068a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800676:	83 ec 04             	sub    $0x4,%esp
  800679:	68 98 23 80 00       	push   $0x802398
  80067e:	6a 44                	push   $0x44
  800680:	68 38 23 80 00       	push   $0x802338
  800685:	e8 23 fe ff ff       	call   8004ad <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80068a:	90                   	nop
  80068b:	c9                   	leave  
  80068c:	c3                   	ret    

0080068d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800693:	8b 45 0c             	mov    0xc(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 48 01             	lea    0x1(%eax),%ecx
  80069b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069e:	89 0a                	mov    %ecx,(%edx)
  8006a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a3:	88 d1                	mov    %dl,%cl
  8006a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b6:	75 2c                	jne    8006e4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b8:	a0 24 30 80 00       	mov    0x803024,%al
  8006bd:	0f b6 c0             	movzbl %al,%eax
  8006c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c3:	8b 12                	mov    (%edx),%edx
  8006c5:	89 d1                	mov    %edx,%ecx
  8006c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ca:	83 c2 08             	add    $0x8,%edx
  8006cd:	83 ec 04             	sub    $0x4,%esp
  8006d0:	50                   	push   %eax
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	e8 7b 0f 00 00       	call   801653 <sys_cputs>
  8006d8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e7:	8b 40 04             	mov    0x4(%eax),%eax
  8006ea:	8d 50 01             	lea    0x1(%eax),%edx
  8006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f3:	90                   	nop
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    

008006f6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800706:	00 00 00 
	b.cnt = 0;
  800709:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800710:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	ff 75 08             	pushl  0x8(%ebp)
  800719:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071f:	50                   	push   %eax
  800720:	68 8d 06 80 00       	push   $0x80068d
  800725:	e8 11 02 00 00       	call   80093b <vprintfmt>
  80072a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80072d:	a0 24 30 80 00       	mov    0x803024,%al
  800732:	0f b6 c0             	movzbl %al,%eax
  800735:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80073b:	83 ec 04             	sub    $0x4,%esp
  80073e:	50                   	push   %eax
  80073f:	52                   	push   %edx
  800740:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800746:	83 c0 08             	add    $0x8,%eax
  800749:	50                   	push   %eax
  80074a:	e8 04 0f 00 00       	call   801653 <sys_cputs>
  80074f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800752:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800759:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <cprintf>:

int cprintf(const char *fmt, ...) {
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800767:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80076e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 f4             	pushl  -0xc(%ebp)
  80077d:	50                   	push   %eax
  80077e:	e8 73 ff ff ff       	call   8006f6 <vcprintf>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078c:	c9                   	leave  
  80078d:	c3                   	ret    

0080078e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800794:	e8 68 10 00 00       	call   801801 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800799:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a8:	50                   	push   %eax
  8007a9:	e8 48 ff ff ff       	call   8006f6 <vcprintf>
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007b4:	e8 62 10 00 00       	call   80181b <sys_enable_interrupt>
	return cnt;
  8007b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007bc:	c9                   	leave  
  8007bd:	c3                   	ret    

008007be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	53                   	push   %ebx
  8007c2:	83 ec 14             	sub    $0x14,%esp
  8007c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007dc:	77 55                	ja     800833 <printnum+0x75>
  8007de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e1:	72 05                	jb     8007e8 <printnum+0x2a>
  8007e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e6:	77 4b                	ja     800833 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007eb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f6:	52                   	push   %edx
  8007f7:	50                   	push   %eax
  8007f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8007fe:	e8 39 15 00 00       	call   801d3c <__udivdi3>
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	ff 75 20             	pushl  0x20(%ebp)
  80080c:	53                   	push   %ebx
  80080d:	ff 75 18             	pushl  0x18(%ebp)
  800810:	52                   	push   %edx
  800811:	50                   	push   %eax
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	ff 75 08             	pushl  0x8(%ebp)
  800818:	e8 a1 ff ff ff       	call   8007be <printnum>
  80081d:	83 c4 20             	add    $0x20,%esp
  800820:	eb 1a                	jmp    80083c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	ff 75 20             	pushl  0x20(%ebp)
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800833:	ff 4d 1c             	decl   0x1c(%ebp)
  800836:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80083a:	7f e6                	jg     800822 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80083c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80083f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80084a:	53                   	push   %ebx
  80084b:	51                   	push   %ecx
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	e8 f9 15 00 00       	call   801e4c <__umoddi3>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	05 14 26 80 00       	add    $0x802614,%eax
  80085b:	8a 00                	mov    (%eax),%al
  80085d:	0f be c0             	movsbl %al,%eax
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	ff 75 0c             	pushl  0xc(%ebp)
  800866:	50                   	push   %eax
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
}
  80086f:	90                   	nop
  800870:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800873:	c9                   	leave  
  800874:	c3                   	ret    

00800875 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800878:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80087c:	7e 1c                	jle    80089a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	8d 50 08             	lea    0x8(%eax),%edx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	89 10                	mov    %edx,(%eax)
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	83 e8 08             	sub    $0x8,%eax
  800893:	8b 50 04             	mov    0x4(%eax),%edx
  800896:	8b 00                	mov    (%eax),%eax
  800898:	eb 40                	jmp    8008da <getuint+0x65>
	else if (lflag)
  80089a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80089e:	74 1e                	je     8008be <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	8d 50 04             	lea    0x4(%eax),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	89 10                	mov    %edx,(%eax)
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	83 e8 04             	sub    $0x4,%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bc:	eb 1c                	jmp    8008da <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	8d 50 04             	lea    0x4(%eax),%edx
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	89 10                	mov    %edx,(%eax)
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	83 e8 04             	sub    $0x4,%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008da:	5d                   	pop    %ebp
  8008db:	c3                   	ret    

008008dc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e3:	7e 1c                	jle    800901 <getint+0x25>
		return va_arg(*ap, long long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 08             	lea    0x8(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 08             	sub    $0x8,%eax
  8008fa:	8b 50 04             	mov    0x4(%eax),%edx
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	eb 38                	jmp    800939 <getint+0x5d>
	else if (lflag)
  800901:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800905:	74 1a                	je     800921 <getint+0x45>
		return va_arg(*ap, long);
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	8d 50 04             	lea    0x4(%eax),%edx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	89 10                	mov    %edx,(%eax)
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	83 e8 04             	sub    $0x4,%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	99                   	cltd   
  80091f:	eb 18                	jmp    800939 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	8d 50 04             	lea    0x4(%eax),%edx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	89 10                	mov    %edx,(%eax)
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	83 e8 04             	sub    $0x4,%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	99                   	cltd   
}
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	56                   	push   %esi
  80093f:	53                   	push   %ebx
  800940:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800943:	eb 17                	jmp    80095c <vprintfmt+0x21>
			if (ch == '\0')
  800945:	85 db                	test   %ebx,%ebx
  800947:	0f 84 af 03 00 00    	je     800cfc <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	53                   	push   %ebx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	ff d0                	call   *%eax
  800959:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80095c:	8b 45 10             	mov    0x10(%ebp),%eax
  80095f:	8d 50 01             	lea    0x1(%eax),%edx
  800962:	89 55 10             	mov    %edx,0x10(%ebp)
  800965:	8a 00                	mov    (%eax),%al
  800967:	0f b6 d8             	movzbl %al,%ebx
  80096a:	83 fb 25             	cmp    $0x25,%ebx
  80096d:	75 d6                	jne    800945 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80096f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800973:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80097a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800981:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800988:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098f:	8b 45 10             	mov    0x10(%ebp),%eax
  800992:	8d 50 01             	lea    0x1(%eax),%edx
  800995:	89 55 10             	mov    %edx,0x10(%ebp)
  800998:	8a 00                	mov    (%eax),%al
  80099a:	0f b6 d8             	movzbl %al,%ebx
  80099d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009a0:	83 f8 55             	cmp    $0x55,%eax
  8009a3:	0f 87 2b 03 00 00    	ja     800cd4 <vprintfmt+0x399>
  8009a9:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  8009b0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009b2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b6:	eb d7                	jmp    80098f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009bc:	eb d1                	jmp    80098f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c8:	89 d0                	mov    %edx,%eax
  8009ca:	c1 e0 02             	shl    $0x2,%eax
  8009cd:	01 d0                	add    %edx,%eax
  8009cf:	01 c0                	add    %eax,%eax
  8009d1:	01 d8                	add    %ebx,%eax
  8009d3:	83 e8 30             	sub    $0x30,%eax
  8009d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009dc:	8a 00                	mov    (%eax),%al
  8009de:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009e1:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e4:	7e 3e                	jle    800a24 <vprintfmt+0xe9>
  8009e6:	83 fb 39             	cmp    $0x39,%ebx
  8009e9:	7f 39                	jg     800a24 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009eb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ee:	eb d5                	jmp    8009c5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f3:	83 c0 04             	add    $0x4,%eax
  8009f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fc:	83 e8 04             	sub    $0x4,%eax
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a04:	eb 1f                	jmp    800a25 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0a:	79 83                	jns    80098f <vprintfmt+0x54>
				width = 0;
  800a0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a13:	e9 77 ff ff ff       	jmp    80098f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a18:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a1f:	e9 6b ff ff ff       	jmp    80098f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a24:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a29:	0f 89 60 ff ff ff    	jns    80098f <vprintfmt+0x54>
				width = precision, precision = -1;
  800a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a35:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a3c:	e9 4e ff ff ff       	jmp    80098f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a41:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a44:	e9 46 ff ff ff       	jmp    80098f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	83 c0 04             	add    $0x4,%eax
  800a4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	83 e8 04             	sub    $0x4,%eax
  800a58:	8b 00                	mov    (%eax),%eax
  800a5a:	83 ec 08             	sub    $0x8,%esp
  800a5d:	ff 75 0c             	pushl  0xc(%ebp)
  800a60:	50                   	push   %eax
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	ff d0                	call   *%eax
  800a66:	83 c4 10             	add    $0x10,%esp
			break;
  800a69:	e9 89 02 00 00       	jmp    800cf7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a71:	83 c0 04             	add    $0x4,%eax
  800a74:	89 45 14             	mov    %eax,0x14(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	83 e8 04             	sub    $0x4,%eax
  800a7d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a7f:	85 db                	test   %ebx,%ebx
  800a81:	79 02                	jns    800a85 <vprintfmt+0x14a>
				err = -err;
  800a83:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a85:	83 fb 64             	cmp    $0x64,%ebx
  800a88:	7f 0b                	jg     800a95 <vprintfmt+0x15a>
  800a8a:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800a91:	85 f6                	test   %esi,%esi
  800a93:	75 19                	jne    800aae <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a95:	53                   	push   %ebx
  800a96:	68 25 26 80 00       	push   $0x802625
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	ff 75 08             	pushl  0x8(%ebp)
  800aa1:	e8 5e 02 00 00       	call   800d04 <printfmt>
  800aa6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa9:	e9 49 02 00 00       	jmp    800cf7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aae:	56                   	push   %esi
  800aaf:	68 2e 26 80 00       	push   $0x80262e
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	ff 75 08             	pushl  0x8(%ebp)
  800aba:	e8 45 02 00 00       	call   800d04 <printfmt>
  800abf:	83 c4 10             	add    $0x10,%esp
			break;
  800ac2:	e9 30 02 00 00       	jmp    800cf7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aca:	83 c0 04             	add    $0x4,%eax
  800acd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad3:	83 e8 04             	sub    $0x4,%eax
  800ad6:	8b 30                	mov    (%eax),%esi
  800ad8:	85 f6                	test   %esi,%esi
  800ada:	75 05                	jne    800ae1 <vprintfmt+0x1a6>
				p = "(null)";
  800adc:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800ae1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae5:	7e 6d                	jle    800b54 <vprintfmt+0x219>
  800ae7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aeb:	74 67                	je     800b54 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	50                   	push   %eax
  800af4:	56                   	push   %esi
  800af5:	e8 0c 03 00 00       	call   800e06 <strnlen>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b00:	eb 16                	jmp    800b18 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b02:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	50                   	push   %eax
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	ff d0                	call   *%eax
  800b12:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b15:	ff 4d e4             	decl   -0x1c(%ebp)
  800b18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1c:	7f e4                	jg     800b02 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b1e:	eb 34                	jmp    800b54 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b20:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b24:	74 1c                	je     800b42 <vprintfmt+0x207>
  800b26:	83 fb 1f             	cmp    $0x1f,%ebx
  800b29:	7e 05                	jle    800b30 <vprintfmt+0x1f5>
  800b2b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b2e:	7e 12                	jle    800b42 <vprintfmt+0x207>
					putch('?', putdat);
  800b30:	83 ec 08             	sub    $0x8,%esp
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	6a 3f                	push   $0x3f
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	ff d0                	call   *%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	eb 0f                	jmp    800b51 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	53                   	push   %ebx
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	ff d0                	call   *%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b51:	ff 4d e4             	decl   -0x1c(%ebp)
  800b54:	89 f0                	mov    %esi,%eax
  800b56:	8d 70 01             	lea    0x1(%eax),%esi
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	0f be d8             	movsbl %al,%ebx
  800b5e:	85 db                	test   %ebx,%ebx
  800b60:	74 24                	je     800b86 <vprintfmt+0x24b>
  800b62:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b66:	78 b8                	js     800b20 <vprintfmt+0x1e5>
  800b68:	ff 4d e0             	decl   -0x20(%ebp)
  800b6b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b6f:	79 af                	jns    800b20 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b71:	eb 13                	jmp    800b86 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	6a 20                	push   $0x20
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	ff d0                	call   *%eax
  800b80:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b83:	ff 4d e4             	decl   -0x1c(%ebp)
  800b86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8a:	7f e7                	jg     800b73 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b8c:	e9 66 01 00 00       	jmp    800cf7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 e8             	pushl  -0x18(%ebp)
  800b97:	8d 45 14             	lea    0x14(%ebp),%eax
  800b9a:	50                   	push   %eax
  800b9b:	e8 3c fd ff ff       	call   8008dc <getint>
  800ba0:	83 c4 10             	add    $0x10,%esp
  800ba3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800baf:	85 d2                	test   %edx,%edx
  800bb1:	79 23                	jns    800bd6 <vprintfmt+0x29b>
				putch('-', putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	6a 2d                	push   $0x2d
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	ff d0                	call   *%eax
  800bc0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc9:	f7 d8                	neg    %eax
  800bcb:	83 d2 00             	adc    $0x0,%edx
  800bce:	f7 da                	neg    %edx
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 bc 00 00 00       	jmp    800c9e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 e8             	pushl  -0x18(%ebp)
  800be8:	8d 45 14             	lea    0x14(%ebp),%eax
  800beb:	50                   	push   %eax
  800bec:	e8 84 fc ff ff       	call   800875 <getuint>
  800bf1:	83 c4 10             	add    $0x10,%esp
  800bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bfa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c01:	e9 98 00 00 00       	jmp    800c9e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c06:	83 ec 08             	sub    $0x8,%esp
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	6a 58                	push   $0x58
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	ff d0                	call   *%eax
  800c13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	6a 58                	push   $0x58
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	6a 58                	push   $0x58
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	ff d0                	call   *%eax
  800c33:	83 c4 10             	add    $0x10,%esp
			break;
  800c36:	e9 bc 00 00 00       	jmp    800cf7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 30                	push   $0x30
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 78                	push   $0x78
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5e:	83 c0 04             	add    $0x4,%eax
  800c61:	89 45 14             	mov    %eax,0x14(%ebp)
  800c64:	8b 45 14             	mov    0x14(%ebp),%eax
  800c67:	83 e8 04             	sub    $0x4,%eax
  800c6a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c76:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c7d:	eb 1f                	jmp    800c9e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 e8             	pushl  -0x18(%ebp)
  800c85:	8d 45 14             	lea    0x14(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	e8 e7 fb ff ff       	call   800875 <getuint>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c9e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca5:	83 ec 04             	sub    $0x4,%esp
  800ca8:	52                   	push   %edx
  800ca9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cac:	50                   	push   %eax
  800cad:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	ff 75 08             	pushl  0x8(%ebp)
  800cb9:	e8 00 fb ff ff       	call   8007be <printnum>
  800cbe:	83 c4 20             	add    $0x20,%esp
			break;
  800cc1:	eb 34                	jmp    800cf7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	53                   	push   %ebx
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	ff d0                	call   *%eax
  800ccf:	83 c4 10             	add    $0x10,%esp
			break;
  800cd2:	eb 23                	jmp    800cf7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	ff 75 0c             	pushl  0xc(%ebp)
  800cda:	6a 25                	push   $0x25
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	ff d0                	call   *%eax
  800ce1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ce4:	ff 4d 10             	decl   0x10(%ebp)
  800ce7:	eb 03                	jmp    800cec <vprintfmt+0x3b1>
  800ce9:	ff 4d 10             	decl   0x10(%ebp)
  800cec:	8b 45 10             	mov    0x10(%ebp),%eax
  800cef:	48                   	dec    %eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	3c 25                	cmp    $0x25,%al
  800cf4:	75 f3                	jne    800ce9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cf6:	90                   	nop
		}
	}
  800cf7:	e9 47 fc ff ff       	jmp    800943 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cfc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d0a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0d:	83 c0 04             	add    $0x4,%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d13:	8b 45 10             	mov    0x10(%ebp),%eax
  800d16:	ff 75 f4             	pushl  -0xc(%ebp)
  800d19:	50                   	push   %eax
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 16 fc ff ff       	call   80093b <vprintfmt>
  800d25:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d28:	90                   	nop
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 40 08             	mov    0x8(%eax),%eax
  800d34:	8d 50 01             	lea    0x1(%eax),%edx
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8b 10                	mov    (%eax),%edx
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8b 40 04             	mov    0x4(%eax),%eax
  800d48:	39 c2                	cmp    %eax,%edx
  800d4a:	73 12                	jae    800d5e <sprintputch+0x33>
		*b->buf++ = ch;
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	8d 48 01             	lea    0x1(%eax),%ecx
  800d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d57:	89 0a                	mov    %ecx,(%edx)
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	88 10                	mov    %dl,(%eax)
}
  800d5e:	90                   	nop
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    

00800d61 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	01 d0                	add    %edx,%eax
  800d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d86:	74 06                	je     800d8e <vsnprintf+0x2d>
  800d88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8c:	7f 07                	jg     800d95 <vsnprintf+0x34>
		return -E_INVAL;
  800d8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d93:	eb 20                	jmp    800db5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d95:	ff 75 14             	pushl  0x14(%ebp)
  800d98:	ff 75 10             	pushl  0x10(%ebp)
  800d9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d9e:	50                   	push   %eax
  800d9f:	68 2b 0d 80 00       	push   $0x800d2b
  800da4:	e8 92 fb ff ff       	call   80093b <vprintfmt>
  800da9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800daf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dbd:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc0:	83 c0 04             	add    $0x4,%eax
  800dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dcc:	50                   	push   %eax
  800dcd:	ff 75 0c             	pushl  0xc(%ebp)
  800dd0:	ff 75 08             	pushl  0x8(%ebp)
  800dd3:	e8 89 ff ff ff       	call   800d61 <vsnprintf>
  800dd8:	83 c4 10             	add    $0x10,%esp
  800ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df0:	eb 06                	jmp    800df8 <strlen+0x15>
		n++;
  800df2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800df5:	ff 45 08             	incl   0x8(%ebp)
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	75 f1                	jne    800df2 <strlen+0xf>
		n++;
	return n;
  800e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e13:	eb 09                	jmp    800e1e <strnlen+0x18>
		n++;
  800e15:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e18:	ff 45 08             	incl   0x8(%ebp)
  800e1b:	ff 4d 0c             	decl   0xc(%ebp)
  800e1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e22:	74 09                	je     800e2d <strnlen+0x27>
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	84 c0                	test   %al,%al
  800e2b:	75 e8                	jne    800e15 <strnlen+0xf>
		n++;
	return n;
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e3e:	90                   	nop
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 08             	mov    %edx,0x8(%ebp)
  800e48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e4                	jne    800e3f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e73:	eb 1f                	jmp    800e94 <strncpy+0x34>
		*dst++ = *src;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8d 50 01             	lea    0x1(%eax),%edx
  800e7b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e81:	8a 12                	mov    (%edx),%dl
  800e83:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	74 03                	je     800e91 <strncpy+0x31>
			src++;
  800e8e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e91:	ff 45 fc             	incl   -0x4(%ebp)
  800e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e97:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e9a:	72 d9                	jb     800e75 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ead:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb1:	74 30                	je     800ee3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eb3:	eb 16                	jmp    800ecb <strlcpy+0x2a>
			*dst++ = *src++;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8d 50 01             	lea    0x1(%eax),%edx
  800ebb:	89 55 08             	mov    %edx,0x8(%ebp)
  800ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ecb:	ff 4d 10             	decl   0x10(%ebp)
  800ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed2:	74 09                	je     800edd <strlcpy+0x3c>
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	84 c0                	test   %al,%al
  800edb:	75 d8                	jne    800eb5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee9:	29 c2                	sub    %eax,%edx
  800eeb:	89 d0                	mov    %edx,%eax
}
  800eed:	c9                   	leave  
  800eee:	c3                   	ret    

00800eef <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ef2:	eb 06                	jmp    800efa <strcmp+0xb>
		p++, q++;
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	74 0e                	je     800f11 <strcmp+0x22>
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 10                	mov    (%eax),%dl
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	38 c2                	cmp    %al,%dl
  800f0f:	74 e3                	je     800ef4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	0f b6 d0             	movzbl %al,%edx
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	0f b6 c0             	movzbl %al,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
}
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f2a:	eb 09                	jmp    800f35 <strncmp+0xe>
		n--, p++, q++;
  800f2c:	ff 4d 10             	decl   0x10(%ebp)
  800f2f:	ff 45 08             	incl   0x8(%ebp)
  800f32:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f39:	74 17                	je     800f52 <strncmp+0x2b>
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	84 c0                	test   %al,%al
  800f42:	74 0e                	je     800f52 <strncmp+0x2b>
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 10                	mov    (%eax),%dl
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	38 c2                	cmp    %al,%dl
  800f50:	74 da                	je     800f2c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f56:	75 07                	jne    800f5f <strncmp+0x38>
		return 0;
  800f58:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5d:	eb 14                	jmp    800f73 <strncmp+0x4c>
	else
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

00800f75 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f81:	eb 12                	jmp    800f95 <strchr+0x20>
		if (*s == c)
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f8b:	75 05                	jne    800f92 <strchr+0x1d>
			return (char *) s;
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	eb 11                	jmp    800fa3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f92:	ff 45 08             	incl   0x8(%ebp)
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	84 c0                	test   %al,%al
  800f9c:	75 e5                	jne    800f83 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 04             	sub    $0x4,%esp
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb1:	eb 0d                	jmp    800fc0 <strfind+0x1b>
		if (*s == c)
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fbb:	74 0e                	je     800fcb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fbd:	ff 45 08             	incl   0x8(%ebp)
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	84 c0                	test   %al,%al
  800fc7:	75 ea                	jne    800fb3 <strfind+0xe>
  800fc9:	eb 01                	jmp    800fcc <strfind+0x27>
		if (*s == c)
			break;
  800fcb:	90                   	nop
	return (char *) s;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fe3:	eb 0e                	jmp    800ff3 <memset+0x22>
		*p++ = c;
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	8d 50 01             	lea    0x1(%eax),%edx
  800feb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ff3:	ff 4d f8             	decl   -0x8(%ebp)
  800ff6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ffa:	79 e9                	jns    800fe5 <memset+0x14>
		*p++ = c;

	return v;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801013:	eb 16                	jmp    80102b <memcpy+0x2a>
		*d++ = *s++;
  801015:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80101e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801021:	8d 4a 01             	lea    0x1(%edx),%ecx
  801024:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801027:	8a 12                	mov    (%edx),%dl
  801029:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80102b:	8b 45 10             	mov    0x10(%ebp),%eax
  80102e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801031:	89 55 10             	mov    %edx,0x10(%ebp)
  801034:	85 c0                	test   %eax,%eax
  801036:	75 dd                	jne    801015 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    

0080103d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801052:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801055:	73 50                	jae    8010a7 <memmove+0x6a>
  801057:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80105a:	8b 45 10             	mov    0x10(%ebp),%eax
  80105d:	01 d0                	add    %edx,%eax
  80105f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801062:	76 43                	jbe    8010a7 <memmove+0x6a>
		s += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80106a:	8b 45 10             	mov    0x10(%ebp),%eax
  80106d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801070:	eb 10                	jmp    801082 <memmove+0x45>
			*--d = *--s;
  801072:	ff 4d f8             	decl   -0x8(%ebp)
  801075:	ff 4d fc             	decl   -0x4(%ebp)
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	8a 10                	mov    (%eax),%dl
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801082:	8b 45 10             	mov    0x10(%ebp),%eax
  801085:	8d 50 ff             	lea    -0x1(%eax),%edx
  801088:	89 55 10             	mov    %edx,0x10(%ebp)
  80108b:	85 c0                	test   %eax,%eax
  80108d:	75 e3                	jne    801072 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80108f:	eb 23                	jmp    8010b4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801091:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801094:	8d 50 01             	lea    0x1(%eax),%edx
  801097:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	75 dd                	jne    801091 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010cb:	eb 2a                	jmp    8010f7 <memcmp+0x3e>
		if (*s1 != *s2)
  8010cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d0:	8a 10                	mov    (%eax),%dl
  8010d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	38 c2                	cmp    %al,%dl
  8010d9:	74 16                	je     8010f1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	0f b6 d0             	movzbl %al,%edx
  8010e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	0f b6 c0             	movzbl %al,%eax
  8010eb:	29 c2                	sub    %eax,%edx
  8010ed:	89 d0                	mov    %edx,%eax
  8010ef:	eb 18                	jmp    801109 <memcmp+0x50>
		s1++, s2++;
  8010f1:	ff 45 fc             	incl   -0x4(%ebp)
  8010f4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fd:	89 55 10             	mov    %edx,0x10(%ebp)
  801100:	85 c0                	test   %eax,%eax
  801102:	75 c9                	jne    8010cd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801104:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801111:	8b 55 08             	mov    0x8(%ebp),%edx
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80111c:	eb 15                	jmp    801133 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	0f b6 d0             	movzbl %al,%edx
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	0f b6 c0             	movzbl %al,%eax
  80112c:	39 c2                	cmp    %eax,%edx
  80112e:	74 0d                	je     80113d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801130:	ff 45 08             	incl   0x8(%ebp)
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801139:	72 e3                	jb     80111e <memfind+0x13>
  80113b:	eb 01                	jmp    80113e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80113d:	90                   	nop
	return (void *) s;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801150:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801157:	eb 03                	jmp    80115c <strtol+0x19>
		s++;
  801159:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 20                	cmp    $0x20,%al
  801163:	74 f4                	je     801159 <strtol+0x16>
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 09                	cmp    $0x9,%al
  80116c:	74 eb                	je     801159 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 2b                	cmp    $0x2b,%al
  801175:	75 05                	jne    80117c <strtol+0x39>
		s++;
  801177:	ff 45 08             	incl   0x8(%ebp)
  80117a:	eb 13                	jmp    80118f <strtol+0x4c>
	else if (*s == '-')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 2d                	cmp    $0x2d,%al
  801183:	75 0a                	jne    80118f <strtol+0x4c>
		s++, neg = 1;
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80118f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801193:	74 06                	je     80119b <strtol+0x58>
  801195:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801199:	75 20                	jne    8011bb <strtol+0x78>
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	3c 30                	cmp    $0x30,%al
  8011a2:	75 17                	jne    8011bb <strtol+0x78>
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	40                   	inc    %eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 78                	cmp    $0x78,%al
  8011ac:	75 0d                	jne    8011bb <strtol+0x78>
		s += 2, base = 16;
  8011ae:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011b2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b9:	eb 28                	jmp    8011e3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bf:	75 15                	jne    8011d6 <strtol+0x93>
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 30                	cmp    $0x30,%al
  8011c8:	75 0c                	jne    8011d6 <strtol+0x93>
		s++, base = 8;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011d4:	eb 0d                	jmp    8011e3 <strtol+0xa0>
	else if (base == 0)
  8011d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011da:	75 07                	jne    8011e3 <strtol+0xa0>
		base = 10;
  8011dc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	3c 2f                	cmp    $0x2f,%al
  8011ea:	7e 19                	jle    801205 <strtol+0xc2>
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	3c 39                	cmp    $0x39,%al
  8011f3:	7f 10                	jg     801205 <strtol+0xc2>
			dig = *s - '0';
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	0f be c0             	movsbl %al,%eax
  8011fd:	83 e8 30             	sub    $0x30,%eax
  801200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801203:	eb 42                	jmp    801247 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3c 60                	cmp    $0x60,%al
  80120c:	7e 19                	jle    801227 <strtol+0xe4>
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	3c 7a                	cmp    $0x7a,%al
  801215:	7f 10                	jg     801227 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	0f be c0             	movsbl %al,%eax
  80121f:	83 e8 57             	sub    $0x57,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801225:	eb 20                	jmp    801247 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	3c 40                	cmp    $0x40,%al
  80122e:	7e 39                	jle    801269 <strtol+0x126>
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	3c 5a                	cmp    $0x5a,%al
  801237:	7f 30                	jg     801269 <strtol+0x126>
			dig = *s - 'A' + 10;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	0f be c0             	movsbl %al,%eax
  801241:	83 e8 37             	sub    $0x37,%eax
  801244:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80124d:	7d 19                	jge    801268 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80124f:	ff 45 08             	incl   0x8(%ebp)
  801252:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801255:	0f af 45 10          	imul   0x10(%ebp),%eax
  801259:	89 c2                	mov    %eax,%edx
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	01 d0                	add    %edx,%eax
  801260:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801263:	e9 7b ff ff ff       	jmp    8011e3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801268:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801269:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80126d:	74 08                	je     801277 <strtol+0x134>
		*endptr = (char *) s;
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	8b 55 08             	mov    0x8(%ebp),%edx
  801275:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127b:	74 07                	je     801284 <strtol+0x141>
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	f7 d8                	neg    %eax
  801282:	eb 03                	jmp    801287 <strtol+0x144>
  801284:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801287:	c9                   	leave  
  801288:	c3                   	ret    

00801289 <ltostr>:

void
ltostr(long value, char *str)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80128f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80129d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a1:	79 13                	jns    8012b6 <ltostr+0x2d>
	{
		neg = 1;
  8012a3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012b0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012b3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012be:	99                   	cltd   
  8012bf:	f7 f9                	idiv   %ecx
  8012c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012cd:	89 c2                	mov    %eax,%edx
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d7:	83 c2 30             	add    $0x30,%edx
  8012da:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012df:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e4:	f7 e9                	imul   %ecx
  8012e6:	c1 fa 02             	sar    $0x2,%edx
  8012e9:	89 c8                	mov    %ecx,%eax
  8012eb:	c1 f8 1f             	sar    $0x1f,%eax
  8012ee:	29 c2                	sub    %eax,%edx
  8012f0:	89 d0                	mov    %edx,%eax
  8012f2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012fd:	f7 e9                	imul   %ecx
  8012ff:	c1 fa 02             	sar    $0x2,%edx
  801302:	89 c8                	mov    %ecx,%eax
  801304:	c1 f8 1f             	sar    $0x1f,%eax
  801307:	29 c2                	sub    %eax,%edx
  801309:	89 d0                	mov    %edx,%eax
  80130b:	c1 e0 02             	shl    $0x2,%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	01 c0                	add    %eax,%eax
  801312:	29 c1                	sub    %eax,%ecx
  801314:	89 ca                	mov    %ecx,%edx
  801316:	85 d2                	test   %edx,%edx
  801318:	75 9c                	jne    8012b6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80131a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801324:	48                   	dec    %eax
  801325:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801328:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80132c:	74 3d                	je     80136b <ltostr+0xe2>
		start = 1 ;
  80132e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801335:	eb 34                	jmp    80136b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801337:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133d:	01 d0                	add    %edx,%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	01 c8                	add    %ecx,%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801358:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 c2                	add    %eax,%edx
  801360:	8a 45 eb             	mov    -0x15(%ebp),%al
  801363:	88 02                	mov    %al,(%edx)
		start++ ;
  801365:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801368:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801371:	7c c4                	jl     801337 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801373:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80137e:	90                   	nop
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801387:	ff 75 08             	pushl  0x8(%ebp)
  80138a:	e8 54 fa ff ff       	call   800de3 <strlen>
  80138f:	83 c4 04             	add    $0x4,%esp
  801392:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801395:	ff 75 0c             	pushl  0xc(%ebp)
  801398:	e8 46 fa ff ff       	call   800de3 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b1:	eb 17                	jmp    8013ca <strcconcat+0x49>
		final[s] = str1[s] ;
  8013b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	01 c2                	add    %eax,%edx
  8013bb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	01 c8                	add    %ecx,%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c7:	ff 45 fc             	incl   -0x4(%ebp)
  8013ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013d0:	7c e1                	jl     8013b3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013e0:	eb 1f                	jmp    801401 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e5:	8d 50 01             	lea    0x1(%eax),%edx
  8013e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f0:	01 c2                	add    %eax,%edx
  8013f2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	01 c8                	add    %ecx,%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013fe:	ff 45 f8             	incl   -0x8(%ebp)
  801401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801404:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801407:	7c d9                	jl     8013e2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801409:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140c:	8b 45 10             	mov    0x10(%ebp),%eax
  80140f:	01 d0                	add    %edx,%eax
  801411:	c6 00 00             	movb   $0x0,(%eax)
}
  801414:	90                   	nop
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80141a:	8b 45 14             	mov    0x14(%ebp),%eax
  80141d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801423:	8b 45 14             	mov    0x14(%ebp),%eax
  801426:	8b 00                	mov    (%eax),%eax
  801428:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142f:	8b 45 10             	mov    0x10(%ebp),%eax
  801432:	01 d0                	add    %edx,%eax
  801434:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80143a:	eb 0c                	jmp    801448 <strsplit+0x31>
			*string++ = 0;
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8d 50 01             	lea    0x1(%eax),%edx
  801442:	89 55 08             	mov    %edx,0x8(%ebp)
  801445:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	74 18                	je     801469 <strsplit+0x52>
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f be c0             	movsbl %al,%eax
  801459:	50                   	push   %eax
  80145a:	ff 75 0c             	pushl  0xc(%ebp)
  80145d:	e8 13 fb ff ff       	call   800f75 <strchr>
  801462:	83 c4 08             	add    $0x8,%esp
  801465:	85 c0                	test   %eax,%eax
  801467:	75 d3                	jne    80143c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	84 c0                	test   %al,%al
  801470:	74 5a                	je     8014cc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801472:	8b 45 14             	mov    0x14(%ebp),%eax
  801475:	8b 00                	mov    (%eax),%eax
  801477:	83 f8 0f             	cmp    $0xf,%eax
  80147a:	75 07                	jne    801483 <strsplit+0x6c>
		{
			return 0;
  80147c:	b8 00 00 00 00       	mov    $0x0,%eax
  801481:	eb 66                	jmp    8014e9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801483:	8b 45 14             	mov    0x14(%ebp),%eax
  801486:	8b 00                	mov    (%eax),%eax
  801488:	8d 48 01             	lea    0x1(%eax),%ecx
  80148b:	8b 55 14             	mov    0x14(%ebp),%edx
  80148e:	89 0a                	mov    %ecx,(%edx)
  801490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801497:	8b 45 10             	mov    0x10(%ebp),%eax
  80149a:	01 c2                	add    %eax,%edx
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a1:	eb 03                	jmp    8014a6 <strsplit+0x8f>
			string++;
  8014a3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	84 c0                	test   %al,%al
  8014ad:	74 8b                	je     80143a <strsplit+0x23>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	0f be c0             	movsbl %al,%eax
  8014b7:	50                   	push   %eax
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	e8 b5 fa ff ff       	call   800f75 <strchr>
  8014c0:	83 c4 08             	add    $0x8,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	74 dc                	je     8014a3 <strsplit+0x8c>
			string++;
	}
  8014c7:	e9 6e ff ff ff       	jmp    80143a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014cc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d0:	8b 00                	mov    (%eax),%eax
  8014d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014e4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8014f1:	83 ec 04             	sub    $0x4,%esp
  8014f4:	68 90 27 80 00       	push   $0x802790
  8014f9:	6a 0e                	push   $0xe
  8014fb:	68 ca 27 80 00       	push   $0x8027ca
  801500:	e8 a8 ef ff ff       	call   8004ad <_panic>

00801505 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80150b:	a1 04 30 80 00       	mov    0x803004,%eax
  801510:	85 c0                	test   %eax,%eax
  801512:	74 0f                	je     801523 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801514:	e8 d2 ff ff ff       	call   8014eb <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801519:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801520:	00 00 00 
	}
	if (size == 0) return NULL ;
  801523:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801527:	75 07                	jne    801530 <malloc+0x2b>
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
  80152e:	eb 14                	jmp    801544 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	68 d8 27 80 00       	push   $0x8027d8
  801538:	6a 2e                	push   $0x2e
  80153a:	68 ca 27 80 00       	push   $0x8027ca
  80153f:	e8 69 ef ff ff       	call   8004ad <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	68 00 28 80 00       	push   $0x802800
  801554:	6a 49                	push   $0x49
  801556:	68 ca 27 80 00       	push   $0x8027ca
  80155b:	e8 4d ef ff ff       	call   8004ad <_panic>

00801560 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 18             	sub    $0x18,%esp
  801566:	8b 45 10             	mov    0x10(%ebp),%eax
  801569:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 24 28 80 00       	push   $0x802824
  801574:	6a 57                	push   $0x57
  801576:	68 ca 27 80 00       	push   $0x8027ca
  80157b:	e8 2d ef ff ff       	call   8004ad <_panic>

00801580 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	68 4c 28 80 00       	push   $0x80284c
  80158e:	6a 60                	push   $0x60
  801590:	68 ca 27 80 00       	push   $0x8027ca
  801595:	e8 13 ef ff ff       	call   8004ad <_panic>

0080159a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a0:	83 ec 04             	sub    $0x4,%esp
  8015a3:	68 70 28 80 00       	push   $0x802870
  8015a8:	6a 7c                	push   $0x7c
  8015aa:	68 ca 27 80 00       	push   $0x8027ca
  8015af:	e8 f9 ee ff ff       	call   8004ad <_panic>

008015b4 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	68 98 28 80 00       	push   $0x802898
  8015c2:	68 86 00 00 00       	push   $0x86
  8015c7:	68 ca 27 80 00       	push   $0x8027ca
  8015cc:	e8 dc ee ff ff       	call   8004ad <_panic>

008015d1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	68 bc 28 80 00       	push   $0x8028bc
  8015df:	68 91 00 00 00       	push   $0x91
  8015e4:	68 ca 27 80 00       	push   $0x8027ca
  8015e9:	e8 bf ee ff ff       	call   8004ad <_panic>

008015ee <shrink>:

}
void shrink(uint32 newSize)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f4:	83 ec 04             	sub    $0x4,%esp
  8015f7:	68 bc 28 80 00       	push   $0x8028bc
  8015fc:	68 96 00 00 00       	push   $0x96
  801601:	68 ca 27 80 00       	push   $0x8027ca
  801606:	e8 a2 ee ff ff       	call   8004ad <_panic>

0080160b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	68 bc 28 80 00       	push   $0x8028bc
  801619:	68 9b 00 00 00       	push   $0x9b
  80161e:	68 ca 27 80 00       	push   $0x8027ca
  801623:	e8 85 ee ff ff       	call   8004ad <_panic>

00801628 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	57                   	push   %edi
  80162c:	56                   	push   %esi
  80162d:	53                   	push   %ebx
  80162e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	8b 55 0c             	mov    0xc(%ebp),%edx
  801637:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80163d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801640:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801643:	cd 30                	int    $0x30
  801645:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801648:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	5b                   	pop    %ebx
  80164f:	5e                   	pop    %esi
  801650:	5f                   	pop    %edi
  801651:	5d                   	pop    %ebp
  801652:	c3                   	ret    

00801653 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80165f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	52                   	push   %edx
  80166b:	ff 75 0c             	pushl  0xc(%ebp)
  80166e:	50                   	push   %eax
  80166f:	6a 00                	push   $0x0
  801671:	e8 b2 ff ff ff       	call   801628 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	90                   	nop
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_cgetc>:

int
sys_cgetc(void)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 01                	push   $0x1
  80168b:	e8 98 ff ff ff       	call   801628 <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	52                   	push   %edx
  8016a5:	50                   	push   %eax
  8016a6:	6a 05                	push   $0x5
  8016a8:	e8 7b ff ff ff       	call   801628 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	56                   	push   %esi
  8016b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8016ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	56                   	push   %esi
  8016c7:	53                   	push   %ebx
  8016c8:	51                   	push   %ecx
  8016c9:	52                   	push   %edx
  8016ca:	50                   	push   %eax
  8016cb:	6a 06                	push   $0x6
  8016cd:	e8 56 ff ff ff       	call   801628 <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d8:	5b                   	pop    %ebx
  8016d9:	5e                   	pop    %esi
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	52                   	push   %edx
  8016ec:	50                   	push   %eax
  8016ed:	6a 07                	push   $0x7
  8016ef:	e8 34 ff ff ff       	call   801628 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	6a 08                	push   $0x8
  80170a:	e8 19 ff ff ff       	call   801628 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 09                	push   $0x9
  801723:	e8 00 ff ff ff       	call   801628 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 0a                	push   $0xa
  80173c:	e8 e7 fe ff ff       	call   801628 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 0b                	push   $0xb
  801755:	e8 ce fe ff ff       	call   801628 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	6a 0f                	push   $0xf
  801770:	e8 b3 fe ff ff       	call   801628 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
	return;
  801778:	90                   	nop
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	ff 75 08             	pushl  0x8(%ebp)
  80178a:	6a 10                	push   $0x10
  80178c:	e8 97 fe ff ff       	call   801628 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
	return ;
  801794:	90                   	nop
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	ff 75 10             	pushl  0x10(%ebp)
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 08             	pushl  0x8(%ebp)
  8017a7:	6a 11                	push   $0x11
  8017a9:	e8 7a fe ff ff       	call   801628 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b1:	90                   	nop
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 0c                	push   $0xc
  8017c3:	e8 60 fe ff ff       	call   801628 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	6a 0d                	push   $0xd
  8017dd:	e8 46 fe ff ff       	call   801628 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 0e                	push   $0xe
  8017f6:	e8 2d fe ff ff       	call   801628 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	90                   	nop
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 13                	push   $0x13
  801810:	e8 13 fe ff ff       	call   801628 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	90                   	nop
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 14                	push   $0x14
  80182a:	e8 f9 fd ff ff       	call   801628 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	90                   	nop
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_cputc>:


void
sys_cputc(const char c)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801841:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	50                   	push   %eax
  80184e:	6a 15                	push   $0x15
  801850:	e8 d3 fd ff ff       	call   801628 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	90                   	nop
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 16                	push   $0x16
  80186a:	e8 b9 fd ff ff       	call   801628 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	50                   	push   %eax
  801885:	6a 17                	push   $0x17
  801887:	e8 9c fd ff ff       	call   801628 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801894:	8b 55 0c             	mov    0xc(%ebp),%edx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 1a                	push   $0x1a
  8018a4:	e8 7f fd ff ff       	call   801628 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 18                	push   $0x18
  8018c1:	e8 62 fd ff ff       	call   801628 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	90                   	nop
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	6a 19                	push   $0x19
  8018df:	e8 44 fd ff ff       	call   801628 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	90                   	nop
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 04             	sub    $0x4,%esp
  8018f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	51                   	push   %ecx
  801903:	52                   	push   %edx
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	50                   	push   %eax
  801908:	6a 1b                	push   $0x1b
  80190a:	e8 19 fd ff ff       	call   801628 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 1c                	push   $0x1c
  801927:	e8 fc fc ff ff       	call   801628 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801934:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	51                   	push   %ecx
  801942:	52                   	push   %edx
  801943:	50                   	push   %eax
  801944:	6a 1d                	push   $0x1d
  801946:	e8 dd fc ff ff       	call   801628 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	6a 1e                	push   $0x1e
  801963:	e8 c0 fc ff ff       	call   801628 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 1f                	push   $0x1f
  80197c:	e8 a7 fc ff ff       	call   801628 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 14             	pushl  0x14(%ebp)
  801991:	ff 75 10             	pushl  0x10(%ebp)
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	50                   	push   %eax
  801998:	6a 20                	push   $0x20
  80199a:	e8 89 fc ff ff       	call   801628 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	50                   	push   %eax
  8019b3:	6a 21                	push   $0x21
  8019b5:	e8 6e fc ff ff       	call   801628 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	90                   	nop
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	50                   	push   %eax
  8019cf:	6a 22                	push   $0x22
  8019d1:	e8 52 fc ff ff       	call   801628 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 02                	push   $0x2
  8019ea:	e8 39 fc ff ff       	call   801628 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 03                	push   $0x3
  801a03:	e8 20 fc ff ff       	call   801628 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 04                	push   $0x4
  801a1c:	e8 07 fc ff ff       	call   801628 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_exit_env>:


void sys_exit_env(void)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 23                	push   $0x23
  801a35:	e8 ee fb ff ff       	call   801628 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a49:	8d 50 04             	lea    0x4(%eax),%edx
  801a4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 24                	push   $0x24
  801a59:	e8 ca fb ff ff       	call   801628 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
	return result;
  801a61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6a:	89 01                	mov    %eax,(%ecx)
  801a6c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	c9                   	leave  
  801a73:	c2 04 00             	ret    $0x4

00801a76 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	ff 75 10             	pushl  0x10(%ebp)
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 12                	push   $0x12
  801a88:	e8 9b fb ff ff       	call   801628 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a90:	90                   	nop
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 25                	push   $0x25
  801aa2:	e8 81 fb ff ff       	call   801628 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ab8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	50                   	push   %eax
  801ac5:	6a 26                	push   $0x26
  801ac7:	e8 5c fb ff ff       	call   801628 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
	return ;
  801acf:	90                   	nop
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <rsttst>:
void rsttst()
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 28                	push   $0x28
  801ae1:	e8 42 fb ff ff       	call   801628 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae9:	90                   	nop
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	8b 45 14             	mov    0x14(%ebp),%eax
  801af5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801af8:	8b 55 18             	mov    0x18(%ebp),%edx
  801afb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	ff 75 10             	pushl  0x10(%ebp)
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	6a 27                	push   $0x27
  801b0c:	e8 17 fb ff ff       	call   801628 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
	return ;
  801b14:	90                   	nop
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <chktst>:
void chktst(uint32 n)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	ff 75 08             	pushl  0x8(%ebp)
  801b25:	6a 29                	push   $0x29
  801b27:	e8 fc fa ff ff       	call   801628 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2f:	90                   	nop
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <inctst>:

void inctst()
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 2a                	push   $0x2a
  801b41:	e8 e2 fa ff ff       	call   801628 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
	return ;
  801b49:	90                   	nop
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <gettst>:
uint32 gettst()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 2b                	push   $0x2b
  801b5b:	e8 c8 fa ff ff       	call   801628 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 2c                	push   $0x2c
  801b77:	e8 ac fa ff ff       	call   801628 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
  801b7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b82:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b86:	75 07                	jne    801b8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b88:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8d:	eb 05                	jmp    801b94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 2c                	push   $0x2c
  801ba8:	e8 7b fa ff ff       	call   801628 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
  801bb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bb3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bb7:	75 07                	jne    801bc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbe:	eb 05                	jmp    801bc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 2c                	push   $0x2c
  801bd9:	e8 4a fa ff ff       	call   801628 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
  801be1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801be4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801be8:	75 07                	jne    801bf1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
  801bef:	eb 05                	jmp    801bf6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 2c                	push   $0x2c
  801c0a:	e8 19 fa ff ff       	call   801628 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
  801c12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c15:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c19:	75 07                	jne    801c22 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c20:	eb 05                	jmp    801c27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 08             	pushl  0x8(%ebp)
  801c37:	6a 2d                	push   $0x2d
  801c39:	e8 ea f9 ff ff       	call   801628 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c41:	90                   	nop
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c48:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	53                   	push   %ebx
  801c57:	51                   	push   %ecx
  801c58:	52                   	push   %edx
  801c59:	50                   	push   %eax
  801c5a:	6a 2e                	push   $0x2e
  801c5c:	e8 c7 f9 ff ff       	call   801628 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	52                   	push   %edx
  801c79:	50                   	push   %eax
  801c7a:	6a 2f                	push   $0x2f
  801c7c:	e8 a7 f9 ff ff       	call   801628 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	c1 e0 02             	shl    $0x2,%eax
  801c94:	01 d0                	add    %edx,%eax
  801c96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c9d:	01 d0                	add    %edx,%eax
  801c9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ca6:	01 d0                	add    %edx,%eax
  801ca8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caf:	01 d0                	add    %edx,%eax
  801cb1:	c1 e0 04             	shl    $0x4,%eax
  801cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801cb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801cbe:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	50                   	push   %eax
  801cc5:	e8 76 fd ff ff       	call   801a40 <sys_get_virtual_time>
  801cca:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801ccd:	eb 41                	jmp    801d10 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801ccf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801cd2:	83 ec 0c             	sub    $0xc,%esp
  801cd5:	50                   	push   %eax
  801cd6:	e8 65 fd ff ff       	call   801a40 <sys_get_virtual_time>
  801cdb:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801cde:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ce1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce4:	29 c2                	sub    %eax,%edx
  801ce6:	89 d0                	mov    %edx,%eax
  801ce8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801ceb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf1:	89 d1                	mov    %edx,%ecx
  801cf3:	29 c1                	sub    %eax,%ecx
  801cf5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfb:	39 c2                	cmp    %eax,%edx
  801cfd:	0f 97 c0             	seta   %al
  801d00:	0f b6 c0             	movzbl %al,%eax
  801d03:	29 c1                	sub    %eax,%ecx
  801d05:	89 c8                	mov    %ecx,%eax
  801d07:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d13:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d16:	72 b7                	jb     801ccf <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d18:	90                   	nop
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801d28:	eb 03                	jmp    801d2d <busy_wait+0x12>
  801d2a:	ff 45 fc             	incl   -0x4(%ebp)
  801d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d30:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d33:	72 f5                	jb     801d2a <busy_wait+0xf>
	return i;
  801d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    
  801d3a:	66 90                	xchg   %ax,%ax

00801d3c <__udivdi3>:
  801d3c:	55                   	push   %ebp
  801d3d:	57                   	push   %edi
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	83 ec 1c             	sub    $0x1c,%esp
  801d43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d53:	89 ca                	mov    %ecx,%edx
  801d55:	89 f8                	mov    %edi,%eax
  801d57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d5b:	85 f6                	test   %esi,%esi
  801d5d:	75 2d                	jne    801d8c <__udivdi3+0x50>
  801d5f:	39 cf                	cmp    %ecx,%edi
  801d61:	77 65                	ja     801dc8 <__udivdi3+0x8c>
  801d63:	89 fd                	mov    %edi,%ebp
  801d65:	85 ff                	test   %edi,%edi
  801d67:	75 0b                	jne    801d74 <__udivdi3+0x38>
  801d69:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6e:	31 d2                	xor    %edx,%edx
  801d70:	f7 f7                	div    %edi
  801d72:	89 c5                	mov    %eax,%ebp
  801d74:	31 d2                	xor    %edx,%edx
  801d76:	89 c8                	mov    %ecx,%eax
  801d78:	f7 f5                	div    %ebp
  801d7a:	89 c1                	mov    %eax,%ecx
  801d7c:	89 d8                	mov    %ebx,%eax
  801d7e:	f7 f5                	div    %ebp
  801d80:	89 cf                	mov    %ecx,%edi
  801d82:	89 fa                	mov    %edi,%edx
  801d84:	83 c4 1c             	add    $0x1c,%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5f                   	pop    %edi
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    
  801d8c:	39 ce                	cmp    %ecx,%esi
  801d8e:	77 28                	ja     801db8 <__udivdi3+0x7c>
  801d90:	0f bd fe             	bsr    %esi,%edi
  801d93:	83 f7 1f             	xor    $0x1f,%edi
  801d96:	75 40                	jne    801dd8 <__udivdi3+0x9c>
  801d98:	39 ce                	cmp    %ecx,%esi
  801d9a:	72 0a                	jb     801da6 <__udivdi3+0x6a>
  801d9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801da0:	0f 87 9e 00 00 00    	ja     801e44 <__udivdi3+0x108>
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	89 fa                	mov    %edi,%edx
  801dad:	83 c4 1c             	add    $0x1c,%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5f                   	pop    %edi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    
  801db5:	8d 76 00             	lea    0x0(%esi),%esi
  801db8:	31 ff                	xor    %edi,%edi
  801dba:	31 c0                	xor    %eax,%eax
  801dbc:	89 fa                	mov    %edi,%edx
  801dbe:	83 c4 1c             	add    $0x1c,%esp
  801dc1:	5b                   	pop    %ebx
  801dc2:	5e                   	pop    %esi
  801dc3:	5f                   	pop    %edi
  801dc4:	5d                   	pop    %ebp
  801dc5:	c3                   	ret    
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	89 d8                	mov    %ebx,%eax
  801dca:	f7 f7                	div    %edi
  801dcc:	31 ff                	xor    %edi,%edi
  801dce:	89 fa                	mov    %edi,%edx
  801dd0:	83 c4 1c             	add    $0x1c,%esp
  801dd3:	5b                   	pop    %ebx
  801dd4:	5e                   	pop    %esi
  801dd5:	5f                   	pop    %edi
  801dd6:	5d                   	pop    %ebp
  801dd7:	c3                   	ret    
  801dd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ddd:	89 eb                	mov    %ebp,%ebx
  801ddf:	29 fb                	sub    %edi,%ebx
  801de1:	89 f9                	mov    %edi,%ecx
  801de3:	d3 e6                	shl    %cl,%esi
  801de5:	89 c5                	mov    %eax,%ebp
  801de7:	88 d9                	mov    %bl,%cl
  801de9:	d3 ed                	shr    %cl,%ebp
  801deb:	89 e9                	mov    %ebp,%ecx
  801ded:	09 f1                	or     %esi,%ecx
  801def:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801df3:	89 f9                	mov    %edi,%ecx
  801df5:	d3 e0                	shl    %cl,%eax
  801df7:	89 c5                	mov    %eax,%ebp
  801df9:	89 d6                	mov    %edx,%esi
  801dfb:	88 d9                	mov    %bl,%cl
  801dfd:	d3 ee                	shr    %cl,%esi
  801dff:	89 f9                	mov    %edi,%ecx
  801e01:	d3 e2                	shl    %cl,%edx
  801e03:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e07:	88 d9                	mov    %bl,%cl
  801e09:	d3 e8                	shr    %cl,%eax
  801e0b:	09 c2                	or     %eax,%edx
  801e0d:	89 d0                	mov    %edx,%eax
  801e0f:	89 f2                	mov    %esi,%edx
  801e11:	f7 74 24 0c          	divl   0xc(%esp)
  801e15:	89 d6                	mov    %edx,%esi
  801e17:	89 c3                	mov    %eax,%ebx
  801e19:	f7 e5                	mul    %ebp
  801e1b:	39 d6                	cmp    %edx,%esi
  801e1d:	72 19                	jb     801e38 <__udivdi3+0xfc>
  801e1f:	74 0b                	je     801e2c <__udivdi3+0xf0>
  801e21:	89 d8                	mov    %ebx,%eax
  801e23:	31 ff                	xor    %edi,%edi
  801e25:	e9 58 ff ff ff       	jmp    801d82 <__udivdi3+0x46>
  801e2a:	66 90                	xchg   %ax,%ax
  801e2c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e30:	89 f9                	mov    %edi,%ecx
  801e32:	d3 e2                	shl    %cl,%edx
  801e34:	39 c2                	cmp    %eax,%edx
  801e36:	73 e9                	jae    801e21 <__udivdi3+0xe5>
  801e38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e3b:	31 ff                	xor    %edi,%edi
  801e3d:	e9 40 ff ff ff       	jmp    801d82 <__udivdi3+0x46>
  801e42:	66 90                	xchg   %ax,%ax
  801e44:	31 c0                	xor    %eax,%eax
  801e46:	e9 37 ff ff ff       	jmp    801d82 <__udivdi3+0x46>
  801e4b:	90                   	nop

00801e4c <__umoddi3>:
  801e4c:	55                   	push   %ebp
  801e4d:	57                   	push   %edi
  801e4e:	56                   	push   %esi
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 1c             	sub    $0x1c,%esp
  801e53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e57:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e6b:	89 f3                	mov    %esi,%ebx
  801e6d:	89 fa                	mov    %edi,%edx
  801e6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e73:	89 34 24             	mov    %esi,(%esp)
  801e76:	85 c0                	test   %eax,%eax
  801e78:	75 1a                	jne    801e94 <__umoddi3+0x48>
  801e7a:	39 f7                	cmp    %esi,%edi
  801e7c:	0f 86 a2 00 00 00    	jbe    801f24 <__umoddi3+0xd8>
  801e82:	89 c8                	mov    %ecx,%eax
  801e84:	89 f2                	mov    %esi,%edx
  801e86:	f7 f7                	div    %edi
  801e88:	89 d0                	mov    %edx,%eax
  801e8a:	31 d2                	xor    %edx,%edx
  801e8c:	83 c4 1c             	add    $0x1c,%esp
  801e8f:	5b                   	pop    %ebx
  801e90:	5e                   	pop    %esi
  801e91:	5f                   	pop    %edi
  801e92:	5d                   	pop    %ebp
  801e93:	c3                   	ret    
  801e94:	39 f0                	cmp    %esi,%eax
  801e96:	0f 87 ac 00 00 00    	ja     801f48 <__umoddi3+0xfc>
  801e9c:	0f bd e8             	bsr    %eax,%ebp
  801e9f:	83 f5 1f             	xor    $0x1f,%ebp
  801ea2:	0f 84 ac 00 00 00    	je     801f54 <__umoddi3+0x108>
  801ea8:	bf 20 00 00 00       	mov    $0x20,%edi
  801ead:	29 ef                	sub    %ebp,%edi
  801eaf:	89 fe                	mov    %edi,%esi
  801eb1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801eb5:	89 e9                	mov    %ebp,%ecx
  801eb7:	d3 e0                	shl    %cl,%eax
  801eb9:	89 d7                	mov    %edx,%edi
  801ebb:	89 f1                	mov    %esi,%ecx
  801ebd:	d3 ef                	shr    %cl,%edi
  801ebf:	09 c7                	or     %eax,%edi
  801ec1:	89 e9                	mov    %ebp,%ecx
  801ec3:	d3 e2                	shl    %cl,%edx
  801ec5:	89 14 24             	mov    %edx,(%esp)
  801ec8:	89 d8                	mov    %ebx,%eax
  801eca:	d3 e0                	shl    %cl,%eax
  801ecc:	89 c2                	mov    %eax,%edx
  801ece:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ed2:	d3 e0                	shl    %cl,%eax
  801ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801edc:	89 f1                	mov    %esi,%ecx
  801ede:	d3 e8                	shr    %cl,%eax
  801ee0:	09 d0                	or     %edx,%eax
  801ee2:	d3 eb                	shr    %cl,%ebx
  801ee4:	89 da                	mov    %ebx,%edx
  801ee6:	f7 f7                	div    %edi
  801ee8:	89 d3                	mov    %edx,%ebx
  801eea:	f7 24 24             	mull   (%esp)
  801eed:	89 c6                	mov    %eax,%esi
  801eef:	89 d1                	mov    %edx,%ecx
  801ef1:	39 d3                	cmp    %edx,%ebx
  801ef3:	0f 82 87 00 00 00    	jb     801f80 <__umoddi3+0x134>
  801ef9:	0f 84 91 00 00 00    	je     801f90 <__umoddi3+0x144>
  801eff:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f03:	29 f2                	sub    %esi,%edx
  801f05:	19 cb                	sbb    %ecx,%ebx
  801f07:	89 d8                	mov    %ebx,%eax
  801f09:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f0d:	d3 e0                	shl    %cl,%eax
  801f0f:	89 e9                	mov    %ebp,%ecx
  801f11:	d3 ea                	shr    %cl,%edx
  801f13:	09 d0                	or     %edx,%eax
  801f15:	89 e9                	mov    %ebp,%ecx
  801f17:	d3 eb                	shr    %cl,%ebx
  801f19:	89 da                	mov    %ebx,%edx
  801f1b:	83 c4 1c             	add    $0x1c,%esp
  801f1e:	5b                   	pop    %ebx
  801f1f:	5e                   	pop    %esi
  801f20:	5f                   	pop    %edi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    
  801f23:	90                   	nop
  801f24:	89 fd                	mov    %edi,%ebp
  801f26:	85 ff                	test   %edi,%edi
  801f28:	75 0b                	jne    801f35 <__umoddi3+0xe9>
  801f2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2f:	31 d2                	xor    %edx,%edx
  801f31:	f7 f7                	div    %edi
  801f33:	89 c5                	mov    %eax,%ebp
  801f35:	89 f0                	mov    %esi,%eax
  801f37:	31 d2                	xor    %edx,%edx
  801f39:	f7 f5                	div    %ebp
  801f3b:	89 c8                	mov    %ecx,%eax
  801f3d:	f7 f5                	div    %ebp
  801f3f:	89 d0                	mov    %edx,%eax
  801f41:	e9 44 ff ff ff       	jmp    801e8a <__umoddi3+0x3e>
  801f46:	66 90                	xchg   %ax,%ax
  801f48:	89 c8                	mov    %ecx,%eax
  801f4a:	89 f2                	mov    %esi,%edx
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    
  801f54:	3b 04 24             	cmp    (%esp),%eax
  801f57:	72 06                	jb     801f5f <__umoddi3+0x113>
  801f59:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f5d:	77 0f                	ja     801f6e <__umoddi3+0x122>
  801f5f:	89 f2                	mov    %esi,%edx
  801f61:	29 f9                	sub    %edi,%ecx
  801f63:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f67:	89 14 24             	mov    %edx,(%esp)
  801f6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f72:	8b 14 24             	mov    (%esp),%edx
  801f75:	83 c4 1c             	add    $0x1c,%esp
  801f78:	5b                   	pop    %ebx
  801f79:	5e                   	pop    %esi
  801f7a:	5f                   	pop    %edi
  801f7b:	5d                   	pop    %ebp
  801f7c:	c3                   	ret    
  801f7d:	8d 76 00             	lea    0x0(%esi),%esi
  801f80:	2b 04 24             	sub    (%esp),%eax
  801f83:	19 fa                	sbb    %edi,%edx
  801f85:	89 d1                	mov    %edx,%ecx
  801f87:	89 c6                	mov    %eax,%esi
  801f89:	e9 71 ff ff ff       	jmp    801eff <__umoddi3+0xb3>
  801f8e:	66 90                	xchg   %ax,%ax
  801f90:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f94:	72 ea                	jb     801f80 <__umoddi3+0x134>
  801f96:	89 d9                	mov    %ebx,%ecx
  801f98:	e9 62 ff ff ff       	jmp    801eff <__umoddi3+0xb3>
