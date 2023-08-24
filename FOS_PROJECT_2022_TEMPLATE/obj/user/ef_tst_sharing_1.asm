
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 64 03 00 00       	call   80039a <libmain>
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
  80008d:	68 40 1f 80 00       	push   $0x801f40
  800092:	6a 12                	push   $0x12
  800094:	68 5c 1f 80 00       	push   $0x801f5c
  800099:	e8 4b 04 00 00       	call   8004e9 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 74 1f 80 00       	push   $0x801f74
  8000a6:	e8 f2 06 00 00       	call   80079d <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 9d 16 00 00       	call   801750 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 ab 1f 80 00       	push   $0x801fab
  8000c5:	e8 d2 14 00 00       	call   80159c <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 b0 1f 80 00       	push   $0x801fb0
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 5c 1f 80 00       	push   $0x801f5c
  8000e8:	e8 fc 03 00 00       	call   8004e9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 5b 16 00 00       	call   801750 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 4a 16 00 00       	call   801750 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 43 16 00 00       	call   801750 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 1c 20 80 00       	push   $0x80201c
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 5c 1f 80 00       	push   $0x801f5c
  800121:	e8 c3 03 00 00       	call   8004e9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 25 16 00 00       	call   801750 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 a3 20 80 00       	push   $0x8020a3
  80013d:	e8 5a 14 00 00       	call   80159c <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 b0 1f 80 00       	push   $0x801fb0
  800159:	6a 1f                	push   $0x1f
  80015b:	68 5c 1f 80 00       	push   $0x801f5c
  800160:	e8 84 03 00 00       	call   8004e9 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 e3 15 00 00       	call   801750 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 d2 15 00 00       	call   801750 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 cb 15 00 00       	call   801750 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 1c 20 80 00       	push   $0x80201c
  800192:	6a 21                	push   $0x21
  800194:	68 5c 1f 80 00       	push   $0x801f5c
  800199:	e8 4b 03 00 00       	call   8004e9 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 ad 15 00 00       	call   801750 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 a5 20 80 00       	push   $0x8020a5
  8001b2:	e8 e5 13 00 00       	call   80159c <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 b0 1f 80 00       	push   $0x801fb0
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 5c 1f 80 00       	push   $0x801f5c
  8001d5:	e8 0f 03 00 00       	call   8004e9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 6e 15 00 00       	call   801750 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 a8 20 80 00       	push   $0x8020a8
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 5c 1f 80 00       	push   $0x801f5c
  8001fa:	e8 ea 02 00 00       	call   8004e9 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 28 21 80 00       	push   $0x802128
  800207:	e8 91 05 00 00       	call   80079d <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 50 21 80 00       	push   $0x802150
  800217:	e8 81 05 00 00       	call   80079d <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800226:	eb 2d                	jmp    800255 <_main+0x21d>
		{
			x[i] = -1;
  800228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800235:	01 d0                	add    %edx,%eax
  800237:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80025c:	7e ca                	jle    800228 <_main+0x1f0>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800265:	eb 18                	jmp    80027f <_main+0x247>
		{
			z[i] = -1;
  800267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80027c:	ff 45 ec             	incl   -0x14(%ebp)
  80027f:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800286:	7e df                	jle    800267 <_main+0x22f>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800290:	74 14                	je     8002a6 <_main+0x26e>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 78 21 80 00       	push   $0x802178
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 5c 1f 80 00       	push   $0x801f5c
  8002a1:	e8 43 02 00 00       	call   8004e9 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 78 21 80 00       	push   $0x802178
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 5c 1f 80 00       	push   $0x801f5c
  8002c4:	e8 20 02 00 00       	call   8004e9 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 78 21 80 00       	push   $0x802178
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 5c 1f 80 00       	push   $0x801f5c
  8002e2:	e8 02 02 00 00       	call   8004e9 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 78 21 80 00       	push   $0x802178
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 5c 1f 80 00       	push   $0x801f5c
  800305:	e8 df 01 00 00       	call   8004e9 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 78 21 80 00       	push   $0x802178
  80031c:	6a 40                	push   $0x40
  80031e:	68 5c 1f 80 00       	push   $0x801f5c
  800323:	e8 c1 01 00 00       	call   8004e9 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 78 21 80 00       	push   $0x802178
  80033f:	6a 41                	push   $0x41
  800341:	68 5c 1f 80 00       	push   $0x801f5c
  800346:	e8 9e 01 00 00       	call   8004e9 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 a4 21 80 00       	push   $0x8021a4
  800353:	e8 45 04 00 00       	call   80079d <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 e9 16 00 00       	call   801a49 <sys_getparentenvid>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  800363:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800367:	7e 2b                	jle    800394 <_main+0x35c>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800369:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	68 f8 21 80 00       	push   $0x8021f8
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 3c 12 00 00       	call   8015bc <sget>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
	}

	return;
  800393:	90                   	nop
  800394:	90                   	nop
}
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a0:	e8 8b 16 00 00       	call   801a30 <sys_getenvindex>
  8003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	01 c0                	add    %eax,%eax
  8003af:	01 d0                	add    %edx,%eax
  8003b1:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003b8:	01 c8                	add    %ecx,%eax
  8003ba:	c1 e0 02             	shl    $0x2,%eax
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	c1 e0 02             	shl    $0x2,%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	c1 e0 02             	shl    $0x2,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	c1 e0 03             	shl    $0x3,%eax
  8003d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003da:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003df:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e4:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8003ea:	84 c0                	test   %al,%al
  8003ec:	74 0f                	je     8003fd <libmain+0x63>
		binaryname = myEnv->prog_name;
  8003ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f3:	05 18 da 01 00       	add    $0x1da18,%eax
  8003f8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800401:	7e 0a                	jle    80040d <libmain+0x73>
		binaryname = argv[0];
  800403:	8b 45 0c             	mov    0xc(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80040d:	83 ec 08             	sub    $0x8,%esp
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 1d fc ff ff       	call   800038 <_main>
  80041b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80041e:	e8 1a 14 00 00       	call   80183d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	68 20 22 80 00       	push   $0x802220
  80042b:	e8 6d 03 00 00       	call   80079d <cprintf>
  800430:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800433:	a1 20 30 80 00       	mov    0x803020,%eax
  800438:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80043e:	a1 20 30 80 00       	mov    0x803020,%eax
  800443:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800449:	83 ec 04             	sub    $0x4,%esp
  80044c:	52                   	push   %edx
  80044d:	50                   	push   %eax
  80044e:	68 48 22 80 00       	push   $0x802248
  800453:	e8 45 03 00 00       	call   80079d <cprintf>
  800458:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80045b:	a1 20 30 80 00       	mov    0x803020,%eax
  800460:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800466:	a1 20 30 80 00       	mov    0x803020,%eax
  80046b:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800471:	a1 20 30 80 00       	mov    0x803020,%eax
  800476:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80047c:	51                   	push   %ecx
  80047d:	52                   	push   %edx
  80047e:	50                   	push   %eax
  80047f:	68 70 22 80 00       	push   $0x802270
  800484:	e8 14 03 00 00       	call   80079d <cprintf>
  800489:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	50                   	push   %eax
  80049b:	68 c8 22 80 00       	push   $0x8022c8
  8004a0:	e8 f8 02 00 00       	call   80079d <cprintf>
  8004a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004a8:	83 ec 0c             	sub    $0xc,%esp
  8004ab:	68 20 22 80 00       	push   $0x802220
  8004b0:	e8 e8 02 00 00       	call   80079d <cprintf>
  8004b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004b8:	e8 9a 13 00 00       	call   801857 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004bd:	e8 19 00 00 00       	call   8004db <exit>
}
  8004c2:	90                   	nop
  8004c3:	c9                   	leave  
  8004c4:	c3                   	ret    

008004c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004cb:	83 ec 0c             	sub    $0xc,%esp
  8004ce:	6a 00                	push   $0x0
  8004d0:	e8 27 15 00 00       	call   8019fc <sys_destroy_env>
  8004d5:	83 c4 10             	add    $0x10,%esp
}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <exit>:

void
exit(void)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004e1:	e8 7c 15 00 00       	call   801a62 <sys_exit_env>
}
  8004e6:	90                   	nop
  8004e7:	c9                   	leave  
  8004e8:	c3                   	ret    

008004e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004e9:	55                   	push   %ebp
  8004ea:	89 e5                	mov    %esp,%ebp
  8004ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8004f2:	83 c0 04             	add    $0x4,%eax
  8004f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004f8:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8004fd:	85 c0                	test   %eax,%eax
  8004ff:	74 16                	je     800517 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800501:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	50                   	push   %eax
  80050a:	68 dc 22 80 00       	push   $0x8022dc
  80050f:	e8 89 02 00 00       	call   80079d <cprintf>
  800514:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800517:	a1 00 30 80 00       	mov    0x803000,%eax
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	50                   	push   %eax
  800523:	68 e1 22 80 00       	push   $0x8022e1
  800528:	e8 70 02 00 00       	call   80079d <cprintf>
  80052d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800530:	8b 45 10             	mov    0x10(%ebp),%eax
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	ff 75 f4             	pushl  -0xc(%ebp)
  800539:	50                   	push   %eax
  80053a:	e8 f3 01 00 00       	call   800732 <vcprintf>
  80053f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	6a 00                	push   $0x0
  800547:	68 fd 22 80 00       	push   $0x8022fd
  80054c:	e8 e1 01 00 00       	call   800732 <vcprintf>
  800551:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800554:	e8 82 ff ff ff       	call   8004db <exit>

	// should not return here
	while (1) ;
  800559:	eb fe                	jmp    800559 <_panic+0x70>

0080055b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80055b:	55                   	push   %ebp
  80055c:	89 e5                	mov    %esp,%ebp
  80055e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800561:	a1 20 30 80 00       	mov    0x803020,%eax
  800566:	8b 50 74             	mov    0x74(%eax),%edx
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	39 c2                	cmp    %eax,%edx
  80056e:	74 14                	je     800584 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800570:	83 ec 04             	sub    $0x4,%esp
  800573:	68 00 23 80 00       	push   $0x802300
  800578:	6a 26                	push   $0x26
  80057a:	68 4c 23 80 00       	push   $0x80234c
  80057f:	e8 65 ff ff ff       	call   8004e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80058b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800592:	e9 c2 00 00 00       	jmp    800659 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	01 d0                	add    %edx,%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	85 c0                	test   %eax,%eax
  8005aa:	75 08                	jne    8005b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005af:	e9 a2 00 00 00       	jmp    800656 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005c2:	eb 69                	jmp    80062d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c9:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005d2:	89 d0                	mov    %edx,%eax
  8005d4:	01 c0                	add    %eax,%eax
  8005d6:	01 d0                	add    %edx,%eax
  8005d8:	c1 e0 03             	shl    $0x3,%eax
  8005db:	01 c8                	add    %ecx,%eax
  8005dd:	8a 40 04             	mov    0x4(%eax),%al
  8005e0:	84 c0                	test   %al,%al
  8005e2:	75 46                	jne    80062a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e9:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8005ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005f2:	89 d0                	mov    %edx,%eax
  8005f4:	01 c0                	add    %eax,%eax
  8005f6:	01 d0                	add    %edx,%eax
  8005f8:	c1 e0 03             	shl    $0x3,%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800602:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800605:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80060a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80060c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	75 09                	jne    80062a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800621:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800628:	eb 12                	jmp    80063c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	ff 45 e8             	incl   -0x18(%ebp)
  80062d:	a1 20 30 80 00       	mov    0x803020,%eax
  800632:	8b 50 74             	mov    0x74(%eax),%edx
  800635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800638:	39 c2                	cmp    %eax,%edx
  80063a:	77 88                	ja     8005c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80063c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800640:	75 14                	jne    800656 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 58 23 80 00       	push   $0x802358
  80064a:	6a 3a                	push   $0x3a
  80064c:	68 4c 23 80 00       	push   $0x80234c
  800651:	e8 93 fe ff ff       	call   8004e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800656:	ff 45 f0             	incl   -0x10(%ebp)
  800659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80065f:	0f 8c 32 ff ff ff    	jl     800597 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800665:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800673:	eb 26                	jmp    80069b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800675:	a1 20 30 80 00       	mov    0x803020,%eax
  80067a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800680:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800683:	89 d0                	mov    %edx,%eax
  800685:	01 c0                	add    %eax,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	c1 e0 03             	shl    $0x3,%eax
  80068c:	01 c8                	add    %ecx,%eax
  80068e:	8a 40 04             	mov    0x4(%eax),%al
  800691:	3c 01                	cmp    $0x1,%al
  800693:	75 03                	jne    800698 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800695:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800698:	ff 45 e0             	incl   -0x20(%ebp)
  80069b:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a0:	8b 50 74             	mov    0x74(%eax),%edx
  8006a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	77 cb                	ja     800675 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b0:	74 14                	je     8006c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006b2:	83 ec 04             	sub    $0x4,%esp
  8006b5:	68 ac 23 80 00       	push   $0x8023ac
  8006ba:	6a 44                	push   $0x44
  8006bc:	68 4c 23 80 00       	push   $0x80234c
  8006c1:	e8 23 fe ff ff       	call   8004e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006c6:	90                   	nop
  8006c7:	c9                   	leave  
  8006c8:	c3                   	ret    

008006c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8006d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006da:	89 0a                	mov    %ecx,(%edx)
  8006dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8006df:	88 d1                	mov    %dl,%cl
  8006e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006f2:	75 2c                	jne    800720 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006f4:	a0 24 30 80 00       	mov    0x803024,%al
  8006f9:	0f b6 c0             	movzbl %al,%eax
  8006fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ff:	8b 12                	mov    (%edx),%edx
  800701:	89 d1                	mov    %edx,%ecx
  800703:	8b 55 0c             	mov    0xc(%ebp),%edx
  800706:	83 c2 08             	add    $0x8,%edx
  800709:	83 ec 04             	sub    $0x4,%esp
  80070c:	50                   	push   %eax
  80070d:	51                   	push   %ecx
  80070e:	52                   	push   %edx
  80070f:	e8 7b 0f 00 00       	call   80168f <sys_cputs>
  800714:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	8b 40 04             	mov    0x4(%eax),%eax
  800726:	8d 50 01             	lea    0x1(%eax),%edx
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80072f:	90                   	nop
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80073b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800742:	00 00 00 
	b.cnt = 0;
  800745:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80074c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80074f:	ff 75 0c             	pushl  0xc(%ebp)
  800752:	ff 75 08             	pushl  0x8(%ebp)
  800755:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075b:	50                   	push   %eax
  80075c:	68 c9 06 80 00       	push   $0x8006c9
  800761:	e8 11 02 00 00       	call   800977 <vprintfmt>
  800766:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800769:	a0 24 30 80 00       	mov    0x803024,%al
  80076e:	0f b6 c0             	movzbl %al,%eax
  800771:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800777:	83 ec 04             	sub    $0x4,%esp
  80077a:	50                   	push   %eax
  80077b:	52                   	push   %edx
  80077c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800782:	83 c0 08             	add    $0x8,%eax
  800785:	50                   	push   %eax
  800786:	e8 04 0f 00 00       	call   80168f <sys_cputs>
  80078b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80078e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800795:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <cprintf>:

int cprintf(const char *fmt, ...) {
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	e8 73 ff ff ff       	call   800732 <vcprintf>
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d0:	e8 68 10 00 00       	call   80183d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e4:	50                   	push   %eax
  8007e5:	e8 48 ff ff ff       	call   800732 <vcprintf>
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f0:	e8 62 10 00 00       	call   801857 <sys_enable_interrupt>
	return cnt;
  8007f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	83 ec 14             	sub    $0x14,%esp
  800801:	8b 45 10             	mov    0x10(%ebp),%eax
  800804:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080d:	8b 45 18             	mov    0x18(%ebp),%eax
  800810:	ba 00 00 00 00       	mov    $0x0,%edx
  800815:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800818:	77 55                	ja     80086f <printnum+0x75>
  80081a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081d:	72 05                	jb     800824 <printnum+0x2a>
  80081f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800822:	77 4b                	ja     80086f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800824:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800827:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80082a:	8b 45 18             	mov    0x18(%ebp),%eax
  80082d:	ba 00 00 00 00       	mov    $0x0,%edx
  800832:	52                   	push   %edx
  800833:	50                   	push   %eax
  800834:	ff 75 f4             	pushl  -0xc(%ebp)
  800837:	ff 75 f0             	pushl  -0x10(%ebp)
  80083a:	e8 85 14 00 00       	call   801cc4 <__udivdi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	ff 75 20             	pushl  0x20(%ebp)
  800848:	53                   	push   %ebx
  800849:	ff 75 18             	pushl  0x18(%ebp)
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 08             	pushl  0x8(%ebp)
  800854:	e8 a1 ff ff ff       	call   8007fa <printnum>
  800859:	83 c4 20             	add    $0x20,%esp
  80085c:	eb 1a                	jmp    800878 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	ff 75 20             	pushl  0x20(%ebp)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086f:	ff 4d 1c             	decl   0x1c(%ebp)
  800872:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800876:	7f e6                	jg     80085e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800878:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80087b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800886:	53                   	push   %ebx
  800887:	51                   	push   %ecx
  800888:	52                   	push   %edx
  800889:	50                   	push   %eax
  80088a:	e8 45 15 00 00       	call   801dd4 <__umoddi3>
  80088f:	83 c4 10             	add    $0x10,%esp
  800892:	05 14 26 80 00       	add    $0x802614,%eax
  800897:	8a 00                	mov    (%eax),%al
  800899:	0f be c0             	movsbl %al,%eax
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	50                   	push   %eax
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
}
  8008ab:	90                   	nop
  8008ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    

008008b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b8:	7e 1c                	jle    8008d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	8d 50 08             	lea    0x8(%eax),%edx
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	89 10                	mov    %edx,(%eax)
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	83 e8 08             	sub    $0x8,%eax
  8008cf:	8b 50 04             	mov    0x4(%eax),%edx
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	eb 40                	jmp    800916 <getuint+0x65>
	else if (lflag)
  8008d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008da:	74 1e                	je     8008fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	8d 50 04             	lea    0x4(%eax),%edx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	89 10                	mov    %edx,(%eax)
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	eb 1c                	jmp    800916 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	8d 50 04             	lea    0x4(%eax),%edx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	89 10                	mov    %edx,(%eax)
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	83 e8 04             	sub    $0x4,%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091f:	7e 1c                	jle    80093d <getint+0x25>
		return va_arg(*ap, long long);
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	8d 50 08             	lea    0x8(%eax),%edx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	89 10                	mov    %edx,(%eax)
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	83 e8 08             	sub    $0x8,%eax
  800936:	8b 50 04             	mov    0x4(%eax),%edx
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	eb 38                	jmp    800975 <getint+0x5d>
	else if (lflag)
  80093d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800941:	74 1a                	je     80095d <getint+0x45>
		return va_arg(*ap, long);
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	8d 50 04             	lea    0x4(%eax),%edx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	89 10                	mov    %edx,(%eax)
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	83 e8 04             	sub    $0x4,%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	99                   	cltd   
  80095b:	eb 18                	jmp    800975 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	8d 50 04             	lea    0x4(%eax),%edx
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	89 10                	mov    %edx,(%eax)
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	83 e8 04             	sub    $0x4,%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	99                   	cltd   
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	56                   	push   %esi
  80097b:	53                   	push   %ebx
  80097c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097f:	eb 17                	jmp    800998 <vprintfmt+0x21>
			if (ch == '\0')
  800981:	85 db                	test   %ebx,%ebx
  800983:	0f 84 af 03 00 00    	je     800d38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	53                   	push   %ebx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800998:	8b 45 10             	mov    0x10(%ebp),%eax
  80099b:	8d 50 01             	lea    0x1(%eax),%edx
  80099e:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a1:	8a 00                	mov    (%eax),%al
  8009a3:	0f b6 d8             	movzbl %al,%ebx
  8009a6:	83 fb 25             	cmp    $0x25,%ebx
  8009a9:	75 d6                	jne    800981 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d4:	8a 00                	mov    (%eax),%al
  8009d6:	0f b6 d8             	movzbl %al,%ebx
  8009d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009dc:	83 f8 55             	cmp    $0x55,%eax
  8009df:	0f 87 2b 03 00 00    	ja     800d10 <vprintfmt+0x399>
  8009e5:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  8009ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f2:	eb d7                	jmp    8009cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f8:	eb d1                	jmp    8009cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a04:	89 d0                	mov    %edx,%eax
  800a06:	c1 e0 02             	shl    $0x2,%eax
  800a09:	01 d0                	add    %edx,%eax
  800a0b:	01 c0                	add    %eax,%eax
  800a0d:	01 d8                	add    %ebx,%eax
  800a0f:	83 e8 30             	sub    $0x30,%eax
  800a12:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a15:	8b 45 10             	mov    0x10(%ebp),%eax
  800a18:	8a 00                	mov    (%eax),%al
  800a1a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1d:	83 fb 2f             	cmp    $0x2f,%ebx
  800a20:	7e 3e                	jle    800a60 <vprintfmt+0xe9>
  800a22:	83 fb 39             	cmp    $0x39,%ebx
  800a25:	7f 39                	jg     800a60 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a27:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a2a:	eb d5                	jmp    800a01 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	83 c0 04             	add    $0x4,%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 e8 04             	sub    $0x4,%eax
  800a3b:	8b 00                	mov    (%eax),%eax
  800a3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a40:	eb 1f                	jmp    800a61 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a46:	79 83                	jns    8009cb <vprintfmt+0x54>
				width = 0;
  800a48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4f:	e9 77 ff ff ff       	jmp    8009cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a54:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a5b:	e9 6b ff ff ff       	jmp    8009cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a60:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a65:	0f 89 60 ff ff ff    	jns    8009cb <vprintfmt+0x54>
				width = precision, precision = -1;
  800a6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a71:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a78:	e9 4e ff ff ff       	jmp    8009cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a80:	e9 46 ff ff ff       	jmp    8009cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 c0 04             	add    $0x4,%eax
  800a8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 e8 04             	sub    $0x4,%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	50                   	push   %eax
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			break;
  800aa5:	e9 89 02 00 00       	jmp    800d33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  800aad:	83 c0 04             	add    $0x4,%eax
  800ab0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 e8 04             	sub    $0x4,%eax
  800ab9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800abb:	85 db                	test   %ebx,%ebx
  800abd:	79 02                	jns    800ac1 <vprintfmt+0x14a>
				err = -err;
  800abf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac1:	83 fb 64             	cmp    $0x64,%ebx
  800ac4:	7f 0b                	jg     800ad1 <vprintfmt+0x15a>
  800ac6:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800acd:	85 f6                	test   %esi,%esi
  800acf:	75 19                	jne    800aea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad1:	53                   	push   %ebx
  800ad2:	68 25 26 80 00       	push   $0x802625
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 5e 02 00 00       	call   800d40 <printfmt>
  800ae2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae5:	e9 49 02 00 00       	jmp    800d33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aea:	56                   	push   %esi
  800aeb:	68 2e 26 80 00       	push   $0x80262e
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	ff 75 08             	pushl  0x8(%ebp)
  800af6:	e8 45 02 00 00       	call   800d40 <printfmt>
  800afb:	83 c4 10             	add    $0x10,%esp
			break;
  800afe:	e9 30 02 00 00       	jmp    800d33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b03:	8b 45 14             	mov    0x14(%ebp),%eax
  800b06:	83 c0 04             	add    $0x4,%eax
  800b09:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 e8 04             	sub    $0x4,%eax
  800b12:	8b 30                	mov    (%eax),%esi
  800b14:	85 f6                	test   %esi,%esi
  800b16:	75 05                	jne    800b1d <vprintfmt+0x1a6>
				p = "(null)";
  800b18:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800b1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b21:	7e 6d                	jle    800b90 <vprintfmt+0x219>
  800b23:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b27:	74 67                	je     800b90 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	50                   	push   %eax
  800b30:	56                   	push   %esi
  800b31:	e8 0c 03 00 00       	call   800e42 <strnlen>
  800b36:	83 c4 10             	add    $0x10,%esp
  800b39:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b3c:	eb 16                	jmp    800b54 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	50                   	push   %eax
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	ff d0                	call   *%eax
  800b4e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b51:	ff 4d e4             	decl   -0x1c(%ebp)
  800b54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b58:	7f e4                	jg     800b3e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5a:	eb 34                	jmp    800b90 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b60:	74 1c                	je     800b7e <vprintfmt+0x207>
  800b62:	83 fb 1f             	cmp    $0x1f,%ebx
  800b65:	7e 05                	jle    800b6c <vprintfmt+0x1f5>
  800b67:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6a:	7e 12                	jle    800b7e <vprintfmt+0x207>
					putch('?', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 3f                	push   $0x3f
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	eb 0f                	jmp    800b8d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	53                   	push   %ebx
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	ff d0                	call   *%eax
  800b8a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b90:	89 f0                	mov    %esi,%eax
  800b92:	8d 70 01             	lea    0x1(%eax),%esi
  800b95:	8a 00                	mov    (%eax),%al
  800b97:	0f be d8             	movsbl %al,%ebx
  800b9a:	85 db                	test   %ebx,%ebx
  800b9c:	74 24                	je     800bc2 <vprintfmt+0x24b>
  800b9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba2:	78 b8                	js     800b5c <vprintfmt+0x1e5>
  800ba4:	ff 4d e0             	decl   -0x20(%ebp)
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	79 af                	jns    800b5c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bad:	eb 13                	jmp    800bc2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	6a 20                	push   $0x20
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	ff d0                	call   *%eax
  800bbc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbf:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc6:	7f e7                	jg     800baf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc8:	e9 66 01 00 00       	jmp    800d33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd6:	50                   	push   %eax
  800bd7:	e8 3c fd ff ff       	call   800918 <getint>
  800bdc:	83 c4 10             	add    $0x10,%esp
  800bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800beb:	85 d2                	test   %edx,%edx
  800bed:	79 23                	jns    800c12 <vprintfmt+0x29b>
				putch('-', putdat);
  800bef:	83 ec 08             	sub    $0x8,%esp
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	6a 2d                	push   $0x2d
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	ff d0                	call   *%eax
  800bfc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c05:	f7 d8                	neg    %eax
  800c07:	83 d2 00             	adc    $0x0,%edx
  800c0a:	f7 da                	neg    %edx
  800c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c19:	e9 bc 00 00 00       	jmp    800cda <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 e8             	pushl  -0x18(%ebp)
  800c24:	8d 45 14             	lea    0x14(%ebp),%eax
  800c27:	50                   	push   %eax
  800c28:	e8 84 fc ff ff       	call   8008b1 <getuint>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3d:	e9 98 00 00 00       	jmp    800cda <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	6a 58                	push   $0x58
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	ff d0                	call   *%eax
  800c4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	6a 58                	push   $0x58
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	6a 58                	push   $0x58
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	ff d0                	call   *%eax
  800c6f:	83 c4 10             	add    $0x10,%esp
			break;
  800c72:	e9 bc 00 00 00       	jmp    800d33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	6a 30                	push   $0x30
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	6a 78                	push   $0x78
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	83 c0 04             	add    $0x4,%eax
  800c9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 e8 04             	sub    $0x4,%eax
  800ca6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb9:	eb 1f                	jmp    800cda <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cbb:	83 ec 08             	sub    $0x8,%esp
  800cbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc4:	50                   	push   %eax
  800cc5:	e8 e7 fb ff ff       	call   8008b1 <getuint>
  800cca:	83 c4 10             	add    $0x10,%esp
  800ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cda:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce1:	83 ec 04             	sub    $0x4,%esp
  800ce4:	52                   	push   %edx
  800ce5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce8:	50                   	push   %eax
  800ce9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cec:	ff 75 f0             	pushl  -0x10(%ebp)
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 00 fb ff ff       	call   8007fa <printnum>
  800cfa:	83 c4 20             	add    $0x20,%esp
			break;
  800cfd:	eb 34                	jmp    800d33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cff:	83 ec 08             	sub    $0x8,%esp
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	53                   	push   %ebx
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	ff d0                	call   *%eax
  800d0b:	83 c4 10             	add    $0x10,%esp
			break;
  800d0e:	eb 23                	jmp    800d33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	ff 75 0c             	pushl  0xc(%ebp)
  800d16:	6a 25                	push   $0x25
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	ff d0                	call   *%eax
  800d1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d20:	ff 4d 10             	decl   0x10(%ebp)
  800d23:	eb 03                	jmp    800d28 <vprintfmt+0x3b1>
  800d25:	ff 4d 10             	decl   0x10(%ebp)
  800d28:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2b:	48                   	dec    %eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	3c 25                	cmp    $0x25,%al
  800d30:	75 f3                	jne    800d25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d32:	90                   	nop
		}
	}
  800d33:	e9 47 fc ff ff       	jmp    80097f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d46:	8d 45 10             	lea    0x10(%ebp),%eax
  800d49:	83 c0 04             	add    $0x4,%eax
  800d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d52:	ff 75 f4             	pushl  -0xc(%ebp)
  800d55:	50                   	push   %eax
  800d56:	ff 75 0c             	pushl  0xc(%ebp)
  800d59:	ff 75 08             	pushl  0x8(%ebp)
  800d5c:	e8 16 fc ff ff       	call   800977 <vprintfmt>
  800d61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d64:	90                   	nop
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

00800d67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8b 40 08             	mov    0x8(%eax),%eax
  800d70:	8d 50 01             	lea    0x1(%eax),%edx
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	8b 10                	mov    (%eax),%edx
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8b 40 04             	mov    0x4(%eax),%eax
  800d84:	39 c2                	cmp    %eax,%edx
  800d86:	73 12                	jae    800d9a <sprintputch+0x33>
		*b->buf++ = ch;
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d93:	89 0a                	mov    %ecx,(%edx)
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	88 10                	mov    %dl,(%eax)
}
  800d9a:	90                   	nop
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	01 d0                	add    %edx,%eax
  800db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc2:	74 06                	je     800dca <vsnprintf+0x2d>
  800dc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc8:	7f 07                	jg     800dd1 <vsnprintf+0x34>
		return -E_INVAL;
  800dca:	b8 03 00 00 00       	mov    $0x3,%eax
  800dcf:	eb 20                	jmp    800df1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd1:	ff 75 14             	pushl  0x14(%ebp)
  800dd4:	ff 75 10             	pushl  0x10(%ebp)
  800dd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dda:	50                   	push   %eax
  800ddb:	68 67 0d 80 00       	push   $0x800d67
  800de0:	e8 92 fb ff ff       	call   800977 <vprintfmt>
  800de5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800deb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e02:	8b 45 10             	mov    0x10(%ebp),%eax
  800e05:	ff 75 f4             	pushl  -0xc(%ebp)
  800e08:	50                   	push   %eax
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	ff 75 08             	pushl  0x8(%ebp)
  800e0f:	e8 89 ff ff ff       	call   800d9d <vsnprintf>
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2c:	eb 06                	jmp    800e34 <strlen+0x15>
		n++;
  800e2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e31:	ff 45 08             	incl   0x8(%ebp)
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	84 c0                	test   %al,%al
  800e3b:	75 f1                	jne    800e2e <strlen+0xf>
		n++;
	return n;
  800e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 09                	jmp    800e5a <strnlen+0x18>
		n++;
  800e51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e54:	ff 45 08             	incl   0x8(%ebp)
  800e57:	ff 4d 0c             	decl   0xc(%ebp)
  800e5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5e:	74 09                	je     800e69 <strnlen+0x27>
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e8                	jne    800e51 <strnlen+0xf>
		n++;
	return n;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e7a:	90                   	nop
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8d 50 01             	lea    0x1(%eax),%edx
  800e81:	89 55 08             	mov    %edx,0x8(%ebp)
  800e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e8d:	8a 12                	mov    (%edx),%dl
  800e8f:	88 10                	mov    %dl,(%eax)
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	84 c0                	test   %al,%al
  800e95:	75 e4                	jne    800e7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ea8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eaf:	eb 1f                	jmp    800ed0 <strncpy+0x34>
		*dst++ = *src;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8d 50 01             	lea    0x1(%eax),%edx
  800eb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebd:	8a 12                	mov    (%edx),%dl
  800ebf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	74 03                	je     800ecd <strncpy+0x31>
			src++;
  800eca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ecd:	ff 45 fc             	incl   -0x4(%ebp)
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed6:	72 d9                	jb     800eb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ed8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ee9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eed:	74 30                	je     800f1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eef:	eb 16                	jmp    800f07 <strlcpy+0x2a>
			*dst++ = *src++;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8d 50 01             	lea    0x1(%eax),%edx
  800ef7:	89 55 08             	mov    %edx,0x8(%ebp)
  800efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f03:	8a 12                	mov    (%edx),%dl
  800f05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f07:	ff 4d 10             	decl   0x10(%ebp)
  800f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0e:	74 09                	je     800f19 <strlcpy+0x3c>
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	84 c0                	test   %al,%al
  800f17:	75 d8                	jne    800ef1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f25:	29 c2                	sub    %eax,%edx
  800f27:	89 d0                	mov    %edx,%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f2e:	eb 06                	jmp    800f36 <strcmp+0xb>
		p++, q++;
  800f30:	ff 45 08             	incl   0x8(%ebp)
  800f33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	84 c0                	test   %al,%al
  800f3d:	74 0e                	je     800f4d <strcmp+0x22>
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 10                	mov    (%eax),%dl
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	38 c2                	cmp    %al,%dl
  800f4b:	74 e3                	je     800f30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	0f b6 d0             	movzbl %al,%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f b6 c0             	movzbl %al,%eax
  800f5d:	29 c2                	sub    %eax,%edx
  800f5f:	89 d0                	mov    %edx,%eax
}
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f66:	eb 09                	jmp    800f71 <strncmp+0xe>
		n--, p++, q++;
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 17                	je     800f8e <strncmp+0x2b>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	84 c0                	test   %al,%al
  800f7e:	74 0e                	je     800f8e <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 10                	mov    (%eax),%dl
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	38 c2                	cmp    %al,%dl
  800f8c:	74 da                	je     800f68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f92:	75 07                	jne    800f9b <strncmp+0x38>
		return 0;
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
  800f99:	eb 14                	jmp    800faf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	0f b6 d0             	movzbl %al,%edx
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f b6 c0             	movzbl %al,%eax
  800fab:	29 c2                	sub    %eax,%edx
  800fad:	89 d0                	mov    %edx,%eax
}
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbd:	eb 12                	jmp    800fd1 <strchr+0x20>
		if (*s == c)
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc7:	75 05                	jne    800fce <strchr+0x1d>
			return (char *) s;
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	eb 11                	jmp    800fdf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fce:	ff 45 08             	incl   0x8(%ebp)
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	84 c0                	test   %al,%al
  800fd8:	75 e5                	jne    800fbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 04             	sub    $0x4,%esp
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fed:	eb 0d                	jmp    800ffc <strfind+0x1b>
		if (*s == c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff7:	74 0e                	je     801007 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ff9:	ff 45 08             	incl   0x8(%ebp)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	75 ea                	jne    800fef <strfind+0xe>
  801005:	eb 01                	jmp    801008 <strfind+0x27>
		if (*s == c)
			break;
  801007:	90                   	nop
	return (char *) s;
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100b:	c9                   	leave  
  80100c:	c3                   	ret    

0080100d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80101f:	eb 0e                	jmp    80102f <memset+0x22>
		*p++ = c;
  801021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801024:	8d 50 01             	lea    0x1(%eax),%edx
  801027:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80102a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80102f:	ff 4d f8             	decl   -0x8(%ebp)
  801032:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801036:	79 e9                	jns    801021 <memset+0x14>
		*p++ = c;

	return v;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103b:	c9                   	leave  
  80103c:	c3                   	ret    

0080103d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
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
	while (n-- > 0)
  80104f:	eb 16                	jmp    801067 <memcpy+0x2a>
		*d++ = *s++;
  801051:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801054:	8d 50 01             	lea    0x1(%eax),%edx
  801057:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80105a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80105d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801060:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801063:	8a 12                	mov    (%edx),%dl
  801065:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 dd                	jne    801051 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80108b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801091:	73 50                	jae    8010e3 <memmove+0x6a>
  801093:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109e:	76 43                	jbe    8010e3 <memmove+0x6a>
		s += n;
  8010a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ac:	eb 10                	jmp    8010be <memmove+0x45>
			*--d = *--s;
  8010ae:	ff 4d f8             	decl   -0x8(%ebp)
  8010b1:	ff 4d fc             	decl   -0x4(%ebp)
  8010b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b7:	8a 10                	mov    (%eax),%dl
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	75 e3                	jne    8010ae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010cb:	eb 23                	jmp    8010f0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010dc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010df:	8a 12                	mov    (%edx),%dl
  8010e1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 dd                	jne    8010cd <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801107:	eb 2a                	jmp    801133 <memcmp+0x3e>
		if (*s1 != *s2)
  801109:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 16                	je     80112d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
  80112b:	eb 18                	jmp    801145 <memcmp+0x50>
		s1++, s2++;
  80112d:	ff 45 fc             	incl   -0x4(%ebp)
  801130:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	8d 50 ff             	lea    -0x1(%eax),%edx
  801139:	89 55 10             	mov    %edx,0x10(%ebp)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	75 c9                	jne    801109 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801145:	c9                   	leave  
  801146:	c3                   	ret    

00801147 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80114d:	8b 55 08             	mov    0x8(%ebp),%edx
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	01 d0                	add    %edx,%eax
  801155:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801158:	eb 15                	jmp    80116f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f b6 d0             	movzbl %al,%edx
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	0f b6 c0             	movzbl %al,%eax
  801168:	39 c2                	cmp    %eax,%edx
  80116a:	74 0d                	je     801179 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80116c:	ff 45 08             	incl   0x8(%ebp)
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801175:	72 e3                	jb     80115a <memfind+0x13>
  801177:	eb 01                	jmp    80117a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801179:	90                   	nop
	return (void *) s;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801185:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80118c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801193:	eb 03                	jmp    801198 <strtol+0x19>
		s++;
  801195:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 20                	cmp    $0x20,%al
  80119f:	74 f4                	je     801195 <strtol+0x16>
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 09                	cmp    $0x9,%al
  8011a8:	74 eb                	je     801195 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 2b                	cmp    $0x2b,%al
  8011b1:	75 05                	jne    8011b8 <strtol+0x39>
		s++;
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	eb 13                	jmp    8011cb <strtol+0x4c>
	else if (*s == '-')
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 2d                	cmp    $0x2d,%al
  8011bf:	75 0a                	jne    8011cb <strtol+0x4c>
		s++, neg = 1;
  8011c1:	ff 45 08             	incl   0x8(%ebp)
  8011c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cf:	74 06                	je     8011d7 <strtol+0x58>
  8011d1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011d5:	75 20                	jne    8011f7 <strtol+0x78>
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	3c 30                	cmp    $0x30,%al
  8011de:	75 17                	jne    8011f7 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	40                   	inc    %eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 78                	cmp    $0x78,%al
  8011e8:	75 0d                	jne    8011f7 <strtol+0x78>
		s += 2, base = 16;
  8011ea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011f5:	eb 28                	jmp    80121f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fb:	75 15                	jne    801212 <strtol+0x93>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 30                	cmp    $0x30,%al
  801204:	75 0c                	jne    801212 <strtol+0x93>
		s++, base = 8;
  801206:	ff 45 08             	incl   0x8(%ebp)
  801209:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801210:	eb 0d                	jmp    80121f <strtol+0xa0>
	else if (base == 0)
  801212:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801216:	75 07                	jne    80121f <strtol+0xa0>
		base = 10;
  801218:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 2f                	cmp    $0x2f,%al
  801226:	7e 19                	jle    801241 <strtol+0xc2>
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 39                	cmp    $0x39,%al
  80122f:	7f 10                	jg     801241 <strtol+0xc2>
			dig = *s - '0';
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	0f be c0             	movsbl %al,%eax
  801239:	83 e8 30             	sub    $0x30,%eax
  80123c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123f:	eb 42                	jmp    801283 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	3c 60                	cmp    $0x60,%al
  801248:	7e 19                	jle    801263 <strtol+0xe4>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 7a                	cmp    $0x7a,%al
  801251:	7f 10                	jg     801263 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	0f be c0             	movsbl %al,%eax
  80125b:	83 e8 57             	sub    $0x57,%eax
  80125e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801261:	eb 20                	jmp    801283 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 40                	cmp    $0x40,%al
  80126a:	7e 39                	jle    8012a5 <strtol+0x126>
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 5a                	cmp    $0x5a,%al
  801273:	7f 30                	jg     8012a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	83 e8 37             	sub    $0x37,%eax
  801280:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801286:	3b 45 10             	cmp    0x10(%ebp),%eax
  801289:	7d 19                	jge    8012a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80128b:	ff 45 08             	incl   0x8(%ebp)
  80128e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801291:	0f af 45 10          	imul   0x10(%ebp),%eax
  801295:	89 c2                	mov    %eax,%edx
  801297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80129f:	e9 7b ff ff ff       	jmp    80121f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a9:	74 08                	je     8012b3 <strtol+0x134>
		*endptr = (char *) s;
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012b7:	74 07                	je     8012c0 <strtol+0x141>
  8012b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bc:	f7 d8                	neg    %eax
  8012be:	eb 03                	jmp    8012c3 <strtol+0x144>
  8012c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012dd:	79 13                	jns    8012f2 <ltostr+0x2d>
	{
		neg = 1;
  8012df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012fa:	99                   	cltd   
  8012fb:	f7 f9                	idiv   %ecx
  8012fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801300:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801303:	8d 50 01             	lea    0x1(%eax),%edx
  801306:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801309:	89 c2                	mov    %eax,%edx
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801313:	83 c2 30             	add    $0x30,%edx
  801316:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801318:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801320:	f7 e9                	imul   %ecx
  801322:	c1 fa 02             	sar    $0x2,%edx
  801325:	89 c8                	mov    %ecx,%eax
  801327:	c1 f8 1f             	sar    $0x1f,%eax
  80132a:	29 c2                	sub    %eax,%edx
  80132c:	89 d0                	mov    %edx,%eax
  80132e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801331:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801334:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801339:	f7 e9                	imul   %ecx
  80133b:	c1 fa 02             	sar    $0x2,%edx
  80133e:	89 c8                	mov    %ecx,%eax
  801340:	c1 f8 1f             	sar    $0x1f,%eax
  801343:	29 c2                	sub    %eax,%edx
  801345:	89 d0                	mov    %edx,%eax
  801347:	c1 e0 02             	shl    $0x2,%eax
  80134a:	01 d0                	add    %edx,%eax
  80134c:	01 c0                	add    %eax,%eax
  80134e:	29 c1                	sub    %eax,%ecx
  801350:	89 ca                	mov    %ecx,%edx
  801352:	85 d2                	test   %edx,%edx
  801354:	75 9c                	jne    8012f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801356:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80135d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801360:	48                   	dec    %eax
  801361:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801364:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801368:	74 3d                	je     8013a7 <ltostr+0xe2>
		start = 1 ;
  80136a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801371:	eb 34                	jmp    8013a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801383:	8b 45 0c             	mov    0xc(%ebp),%eax
  801386:	01 c2                	add    %eax,%edx
  801388:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80138b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138e:	01 c8                	add    %ecx,%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801394:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	01 c2                	add    %eax,%edx
  80139c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80139f:	88 02                	mov    %al,(%edx)
		start++ ;
  8013a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ad:	7c c4                	jl     801373 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b5:	01 d0                	add    %edx,%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013ba:	90                   	nop
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013c3:	ff 75 08             	pushl  0x8(%ebp)
  8013c6:	e8 54 fa ff ff       	call   800e1f <strlen>
  8013cb:	83 c4 04             	add    $0x4,%esp
  8013ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	e8 46 fa ff ff       	call   800e1f <strlen>
  8013d9:	83 c4 04             	add    $0x4,%esp
  8013dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 17                	jmp    801406 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f5:	01 c2                	add    %eax,%edx
  8013f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	01 c8                	add    %ecx,%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801403:	ff 45 fc             	incl   -0x4(%ebp)
  801406:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801409:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80140c:	7c e1                	jl     8013ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80140e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801415:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80141c:	eb 1f                	jmp    80143d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80141e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801421:	8d 50 01             	lea    0x1(%eax),%edx
  801424:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801427:	89 c2                	mov    %eax,%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 c2                	add    %eax,%edx
  80142e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	01 c8                	add    %ecx,%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80143a:	ff 45 f8             	incl   -0x8(%ebp)
  80143d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801440:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801443:	7c d9                	jl     80141e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801445:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801448:	8b 45 10             	mov    0x10(%ebp),%eax
  80144b:	01 d0                	add    %edx,%eax
  80144d:	c6 00 00             	movb   $0x0,(%eax)
}
  801450:	90                   	nop
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801456:	8b 45 14             	mov    0x14(%ebp),%eax
  801459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146b:	8b 45 10             	mov    0x10(%ebp),%eax
  80146e:	01 d0                	add    %edx,%eax
  801470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801476:	eb 0c                	jmp    801484 <strsplit+0x31>
			*string++ = 0;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8d 50 01             	lea    0x1(%eax),%edx
  80147e:	89 55 08             	mov    %edx,0x8(%ebp)
  801481:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	84 c0                	test   %al,%al
  80148b:	74 18                	je     8014a5 <strsplit+0x52>
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	0f be c0             	movsbl %al,%eax
  801495:	50                   	push   %eax
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	e8 13 fb ff ff       	call   800fb1 <strchr>
  80149e:	83 c4 08             	add    $0x8,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	75 d3                	jne    801478 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	84 c0                	test   %al,%al
  8014ac:	74 5a                	je     801508 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b1:	8b 00                	mov    (%eax),%eax
  8014b3:	83 f8 0f             	cmp    $0xf,%eax
  8014b6:	75 07                	jne    8014bf <strsplit+0x6c>
		{
			return 0;
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bd:	eb 66                	jmp    801525 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c2:	8b 00                	mov    (%eax),%eax
  8014c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8014c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8014ca:	89 0a                	mov    %ecx,(%edx)
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 c2                	add    %eax,%edx
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014dd:	eb 03                	jmp    8014e2 <strsplit+0x8f>
			string++;
  8014df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	84 c0                	test   %al,%al
  8014e9:	74 8b                	je     801476 <strsplit+0x23>
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	0f be c0             	movsbl %al,%eax
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	e8 b5 fa ff ff       	call   800fb1 <strchr>
  8014fc:	83 c4 08             	add    $0x8,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 dc                	je     8014df <strsplit+0x8c>
			string++;
	}
  801503:	e9 6e ff ff ff       	jmp    801476 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801508:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801509:	8b 45 14             	mov    0x14(%ebp),%eax
  80150c:	8b 00                	mov    (%eax),%eax
  80150e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
  80151a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801520:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	68 90 27 80 00       	push   $0x802790
  801535:	6a 0e                	push   $0xe
  801537:	68 ca 27 80 00       	push   $0x8027ca
  80153c:	e8 a8 ef ff ff       	call   8004e9 <_panic>

00801541 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801547:	a1 04 30 80 00       	mov    0x803004,%eax
  80154c:	85 c0                	test   %eax,%eax
  80154e:	74 0f                	je     80155f <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801550:	e8 d2 ff ff ff       	call   801527 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801555:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80155c:	00 00 00 
	}
	if (size == 0) return NULL ;
  80155f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801563:	75 07                	jne    80156c <malloc+0x2b>
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
  80156a:	eb 14                	jmp    801580 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 d8 27 80 00       	push   $0x8027d8
  801574:	6a 2e                	push   $0x2e
  801576:	68 ca 27 80 00       	push   $0x8027ca
  80157b:	e8 69 ef ff ff       	call   8004e9 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	68 00 28 80 00       	push   $0x802800
  801590:	6a 49                	push   $0x49
  801592:	68 ca 27 80 00       	push   $0x8027ca
  801597:	e8 4d ef ff ff       	call   8004e9 <_panic>

0080159c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 18             	sub    $0x18,%esp
  8015a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a5:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	68 24 28 80 00       	push   $0x802824
  8015b0:	6a 57                	push   $0x57
  8015b2:	68 ca 27 80 00       	push   $0x8027ca
  8015b7:	e8 2d ef ff ff       	call   8004e9 <_panic>

008015bc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	68 4c 28 80 00       	push   $0x80284c
  8015ca:	6a 60                	push   $0x60
  8015cc:	68 ca 27 80 00       	push   $0x8027ca
  8015d1:	e8 13 ef ff ff       	call   8004e9 <_panic>

008015d6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	68 70 28 80 00       	push   $0x802870
  8015e4:	6a 7c                	push   $0x7c
  8015e6:	68 ca 27 80 00       	push   $0x8027ca
  8015eb:	e8 f9 ee ff ff       	call   8004e9 <_panic>

008015f0 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	68 98 28 80 00       	push   $0x802898
  8015fe:	68 86 00 00 00       	push   $0x86
  801603:	68 ca 27 80 00       	push   $0x8027ca
  801608:	e8 dc ee ff ff       	call   8004e9 <_panic>

0080160d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	68 bc 28 80 00       	push   $0x8028bc
  80161b:	68 91 00 00 00       	push   $0x91
  801620:	68 ca 27 80 00       	push   $0x8027ca
  801625:	e8 bf ee ff ff       	call   8004e9 <_panic>

0080162a <shrink>:

}
void shrink(uint32 newSize)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801630:	83 ec 04             	sub    $0x4,%esp
  801633:	68 bc 28 80 00       	push   $0x8028bc
  801638:	68 96 00 00 00       	push   $0x96
  80163d:	68 ca 27 80 00       	push   $0x8027ca
  801642:	e8 a2 ee ff ff       	call   8004e9 <_panic>

00801647 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	68 bc 28 80 00       	push   $0x8028bc
  801655:	68 9b 00 00 00       	push   $0x9b
  80165a:	68 ca 27 80 00       	push   $0x8027ca
  80165f:	e8 85 ee ff ff       	call   8004e9 <_panic>

00801664 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	57                   	push   %edi
  801668:	56                   	push   %esi
  801669:	53                   	push   %ebx
  80166a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8b 55 0c             	mov    0xc(%ebp),%edx
  801673:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801676:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801679:	8b 7d 18             	mov    0x18(%ebp),%edi
  80167c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80167f:	cd 30                	int    $0x30
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801684:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	5b                   	pop    %ebx
  80168b:	5e                   	pop    %esi
  80168c:	5f                   	pop    %edi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    

0080168f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	8b 45 10             	mov    0x10(%ebp),%eax
  801698:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80169b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	52                   	push   %edx
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	50                   	push   %eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	e8 b2 ff ff ff       	call   801664 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	90                   	nop
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 01                	push   $0x1
  8016c7:	e8 98 ff ff ff       	call   801664 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	52                   	push   %edx
  8016e1:	50                   	push   %eax
  8016e2:	6a 05                	push   $0x5
  8016e4:	e8 7b ff ff ff       	call   801664 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	56                   	push   %esi
  8016f2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016f3:	8b 75 18             	mov    0x18(%ebp),%esi
  8016f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	51                   	push   %ecx
  801705:	52                   	push   %edx
  801706:	50                   	push   %eax
  801707:	6a 06                	push   $0x6
  801709:	e8 56 ff ff ff       	call   801664 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801714:	5b                   	pop    %ebx
  801715:	5e                   	pop    %esi
  801716:	5d                   	pop    %ebp
  801717:	c3                   	ret    

00801718 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80171b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	52                   	push   %edx
  801728:	50                   	push   %eax
  801729:	6a 07                	push   $0x7
  80172b:	e8 34 ff ff ff       	call   801664 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	6a 08                	push   $0x8
  801746:	e8 19 ff ff ff       	call   801664 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 09                	push   $0x9
  80175f:	e8 00 ff ff ff       	call   801664 <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 0a                	push   $0xa
  801778:	e8 e7 fe ff ff       	call   801664 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 0b                	push   $0xb
  801791:	e8 ce fe ff ff       	call   801664 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	6a 0f                	push   $0xf
  8017ac:	e8 b3 fe ff ff       	call   801664 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
	return;
  8017b4:	90                   	nop
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	ff 75 08             	pushl  0x8(%ebp)
  8017c6:	6a 10                	push   $0x10
  8017c8:	e8 97 fe ff ff       	call   801664 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d0:	90                   	nop
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	ff 75 10             	pushl  0x10(%ebp)
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	6a 11                	push   $0x11
  8017e5:	e8 7a fe ff ff       	call   801664 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ed:	90                   	nop
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 0c                	push   $0xc
  8017ff:	e8 60 fe ff ff       	call   801664 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	6a 0d                	push   $0xd
  801819:	e8 46 fe ff ff       	call   801664 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 0e                	push   $0xe
  801832:	e8 2d fe ff ff       	call   801664 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	90                   	nop
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 13                	push   $0x13
  80184c:	e8 13 fe ff ff       	call   801664 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 14                	push   $0x14
  801866:	e8 f9 fd ff ff       	call   801664 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	90                   	nop
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_cputc>:


void
sys_cputc(const char c)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80187d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	50                   	push   %eax
  80188a:	6a 15                	push   $0x15
  80188c:	e8 d3 fd ff ff       	call   801664 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	90                   	nop
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 16                	push   $0x16
  8018a6:	e8 b9 fd ff ff       	call   801664 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 0c             	pushl  0xc(%ebp)
  8018c0:	50                   	push   %eax
  8018c1:	6a 17                	push   $0x17
  8018c3:	e8 9c fd ff ff       	call   801664 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 1a                	push   $0x1a
  8018e0:	e8 7f fd ff ff       	call   801664 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	52                   	push   %edx
  8018fa:	50                   	push   %eax
  8018fb:	6a 18                	push   $0x18
  8018fd:	e8 62 fd ff ff       	call   801664 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	90                   	nop
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 19                	push   $0x19
  80191b:	e8 44 fd ff ff       	call   801664 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	90                   	nop
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	8b 45 10             	mov    0x10(%ebp),%eax
  80192f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801932:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801935:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	6a 00                	push   $0x0
  80193e:	51                   	push   %ecx
  80193f:	52                   	push   %edx
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	50                   	push   %eax
  801944:	6a 1b                	push   $0x1b
  801946:	e8 19 fd ff ff       	call   801664 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	6a 1c                	push   $0x1c
  801963:	e8 fc fc ff ff       	call   801664 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801970:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	51                   	push   %ecx
  80197e:	52                   	push   %edx
  80197f:	50                   	push   %eax
  801980:	6a 1d                	push   $0x1d
  801982:	e8 dd fc ff ff       	call   801664 <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 1e                	push   $0x1e
  80199f:	e8 c0 fc ff ff       	call   801664 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 1f                	push   $0x1f
  8019b8:	e8 a7 fc ff ff       	call   801664 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	ff 75 14             	pushl  0x14(%ebp)
  8019cd:	ff 75 10             	pushl  0x10(%ebp)
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	50                   	push   %eax
  8019d4:	6a 20                	push   $0x20
  8019d6:	e8 89 fc ff ff       	call   801664 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	50                   	push   %eax
  8019ef:	6a 21                	push   $0x21
  8019f1:	e8 6e fc ff ff       	call   801664 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	50                   	push   %eax
  801a0b:	6a 22                	push   $0x22
  801a0d:	e8 52 fc ff ff       	call   801664 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 02                	push   $0x2
  801a26:	e8 39 fc ff ff       	call   801664 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 03                	push   $0x3
  801a3f:	e8 20 fc ff ff       	call   801664 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 04                	push   $0x4
  801a58:	e8 07 fc ff ff       	call   801664 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_exit_env>:


void sys_exit_env(void)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 23                	push   $0x23
  801a71:	e8 ee fb ff ff       	call   801664 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a82:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a85:	8d 50 04             	lea    0x4(%eax),%edx
  801a88:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	52                   	push   %edx
  801a92:	50                   	push   %eax
  801a93:	6a 24                	push   $0x24
  801a95:	e8 ca fb ff ff       	call   801664 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
	return result;
  801a9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa6:	89 01                	mov    %eax,(%ecx)
  801aa8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	c9                   	leave  
  801aaf:	c2 04 00             	ret    $0x4

00801ab2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	ff 75 10             	pushl  0x10(%ebp)
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	ff 75 08             	pushl  0x8(%ebp)
  801ac2:	6a 12                	push   $0x12
  801ac4:	e8 9b fb ff ff       	call   801664 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
	return ;
  801acc:	90                   	nop
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_rcr2>:
uint32 sys_rcr2()
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 25                	push   $0x25
  801ade:	e8 81 fb ff ff       	call   801664 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801af4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	50                   	push   %eax
  801b01:	6a 26                	push   $0x26
  801b03:	e8 5c fb ff ff       	call   801664 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0b:	90                   	nop
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <rsttst>:
void rsttst()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 28                	push   $0x28
  801b1d:	e8 42 fb ff ff       	call   801664 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
	return ;
  801b25:	90                   	nop
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 04             	sub    $0x4,%esp
  801b2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b34:	8b 55 18             	mov    0x18(%ebp),%edx
  801b37:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	6a 27                	push   $0x27
  801b48:	e8 17 fb ff ff       	call   801664 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <chktst>:
void chktst(uint32 n)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	ff 75 08             	pushl  0x8(%ebp)
  801b61:	6a 29                	push   $0x29
  801b63:	e8 fc fa ff ff       	call   801664 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6b:	90                   	nop
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <inctst>:

void inctst()
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 2a                	push   $0x2a
  801b7d:	e8 e2 fa ff ff       	call   801664 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <gettst>:
uint32 gettst()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 2b                	push   $0x2b
  801b97:	e8 c8 fa ff ff       	call   801664 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 2c                	push   $0x2c
  801bb3:	e8 ac fa ff ff       	call   801664 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
  801bbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bbe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bc2:	75 07                	jne    801bcb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc9:	eb 05                	jmp    801bd0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 2c                	push   $0x2c
  801be4:	e8 7b fa ff ff       	call   801664 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
  801bec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bf3:	75 07                	jne    801bfc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfa:	eb 05                	jmp    801c01 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 2c                	push   $0x2c
  801c15:	e8 4a fa ff ff       	call   801664 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
  801c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c20:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c24:	75 07                	jne    801c2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	eb 05                	jmp    801c32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 2c                	push   $0x2c
  801c46:	e8 19 fa ff ff       	call   801664 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
  801c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c51:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c55:	75 07                	jne    801c5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c57:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5c:	eb 05                	jmp    801c63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	ff 75 08             	pushl  0x8(%ebp)
  801c73:	6a 2d                	push   $0x2d
  801c75:	e8 ea f9 ff ff       	call   801664 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7d:	90                   	nop
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	6a 00                	push   $0x0
  801c92:	53                   	push   %ebx
  801c93:	51                   	push   %ecx
  801c94:	52                   	push   %edx
  801c95:	50                   	push   %eax
  801c96:	6a 2e                	push   $0x2e
  801c98:	e8 c7 f9 ff ff       	call   801664 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 2f                	push   $0x2f
  801cb8:	e8 a7 f9 ff ff       	call   801664 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    
  801cc2:	66 90                	xchg   %ax,%ax

00801cc4 <__udivdi3>:
  801cc4:	55                   	push   %ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
  801ccb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ccf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cdb:	89 ca                	mov    %ecx,%edx
  801cdd:	89 f8                	mov    %edi,%eax
  801cdf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ce3:	85 f6                	test   %esi,%esi
  801ce5:	75 2d                	jne    801d14 <__udivdi3+0x50>
  801ce7:	39 cf                	cmp    %ecx,%edi
  801ce9:	77 65                	ja     801d50 <__udivdi3+0x8c>
  801ceb:	89 fd                	mov    %edi,%ebp
  801ced:	85 ff                	test   %edi,%edi
  801cef:	75 0b                	jne    801cfc <__udivdi3+0x38>
  801cf1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf6:	31 d2                	xor    %edx,%edx
  801cf8:	f7 f7                	div    %edi
  801cfa:	89 c5                	mov    %eax,%ebp
  801cfc:	31 d2                	xor    %edx,%edx
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	f7 f5                	div    %ebp
  801d02:	89 c1                	mov    %eax,%ecx
  801d04:	89 d8                	mov    %ebx,%eax
  801d06:	f7 f5                	div    %ebp
  801d08:	89 cf                	mov    %ecx,%edi
  801d0a:	89 fa                	mov    %edi,%edx
  801d0c:	83 c4 1c             	add    $0x1c,%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5e                   	pop    %esi
  801d11:	5f                   	pop    %edi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    
  801d14:	39 ce                	cmp    %ecx,%esi
  801d16:	77 28                	ja     801d40 <__udivdi3+0x7c>
  801d18:	0f bd fe             	bsr    %esi,%edi
  801d1b:	83 f7 1f             	xor    $0x1f,%edi
  801d1e:	75 40                	jne    801d60 <__udivdi3+0x9c>
  801d20:	39 ce                	cmp    %ecx,%esi
  801d22:	72 0a                	jb     801d2e <__udivdi3+0x6a>
  801d24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d28:	0f 87 9e 00 00 00    	ja     801dcc <__udivdi3+0x108>
  801d2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d33:	89 fa                	mov    %edi,%edx
  801d35:	83 c4 1c             	add    $0x1c,%esp
  801d38:	5b                   	pop    %ebx
  801d39:	5e                   	pop    %esi
  801d3a:	5f                   	pop    %edi
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    
  801d3d:	8d 76 00             	lea    0x0(%esi),%esi
  801d40:	31 ff                	xor    %edi,%edi
  801d42:	31 c0                	xor    %eax,%eax
  801d44:	89 fa                	mov    %edi,%edx
  801d46:	83 c4 1c             	add    $0x1c,%esp
  801d49:	5b                   	pop    %ebx
  801d4a:	5e                   	pop    %esi
  801d4b:	5f                   	pop    %edi
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    
  801d4e:	66 90                	xchg   %ax,%ax
  801d50:	89 d8                	mov    %ebx,%eax
  801d52:	f7 f7                	div    %edi
  801d54:	31 ff                	xor    %edi,%edi
  801d56:	89 fa                	mov    %edi,%edx
  801d58:	83 c4 1c             	add    $0x1c,%esp
  801d5b:	5b                   	pop    %ebx
  801d5c:	5e                   	pop    %esi
  801d5d:	5f                   	pop    %edi
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    
  801d60:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d65:	89 eb                	mov    %ebp,%ebx
  801d67:	29 fb                	sub    %edi,%ebx
  801d69:	89 f9                	mov    %edi,%ecx
  801d6b:	d3 e6                	shl    %cl,%esi
  801d6d:	89 c5                	mov    %eax,%ebp
  801d6f:	88 d9                	mov    %bl,%cl
  801d71:	d3 ed                	shr    %cl,%ebp
  801d73:	89 e9                	mov    %ebp,%ecx
  801d75:	09 f1                	or     %esi,%ecx
  801d77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d7b:	89 f9                	mov    %edi,%ecx
  801d7d:	d3 e0                	shl    %cl,%eax
  801d7f:	89 c5                	mov    %eax,%ebp
  801d81:	89 d6                	mov    %edx,%esi
  801d83:	88 d9                	mov    %bl,%cl
  801d85:	d3 ee                	shr    %cl,%esi
  801d87:	89 f9                	mov    %edi,%ecx
  801d89:	d3 e2                	shl    %cl,%edx
  801d8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d8f:	88 d9                	mov    %bl,%cl
  801d91:	d3 e8                	shr    %cl,%eax
  801d93:	09 c2                	or     %eax,%edx
  801d95:	89 d0                	mov    %edx,%eax
  801d97:	89 f2                	mov    %esi,%edx
  801d99:	f7 74 24 0c          	divl   0xc(%esp)
  801d9d:	89 d6                	mov    %edx,%esi
  801d9f:	89 c3                	mov    %eax,%ebx
  801da1:	f7 e5                	mul    %ebp
  801da3:	39 d6                	cmp    %edx,%esi
  801da5:	72 19                	jb     801dc0 <__udivdi3+0xfc>
  801da7:	74 0b                	je     801db4 <__udivdi3+0xf0>
  801da9:	89 d8                	mov    %ebx,%eax
  801dab:	31 ff                	xor    %edi,%edi
  801dad:	e9 58 ff ff ff       	jmp    801d0a <__udivdi3+0x46>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801db8:	89 f9                	mov    %edi,%ecx
  801dba:	d3 e2                	shl    %cl,%edx
  801dbc:	39 c2                	cmp    %eax,%edx
  801dbe:	73 e9                	jae    801da9 <__udivdi3+0xe5>
  801dc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dc3:	31 ff                	xor    %edi,%edi
  801dc5:	e9 40 ff ff ff       	jmp    801d0a <__udivdi3+0x46>
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	31 c0                	xor    %eax,%eax
  801dce:	e9 37 ff ff ff       	jmp    801d0a <__udivdi3+0x46>
  801dd3:	90                   	nop

00801dd4 <__umoddi3>:
  801dd4:	55                   	push   %ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 1c             	sub    $0x1c,%esp
  801ddb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ddf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801de3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801de7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801deb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801def:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801df3:	89 f3                	mov    %esi,%ebx
  801df5:	89 fa                	mov    %edi,%edx
  801df7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dfb:	89 34 24             	mov    %esi,(%esp)
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	75 1a                	jne    801e1c <__umoddi3+0x48>
  801e02:	39 f7                	cmp    %esi,%edi
  801e04:	0f 86 a2 00 00 00    	jbe    801eac <__umoddi3+0xd8>
  801e0a:	89 c8                	mov    %ecx,%eax
  801e0c:	89 f2                	mov    %esi,%edx
  801e0e:	f7 f7                	div    %edi
  801e10:	89 d0                	mov    %edx,%eax
  801e12:	31 d2                	xor    %edx,%edx
  801e14:	83 c4 1c             	add    $0x1c,%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
  801e1c:	39 f0                	cmp    %esi,%eax
  801e1e:	0f 87 ac 00 00 00    	ja     801ed0 <__umoddi3+0xfc>
  801e24:	0f bd e8             	bsr    %eax,%ebp
  801e27:	83 f5 1f             	xor    $0x1f,%ebp
  801e2a:	0f 84 ac 00 00 00    	je     801edc <__umoddi3+0x108>
  801e30:	bf 20 00 00 00       	mov    $0x20,%edi
  801e35:	29 ef                	sub    %ebp,%edi
  801e37:	89 fe                	mov    %edi,%esi
  801e39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e3d:	89 e9                	mov    %ebp,%ecx
  801e3f:	d3 e0                	shl    %cl,%eax
  801e41:	89 d7                	mov    %edx,%edi
  801e43:	89 f1                	mov    %esi,%ecx
  801e45:	d3 ef                	shr    %cl,%edi
  801e47:	09 c7                	or     %eax,%edi
  801e49:	89 e9                	mov    %ebp,%ecx
  801e4b:	d3 e2                	shl    %cl,%edx
  801e4d:	89 14 24             	mov    %edx,(%esp)
  801e50:	89 d8                	mov    %ebx,%eax
  801e52:	d3 e0                	shl    %cl,%eax
  801e54:	89 c2                	mov    %eax,%edx
  801e56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e5a:	d3 e0                	shl    %cl,%eax
  801e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e64:	89 f1                	mov    %esi,%ecx
  801e66:	d3 e8                	shr    %cl,%eax
  801e68:	09 d0                	or     %edx,%eax
  801e6a:	d3 eb                	shr    %cl,%ebx
  801e6c:	89 da                	mov    %ebx,%edx
  801e6e:	f7 f7                	div    %edi
  801e70:	89 d3                	mov    %edx,%ebx
  801e72:	f7 24 24             	mull   (%esp)
  801e75:	89 c6                	mov    %eax,%esi
  801e77:	89 d1                	mov    %edx,%ecx
  801e79:	39 d3                	cmp    %edx,%ebx
  801e7b:	0f 82 87 00 00 00    	jb     801f08 <__umoddi3+0x134>
  801e81:	0f 84 91 00 00 00    	je     801f18 <__umoddi3+0x144>
  801e87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e8b:	29 f2                	sub    %esi,%edx
  801e8d:	19 cb                	sbb    %ecx,%ebx
  801e8f:	89 d8                	mov    %ebx,%eax
  801e91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e95:	d3 e0                	shl    %cl,%eax
  801e97:	89 e9                	mov    %ebp,%ecx
  801e99:	d3 ea                	shr    %cl,%edx
  801e9b:	09 d0                	or     %edx,%eax
  801e9d:	89 e9                	mov    %ebp,%ecx
  801e9f:	d3 eb                	shr    %cl,%ebx
  801ea1:	89 da                	mov    %ebx,%edx
  801ea3:	83 c4 1c             	add    $0x1c,%esp
  801ea6:	5b                   	pop    %ebx
  801ea7:	5e                   	pop    %esi
  801ea8:	5f                   	pop    %edi
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    
  801eab:	90                   	nop
  801eac:	89 fd                	mov    %edi,%ebp
  801eae:	85 ff                	test   %edi,%edi
  801eb0:	75 0b                	jne    801ebd <__umoddi3+0xe9>
  801eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb7:	31 d2                	xor    %edx,%edx
  801eb9:	f7 f7                	div    %edi
  801ebb:	89 c5                	mov    %eax,%ebp
  801ebd:	89 f0                	mov    %esi,%eax
  801ebf:	31 d2                	xor    %edx,%edx
  801ec1:	f7 f5                	div    %ebp
  801ec3:	89 c8                	mov    %ecx,%eax
  801ec5:	f7 f5                	div    %ebp
  801ec7:	89 d0                	mov    %edx,%eax
  801ec9:	e9 44 ff ff ff       	jmp    801e12 <__umoddi3+0x3e>
  801ece:	66 90                	xchg   %ax,%ax
  801ed0:	89 c8                	mov    %ecx,%eax
  801ed2:	89 f2                	mov    %esi,%edx
  801ed4:	83 c4 1c             	add    $0x1c,%esp
  801ed7:	5b                   	pop    %ebx
  801ed8:	5e                   	pop    %esi
  801ed9:	5f                   	pop    %edi
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    
  801edc:	3b 04 24             	cmp    (%esp),%eax
  801edf:	72 06                	jb     801ee7 <__umoddi3+0x113>
  801ee1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ee5:	77 0f                	ja     801ef6 <__umoddi3+0x122>
  801ee7:	89 f2                	mov    %esi,%edx
  801ee9:	29 f9                	sub    %edi,%ecx
  801eeb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801eef:	89 14 24             	mov    %edx,(%esp)
  801ef2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ef6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801efa:	8b 14 24             	mov    (%esp),%edx
  801efd:	83 c4 1c             	add    $0x1c,%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5e                   	pop    %esi
  801f02:	5f                   	pop    %edi
  801f03:	5d                   	pop    %ebp
  801f04:	c3                   	ret    
  801f05:	8d 76 00             	lea    0x0(%esi),%esi
  801f08:	2b 04 24             	sub    (%esp),%eax
  801f0b:	19 fa                	sbb    %edi,%edx
  801f0d:	89 d1                	mov    %edx,%ecx
  801f0f:	89 c6                	mov    %eax,%esi
  801f11:	e9 71 ff ff ff       	jmp    801e87 <__umoddi3+0xb3>
  801f16:	66 90                	xchg   %ax,%ax
  801f18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f1c:	72 ea                	jb     801f08 <__umoddi3+0x134>
  801f1e:	89 d9                	mov    %ebx,%ecx
  801f20:	e9 62 ff ff ff       	jmp    801e87 <__umoddi3+0xb3>
