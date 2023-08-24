
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 34 05 00 00       	call   80056a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
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
  80008d:	68 00 21 80 00       	push   $0x802100
  800092:	6a 12                	push   $0x12
  800094:	68 1c 21 80 00       	push   $0x80211c
  800099:	e8 1b 06 00 00       	call   8006b9 <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 34 21 80 00       	push   $0x802134
  8000a6:	e8 c2 08 00 00       	call   80096d <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 68 21 80 00       	push   $0x802168
  8000b6:	e8 b2 08 00 00       	call   80096d <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 c4 21 80 00       	push   $0x8021c4
  8000c6:	e8 a2 08 00 00       	call   80096d <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 06 1b 00 00       	call   801be7 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 f8 21 80 00       	push   $0x8021f8
  8000ec:	e8 7c 08 00 00       	call   80096d <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 27 18 00 00       	call   801920 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 27 22 80 00       	push   $0x802227
  80010b:	e8 5c 16 00 00       	call   80176c <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 2c 22 80 00       	push   $0x80222c
  800127:	6a 21                	push   $0x21
  800129:	68 1c 21 80 00       	push   $0x80211c
  80012e:	e8 86 05 00 00       	call   8006b9 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 e5 17 00 00       	call   801920 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 98 22 80 00       	push   $0x802298
  80014c:	6a 22                	push   $0x22
  80014e:	68 1c 21 80 00       	push   $0x80211c
  800153:	e8 61 05 00 00       	call   8006b9 <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 5d 16 00 00       	call   8017c0 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 b2 17 00 00       	call   801920 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 18 23 80 00       	push   $0x802318
  80017f:	6a 25                	push   $0x25
  800181:	68 1c 21 80 00       	push   $0x80211c
  800186:	e8 2e 05 00 00       	call   8006b9 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 90 17 00 00       	call   801920 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 70 23 80 00       	push   $0x802370
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 1c 21 80 00       	push   $0x80211c
  8001a8:	e8 0c 05 00 00       	call   8006b9 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 a0 23 80 00       	push   $0x8023a0
  8001b5:	e8 b3 07 00 00       	call   80096d <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 c4 23 80 00       	push   $0x8023c4
  8001c5:	e8 a3 07 00 00       	call   80096d <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 4e 17 00 00       	call   801920 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 f4 23 80 00       	push   $0x8023f4
  8001e4:	e8 83 15 00 00       	call   80176c <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 27 22 80 00       	push   $0x802227
  8001fe:	e8 69 15 00 00       	call   80176c <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 18 23 80 00       	push   $0x802318
  800217:	6a 32                	push   $0x32
  800219:	68 1c 21 80 00       	push   $0x80211c
  80021e:	e8 96 04 00 00       	call   8006b9 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 f5 16 00 00       	call   801920 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 f8 23 80 00       	push   $0x8023f8
  80023c:	6a 34                	push   $0x34
  80023e:	68 1c 21 80 00       	push   $0x80211c
  800243:	e8 71 04 00 00       	call   8006b9 <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 6d 15 00 00       	call   8017c0 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 c2 16 00 00       	call   801920 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 4d 24 80 00       	push   $0x80244d
  80026f:	6a 37                	push   $0x37
  800271:	68 1c 21 80 00       	push   $0x80211c
  800276:	e8 3e 04 00 00       	call   8006b9 <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 3a 15 00 00       	call   8017c0 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 92 16 00 00       	call   801920 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 4d 24 80 00       	push   $0x80244d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 1c 21 80 00       	push   $0x80211c
  8002a6:	e8 0e 04 00 00       	call   8006b9 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 6c 24 80 00       	push   $0x80246c
  8002b3:	e8 b5 06 00 00       	call   80096d <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 90 24 80 00       	push   $0x802490
  8002c3:	e8 a5 06 00 00       	call   80096d <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 50 16 00 00       	call   801920 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 c0 24 80 00       	push   $0x8024c0
  8002e2:	e8 85 14 00 00       	call   80176c <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 c2 24 80 00       	push   $0x8024c2
  8002fc:	e8 6b 14 00 00       	call   80176c <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 11 16 00 00       	call   801920 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 98 22 80 00       	push   $0x802298
  800320:	6a 45                	push   $0x45
  800322:	68 1c 21 80 00       	push   $0x80211c
  800327:	e8 8d 03 00 00       	call   8006b9 <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 89 14 00 00       	call   8017c0 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 de 15 00 00       	call   801920 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 4d 24 80 00       	push   $0x80244d
  800353:	6a 48                	push   $0x48
  800355:	68 1c 21 80 00       	push   $0x80211c
  80035a:	e8 5a 03 00 00       	call   8006b9 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 c4 24 80 00       	push   $0x8024c4
  80036e:	e8 f9 13 00 00       	call   80176c <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 c6 24 80 00       	push   $0x8024c6
  800381:	e8 e7 05 00 00       	call   80096d <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800389:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80038c:	e8 8f 15 00 00       	call   801920 <sys_calculate_free_frames>
  800391:	29 c3                	sub    %eax,%ebx
  800393:	89 d8                	mov    %ebx,%eax
  800395:	83 f8 08             	cmp    $0x8,%eax
  800398:	74 14                	je     8003ae <_main+0x376>
  80039a:	83 ec 04             	sub    $0x4,%esp
  80039d:	68 98 22 80 00       	push   $0x802298
  8003a2:	6a 4f                	push   $0x4f
  8003a4:	68 1c 21 80 00       	push   $0x80211c
  8003a9:	e8 0b 03 00 00       	call   8006b9 <_panic>

		sfree(o);
  8003ae:	83 ec 0c             	sub    $0xc,%esp
  8003b1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003b4:	e8 07 14 00 00       	call   8017c0 <sfree>
  8003b9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003bc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003bf:	e8 5c 15 00 00       	call   801920 <sys_calculate_free_frames>
  8003c4:	29 c3                	sub    %eax,%ebx
  8003c6:	89 d8                	mov    %ebx,%eax
  8003c8:	83 f8 04             	cmp    $0x4,%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 4d 24 80 00       	push   $0x80244d
  8003d5:	6a 52                	push   $0x52
  8003d7:	68 1c 21 80 00       	push   $0x80211c
  8003dc:	e8 d8 02 00 00       	call   8006b9 <_panic>

		sfree(u);
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003e7:	e8 d4 13 00 00       	call   8017c0 <sfree>
  8003ec:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003ef:	e8 2c 15 00 00       	call   801920 <sys_calculate_free_frames>
  8003f4:	89 c2                	mov    %eax,%edx
  8003f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003f9:	39 c2                	cmp    %eax,%edx
  8003fb:	74 14                	je     800411 <_main+0x3d9>
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	68 4d 24 80 00       	push   $0x80244d
  800405:	6a 55                	push   $0x55
  800407:	68 1c 21 80 00       	push   $0x80211c
  80040c:	e8 a8 02 00 00       	call   8006b9 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800411:	e8 0a 15 00 00       	call   801920 <sys_calculate_free_frames>
  800416:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	01 d2                	add    %edx,%edx
  800420:	01 d0                	add    %edx,%eax
  800422:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800425:	83 ec 04             	sub    $0x4,%esp
  800428:	6a 01                	push   $0x1
  80042a:	50                   	push   %eax
  80042b:	68 c0 24 80 00       	push   $0x8024c0
  800430:	e8 37 13 00 00       	call   80176c <smalloc>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80043b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	01 c0                	add    %eax,%eax
  800446:	01 d0                	add    %edx,%eax
  800448:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	6a 01                	push   $0x1
  800450:	50                   	push   %eax
  800451:	68 c2 24 80 00       	push   $0x8024c2
  800456:	e8 11 13 00 00       	call   80176c <smalloc>
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800461:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	6a 01                	push   $0x1
  800472:	50                   	push   %eax
  800473:	68 c4 24 80 00       	push   $0x8024c4
  800478:	e8 ef 12 00 00       	call   80176c <smalloc>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800483:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800486:	e8 95 14 00 00       	call   801920 <sys_calculate_free_frames>
  80048b:	29 c3                	sub    %eax,%ebx
  80048d:	89 d8                	mov    %ebx,%eax
  80048f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 98 22 80 00       	push   $0x802298
  80049e:	6a 5e                	push   $0x5e
  8004a0:	68 1c 21 80 00       	push   $0x80211c
  8004a5:	e8 0f 02 00 00       	call   8006b9 <_panic>

		sfree(o);
  8004aa:	83 ec 0c             	sub    $0xc,%esp
  8004ad:	ff 75 c0             	pushl  -0x40(%ebp)
  8004b0:	e8 0b 13 00 00       	call   8017c0 <sfree>
  8004b5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004b8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004bb:	e8 60 14 00 00       	call   801920 <sys_calculate_free_frames>
  8004c0:	29 c3                	sub    %eax,%ebx
  8004c2:	89 d8                	mov    %ebx,%eax
  8004c4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 4d 24 80 00       	push   $0x80244d
  8004d3:	6a 61                	push   $0x61
  8004d5:	68 1c 21 80 00       	push   $0x80211c
  8004da:	e8 da 01 00 00       	call   8006b9 <_panic>

		sfree(w);
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004e5:	e8 d6 12 00 00       	call   8017c0 <sfree>
  8004ea:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004ed:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004f0:	e8 2b 14 00 00       	call   801920 <sys_calculate_free_frames>
  8004f5:	29 c3                	sub    %eax,%ebx
  8004f7:	89 d8                	mov    %ebx,%eax
  8004f9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004fe:	74 14                	je     800514 <_main+0x4dc>
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	68 4d 24 80 00       	push   $0x80244d
  800508:	6a 64                	push   $0x64
  80050a:	68 1c 21 80 00       	push   $0x80211c
  80050f:	e8 a5 01 00 00       	call   8006b9 <_panic>

		sfree(u);
  800514:	83 ec 0c             	sub    $0xc,%esp
  800517:	ff 75 c4             	pushl  -0x3c(%ebp)
  80051a:	e8 a1 12 00 00       	call   8017c0 <sfree>
  80051f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800522:	e8 f9 13 00 00       	call   801920 <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 14                	je     800544 <_main+0x50c>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 4d 24 80 00       	push   $0x80244d
  800538:	6a 67                	push   $0x67
  80053a:	68 1c 21 80 00       	push   $0x80211c
  80053f:	e8 75 01 00 00       	call   8006b9 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 cc 24 80 00       	push   $0x8024cc
  80054c:	e8 1c 04 00 00       	call   80096d <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	68 f0 24 80 00       	push   $0x8024f0
  80055c:	e8 0c 04 00 00       	call   80096d <cprintf>
  800561:	83 c4 10             	add    $0x10,%esp

	return;
  800564:	90                   	nop
}
  800565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800570:	e8 8b 16 00 00       	call   801c00 <sys_getenvindex>
  800575:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80057b:	89 d0                	mov    %edx,%eax
  80057d:	01 c0                	add    %eax,%eax
  80057f:	01 d0                	add    %edx,%eax
  800581:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800588:	01 c8                	add    %ecx,%eax
  80058a:	c1 e0 02             	shl    $0x2,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800596:	01 c8                	add    %ecx,%eax
  800598:	c1 e0 02             	shl    $0x2,%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	c1 e0 02             	shl    $0x2,%eax
  8005a0:	01 d0                	add    %edx,%eax
  8005a2:	c1 e0 03             	shl    $0x3,%eax
  8005a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005aa:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005af:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b4:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8005ba:	84 c0                	test   %al,%al
  8005bc:	74 0f                	je     8005cd <libmain+0x63>
		binaryname = myEnv->prog_name;
  8005be:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c3:	05 18 da 01 00       	add    $0x1da18,%eax
  8005c8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005d1:	7e 0a                	jle    8005dd <libmain+0x73>
		binaryname = argv[0];
  8005d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	ff 75 08             	pushl  0x8(%ebp)
  8005e6:	e8 4d fa ff ff       	call   800038 <_main>
  8005eb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005ee:	e8 1a 14 00 00       	call   801a0d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005f3:	83 ec 0c             	sub    $0xc,%esp
  8005f6:	68 54 25 80 00       	push   $0x802554
  8005fb:	e8 6d 03 00 00       	call   80096d <cprintf>
  800600:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800603:	a1 20 30 80 00       	mov    0x803020,%eax
  800608:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80060e:	a1 20 30 80 00       	mov    0x803020,%eax
  800613:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800619:	83 ec 04             	sub    $0x4,%esp
  80061c:	52                   	push   %edx
  80061d:	50                   	push   %eax
  80061e:	68 7c 25 80 00       	push   $0x80257c
  800623:	e8 45 03 00 00       	call   80096d <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80062b:	a1 20 30 80 00       	mov    0x803020,%eax
  800630:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800636:	a1 20 30 80 00       	mov    0x803020,%eax
  80063b:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  800641:	a1 20 30 80 00       	mov    0x803020,%eax
  800646:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80064c:	51                   	push   %ecx
  80064d:	52                   	push   %edx
  80064e:	50                   	push   %eax
  80064f:	68 a4 25 80 00       	push   $0x8025a4
  800654:	e8 14 03 00 00       	call   80096d <cprintf>
  800659:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80065c:	a1 20 30 80 00       	mov    0x803020,%eax
  800661:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	50                   	push   %eax
  80066b:	68 fc 25 80 00       	push   $0x8025fc
  800670:	e8 f8 02 00 00       	call   80096d <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800678:	83 ec 0c             	sub    $0xc,%esp
  80067b:	68 54 25 80 00       	push   $0x802554
  800680:	e8 e8 02 00 00       	call   80096d <cprintf>
  800685:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800688:	e8 9a 13 00 00       	call   801a27 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80068d:	e8 19 00 00 00       	call   8006ab <exit>
}
  800692:	90                   	nop
  800693:	c9                   	leave  
  800694:	c3                   	ret    

00800695 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800695:	55                   	push   %ebp
  800696:	89 e5                	mov    %esp,%ebp
  800698:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80069b:	83 ec 0c             	sub    $0xc,%esp
  80069e:	6a 00                	push   $0x0
  8006a0:	e8 27 15 00 00       	call   801bcc <sys_destroy_env>
  8006a5:	83 c4 10             	add    $0x10,%esp
}
  8006a8:	90                   	nop
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <exit>:

void
exit(void)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006b1:	e8 7c 15 00 00       	call   801c32 <sys_exit_env>
}
  8006b6:	90                   	nop
  8006b7:	c9                   	leave  
  8006b8:	c3                   	ret    

008006b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006b9:	55                   	push   %ebp
  8006ba:	89 e5                	mov    %esp,%ebp
  8006bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006bf:	8d 45 10             	lea    0x10(%ebp),%eax
  8006c2:	83 c0 04             	add    $0x4,%eax
  8006c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006c8:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	74 16                	je     8006e7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006d1:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	50                   	push   %eax
  8006da:	68 10 26 80 00       	push   $0x802610
  8006df:	e8 89 02 00 00       	call   80096d <cprintf>
  8006e4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e7:	a1 00 30 80 00       	mov    0x803000,%eax
  8006ec:	ff 75 0c             	pushl  0xc(%ebp)
  8006ef:	ff 75 08             	pushl  0x8(%ebp)
  8006f2:	50                   	push   %eax
  8006f3:	68 15 26 80 00       	push   $0x802615
  8006f8:	e8 70 02 00 00       	call   80096d <cprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800700:	8b 45 10             	mov    0x10(%ebp),%eax
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	ff 75 f4             	pushl  -0xc(%ebp)
  800709:	50                   	push   %eax
  80070a:	e8 f3 01 00 00       	call   800902 <vcprintf>
  80070f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	6a 00                	push   $0x0
  800717:	68 31 26 80 00       	push   $0x802631
  80071c:	e8 e1 01 00 00       	call   800902 <vcprintf>
  800721:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800724:	e8 82 ff ff ff       	call   8006ab <exit>

	// should not return here
	while (1) ;
  800729:	eb fe                	jmp    800729 <_panic+0x70>

0080072b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800731:	a1 20 30 80 00       	mov    0x803020,%eax
  800736:	8b 50 74             	mov    0x74(%eax),%edx
  800739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073c:	39 c2                	cmp    %eax,%edx
  80073e:	74 14                	je     800754 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800740:	83 ec 04             	sub    $0x4,%esp
  800743:	68 34 26 80 00       	push   $0x802634
  800748:	6a 26                	push   $0x26
  80074a:	68 80 26 80 00       	push   $0x802680
  80074f:	e8 65 ff ff ff       	call   8006b9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800754:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	e9 c2 00 00 00       	jmp    800829 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	01 d0                	add    %edx,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	85 c0                	test   %eax,%eax
  80077a:	75 08                	jne    800784 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80077c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80077f:	e9 a2 00 00 00       	jmp    800826 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800784:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80078b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800792:	eb 69                	jmp    8007fd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800794:	a1 20 30 80 00       	mov    0x803020,%eax
  800799:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80079f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007a2:	89 d0                	mov    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d0                	add    %edx,%eax
  8007a8:	c1 e0 03             	shl    $0x3,%eax
  8007ab:	01 c8                	add    %ecx,%eax
  8007ad:	8a 40 04             	mov    0x4(%eax),%al
  8007b0:	84 c0                	test   %al,%al
  8007b2:	75 46                	jne    8007fa <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b9:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8007bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007c2:	89 d0                	mov    %edx,%eax
  8007c4:	01 c0                	add    %eax,%eax
  8007c6:	01 d0                	add    %edx,%eax
  8007c8:	c1 e0 03             	shl    $0x3,%eax
  8007cb:	01 c8                	add    %ecx,%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007da:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007df:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	01 c8                	add    %ecx,%eax
  8007eb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ed:	39 c2                	cmp    %eax,%edx
  8007ef:	75 09                	jne    8007fa <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007f1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007f8:	eb 12                	jmp    80080c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007fa:	ff 45 e8             	incl   -0x18(%ebp)
  8007fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800802:	8b 50 74             	mov    0x74(%eax),%edx
  800805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800808:	39 c2                	cmp    %eax,%edx
  80080a:	77 88                	ja     800794 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80080c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800810:	75 14                	jne    800826 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800812:	83 ec 04             	sub    $0x4,%esp
  800815:	68 8c 26 80 00       	push   $0x80268c
  80081a:	6a 3a                	push   $0x3a
  80081c:	68 80 26 80 00       	push   $0x802680
  800821:	e8 93 fe ff ff       	call   8006b9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800826:	ff 45 f0             	incl   -0x10(%ebp)
  800829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80082f:	0f 8c 32 ff ff ff    	jl     800767 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800835:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80083c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800843:	eb 26                	jmp    80086b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800845:	a1 20 30 80 00       	mov    0x803020,%eax
  80084a:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800850:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800853:	89 d0                	mov    %edx,%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	01 d0                	add    %edx,%eax
  800859:	c1 e0 03             	shl    $0x3,%eax
  80085c:	01 c8                	add    %ecx,%eax
  80085e:	8a 40 04             	mov    0x4(%eax),%al
  800861:	3c 01                	cmp    $0x1,%al
  800863:	75 03                	jne    800868 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800865:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800868:	ff 45 e0             	incl   -0x20(%ebp)
  80086b:	a1 20 30 80 00       	mov    0x803020,%eax
  800870:	8b 50 74             	mov    0x74(%eax),%edx
  800873:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	77 cb                	ja     800845 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800880:	74 14                	je     800896 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800882:	83 ec 04             	sub    $0x4,%esp
  800885:	68 e0 26 80 00       	push   $0x8026e0
  80088a:	6a 44                	push   $0x44
  80088c:	68 80 26 80 00       	push   $0x802680
  800891:	e8 23 fe ff ff       	call   8006b9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800896:	90                   	nop
  800897:	c9                   	leave  
  800898:	c3                   	ret    

00800899 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80089f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008aa:	89 0a                	mov    %ecx,(%edx)
  8008ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8008af:	88 d1                	mov    %dl,%cl
  8008b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008c2:	75 2c                	jne    8008f0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008c4:	a0 24 30 80 00       	mov    0x803024,%al
  8008c9:	0f b6 c0             	movzbl %al,%eax
  8008cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cf:	8b 12                	mov    (%edx),%edx
  8008d1:	89 d1                	mov    %edx,%ecx
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d6:	83 c2 08             	add    $0x8,%edx
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	50                   	push   %eax
  8008dd:	51                   	push   %ecx
  8008de:	52                   	push   %edx
  8008df:	e8 7b 0f 00 00       	call   80185f <sys_cputs>
  8008e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f3:	8b 40 04             	mov    0x4(%eax),%eax
  8008f6:	8d 50 01             	lea    0x1(%eax),%edx
  8008f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008ff:	90                   	nop
  800900:	c9                   	leave  
  800901:	c3                   	ret    

00800902 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80090b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800912:	00 00 00 
	b.cnt = 0;
  800915:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80091c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	ff 75 08             	pushl  0x8(%ebp)
  800925:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80092b:	50                   	push   %eax
  80092c:	68 99 08 80 00       	push   $0x800899
  800931:	e8 11 02 00 00       	call   800b47 <vprintfmt>
  800936:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800939:	a0 24 30 80 00       	mov    0x803024,%al
  80093e:	0f b6 c0             	movzbl %al,%eax
  800941:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800947:	83 ec 04             	sub    $0x4,%esp
  80094a:	50                   	push   %eax
  80094b:	52                   	push   %edx
  80094c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800952:	83 c0 08             	add    $0x8,%eax
  800955:	50                   	push   %eax
  800956:	e8 04 0f 00 00       	call   80185f <sys_cputs>
  80095b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80095e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800965:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <cprintf>:

int cprintf(const char *fmt, ...) {
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800973:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80097a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80097d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 f4             	pushl  -0xc(%ebp)
  800989:	50                   	push   %eax
  80098a:	e8 73 ff ff ff       	call   800902 <vcprintf>
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009a0:	e8 68 10 00 00       	call   801a0d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b4:	50                   	push   %eax
  8009b5:	e8 48 ff ff ff       	call   800902 <vcprintf>
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009c0:	e8 62 10 00 00       	call   801a27 <sys_enable_interrupt>
	return cnt;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	83 ec 14             	sub    $0x14,%esp
  8009d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009dd:	8b 45 18             	mov    0x18(%ebp),%eax
  8009e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e8:	77 55                	ja     800a3f <printnum+0x75>
  8009ea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009ed:	72 05                	jb     8009f4 <printnum+0x2a>
  8009ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009f2:	77 4b                	ja     800a3f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009f4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8009fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800a02:	52                   	push   %edx
  800a03:	50                   	push   %eax
  800a04:	ff 75 f4             	pushl  -0xc(%ebp)
  800a07:	ff 75 f0             	pushl  -0x10(%ebp)
  800a0a:	e8 85 14 00 00       	call   801e94 <__udivdi3>
  800a0f:	83 c4 10             	add    $0x10,%esp
  800a12:	83 ec 04             	sub    $0x4,%esp
  800a15:	ff 75 20             	pushl  0x20(%ebp)
  800a18:	53                   	push   %ebx
  800a19:	ff 75 18             	pushl  0x18(%ebp)
  800a1c:	52                   	push   %edx
  800a1d:	50                   	push   %eax
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	ff 75 08             	pushl  0x8(%ebp)
  800a24:	e8 a1 ff ff ff       	call   8009ca <printnum>
  800a29:	83 c4 20             	add    $0x20,%esp
  800a2c:	eb 1a                	jmp    800a48 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	ff 75 20             	pushl  0x20(%ebp)
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a3f:	ff 4d 1c             	decl   0x1c(%ebp)
  800a42:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a46:	7f e6                	jg     800a2e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a48:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a56:	53                   	push   %ebx
  800a57:	51                   	push   %ecx
  800a58:	52                   	push   %edx
  800a59:	50                   	push   %eax
  800a5a:	e8 45 15 00 00       	call   801fa4 <__umoddi3>
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	05 54 29 80 00       	add    $0x802954,%eax
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f be c0             	movsbl %al,%eax
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	50                   	push   %eax
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
}
  800a7b:	90                   	nop
  800a7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a84:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a88:	7e 1c                	jle    800aa6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8b 00                	mov    (%eax),%eax
  800a8f:	8d 50 08             	lea    0x8(%eax),%edx
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	89 10                	mov    %edx,(%eax)
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 00                	mov    (%eax),%eax
  800a9c:	83 e8 08             	sub    $0x8,%eax
  800a9f:	8b 50 04             	mov    0x4(%eax),%edx
  800aa2:	8b 00                	mov    (%eax),%eax
  800aa4:	eb 40                	jmp    800ae6 <getuint+0x65>
	else if (lflag)
  800aa6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aaa:	74 1e                	je     800aca <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8b 00                	mov    (%eax),%eax
  800ab1:	8d 50 04             	lea    0x4(%eax),%edx
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	89 10                	mov    %edx,(%eax)
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 00                	mov    (%eax),%eax
  800abe:	83 e8 04             	sub    $0x4,%eax
  800ac1:	8b 00                	mov    (%eax),%eax
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac8:	eb 1c                	jmp    800ae6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8b 00                	mov    (%eax),%eax
  800acf:	8d 50 04             	lea    0x4(%eax),%edx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	89 10                	mov    %edx,(%eax)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	8b 00                	mov    (%eax),%eax
  800adc:	83 e8 04             	sub    $0x4,%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aeb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aef:	7e 1c                	jle    800b0d <getint+0x25>
		return va_arg(*ap, long long);
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8b 00                	mov    (%eax),%eax
  800af6:	8d 50 08             	lea    0x8(%eax),%edx
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	89 10                	mov    %edx,(%eax)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	83 e8 08             	sub    $0x8,%eax
  800b06:	8b 50 04             	mov    0x4(%eax),%edx
  800b09:	8b 00                	mov    (%eax),%eax
  800b0b:	eb 38                	jmp    800b45 <getint+0x5d>
	else if (lflag)
  800b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b11:	74 1a                	je     800b2d <getint+0x45>
		return va_arg(*ap, long);
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 00                	mov    (%eax),%eax
  800b18:	8d 50 04             	lea    0x4(%eax),%edx
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	89 10                	mov    %edx,(%eax)
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	83 e8 04             	sub    $0x4,%eax
  800b28:	8b 00                	mov    (%eax),%eax
  800b2a:	99                   	cltd   
  800b2b:	eb 18                	jmp    800b45 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	8d 50 04             	lea    0x4(%eax),%edx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	89 10                	mov    %edx,(%eax)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8b 00                	mov    (%eax),%eax
  800b3f:	83 e8 04             	sub    $0x4,%eax
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	99                   	cltd   
}
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
  800b4c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4f:	eb 17                	jmp    800b68 <vprintfmt+0x21>
			if (ch == '\0')
  800b51:	85 db                	test   %ebx,%ebx
  800b53:	0f 84 af 03 00 00    	je     800f08 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	53                   	push   %ebx
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b68:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6b:	8d 50 01             	lea    0x1(%eax),%edx
  800b6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800b71:	8a 00                	mov    (%eax),%al
  800b73:	0f b6 d8             	movzbl %al,%ebx
  800b76:	83 fb 25             	cmp    $0x25,%ebx
  800b79:	75 d6                	jne    800b51 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b7b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b7f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b86:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b8d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ba1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	0f b6 d8             	movzbl %al,%ebx
  800ba9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bac:	83 f8 55             	cmp    $0x55,%eax
  800baf:	0f 87 2b 03 00 00    	ja     800ee0 <vprintfmt+0x399>
  800bb5:	8b 04 85 78 29 80 00 	mov    0x802978(,%eax,4),%eax
  800bbc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bbe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d7                	jmp    800b9b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc8:	eb d1                	jmp    800b9b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bd4:	89 d0                	mov    %edx,%eax
  800bd6:	c1 e0 02             	shl    $0x2,%eax
  800bd9:	01 d0                	add    %edx,%eax
  800bdb:	01 c0                	add    %eax,%eax
  800bdd:	01 d8                	add    %ebx,%eax
  800bdf:	83 e8 30             	sub    $0x30,%eax
  800be2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800be5:	8b 45 10             	mov    0x10(%ebp),%eax
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bed:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf0:	7e 3e                	jle    800c30 <vprintfmt+0xe9>
  800bf2:	83 fb 39             	cmp    $0x39,%ebx
  800bf5:	7f 39                	jg     800c30 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bfa:	eb d5                	jmp    800bd1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bff:	83 c0 04             	add    $0x4,%eax
  800c02:	89 45 14             	mov    %eax,0x14(%ebp)
  800c05:	8b 45 14             	mov    0x14(%ebp),%eax
  800c08:	83 e8 04             	sub    $0x4,%eax
  800c0b:	8b 00                	mov    (%eax),%eax
  800c0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c10:	eb 1f                	jmp    800c31 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c16:	79 83                	jns    800b9b <vprintfmt+0x54>
				width = 0;
  800c18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c1f:	e9 77 ff ff ff       	jmp    800b9b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c24:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c2b:	e9 6b ff ff ff       	jmp    800b9b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c30:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c35:	0f 89 60 ff ff ff    	jns    800b9b <vprintfmt+0x54>
				width = precision, precision = -1;
  800c3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c41:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c48:	e9 4e ff ff ff       	jmp    800b9b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c4d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c50:	e9 46 ff ff ff       	jmp    800b9b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	50                   	push   %eax
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	ff d0                	call   *%eax
  800c72:	83 c4 10             	add    $0x10,%esp
			break;
  800c75:	e9 89 02 00 00       	jmp    800f03 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 14             	mov    %eax,0x14(%ebp)
  800c83:	8b 45 14             	mov    0x14(%ebp),%eax
  800c86:	83 e8 04             	sub    $0x4,%eax
  800c89:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c8b:	85 db                	test   %ebx,%ebx
  800c8d:	79 02                	jns    800c91 <vprintfmt+0x14a>
				err = -err;
  800c8f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c91:	83 fb 64             	cmp    $0x64,%ebx
  800c94:	7f 0b                	jg     800ca1 <vprintfmt+0x15a>
  800c96:	8b 34 9d c0 27 80 00 	mov    0x8027c0(,%ebx,4),%esi
  800c9d:	85 f6                	test   %esi,%esi
  800c9f:	75 19                	jne    800cba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ca1:	53                   	push   %ebx
  800ca2:	68 65 29 80 00       	push   $0x802965
  800ca7:	ff 75 0c             	pushl  0xc(%ebp)
  800caa:	ff 75 08             	pushl  0x8(%ebp)
  800cad:	e8 5e 02 00 00       	call   800f10 <printfmt>
  800cb2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cb5:	e9 49 02 00 00       	jmp    800f03 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cba:	56                   	push   %esi
  800cbb:	68 6e 29 80 00       	push   $0x80296e
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	ff 75 08             	pushl  0x8(%ebp)
  800cc6:	e8 45 02 00 00       	call   800f10 <printfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp
			break;
  800cce:	e9 30 02 00 00       	jmp    800f03 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd6:	83 c0 04             	add    $0x4,%eax
  800cd9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdf:	83 e8 04             	sub    $0x4,%eax
  800ce2:	8b 30                	mov    (%eax),%esi
  800ce4:	85 f6                	test   %esi,%esi
  800ce6:	75 05                	jne    800ced <vprintfmt+0x1a6>
				p = "(null)";
  800ce8:	be 71 29 80 00       	mov    $0x802971,%esi
			if (width > 0 && padc != '-')
  800ced:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf1:	7e 6d                	jle    800d60 <vprintfmt+0x219>
  800cf3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf7:	74 67                	je     800d60 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	50                   	push   %eax
  800d00:	56                   	push   %esi
  800d01:	e8 0c 03 00 00       	call   801012 <strnlen>
  800d06:	83 c4 10             	add    $0x10,%esp
  800d09:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d0c:	eb 16                	jmp    800d24 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d0e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	50                   	push   %eax
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	ff d0                	call   *%eax
  800d1e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	ff 4d e4             	decl   -0x1c(%ebp)
  800d24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d28:	7f e4                	jg     800d0e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2a:	eb 34                	jmp    800d60 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d30:	74 1c                	je     800d4e <vprintfmt+0x207>
  800d32:	83 fb 1f             	cmp    $0x1f,%ebx
  800d35:	7e 05                	jle    800d3c <vprintfmt+0x1f5>
  800d37:	83 fb 7e             	cmp    $0x7e,%ebx
  800d3a:	7e 12                	jle    800d4e <vprintfmt+0x207>
					putch('?', putdat);
  800d3c:	83 ec 08             	sub    $0x8,%esp
  800d3f:	ff 75 0c             	pushl  0xc(%ebp)
  800d42:	6a 3f                	push   $0x3f
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
  800d4c:	eb 0f                	jmp    800d5d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d4e:	83 ec 08             	sub    $0x8,%esp
  800d51:	ff 75 0c             	pushl  0xc(%ebp)
  800d54:	53                   	push   %ebx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d5d:	ff 4d e4             	decl   -0x1c(%ebp)
  800d60:	89 f0                	mov    %esi,%eax
  800d62:	8d 70 01             	lea    0x1(%eax),%esi
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f be d8             	movsbl %al,%ebx
  800d6a:	85 db                	test   %ebx,%ebx
  800d6c:	74 24                	je     800d92 <vprintfmt+0x24b>
  800d6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d72:	78 b8                	js     800d2c <vprintfmt+0x1e5>
  800d74:	ff 4d e0             	decl   -0x20(%ebp)
  800d77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d7b:	79 af                	jns    800d2c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7d:	eb 13                	jmp    800d92 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	6a 20                	push   $0x20
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	ff d0                	call   *%eax
  800d8c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d8f:	ff 4d e4             	decl   -0x1c(%ebp)
  800d92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d96:	7f e7                	jg     800d7f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d98:	e9 66 01 00 00       	jmp    800f03 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d9d:	83 ec 08             	sub    $0x8,%esp
  800da0:	ff 75 e8             	pushl  -0x18(%ebp)
  800da3:	8d 45 14             	lea    0x14(%ebp),%eax
  800da6:	50                   	push   %eax
  800da7:	e8 3c fd ff ff       	call   800ae8 <getint>
  800dac:	83 c4 10             	add    $0x10,%esp
  800daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dbb:	85 d2                	test   %edx,%edx
  800dbd:	79 23                	jns    800de2 <vprintfmt+0x29b>
				putch('-', putdat);
  800dbf:	83 ec 08             	sub    $0x8,%esp
  800dc2:	ff 75 0c             	pushl  0xc(%ebp)
  800dc5:	6a 2d                	push   $0x2d
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	ff d0                	call   *%eax
  800dcc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd5:	f7 d8                	neg    %eax
  800dd7:	83 d2 00             	adc    $0x0,%edx
  800dda:	f7 da                	neg    %edx
  800ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800de2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de9:	e9 bc 00 00 00       	jmp    800eaa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 e8             	pushl  -0x18(%ebp)
  800df4:	8d 45 14             	lea    0x14(%ebp),%eax
  800df7:	50                   	push   %eax
  800df8:	e8 84 fc ff ff       	call   800a81 <getuint>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e06:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e0d:	e9 98 00 00 00       	jmp    800eaa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e12:	83 ec 08             	sub    $0x8,%esp
  800e15:	ff 75 0c             	pushl  0xc(%ebp)
  800e18:	6a 58                	push   $0x58
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	ff d0                	call   *%eax
  800e1f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e22:	83 ec 08             	sub    $0x8,%esp
  800e25:	ff 75 0c             	pushl  0xc(%ebp)
  800e28:	6a 58                	push   $0x58
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	ff d0                	call   *%eax
  800e2f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	6a 58                	push   $0x58
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	ff d0                	call   *%eax
  800e3f:	83 c4 10             	add    $0x10,%esp
			break;
  800e42:	e9 bc 00 00 00       	jmp    800f03 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e47:	83 ec 08             	sub    $0x8,%esp
  800e4a:	ff 75 0c             	pushl  0xc(%ebp)
  800e4d:	6a 30                	push   $0x30
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	ff d0                	call   *%eax
  800e54:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 78                	push   $0x78
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 c0 04             	add    $0x4,%eax
  800e6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e70:	8b 45 14             	mov    0x14(%ebp),%eax
  800e73:	83 e8 04             	sub    $0x4,%eax
  800e76:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e82:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e89:	eb 1f                	jmp    800eaa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e8b:	83 ec 08             	sub    $0x8,%esp
  800e8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e91:	8d 45 14             	lea    0x14(%ebp),%eax
  800e94:	50                   	push   %eax
  800e95:	e8 e7 fb ff ff       	call   800a81 <getuint>
  800e9a:	83 c4 10             	add    $0x10,%esp
  800e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ea3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eaa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	83 ec 04             	sub    $0x4,%esp
  800eb4:	52                   	push   %edx
  800eb5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb8:	50                   	push   %eax
  800eb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800ebc:	ff 75 f0             	pushl  -0x10(%ebp)
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	ff 75 08             	pushl  0x8(%ebp)
  800ec5:	e8 00 fb ff ff       	call   8009ca <printnum>
  800eca:	83 c4 20             	add    $0x20,%esp
			break;
  800ecd:	eb 34                	jmp    800f03 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ecf:	83 ec 08             	sub    $0x8,%esp
  800ed2:	ff 75 0c             	pushl  0xc(%ebp)
  800ed5:	53                   	push   %ebx
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	ff d0                	call   *%eax
  800edb:	83 c4 10             	add    $0x10,%esp
			break;
  800ede:	eb 23                	jmp    800f03 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	ff 75 0c             	pushl  0xc(%ebp)
  800ee6:	6a 25                	push   $0x25
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	ff d0                	call   *%eax
  800eed:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ef0:	ff 4d 10             	decl   0x10(%ebp)
  800ef3:	eb 03                	jmp    800ef8 <vprintfmt+0x3b1>
  800ef5:	ff 4d 10             	decl   0x10(%ebp)
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	48                   	dec    %eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	3c 25                	cmp    $0x25,%al
  800f00:	75 f3                	jne    800ef5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f02:	90                   	nop
		}
	}
  800f03:	e9 47 fc ff ff       	jmp    800b4f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f08:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f0c:	5b                   	pop    %ebx
  800f0d:	5e                   	pop    %esi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f16:	8d 45 10             	lea    0x10(%ebp),%eax
  800f19:	83 c0 04             	add    $0x4,%eax
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f22:	ff 75 f4             	pushl  -0xc(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 0c             	pushl  0xc(%ebp)
  800f29:	ff 75 08             	pushl  0x8(%ebp)
  800f2c:	e8 16 fc ff ff       	call   800b47 <vprintfmt>
  800f31:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f34:	90                   	nop
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8b 40 08             	mov    0x8(%eax),%eax
  800f40:	8d 50 01             	lea    0x1(%eax),%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	8b 10                	mov    (%eax),%edx
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	8b 40 04             	mov    0x4(%eax),%eax
  800f54:	39 c2                	cmp    %eax,%edx
  800f56:	73 12                	jae    800f6a <sprintputch+0x33>
		*b->buf++ = ch;
  800f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5b:	8b 00                	mov    (%eax),%eax
  800f5d:	8d 48 01             	lea    0x1(%eax),%ecx
  800f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f63:	89 0a                	mov    %ecx,(%edx)
  800f65:	8b 55 08             	mov    0x8(%ebp),%edx
  800f68:	88 10                	mov    %dl,(%eax)
}
  800f6a:	90                   	nop
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	01 d0                	add    %edx,%eax
  800f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f92:	74 06                	je     800f9a <vsnprintf+0x2d>
  800f94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f98:	7f 07                	jg     800fa1 <vsnprintf+0x34>
		return -E_INVAL;
  800f9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800f9f:	eb 20                	jmp    800fc1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fa1:	ff 75 14             	pushl  0x14(%ebp)
  800fa4:	ff 75 10             	pushl  0x10(%ebp)
  800fa7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800faa:	50                   	push   %eax
  800fab:	68 37 0f 80 00       	push   $0x800f37
  800fb0:	e8 92 fb ff ff       	call   800b47 <vprintfmt>
  800fb5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fbb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fc1:	c9                   	leave  
  800fc2:	c3                   	ret    

00800fc3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc9:	8d 45 10             	lea    0x10(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd8:	50                   	push   %eax
  800fd9:	ff 75 0c             	pushl  0xc(%ebp)
  800fdc:	ff 75 08             	pushl  0x8(%ebp)
  800fdf:	e8 89 ff ff ff       	call   800f6d <vsnprintf>
  800fe4:	83 c4 10             	add    $0x10,%esp
  800fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ffc:	eb 06                	jmp    801004 <strlen+0x15>
		n++;
  800ffe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	84 c0                	test   %al,%al
  80100b:	75 f1                	jne    800ffe <strlen+0xf>
		n++;
	return n;
  80100d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801018:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101f:	eb 09                	jmp    80102a <strnlen+0x18>
		n++;
  801021:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	ff 4d 0c             	decl   0xc(%ebp)
  80102a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102e:	74 09                	je     801039 <strnlen+0x27>
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	84 c0                	test   %al,%al
  801037:	75 e8                	jne    801021 <strnlen+0xf>
		n++;
	return n;
  801039:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80104a:	90                   	nop
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8d 50 01             	lea    0x1(%eax),%edx
  801051:	89 55 08             	mov    %edx,0x8(%ebp)
  801054:	8b 55 0c             	mov    0xc(%ebp),%edx
  801057:	8d 4a 01             	lea    0x1(%edx),%ecx
  80105a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80105d:	8a 12                	mov    (%edx),%dl
  80105f:	88 10                	mov    %dl,(%eax)
  801061:	8a 00                	mov    (%eax),%al
  801063:	84 c0                	test   %al,%al
  801065:	75 e4                	jne    80104b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801067:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80107f:	eb 1f                	jmp    8010a0 <strncpy+0x34>
		*dst++ = *src;
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8d 50 01             	lea    0x1(%eax),%edx
  801087:	89 55 08             	mov    %edx,0x8(%ebp)
  80108a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108d:	8a 12                	mov    (%edx),%dl
  80108f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	84 c0                	test   %al,%al
  801098:	74 03                	je     80109d <strncpy+0x31>
			src++;
  80109a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80109d:	ff 45 fc             	incl   -0x4(%ebp)
  8010a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a6:	72 d9                	jb     801081 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	74 30                	je     8010ef <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010bf:	eb 16                	jmp    8010d7 <strlcpy+0x2a>
			*dst++ = *src++;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8d 50 01             	lea    0x1(%eax),%edx
  8010c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d3:	8a 12                	mov    (%edx),%dl
  8010d5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d7:	ff 4d 10             	decl   0x10(%ebp)
  8010da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010de:	74 09                	je     8010e9 <strlcpy+0x3c>
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	84 c0                	test   %al,%al
  8010e7:	75 d8                	jne    8010c1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	29 c2                	sub    %eax,%edx
  8010f7:	89 d0                	mov    %edx,%eax
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010fe:	eb 06                	jmp    801106 <strcmp+0xb>
		p++, q++;
  801100:	ff 45 08             	incl   0x8(%ebp)
  801103:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	84 c0                	test   %al,%al
  80110d:	74 0e                	je     80111d <strcmp+0x22>
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8a 10                	mov    (%eax),%dl
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	38 c2                	cmp    %al,%dl
  80111b:	74 e3                	je     801100 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	0f b6 d0             	movzbl %al,%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	0f b6 c0             	movzbl %al,%eax
  80112d:	29 c2                	sub    %eax,%edx
  80112f:	89 d0                	mov    %edx,%eax
}
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801136:	eb 09                	jmp    801141 <strncmp+0xe>
		n--, p++, q++;
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	ff 45 08             	incl   0x8(%ebp)
  80113e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801141:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801145:	74 17                	je     80115e <strncmp+0x2b>
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	84 c0                	test   %al,%al
  80114e:	74 0e                	je     80115e <strncmp+0x2b>
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 10                	mov    (%eax),%dl
  801155:	8b 45 0c             	mov    0xc(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	38 c2                	cmp    %al,%dl
  80115c:	74 da                	je     801138 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80115e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801162:	75 07                	jne    80116b <strncmp+0x38>
		return 0;
  801164:	b8 00 00 00 00       	mov    $0x0,%eax
  801169:	eb 14                	jmp    80117f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	0f b6 d0             	movzbl %al,%edx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	29 c2                	sub    %eax,%edx
  80117d:	89 d0                	mov    %edx,%eax
}
  80117f:	5d                   	pop    %ebp
  801180:	c3                   	ret    

00801181 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	83 ec 04             	sub    $0x4,%esp
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80118d:	eb 12                	jmp    8011a1 <strchr+0x20>
		if (*s == c)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801197:	75 05                	jne    80119e <strchr+0x1d>
			return (char *) s;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	eb 11                	jmp    8011af <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	84 c0                	test   %al,%al
  8011a8:	75 e5                	jne    80118f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011bd:	eb 0d                	jmp    8011cc <strfind+0x1b>
		if (*s == c)
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c7:	74 0e                	je     8011d7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c9:	ff 45 08             	incl   0x8(%ebp)
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	84 c0                	test   %al,%al
  8011d3:	75 ea                	jne    8011bf <strfind+0xe>
  8011d5:	eb 01                	jmp    8011d8 <strfind+0x27>
		if (*s == c)
			break;
  8011d7:	90                   	nop
	return (char *) s;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011ef:	eb 0e                	jmp    8011ff <memset+0x22>
		*p++ = c;
  8011f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f4:	8d 50 01             	lea    0x1(%eax),%edx
  8011f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011ff:	ff 4d f8             	decl   -0x8(%ebp)
  801202:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801206:	79 e9                	jns    8011f1 <memset+0x14>
		*p++ = c;

	return v;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80121f:	eb 16                	jmp    801237 <memcpy+0x2a>
		*d++ = *s++;
  801221:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801224:	8d 50 01             	lea    0x1(%eax),%edx
  801227:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801230:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801233:	8a 12                	mov    (%edx),%dl
  801235:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801237:	8b 45 10             	mov    0x10(%ebp),%eax
  80123a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80123d:	89 55 10             	mov    %edx,0x10(%ebp)
  801240:	85 c0                	test   %eax,%eax
  801242:	75 dd                	jne    801221 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801261:	73 50                	jae    8012b3 <memmove+0x6a>
  801263:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80126e:	76 43                	jbe    8012b3 <memmove+0x6a>
		s += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801276:	8b 45 10             	mov    0x10(%ebp),%eax
  801279:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80127c:	eb 10                	jmp    80128e <memmove+0x45>
			*--d = *--s;
  80127e:	ff 4d f8             	decl   -0x8(%ebp)
  801281:	ff 4d fc             	decl   -0x4(%ebp)
  801284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801287:	8a 10                	mov    (%eax),%dl
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	8d 50 ff             	lea    -0x1(%eax),%edx
  801294:	89 55 10             	mov    %edx,0x10(%ebp)
  801297:	85 c0                	test   %eax,%eax
  801299:	75 e3                	jne    80127e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80129b:	eb 23                	jmp    8012c0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80129d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a0:	8d 50 01             	lea    0x1(%eax),%edx
  8012a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012af:	8a 12                	mov    (%edx),%dl
  8012b1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	75 dd                	jne    80129d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d7:	eb 2a                	jmp    801303 <memcmp+0x3e>
		if (*s1 != *s2)
  8012d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dc:	8a 10                	mov    (%eax),%dl
  8012de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	38 c2                	cmp    %al,%dl
  8012e5:	74 16                	je     8012fd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	0f b6 d0             	movzbl %al,%edx
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	0f b6 c0             	movzbl %al,%eax
  8012f7:	29 c2                	sub    %eax,%edx
  8012f9:	89 d0                	mov    %edx,%eax
  8012fb:	eb 18                	jmp    801315 <memcmp+0x50>
		s1++, s2++;
  8012fd:	ff 45 fc             	incl   -0x4(%ebp)
  801300:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	8d 50 ff             	lea    -0x1(%eax),%edx
  801309:	89 55 10             	mov    %edx,0x10(%ebp)
  80130c:	85 c0                	test   %eax,%eax
  80130e:	75 c9                	jne    8012d9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80131d:	8b 55 08             	mov    0x8(%ebp),%edx
  801320:	8b 45 10             	mov    0x10(%ebp),%eax
  801323:	01 d0                	add    %edx,%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801328:	eb 15                	jmp    80133f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	0f b6 d0             	movzbl %al,%edx
  801332:	8b 45 0c             	mov    0xc(%ebp),%eax
  801335:	0f b6 c0             	movzbl %al,%eax
  801338:	39 c2                	cmp    %eax,%edx
  80133a:	74 0d                	je     801349 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80133c:	ff 45 08             	incl   0x8(%ebp)
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801345:	72 e3                	jb     80132a <memfind+0x13>
  801347:	eb 01                	jmp    80134a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801349:	90                   	nop
	return (void *) s;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801355:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80135c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801363:	eb 03                	jmp    801368 <strtol+0x19>
		s++;
  801365:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	3c 20                	cmp    $0x20,%al
  80136f:	74 f4                	je     801365 <strtol+0x16>
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	8a 00                	mov    (%eax),%al
  801376:	3c 09                	cmp    $0x9,%al
  801378:	74 eb                	je     801365 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	3c 2b                	cmp    $0x2b,%al
  801381:	75 05                	jne    801388 <strtol+0x39>
		s++;
  801383:	ff 45 08             	incl   0x8(%ebp)
  801386:	eb 13                	jmp    80139b <strtol+0x4c>
	else if (*s == '-')
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	3c 2d                	cmp    $0x2d,%al
  80138f:	75 0a                	jne    80139b <strtol+0x4c>
		s++, neg = 1;
  801391:	ff 45 08             	incl   0x8(%ebp)
  801394:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80139b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139f:	74 06                	je     8013a7 <strtol+0x58>
  8013a1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013a5:	75 20                	jne    8013c7 <strtol+0x78>
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	3c 30                	cmp    $0x30,%al
  8013ae:	75 17                	jne    8013c7 <strtol+0x78>
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	40                   	inc    %eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	3c 78                	cmp    $0x78,%al
  8013b8:	75 0d                	jne    8013c7 <strtol+0x78>
		s += 2, base = 16;
  8013ba:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013be:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013c5:	eb 28                	jmp    8013ef <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cb:	75 15                	jne    8013e2 <strtol+0x93>
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 30                	cmp    $0x30,%al
  8013d4:	75 0c                	jne    8013e2 <strtol+0x93>
		s++, base = 8;
  8013d6:	ff 45 08             	incl   0x8(%ebp)
  8013d9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013e0:	eb 0d                	jmp    8013ef <strtol+0xa0>
	else if (base == 0)
  8013e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e6:	75 07                	jne    8013ef <strtol+0xa0>
		base = 10;
  8013e8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	3c 2f                	cmp    $0x2f,%al
  8013f6:	7e 19                	jle    801411 <strtol+0xc2>
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	3c 39                	cmp    $0x39,%al
  8013ff:	7f 10                	jg     801411 <strtol+0xc2>
			dig = *s - '0';
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	0f be c0             	movsbl %al,%eax
  801409:	83 e8 30             	sub    $0x30,%eax
  80140c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140f:	eb 42                	jmp    801453 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 60                	cmp    $0x60,%al
  801418:	7e 19                	jle    801433 <strtol+0xe4>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 7a                	cmp    $0x7a,%al
  801421:	7f 10                	jg     801433 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	0f be c0             	movsbl %al,%eax
  80142b:	83 e8 57             	sub    $0x57,%eax
  80142e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801431:	eb 20                	jmp    801453 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	3c 40                	cmp    $0x40,%al
  80143a:	7e 39                	jle    801475 <strtol+0x126>
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	3c 5a                	cmp    $0x5a,%al
  801443:	7f 30                	jg     801475 <strtol+0x126>
			dig = *s - 'A' + 10;
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f be c0             	movsbl %al,%eax
  80144d:	83 e8 37             	sub    $0x37,%eax
  801450:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801456:	3b 45 10             	cmp    0x10(%ebp),%eax
  801459:	7d 19                	jge    801474 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80145b:	ff 45 08             	incl   0x8(%ebp)
  80145e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801461:	0f af 45 10          	imul   0x10(%ebp),%eax
  801465:	89 c2                	mov    %eax,%edx
  801467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146a:	01 d0                	add    %edx,%eax
  80146c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80146f:	e9 7b ff ff ff       	jmp    8013ef <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801474:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801475:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801479:	74 08                	je     801483 <strtol+0x134>
		*endptr = (char *) s;
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8b 55 08             	mov    0x8(%ebp),%edx
  801481:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801483:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801487:	74 07                	je     801490 <strtol+0x141>
  801489:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148c:	f7 d8                	neg    %eax
  80148e:	eb 03                	jmp    801493 <strtol+0x144>
  801490:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <ltostr>:

void
ltostr(long value, char *str)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80149b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ad:	79 13                	jns    8014c2 <ltostr+0x2d>
	{
		neg = 1;
  8014af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014bc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014bf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014ca:	99                   	cltd   
  8014cb:	f7 f9                	idiv   %ecx
  8014cd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d3:	8d 50 01             	lea    0x1(%eax),%edx
  8014d6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d9:	89 c2                	mov    %eax,%edx
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	01 d0                	add    %edx,%eax
  8014e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014e3:	83 c2 30             	add    $0x30,%edx
  8014e6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014eb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014f0:	f7 e9                	imul   %ecx
  8014f2:	c1 fa 02             	sar    $0x2,%edx
  8014f5:	89 c8                	mov    %ecx,%eax
  8014f7:	c1 f8 1f             	sar    $0x1f,%eax
  8014fa:	29 c2                	sub    %eax,%edx
  8014fc:	89 d0                	mov    %edx,%eax
  8014fe:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801501:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801504:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801509:	f7 e9                	imul   %ecx
  80150b:	c1 fa 02             	sar    $0x2,%edx
  80150e:	89 c8                	mov    %ecx,%eax
  801510:	c1 f8 1f             	sar    $0x1f,%eax
  801513:	29 c2                	sub    %eax,%edx
  801515:	89 d0                	mov    %edx,%eax
  801517:	c1 e0 02             	shl    $0x2,%eax
  80151a:	01 d0                	add    %edx,%eax
  80151c:	01 c0                	add    %eax,%eax
  80151e:	29 c1                	sub    %eax,%ecx
  801520:	89 ca                	mov    %ecx,%edx
  801522:	85 d2                	test   %edx,%edx
  801524:	75 9c                	jne    8014c2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80152d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801530:	48                   	dec    %eax
  801531:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801534:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801538:	74 3d                	je     801577 <ltostr+0xe2>
		start = 1 ;
  80153a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801541:	eb 34                	jmp    801577 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	8b 45 0c             	mov    0xc(%ebp),%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801550:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	01 c2                	add    %eax,%edx
  801558:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80155b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155e:	01 c8                	add    %ecx,%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	01 c2                	add    %eax,%edx
  80156c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80156f:	88 02                	mov    %al,(%edx)
		start++ ;
  801571:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801574:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80157d:	7c c4                	jl     801543 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80157f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	01 d0                	add    %edx,%eax
  801587:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80158a:	90                   	nop
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	e8 54 fa ff ff       	call   800fef <strlen>
  80159b:	83 c4 04             	add    $0x4,%esp
  80159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015a1:	ff 75 0c             	pushl  0xc(%ebp)
  8015a4:	e8 46 fa ff ff       	call   800fef <strlen>
  8015a9:	83 c4 04             	add    $0x4,%esp
  8015ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015bd:	eb 17                	jmp    8015d6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	01 c2                	add    %eax,%edx
  8015c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	01 c8                	add    %ecx,%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015d3:	ff 45 fc             	incl   -0x4(%ebp)
  8015d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015dc:	7c e1                	jl     8015bf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015ec:	eb 1f                	jmp    80160d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f1:	8d 50 01             	lea    0x1(%eax),%edx
  8015f4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f7:	89 c2                	mov    %eax,%edx
  8015f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fc:	01 c2                	add    %eax,%edx
  8015fe:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	01 c8                	add    %ecx,%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80160a:	ff 45 f8             	incl   -0x8(%ebp)
  80160d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801610:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801613:	7c d9                	jl     8015ee <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801618:	8b 45 10             	mov    0x10(%ebp),%eax
  80161b:	01 d0                	add    %edx,%eax
  80161d:	c6 00 00             	movb   $0x0,(%eax)
}
  801620:	90                   	nop
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801626:	8b 45 14             	mov    0x14(%ebp),%eax
  801629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80162f:	8b 45 14             	mov    0x14(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	01 d0                	add    %edx,%eax
  801640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801646:	eb 0c                	jmp    801654 <strsplit+0x31>
			*string++ = 0;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8d 50 01             	lea    0x1(%eax),%edx
  80164e:	89 55 08             	mov    %edx,0x8(%ebp)
  801651:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	84 c0                	test   %al,%al
  80165b:	74 18                	je     801675 <strsplit+0x52>
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	50                   	push   %eax
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	e8 13 fb ff ff       	call   801181 <strchr>
  80166e:	83 c4 08             	add    $0x8,%esp
  801671:	85 c0                	test   %eax,%eax
  801673:	75 d3                	jne    801648 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	84 c0                	test   %al,%al
  80167c:	74 5a                	je     8016d8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80167e:	8b 45 14             	mov    0x14(%ebp),%eax
  801681:	8b 00                	mov    (%eax),%eax
  801683:	83 f8 0f             	cmp    $0xf,%eax
  801686:	75 07                	jne    80168f <strsplit+0x6c>
		{
			return 0;
  801688:	b8 00 00 00 00       	mov    $0x0,%eax
  80168d:	eb 66                	jmp    8016f5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80168f:	8b 45 14             	mov    0x14(%ebp),%eax
  801692:	8b 00                	mov    (%eax),%eax
  801694:	8d 48 01             	lea    0x1(%eax),%ecx
  801697:	8b 55 14             	mov    0x14(%ebp),%edx
  80169a:	89 0a                	mov    %ecx,(%edx)
  80169c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a6:	01 c2                	add    %eax,%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ad:	eb 03                	jmp    8016b2 <strsplit+0x8f>
			string++;
  8016af:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	84 c0                	test   %al,%al
  8016b9:	74 8b                	je     801646 <strsplit+0x23>
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	0f be c0             	movsbl %al,%eax
  8016c3:	50                   	push   %eax
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	e8 b5 fa ff ff       	call   801181 <strchr>
  8016cc:	83 c4 08             	add    $0x8,%esp
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	74 dc                	je     8016af <strsplit+0x8c>
			string++;
	}
  8016d3:	e9 6e ff ff ff       	jmp    801646 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dc:	8b 00                	mov    (%eax),%eax
  8016de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	68 d0 2a 80 00       	push   $0x802ad0
  801705:	6a 0e                	push   $0xe
  801707:	68 0a 2b 80 00       	push   $0x802b0a
  80170c:	e8 a8 ef ff ff       	call   8006b9 <_panic>

00801711 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801717:	a1 04 30 80 00       	mov    0x803004,%eax
  80171c:	85 c0                	test   %eax,%eax
  80171e:	74 0f                	je     80172f <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801720:	e8 d2 ff ff ff       	call   8016f7 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801725:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80172c:	00 00 00 
	}
	if (size == 0) return NULL ;
  80172f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801733:	75 07                	jne    80173c <malloc+0x2b>
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
  80173a:	eb 14                	jmp    801750 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	68 18 2b 80 00       	push   $0x802b18
  801744:	6a 2e                	push   $0x2e
  801746:	68 0a 2b 80 00       	push   $0x802b0a
  80174b:	e8 69 ef ff ff       	call   8006b9 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	68 40 2b 80 00       	push   $0x802b40
  801760:	6a 49                	push   $0x49
  801762:	68 0a 2b 80 00       	push   $0x802b0a
  801767:	e8 4d ef ff ff       	call   8006b9 <_panic>

0080176c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 18             	sub    $0x18,%esp
  801772:	8b 45 10             	mov    0x10(%ebp),%eax
  801775:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	68 64 2b 80 00       	push   $0x802b64
  801780:	6a 57                	push   $0x57
  801782:	68 0a 2b 80 00       	push   $0x802b0a
  801787:	e8 2d ef ff ff       	call   8006b9 <_panic>

0080178c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	68 8c 2b 80 00       	push   $0x802b8c
  80179a:	6a 60                	push   $0x60
  80179c:	68 0a 2b 80 00       	push   $0x802b0a
  8017a1:	e8 13 ef ff ff       	call   8006b9 <_panic>

008017a6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 b0 2b 80 00       	push   $0x802bb0
  8017b4:	6a 7c                	push   $0x7c
  8017b6:	68 0a 2b 80 00       	push   $0x802b0a
  8017bb:	e8 f9 ee ff ff       	call   8006b9 <_panic>

008017c0 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	68 d8 2b 80 00       	push   $0x802bd8
  8017ce:	68 86 00 00 00       	push   $0x86
  8017d3:	68 0a 2b 80 00       	push   $0x802b0a
  8017d8:	e8 dc ee ff ff       	call   8006b9 <_panic>

008017dd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	68 fc 2b 80 00       	push   $0x802bfc
  8017eb:	68 91 00 00 00       	push   $0x91
  8017f0:	68 0a 2b 80 00       	push   $0x802b0a
  8017f5:	e8 bf ee ff ff       	call   8006b9 <_panic>

008017fa <shrink>:

}
void shrink(uint32 newSize)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	68 fc 2b 80 00       	push   $0x802bfc
  801808:	68 96 00 00 00       	push   $0x96
  80180d:	68 0a 2b 80 00       	push   $0x802b0a
  801812:	e8 a2 ee ff ff       	call   8006b9 <_panic>

00801817 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	68 fc 2b 80 00       	push   $0x802bfc
  801825:	68 9b 00 00 00       	push   $0x9b
  80182a:	68 0a 2b 80 00       	push   $0x802b0a
  80182f:	e8 85 ee ff ff       	call   8006b9 <_panic>

00801834 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	57                   	push   %edi
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
  80183a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801846:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801849:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80184f:	cd 30                	int    $0x30
  801851:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801854:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5f                   	pop    %edi
  80185d:	5d                   	pop    %ebp
  80185e:	c3                   	ret    

0080185f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	8b 45 10             	mov    0x10(%ebp),%eax
  801868:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80186b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	52                   	push   %edx
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	50                   	push   %eax
  80187b:	6a 00                	push   $0x0
  80187d:	e8 b2 ff ff ff       	call   801834 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_cgetc>:

int
sys_cgetc(void)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 01                	push   $0x1
  801897:	e8 98 ff ff ff       	call   801834 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	52                   	push   %edx
  8018b1:	50                   	push   %eax
  8018b2:	6a 05                	push   $0x5
  8018b4:	e8 7b ff ff ff       	call   801834 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c3:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	56                   	push   %esi
  8018d3:	53                   	push   %ebx
  8018d4:	51                   	push   %ecx
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	6a 06                	push   $0x6
  8018d9:	e8 56 ff ff ff       	call   801834 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e4:	5b                   	pop    %ebx
  8018e5:	5e                   	pop    %esi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    

008018e8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 07                	push   $0x7
  8018fb:	e8 34 ff ff ff       	call   801834 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	6a 08                	push   $0x8
  801916:	e8 19 ff ff ff       	call   801834 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 09                	push   $0x9
  80192f:	e8 00 ff ff ff       	call   801834 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 0a                	push   $0xa
  801948:	e8 e7 fe ff ff       	call   801834 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0b                	push   $0xb
  801961:	e8 ce fe ff ff       	call   801834 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	6a 0f                	push   $0xf
  80197c:	e8 b3 fe ff ff       	call   801834 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
	return;
  801984:	90                   	nop
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	ff 75 0c             	pushl  0xc(%ebp)
  801993:	ff 75 08             	pushl  0x8(%ebp)
  801996:	6a 10                	push   $0x10
  801998:	e8 97 fe ff ff       	call   801834 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a0:	90                   	nop
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	ff 75 10             	pushl  0x10(%ebp)
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	6a 11                	push   $0x11
  8019b5:	e8 7a fe ff ff       	call   801834 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bd:	90                   	nop
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 0c                	push   $0xc
  8019cf:	e8 60 fe ff ff       	call   801834 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	6a 0d                	push   $0xd
  8019e9:	e8 46 fe ff ff       	call   801834 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 0e                	push   $0xe
  801a02:	e8 2d fe ff ff       	call   801834 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 13                	push   $0x13
  801a1c:	e8 13 fe ff ff       	call   801834 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	90                   	nop
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 14                	push   $0x14
  801a36:	e8 f9 fd ff ff       	call   801834 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 04             	sub    $0x4,%esp
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a4d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	50                   	push   %eax
  801a5a:	6a 15                	push   $0x15
  801a5c:	e8 d3 fd ff ff       	call   801834 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	90                   	nop
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 16                	push   $0x16
  801a76:	e8 b9 fd ff ff       	call   801834 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	50                   	push   %eax
  801a91:	6a 17                	push   $0x17
  801a93:	e8 9c fd ff ff       	call   801834 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 1a                	push   $0x1a
  801ab0:	e8 7f fd ff ff       	call   801834 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 18                	push   $0x18
  801acd:	e8 62 fd ff ff       	call   801834 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	90                   	nop
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 19                	push   $0x19
  801aeb:	e8 44 fd ff ff       	call   801834 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	90                   	nop
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	8b 45 10             	mov    0x10(%ebp),%eax
  801aff:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b02:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b05:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	51                   	push   %ecx
  801b0f:	52                   	push   %edx
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	50                   	push   %eax
  801b14:	6a 1b                	push   $0x1b
  801b16:	e8 19 fd ff ff       	call   801834 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 1c                	push   $0x1c
  801b33:	e8 fc fc ff ff       	call   801834 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	51                   	push   %ecx
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 1d                	push   $0x1d
  801b52:	e8 dd fc ff ff       	call   801834 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 1e                	push   $0x1e
  801b6f:	e8 c0 fc ff ff       	call   801834 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 1f                	push   $0x1f
  801b88:	e8 a7 fc ff ff       	call   801834 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	6a 00                	push   $0x0
  801b9a:	ff 75 14             	pushl  0x14(%ebp)
  801b9d:	ff 75 10             	pushl  0x10(%ebp)
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	50                   	push   %eax
  801ba4:	6a 20                	push   $0x20
  801ba6:	e8 89 fc ff ff       	call   801834 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	50                   	push   %eax
  801bbf:	6a 21                	push   $0x21
  801bc1:	e8 6e fc ff ff       	call   801834 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	90                   	nop
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	50                   	push   %eax
  801bdb:	6a 22                	push   $0x22
  801bdd:	e8 52 fc ff ff       	call   801834 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 02                	push   $0x2
  801bf6:	e8 39 fc ff ff       	call   801834 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 03                	push   $0x3
  801c0f:	e8 20 fc ff ff       	call   801834 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 04                	push   $0x4
  801c28:	e8 07 fc ff ff       	call   801834 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_exit_env>:


void sys_exit_env(void)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 23                	push   $0x23
  801c41:	e8 ee fb ff ff       	call   801834 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	90                   	nop
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c55:	8d 50 04             	lea    0x4(%eax),%edx
  801c58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	52                   	push   %edx
  801c62:	50                   	push   %eax
  801c63:	6a 24                	push   $0x24
  801c65:	e8 ca fb ff ff       	call   801834 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c76:	89 01                	mov    %eax,(%ecx)
  801c78:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	c9                   	leave  
  801c7f:	c2 04 00             	ret    $0x4

00801c82 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	ff 75 10             	pushl  0x10(%ebp)
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	ff 75 08             	pushl  0x8(%ebp)
  801c92:	6a 12                	push   $0x12
  801c94:	e8 9b fb ff ff       	call   801834 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9c:	90                   	nop
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 25                	push   $0x25
  801cae:	e8 81 fb ff ff       	call   801834 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	50                   	push   %eax
  801cd1:	6a 26                	push   $0x26
  801cd3:	e8 5c fb ff ff       	call   801834 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <rsttst>:
void rsttst()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 28                	push   $0x28
  801ced:	e8 42 fb ff ff       	call   801834 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf5:	90                   	nop
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d04:	8b 55 18             	mov    0x18(%ebp),%edx
  801d07:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	ff 75 10             	pushl  0x10(%ebp)
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	6a 27                	push   $0x27
  801d18:	e8 17 fb ff ff       	call   801834 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <chktst>:
void chktst(uint32 n)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 29                	push   $0x29
  801d33:	e8 fc fa ff ff       	call   801834 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <inctst>:

void inctst()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 2a                	push   $0x2a
  801d4d:	e8 e2 fa ff ff       	call   801834 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return ;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <gettst>:
uint32 gettst()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 2b                	push   $0x2b
  801d67:	e8 c8 fa ff ff       	call   801834 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 2c                	push   $0x2c
  801d83:	e8 ac fa ff ff       	call   801834 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
  801d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d8e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d92:	75 07                	jne    801d9b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d94:	b8 01 00 00 00       	mov    $0x1,%eax
  801d99:	eb 05                	jmp    801da0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 2c                	push   $0x2c
  801db4:	e8 7b fa ff ff       	call   801834 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
  801dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dbf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc3:	75 07                	jne    801dcc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dca:	eb 05                	jmp    801dd1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 2c                	push   $0x2c
  801de5:	e8 4a fa ff ff       	call   801834 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
  801ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df4:	75 07                	jne    801dfd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfb:	eb 05                	jmp    801e02 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 2c                	push   $0x2c
  801e16:	e8 19 fa ff ff       	call   801834 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
  801e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e21:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e25:	75 07                	jne    801e2e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e27:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2c:	eb 05                	jmp    801e33 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	6a 2d                	push   $0x2d
  801e45:	e8 ea f9 ff ff       	call   801834 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4d:	90                   	nop
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e54:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	53                   	push   %ebx
  801e63:	51                   	push   %ecx
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	6a 2e                	push   $0x2e
  801e68:	e8 c7 f9 ff ff       	call   801834 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	52                   	push   %edx
  801e85:	50                   	push   %eax
  801e86:	6a 2f                	push   $0x2f
  801e88:	e8 a7 f9 ff ff       	call   801834 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    
  801e92:	66 90                	xchg   %ax,%ax

00801e94 <__udivdi3>:
  801e94:	55                   	push   %ebp
  801e95:	57                   	push   %edi
  801e96:	56                   	push   %esi
  801e97:	53                   	push   %ebx
  801e98:	83 ec 1c             	sub    $0x1c,%esp
  801e9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ea3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ea7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801eab:	89 ca                	mov    %ecx,%edx
  801ead:	89 f8                	mov    %edi,%eax
  801eaf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801eb3:	85 f6                	test   %esi,%esi
  801eb5:	75 2d                	jne    801ee4 <__udivdi3+0x50>
  801eb7:	39 cf                	cmp    %ecx,%edi
  801eb9:	77 65                	ja     801f20 <__udivdi3+0x8c>
  801ebb:	89 fd                	mov    %edi,%ebp
  801ebd:	85 ff                	test   %edi,%edi
  801ebf:	75 0b                	jne    801ecc <__udivdi3+0x38>
  801ec1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec6:	31 d2                	xor    %edx,%edx
  801ec8:	f7 f7                	div    %edi
  801eca:	89 c5                	mov    %eax,%ebp
  801ecc:	31 d2                	xor    %edx,%edx
  801ece:	89 c8                	mov    %ecx,%eax
  801ed0:	f7 f5                	div    %ebp
  801ed2:	89 c1                	mov    %eax,%ecx
  801ed4:	89 d8                	mov    %ebx,%eax
  801ed6:	f7 f5                	div    %ebp
  801ed8:	89 cf                	mov    %ecx,%edi
  801eda:	89 fa                	mov    %edi,%edx
  801edc:	83 c4 1c             	add    $0x1c,%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    
  801ee4:	39 ce                	cmp    %ecx,%esi
  801ee6:	77 28                	ja     801f10 <__udivdi3+0x7c>
  801ee8:	0f bd fe             	bsr    %esi,%edi
  801eeb:	83 f7 1f             	xor    $0x1f,%edi
  801eee:	75 40                	jne    801f30 <__udivdi3+0x9c>
  801ef0:	39 ce                	cmp    %ecx,%esi
  801ef2:	72 0a                	jb     801efe <__udivdi3+0x6a>
  801ef4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ef8:	0f 87 9e 00 00 00    	ja     801f9c <__udivdi3+0x108>
  801efe:	b8 01 00 00 00       	mov    $0x1,%eax
  801f03:	89 fa                	mov    %edi,%edx
  801f05:	83 c4 1c             	add    $0x1c,%esp
  801f08:	5b                   	pop    %ebx
  801f09:	5e                   	pop    %esi
  801f0a:	5f                   	pop    %edi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    
  801f0d:	8d 76 00             	lea    0x0(%esi),%esi
  801f10:	31 ff                	xor    %edi,%edi
  801f12:	31 c0                	xor    %eax,%eax
  801f14:	89 fa                	mov    %edi,%edx
  801f16:	83 c4 1c             	add    $0x1c,%esp
  801f19:	5b                   	pop    %ebx
  801f1a:	5e                   	pop    %esi
  801f1b:	5f                   	pop    %edi
  801f1c:	5d                   	pop    %ebp
  801f1d:	c3                   	ret    
  801f1e:	66 90                	xchg   %ax,%ax
  801f20:	89 d8                	mov    %ebx,%eax
  801f22:	f7 f7                	div    %edi
  801f24:	31 ff                	xor    %edi,%edi
  801f26:	89 fa                	mov    %edi,%edx
  801f28:	83 c4 1c             	add    $0x1c,%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5f                   	pop    %edi
  801f2e:	5d                   	pop    %ebp
  801f2f:	c3                   	ret    
  801f30:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f35:	89 eb                	mov    %ebp,%ebx
  801f37:	29 fb                	sub    %edi,%ebx
  801f39:	89 f9                	mov    %edi,%ecx
  801f3b:	d3 e6                	shl    %cl,%esi
  801f3d:	89 c5                	mov    %eax,%ebp
  801f3f:	88 d9                	mov    %bl,%cl
  801f41:	d3 ed                	shr    %cl,%ebp
  801f43:	89 e9                	mov    %ebp,%ecx
  801f45:	09 f1                	or     %esi,%ecx
  801f47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f4b:	89 f9                	mov    %edi,%ecx
  801f4d:	d3 e0                	shl    %cl,%eax
  801f4f:	89 c5                	mov    %eax,%ebp
  801f51:	89 d6                	mov    %edx,%esi
  801f53:	88 d9                	mov    %bl,%cl
  801f55:	d3 ee                	shr    %cl,%esi
  801f57:	89 f9                	mov    %edi,%ecx
  801f59:	d3 e2                	shl    %cl,%edx
  801f5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f5f:	88 d9                	mov    %bl,%cl
  801f61:	d3 e8                	shr    %cl,%eax
  801f63:	09 c2                	or     %eax,%edx
  801f65:	89 d0                	mov    %edx,%eax
  801f67:	89 f2                	mov    %esi,%edx
  801f69:	f7 74 24 0c          	divl   0xc(%esp)
  801f6d:	89 d6                	mov    %edx,%esi
  801f6f:	89 c3                	mov    %eax,%ebx
  801f71:	f7 e5                	mul    %ebp
  801f73:	39 d6                	cmp    %edx,%esi
  801f75:	72 19                	jb     801f90 <__udivdi3+0xfc>
  801f77:	74 0b                	je     801f84 <__udivdi3+0xf0>
  801f79:	89 d8                	mov    %ebx,%eax
  801f7b:	31 ff                	xor    %edi,%edi
  801f7d:	e9 58 ff ff ff       	jmp    801eda <__udivdi3+0x46>
  801f82:	66 90                	xchg   %ax,%ax
  801f84:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f88:	89 f9                	mov    %edi,%ecx
  801f8a:	d3 e2                	shl    %cl,%edx
  801f8c:	39 c2                	cmp    %eax,%edx
  801f8e:	73 e9                	jae    801f79 <__udivdi3+0xe5>
  801f90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f93:	31 ff                	xor    %edi,%edi
  801f95:	e9 40 ff ff ff       	jmp    801eda <__udivdi3+0x46>
  801f9a:	66 90                	xchg   %ax,%ax
  801f9c:	31 c0                	xor    %eax,%eax
  801f9e:	e9 37 ff ff ff       	jmp    801eda <__udivdi3+0x46>
  801fa3:	90                   	nop

00801fa4 <__umoddi3>:
  801fa4:	55                   	push   %ebp
  801fa5:	57                   	push   %edi
  801fa6:	56                   	push   %esi
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 1c             	sub    $0x1c,%esp
  801fab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801faf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fb7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fc3:	89 f3                	mov    %esi,%ebx
  801fc5:	89 fa                	mov    %edi,%edx
  801fc7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fcb:	89 34 24             	mov    %esi,(%esp)
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	75 1a                	jne    801fec <__umoddi3+0x48>
  801fd2:	39 f7                	cmp    %esi,%edi
  801fd4:	0f 86 a2 00 00 00    	jbe    80207c <__umoddi3+0xd8>
  801fda:	89 c8                	mov    %ecx,%eax
  801fdc:	89 f2                	mov    %esi,%edx
  801fde:	f7 f7                	div    %edi
  801fe0:	89 d0                	mov    %edx,%eax
  801fe2:	31 d2                	xor    %edx,%edx
  801fe4:	83 c4 1c             	add    $0x1c,%esp
  801fe7:	5b                   	pop    %ebx
  801fe8:	5e                   	pop    %esi
  801fe9:	5f                   	pop    %edi
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    
  801fec:	39 f0                	cmp    %esi,%eax
  801fee:	0f 87 ac 00 00 00    	ja     8020a0 <__umoddi3+0xfc>
  801ff4:	0f bd e8             	bsr    %eax,%ebp
  801ff7:	83 f5 1f             	xor    $0x1f,%ebp
  801ffa:	0f 84 ac 00 00 00    	je     8020ac <__umoddi3+0x108>
  802000:	bf 20 00 00 00       	mov    $0x20,%edi
  802005:	29 ef                	sub    %ebp,%edi
  802007:	89 fe                	mov    %edi,%esi
  802009:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80200d:	89 e9                	mov    %ebp,%ecx
  80200f:	d3 e0                	shl    %cl,%eax
  802011:	89 d7                	mov    %edx,%edi
  802013:	89 f1                	mov    %esi,%ecx
  802015:	d3 ef                	shr    %cl,%edi
  802017:	09 c7                	or     %eax,%edi
  802019:	89 e9                	mov    %ebp,%ecx
  80201b:	d3 e2                	shl    %cl,%edx
  80201d:	89 14 24             	mov    %edx,(%esp)
  802020:	89 d8                	mov    %ebx,%eax
  802022:	d3 e0                	shl    %cl,%eax
  802024:	89 c2                	mov    %eax,%edx
  802026:	8b 44 24 08          	mov    0x8(%esp),%eax
  80202a:	d3 e0                	shl    %cl,%eax
  80202c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802030:	8b 44 24 08          	mov    0x8(%esp),%eax
  802034:	89 f1                	mov    %esi,%ecx
  802036:	d3 e8                	shr    %cl,%eax
  802038:	09 d0                	or     %edx,%eax
  80203a:	d3 eb                	shr    %cl,%ebx
  80203c:	89 da                	mov    %ebx,%edx
  80203e:	f7 f7                	div    %edi
  802040:	89 d3                	mov    %edx,%ebx
  802042:	f7 24 24             	mull   (%esp)
  802045:	89 c6                	mov    %eax,%esi
  802047:	89 d1                	mov    %edx,%ecx
  802049:	39 d3                	cmp    %edx,%ebx
  80204b:	0f 82 87 00 00 00    	jb     8020d8 <__umoddi3+0x134>
  802051:	0f 84 91 00 00 00    	je     8020e8 <__umoddi3+0x144>
  802057:	8b 54 24 04          	mov    0x4(%esp),%edx
  80205b:	29 f2                	sub    %esi,%edx
  80205d:	19 cb                	sbb    %ecx,%ebx
  80205f:	89 d8                	mov    %ebx,%eax
  802061:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802065:	d3 e0                	shl    %cl,%eax
  802067:	89 e9                	mov    %ebp,%ecx
  802069:	d3 ea                	shr    %cl,%edx
  80206b:	09 d0                	or     %edx,%eax
  80206d:	89 e9                	mov    %ebp,%ecx
  80206f:	d3 eb                	shr    %cl,%ebx
  802071:	89 da                	mov    %ebx,%edx
  802073:	83 c4 1c             	add    $0x1c,%esp
  802076:	5b                   	pop    %ebx
  802077:	5e                   	pop    %esi
  802078:	5f                   	pop    %edi
  802079:	5d                   	pop    %ebp
  80207a:	c3                   	ret    
  80207b:	90                   	nop
  80207c:	89 fd                	mov    %edi,%ebp
  80207e:	85 ff                	test   %edi,%edi
  802080:	75 0b                	jne    80208d <__umoddi3+0xe9>
  802082:	b8 01 00 00 00       	mov    $0x1,%eax
  802087:	31 d2                	xor    %edx,%edx
  802089:	f7 f7                	div    %edi
  80208b:	89 c5                	mov    %eax,%ebp
  80208d:	89 f0                	mov    %esi,%eax
  80208f:	31 d2                	xor    %edx,%edx
  802091:	f7 f5                	div    %ebp
  802093:	89 c8                	mov    %ecx,%eax
  802095:	f7 f5                	div    %ebp
  802097:	89 d0                	mov    %edx,%eax
  802099:	e9 44 ff ff ff       	jmp    801fe2 <__umoddi3+0x3e>
  80209e:	66 90                	xchg   %ax,%ax
  8020a0:	89 c8                	mov    %ecx,%eax
  8020a2:	89 f2                	mov    %esi,%edx
  8020a4:	83 c4 1c             	add    $0x1c,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
  8020ac:	3b 04 24             	cmp    (%esp),%eax
  8020af:	72 06                	jb     8020b7 <__umoddi3+0x113>
  8020b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020b5:	77 0f                	ja     8020c6 <__umoddi3+0x122>
  8020b7:	89 f2                	mov    %esi,%edx
  8020b9:	29 f9                	sub    %edi,%ecx
  8020bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020bf:	89 14 24             	mov    %edx,(%esp)
  8020c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020ca:	8b 14 24             	mov    (%esp),%edx
  8020cd:	83 c4 1c             	add    $0x1c,%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5e                   	pop    %esi
  8020d2:	5f                   	pop    %edi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    
  8020d5:	8d 76 00             	lea    0x0(%esi),%esi
  8020d8:	2b 04 24             	sub    (%esp),%eax
  8020db:	19 fa                	sbb    %edi,%edx
  8020dd:	89 d1                	mov    %edx,%ecx
  8020df:	89 c6                	mov    %eax,%esi
  8020e1:	e9 71 ff ff ff       	jmp    802057 <__umoddi3+0xb3>
  8020e6:	66 90                	xchg   %ax,%ax
  8020e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020ec:	72 ea                	jb     8020d8 <__umoddi3+0x134>
  8020ee:	89 d9                	mov    %ebx,%ecx
  8020f0:	e9 62 ff ff ff       	jmp    802057 <__umoddi3+0xb3>
