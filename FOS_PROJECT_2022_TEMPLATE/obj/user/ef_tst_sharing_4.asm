
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
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
  80008d:	68 20 21 80 00       	push   $0x802120
  800092:	6a 12                	push   $0x12
  800094:	68 3c 21 80 00       	push   $0x80213c
  800099:	e8 44 06 00 00       	call   8006e2 <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 54 21 80 00       	push   $0x802154
  8000a6:	e8 eb 08 00 00       	call   800996 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 88 21 80 00       	push   $0x802188
  8000b6:	e8 db 08 00 00       	call   800996 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 e4 21 80 00       	push   $0x8021e4
  8000c6:	e8 cb 08 00 00       	call   800996 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 2f 1b 00 00       	call   801c10 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 18 22 80 00       	push   $0x802218
  8000ec:	e8 a5 08 00 00       	call   800996 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 50 18 00 00       	call   801949 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 47 22 80 00       	push   $0x802247
  80010b:	e8 85 16 00 00       	call   801795 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 4c 22 80 00       	push   $0x80224c
  800127:	6a 21                	push   $0x21
  800129:	68 3c 21 80 00       	push   $0x80213c
  80012e:	e8 af 05 00 00       	call   8006e2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 0e 18 00 00       	call   801949 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 b8 22 80 00       	push   $0x8022b8
  80014c:	6a 22                	push   $0x22
  80014e:	68 3c 21 80 00       	push   $0x80213c
  800153:	e8 8a 05 00 00       	call   8006e2 <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 86 16 00 00       	call   8017e9 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 db 17 00 00       	call   801949 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 38 23 80 00       	push   $0x802338
  80017f:	6a 25                	push   $0x25
  800181:	68 3c 21 80 00       	push   $0x80213c
  800186:	e8 57 05 00 00       	call   8006e2 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 b9 17 00 00       	call   801949 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 90 23 80 00       	push   $0x802390
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 3c 21 80 00       	push   $0x80213c
  8001a8:	e8 35 05 00 00       	call   8006e2 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 c0 23 80 00       	push   $0x8023c0
  8001b5:	e8 dc 07 00 00       	call   800996 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 e4 23 80 00       	push   $0x8023e4
  8001c5:	e8 cc 07 00 00       	call   800996 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 77 17 00 00       	call   801949 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 14 24 80 00       	push   $0x802414
  8001e4:	e8 ac 15 00 00       	call   801795 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 47 22 80 00       	push   $0x802247
  8001fe:	e8 92 15 00 00       	call   801795 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 38 23 80 00       	push   $0x802338
  800217:	6a 32                	push   $0x32
  800219:	68 3c 21 80 00       	push   $0x80213c
  80021e:	e8 bf 04 00 00       	call   8006e2 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 1e 17 00 00       	call   801949 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 18 24 80 00       	push   $0x802418
  80023c:	6a 34                	push   $0x34
  80023e:	68 3c 21 80 00       	push   $0x80213c
  800243:	e8 9a 04 00 00       	call   8006e2 <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 96 15 00 00       	call   8017e9 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 eb 16 00 00       	call   801949 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 6d 24 80 00       	push   $0x80246d
  80026f:	6a 37                	push   $0x37
  800271:	68 3c 21 80 00       	push   $0x80213c
  800276:	e8 67 04 00 00       	call   8006e2 <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 63 15 00 00       	call   8017e9 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 bb 16 00 00       	call   801949 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 6d 24 80 00       	push   $0x80246d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 3c 21 80 00       	push   $0x80213c
  8002a6:	e8 37 04 00 00       	call   8006e2 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 8c 24 80 00       	push   $0x80248c
  8002b3:	e8 de 06 00 00       	call   800996 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 b0 24 80 00       	push   $0x8024b0
  8002c3:	e8 ce 06 00 00       	call   800996 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 79 16 00 00       	call   801949 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 e0 24 80 00       	push   $0x8024e0
  8002e2:	e8 ae 14 00 00       	call   801795 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 e2 24 80 00       	push   $0x8024e2
  8002fc:	e8 94 14 00 00       	call   801795 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 3a 16 00 00       	call   801949 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 b8 22 80 00       	push   $0x8022b8
  800320:	6a 46                	push   $0x46
  800322:	68 3c 21 80 00       	push   $0x80213c
  800327:	e8 b6 03 00 00       	call   8006e2 <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 b2 14 00 00       	call   8017e9 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 07 16 00 00       	call   801949 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 6d 24 80 00       	push   $0x80246d
  800353:	6a 49                	push   $0x49
  800355:	68 3c 21 80 00       	push   $0x80213c
  80035a:	e8 83 03 00 00       	call   8006e2 <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 e4 24 80 00       	push   $0x8024e4
  80036e:	e8 22 14 00 00       	call   801795 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 c8 15 00 00       	call   801949 <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 b8 22 80 00       	push   $0x8022b8
  800392:	6a 4e                	push   $0x4e
  800394:	68 3c 21 80 00       	push   $0x80213c
  800399:	e8 44 03 00 00       	call   8006e2 <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 40 14 00 00       	call   8017e9 <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 95 15 00 00       	call   801949 <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 6d 24 80 00       	push   $0x80246d
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 3c 21 80 00       	push   $0x80213c
  8003cc:	e8 11 03 00 00       	call   8006e2 <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 0d 14 00 00       	call   8017e9 <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 65 15 00 00       	call   801949 <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 6d 24 80 00       	push   $0x80246d
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 3c 21 80 00       	push   $0x80213c
  8003fc:	e8 e1 02 00 00       	call   8006e2 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 43 15 00 00       	call   801949 <sys_calculate_free_frames>
  800406:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	01 d2                	add    %edx,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	6a 01                	push   $0x1
  80041a:	50                   	push   %eax
  80041b:	68 e0 24 80 00       	push   $0x8024e0
  800420:	e8 70 13 00 00       	call   801795 <smalloc>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	6a 01                	push   $0x1
  800440:	50                   	push   %eax
  800441:	68 e2 24 80 00       	push   $0x8024e2
  800446:	e8 4a 13 00 00       	call   801795 <smalloc>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800454:	01 c0                	add    %eax,%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	6a 01                	push   $0x1
  800462:	50                   	push   %eax
  800463:	68 e4 24 80 00       	push   $0x8024e4
  800468:	e8 28 13 00 00       	call   801795 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 ce 14 00 00       	call   801949 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 b8 22 80 00       	push   $0x8022b8
  80048e:	6a 5d                	push   $0x5d
  800490:	68 3c 21 80 00       	push   $0x80213c
  800495:	e8 48 02 00 00       	call   8006e2 <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 44 13 00 00       	call   8017e9 <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 99 14 00 00       	call   801949 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 6d 24 80 00       	push   $0x80246d
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 3c 21 80 00       	push   $0x80213c
  8004ca:	e8 13 02 00 00       	call   8006e2 <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 0f 13 00 00       	call   8017e9 <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 64 14 00 00       	call   801949 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 6d 24 80 00       	push   $0x80246d
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 3c 21 80 00       	push   $0x80213c
  8004ff:	e8 de 01 00 00       	call   8006e2 <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 da 12 00 00       	call   8017e9 <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 32 14 00 00       	call   801949 <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 6d 24 80 00       	push   $0x80246d
  800528:	6a 66                	push   $0x66
  80052a:	68 3c 21 80 00       	push   $0x80213c
  80052f:	e8 ae 01 00 00       	call   8006e2 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 e8 24 80 00       	push   $0x8024e8
  80053c:	e8 55 04 00 00       	call   800996 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 0c 25 80 00       	push   $0x80250c
  80054c:	e8 45 04 00 00       	call   800996 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 e9 16 00 00       	call   801c42 <sys_getparentenvid>
  800559:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  80055c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  800560:	7e 2b                	jle    80058d <_main+0x555>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800562:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	68 58 25 80 00       	push   $0x802558
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 3c 12 00 00       	call   8017b5 <sget>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  80057f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
	}
	return;
  80058c:	90                   	nop
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800599:	e8 8b 16 00 00       	call   801c29 <sys_getenvindex>
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005b1:	01 c8                	add    %ecx,%eax
  8005b3:	c1 e0 02             	shl    $0x2,%eax
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8005bf:	01 c8                	add    %ecx,%eax
  8005c1:	c1 e0 02             	shl    $0x2,%eax
  8005c4:	01 d0                	add    %edx,%eax
  8005c6:	c1 e0 02             	shl    $0x2,%eax
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	c1 e0 03             	shl    $0x3,%eax
  8005ce:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005dd:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  8005e3:	84 c0                	test   %al,%al
  8005e5:	74 0f                	je     8005f6 <libmain+0x63>
		binaryname = myEnv->prog_name;
  8005e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ec:	05 18 da 01 00       	add    $0x1da18,%eax
  8005f1:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005fa:	7e 0a                	jle    800606 <libmain+0x73>
		binaryname = argv[0];
  8005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	ff 75 0c             	pushl  0xc(%ebp)
  80060c:	ff 75 08             	pushl  0x8(%ebp)
  80060f:	e8 24 fa ff ff       	call   800038 <_main>
  800614:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800617:	e8 1a 14 00 00       	call   801a36 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061c:	83 ec 0c             	sub    $0xc,%esp
  80061f:	68 80 25 80 00       	push   $0x802580
  800624:	e8 6d 03 00 00       	call   800996 <cprintf>
  800629:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80062c:	a1 20 30 80 00       	mov    0x803020,%eax
  800631:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  800637:	a1 20 30 80 00       	mov    0x803020,%eax
  80063c:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	52                   	push   %edx
  800646:	50                   	push   %eax
  800647:	68 a8 25 80 00       	push   $0x8025a8
  80064c:	e8 45 03 00 00       	call   800996 <cprintf>
  800651:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800654:	a1 20 30 80 00       	mov    0x803020,%eax
  800659:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  80065f:	a1 20 30 80 00       	mov    0x803020,%eax
  800664:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80066a:	a1 20 30 80 00       	mov    0x803020,%eax
  80066f:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  800675:	51                   	push   %ecx
  800676:	52                   	push   %edx
  800677:	50                   	push   %eax
  800678:	68 d0 25 80 00       	push   $0x8025d0
  80067d:	e8 14 03 00 00       	call   800996 <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800685:	a1 20 30 80 00       	mov    0x803020,%eax
  80068a:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	50                   	push   %eax
  800694:	68 28 26 80 00       	push   $0x802628
  800699:	e8 f8 02 00 00       	call   800996 <cprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a1:	83 ec 0c             	sub    $0xc,%esp
  8006a4:	68 80 25 80 00       	push   $0x802580
  8006a9:	e8 e8 02 00 00       	call   800996 <cprintf>
  8006ae:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b1:	e8 9a 13 00 00       	call   801a50 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b6:	e8 19 00 00 00       	call   8006d4 <exit>
}
  8006bb:	90                   	nop
  8006bc:	c9                   	leave  
  8006bd:	c3                   	ret    

008006be <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c4:	83 ec 0c             	sub    $0xc,%esp
  8006c7:	6a 00                	push   $0x0
  8006c9:	e8 27 15 00 00       	call   801bf5 <sys_destroy_env>
  8006ce:	83 c4 10             	add    $0x10,%esp
}
  8006d1:	90                   	nop
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <exit>:

void
exit(void)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006da:	e8 7c 15 00 00       	call   801c5b <sys_exit_env>
}
  8006df:	90                   	nop
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e8:	8d 45 10             	lea    0x10(%ebp),%eax
  8006eb:	83 c0 04             	add    $0x4,%eax
  8006ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006f1:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8006f6:	85 c0                	test   %eax,%eax
  8006f8:	74 16                	je     800710 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006fa:	a1 58 a2 82 00       	mov    0x82a258,%eax
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	50                   	push   %eax
  800703:	68 3c 26 80 00       	push   $0x80263c
  800708:	e8 89 02 00 00       	call   800996 <cprintf>
  80070d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800710:	a1 00 30 80 00       	mov    0x803000,%eax
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 08             	pushl  0x8(%ebp)
  80071b:	50                   	push   %eax
  80071c:	68 41 26 80 00       	push   $0x802641
  800721:	e8 70 02 00 00       	call   800996 <cprintf>
  800726:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800729:	8b 45 10             	mov    0x10(%ebp),%eax
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	ff 75 f4             	pushl  -0xc(%ebp)
  800732:	50                   	push   %eax
  800733:	e8 f3 01 00 00       	call   80092b <vcprintf>
  800738:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	6a 00                	push   $0x0
  800740:	68 5d 26 80 00       	push   $0x80265d
  800745:	e8 e1 01 00 00       	call   80092b <vcprintf>
  80074a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074d:	e8 82 ff ff ff       	call   8006d4 <exit>

	// should not return here
	while (1) ;
  800752:	eb fe                	jmp    800752 <_panic+0x70>

00800754 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80075a:	a1 20 30 80 00       	mov    0x803020,%eax
  80075f:	8b 50 74             	mov    0x74(%eax),%edx
  800762:	8b 45 0c             	mov    0xc(%ebp),%eax
  800765:	39 c2                	cmp    %eax,%edx
  800767:	74 14                	je     80077d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800769:	83 ec 04             	sub    $0x4,%esp
  80076c:	68 60 26 80 00       	push   $0x802660
  800771:	6a 26                	push   $0x26
  800773:	68 ac 26 80 00       	push   $0x8026ac
  800778:	e8 65 ff ff ff       	call   8006e2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800784:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80078b:	e9 c2 00 00 00       	jmp    800852 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	01 d0                	add    %edx,%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	85 c0                	test   %eax,%eax
  8007a3:	75 08                	jne    8007ad <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a8:	e9 a2 00 00 00       	jmp    80084f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007bb:	eb 69                	jmp    800826 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8007c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007cb:	89 d0                	mov    %edx,%eax
  8007cd:	01 c0                	add    %eax,%eax
  8007cf:	01 d0                	add    %edx,%eax
  8007d1:	c1 e0 03             	shl    $0x3,%eax
  8007d4:	01 c8                	add    %ecx,%eax
  8007d6:	8a 40 04             	mov    0x4(%eax),%al
  8007d9:	84 c0                	test   %al,%al
  8007db:	75 46                	jne    800823 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e2:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8007e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007eb:	89 d0                	mov    %edx,%eax
  8007ed:	01 c0                	add    %eax,%eax
  8007ef:	01 d0                	add    %edx,%eax
  8007f1:	c1 e0 03             	shl    $0x3,%eax
  8007f4:	01 c8                	add    %ecx,%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800803:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800808:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	01 c8                	add    %ecx,%eax
  800814:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800816:	39 c2                	cmp    %eax,%edx
  800818:	75 09                	jne    800823 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80081a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800821:	eb 12                	jmp    800835 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800823:	ff 45 e8             	incl   -0x18(%ebp)
  800826:	a1 20 30 80 00       	mov    0x803020,%eax
  80082b:	8b 50 74             	mov    0x74(%eax),%edx
  80082e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800831:	39 c2                	cmp    %eax,%edx
  800833:	77 88                	ja     8007bd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800835:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800839:	75 14                	jne    80084f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80083b:	83 ec 04             	sub    $0x4,%esp
  80083e:	68 b8 26 80 00       	push   $0x8026b8
  800843:	6a 3a                	push   $0x3a
  800845:	68 ac 26 80 00       	push   $0x8026ac
  80084a:	e8 93 fe ff ff       	call   8006e2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084f:	ff 45 f0             	incl   -0x10(%ebp)
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800858:	0f 8c 32 ff ff ff    	jl     800790 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800865:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80086c:	eb 26                	jmp    800894 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086e:	a1 20 30 80 00       	mov    0x803020,%eax
  800873:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  800879:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087c:	89 d0                	mov    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	c1 e0 03             	shl    $0x3,%eax
  800885:	01 c8                	add    %ecx,%eax
  800887:	8a 40 04             	mov    0x4(%eax),%al
  80088a:	3c 01                	cmp    $0x1,%al
  80088c:	75 03                	jne    800891 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800891:	ff 45 e0             	incl   -0x20(%ebp)
  800894:	a1 20 30 80 00       	mov    0x803020,%eax
  800899:	8b 50 74             	mov    0x74(%eax),%edx
  80089c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089f:	39 c2                	cmp    %eax,%edx
  8008a1:	77 cb                	ja     80086e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a9:	74 14                	je     8008bf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008ab:	83 ec 04             	sub    $0x4,%esp
  8008ae:	68 0c 27 80 00       	push   $0x80270c
  8008b3:	6a 44                	push   $0x44
  8008b5:	68 ac 26 80 00       	push   $0x8026ac
  8008ba:	e8 23 fe ff ff       	call   8006e2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008bf:	90                   	nop
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d3:	89 0a                	mov    %ecx,(%edx)
  8008d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d8:	88 d1                	mov    %dl,%cl
  8008da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008eb:	75 2c                	jne    800919 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ed:	a0 24 30 80 00       	mov    0x803024,%al
  8008f2:	0f b6 c0             	movzbl %al,%eax
  8008f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f8:	8b 12                	mov    (%edx),%edx
  8008fa:	89 d1                	mov    %edx,%ecx
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ff:	83 c2 08             	add    $0x8,%edx
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	50                   	push   %eax
  800906:	51                   	push   %ecx
  800907:	52                   	push   %edx
  800908:	e8 7b 0f 00 00       	call   801888 <sys_cputs>
  80090d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800910:	8b 45 0c             	mov    0xc(%ebp),%eax
  800913:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091c:	8b 40 04             	mov    0x4(%eax),%eax
  80091f:	8d 50 01             	lea    0x1(%eax),%edx
  800922:	8b 45 0c             	mov    0xc(%ebp),%eax
  800925:	89 50 04             	mov    %edx,0x4(%eax)
}
  800928:	90                   	nop
  800929:	c9                   	leave  
  80092a:	c3                   	ret    

0080092b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800934:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093b:	00 00 00 
	b.cnt = 0;
  80093e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800945:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	ff 75 08             	pushl  0x8(%ebp)
  80094e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800954:	50                   	push   %eax
  800955:	68 c2 08 80 00       	push   $0x8008c2
  80095a:	e8 11 02 00 00       	call   800b70 <vprintfmt>
  80095f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800962:	a0 24 30 80 00       	mov    0x803024,%al
  800967:	0f b6 c0             	movzbl %al,%eax
  80096a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800970:	83 ec 04             	sub    $0x4,%esp
  800973:	50                   	push   %eax
  800974:	52                   	push   %edx
  800975:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097b:	83 c0 08             	add    $0x8,%eax
  80097e:	50                   	push   %eax
  80097f:	e8 04 0f 00 00       	call   801888 <sys_cputs>
  800984:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800987:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80098e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800994:	c9                   	leave  
  800995:	c3                   	ret    

00800996 <cprintf>:

int cprintf(const char *fmt, ...) {
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099c:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b2:	50                   	push   %eax
  8009b3:	e8 73 ff ff ff       	call   80092b <vcprintf>
  8009b8:	83 c4 10             	add    $0x10,%esp
  8009bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c1:	c9                   	leave  
  8009c2:	c3                   	ret    

008009c3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c9:	e8 68 10 00 00       	call   801a36 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009ce:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dd:	50                   	push   %eax
  8009de:	e8 48 ff ff ff       	call   80092b <vcprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e9:	e8 62 10 00 00       	call   801a50 <sys_enable_interrupt>
	return cnt;
  8009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	53                   	push   %ebx
  8009f7:	83 ec 14             	sub    $0x14,%esp
  8009fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a06:	8b 45 18             	mov    0x18(%ebp),%eax
  800a09:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a11:	77 55                	ja     800a68 <printnum+0x75>
  800a13:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a16:	72 05                	jb     800a1d <printnum+0x2a>
  800a18:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1b:	77 4b                	ja     800a68 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a20:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a23:	8b 45 18             	mov    0x18(%ebp),%eax
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	52                   	push   %edx
  800a2c:	50                   	push   %eax
  800a2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a30:	ff 75 f0             	pushl  -0x10(%ebp)
  800a33:	e8 84 14 00 00       	call   801ebc <__udivdi3>
  800a38:	83 c4 10             	add    $0x10,%esp
  800a3b:	83 ec 04             	sub    $0x4,%esp
  800a3e:	ff 75 20             	pushl  0x20(%ebp)
  800a41:	53                   	push   %ebx
  800a42:	ff 75 18             	pushl  0x18(%ebp)
  800a45:	52                   	push   %edx
  800a46:	50                   	push   %eax
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 08             	pushl  0x8(%ebp)
  800a4d:	e8 a1 ff ff ff       	call   8009f3 <printnum>
  800a52:	83 c4 20             	add    $0x20,%esp
  800a55:	eb 1a                	jmp    800a71 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 20             	pushl  0x20(%ebp)
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a68:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6f:	7f e6                	jg     800a57 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a71:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7f:	53                   	push   %ebx
  800a80:	51                   	push   %ecx
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	e8 44 15 00 00       	call   801fcc <__umoddi3>
  800a88:	83 c4 10             	add    $0x10,%esp
  800a8b:	05 74 29 80 00       	add    $0x802974,%eax
  800a90:	8a 00                	mov    (%eax),%al
  800a92:	0f be c0             	movsbl %al,%eax
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	50                   	push   %eax
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
}
  800aa4:	90                   	nop
  800aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa8:	c9                   	leave  
  800aa9:	c3                   	ret    

00800aaa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab1:	7e 1c                	jle    800acf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	8d 50 08             	lea    0x8(%eax),%edx
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	89 10                	mov    %edx,(%eax)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	83 e8 08             	sub    $0x8,%eax
  800ac8:	8b 50 04             	mov    0x4(%eax),%edx
  800acb:	8b 00                	mov    (%eax),%eax
  800acd:	eb 40                	jmp    800b0f <getuint+0x65>
	else if (lflag)
  800acf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad3:	74 1e                	je     800af3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8b 00                	mov    (%eax),%eax
  800ada:	8d 50 04             	lea    0x4(%eax),%edx
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	89 10                	mov    %edx,(%eax)
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	83 e8 04             	sub    $0x4,%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	ba 00 00 00 00       	mov    $0x0,%edx
  800af1:	eb 1c                	jmp    800b0f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8b 00                	mov    (%eax),%eax
  800af8:	8d 50 04             	lea    0x4(%eax),%edx
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	89 10                	mov    %edx,(%eax)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	83 e8 04             	sub    $0x4,%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b14:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b18:	7e 1c                	jle    800b36 <getint+0x25>
		return va_arg(*ap, long long);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	8d 50 08             	lea    0x8(%eax),%edx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 10                	mov    %edx,(%eax)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	83 e8 08             	sub    $0x8,%eax
  800b2f:	8b 50 04             	mov    0x4(%eax),%edx
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	eb 38                	jmp    800b6e <getint+0x5d>
	else if (lflag)
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	74 1a                	je     800b56 <getint+0x45>
		return va_arg(*ap, long);
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	8d 50 04             	lea    0x4(%eax),%edx
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 10                	mov    %edx,(%eax)
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	83 e8 04             	sub    $0x4,%eax
  800b51:	8b 00                	mov    (%eax),%eax
  800b53:	99                   	cltd   
  800b54:	eb 18                	jmp    800b6e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 04             	lea    0x4(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 04             	sub    $0x4,%eax
  800b6b:	8b 00                	mov    (%eax),%eax
  800b6d:	99                   	cltd   
}
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b78:	eb 17                	jmp    800b91 <vprintfmt+0x21>
			if (ch == '\0')
  800b7a:	85 db                	test   %ebx,%ebx
  800b7c:	0f 84 af 03 00 00    	je     800f31 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	53                   	push   %ebx
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b91:	8b 45 10             	mov    0x10(%ebp),%eax
  800b94:	8d 50 01             	lea    0x1(%eax),%edx
  800b97:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	0f b6 d8             	movzbl %al,%ebx
  800b9f:	83 fb 25             	cmp    $0x25,%ebx
  800ba2:	75 d6                	jne    800b7a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800baf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	8d 50 01             	lea    0x1(%eax),%edx
  800bca:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	0f b6 d8             	movzbl %al,%ebx
  800bd2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd5:	83 f8 55             	cmp    $0x55,%eax
  800bd8:	0f 87 2b 03 00 00    	ja     800f09 <vprintfmt+0x399>
  800bde:	8b 04 85 98 29 80 00 	mov    0x802998(,%eax,4),%eax
  800be5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800beb:	eb d7                	jmp    800bc4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bed:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf1:	eb d1                	jmp    800bc4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 02             	shl    $0x2,%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	01 c0                	add    %eax,%eax
  800c06:	01 d8                	add    %ebx,%eax
  800c08:	83 e8 30             	sub    $0x30,%eax
  800c0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c16:	83 fb 2f             	cmp    $0x2f,%ebx
  800c19:	7e 3e                	jle    800c59 <vprintfmt+0xe9>
  800c1b:	83 fb 39             	cmp    $0x39,%ebx
  800c1e:	7f 39                	jg     800c59 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c20:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c23:	eb d5                	jmp    800bfa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c25:	8b 45 14             	mov    0x14(%ebp),%eax
  800c28:	83 c0 04             	add    $0x4,%eax
  800c2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c31:	83 e8 04             	sub    $0x4,%eax
  800c34:	8b 00                	mov    (%eax),%eax
  800c36:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c39:	eb 1f                	jmp    800c5a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3f:	79 83                	jns    800bc4 <vprintfmt+0x54>
				width = 0;
  800c41:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c48:	e9 77 ff ff ff       	jmp    800bc4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c54:	e9 6b ff ff ff       	jmp    800bc4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c59:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5e:	0f 89 60 ff ff ff    	jns    800bc4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c71:	e9 4e ff ff ff       	jmp    800bc4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c76:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c79:	e9 46 ff ff ff       	jmp    800bc4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 14             	mov    %eax,0x14(%ebp)
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	83 e8 04             	sub    $0x4,%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	50                   	push   %eax
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	ff d0                	call   *%eax
  800c9b:	83 c4 10             	add    $0x10,%esp
			break;
  800c9e:	e9 89 02 00 00       	jmp    800f2c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca6:	83 c0 04             	add    $0x4,%eax
  800ca9:	89 45 14             	mov    %eax,0x14(%ebp)
  800cac:	8b 45 14             	mov    0x14(%ebp),%eax
  800caf:	83 e8 04             	sub    $0x4,%eax
  800cb2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb4:	85 db                	test   %ebx,%ebx
  800cb6:	79 02                	jns    800cba <vprintfmt+0x14a>
				err = -err;
  800cb8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cba:	83 fb 64             	cmp    $0x64,%ebx
  800cbd:	7f 0b                	jg     800cca <vprintfmt+0x15a>
  800cbf:	8b 34 9d e0 27 80 00 	mov    0x8027e0(,%ebx,4),%esi
  800cc6:	85 f6                	test   %esi,%esi
  800cc8:	75 19                	jne    800ce3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cca:	53                   	push   %ebx
  800ccb:	68 85 29 80 00       	push   $0x802985
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	ff 75 08             	pushl  0x8(%ebp)
  800cd6:	e8 5e 02 00 00       	call   800f39 <printfmt>
  800cdb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cde:	e9 49 02 00 00       	jmp    800f2c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce3:	56                   	push   %esi
  800ce4:	68 8e 29 80 00       	push   $0x80298e
  800ce9:	ff 75 0c             	pushl  0xc(%ebp)
  800cec:	ff 75 08             	pushl  0x8(%ebp)
  800cef:	e8 45 02 00 00       	call   800f39 <printfmt>
  800cf4:	83 c4 10             	add    $0x10,%esp
			break;
  800cf7:	e9 30 02 00 00       	jmp    800f2c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cff:	83 c0 04             	add    $0x4,%eax
  800d02:	89 45 14             	mov    %eax,0x14(%ebp)
  800d05:	8b 45 14             	mov    0x14(%ebp),%eax
  800d08:	83 e8 04             	sub    $0x4,%eax
  800d0b:	8b 30                	mov    (%eax),%esi
  800d0d:	85 f6                	test   %esi,%esi
  800d0f:	75 05                	jne    800d16 <vprintfmt+0x1a6>
				p = "(null)";
  800d11:	be 91 29 80 00       	mov    $0x802991,%esi
			if (width > 0 && padc != '-')
  800d16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d1a:	7e 6d                	jle    800d89 <vprintfmt+0x219>
  800d1c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d20:	74 67                	je     800d89 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d25:	83 ec 08             	sub    $0x8,%esp
  800d28:	50                   	push   %eax
  800d29:	56                   	push   %esi
  800d2a:	e8 0c 03 00 00       	call   80103b <strnlen>
  800d2f:	83 c4 10             	add    $0x10,%esp
  800d32:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d35:	eb 16                	jmp    800d4d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d37:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	50                   	push   %eax
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	ff d0                	call   *%eax
  800d47:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d4a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d51:	7f e4                	jg     800d37 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d53:	eb 34                	jmp    800d89 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d59:	74 1c                	je     800d77 <vprintfmt+0x207>
  800d5b:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5e:	7e 05                	jle    800d65 <vprintfmt+0x1f5>
  800d60:	83 fb 7e             	cmp    $0x7e,%ebx
  800d63:	7e 12                	jle    800d77 <vprintfmt+0x207>
					putch('?', putdat);
  800d65:	83 ec 08             	sub    $0x8,%esp
  800d68:	ff 75 0c             	pushl  0xc(%ebp)
  800d6b:	6a 3f                	push   $0x3f
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	ff d0                	call   *%eax
  800d72:	83 c4 10             	add    $0x10,%esp
  800d75:	eb 0f                	jmp    800d86 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	89 f0                	mov    %esi,%eax
  800d8b:	8d 70 01             	lea    0x1(%eax),%esi
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f be d8             	movsbl %al,%ebx
  800d93:	85 db                	test   %ebx,%ebx
  800d95:	74 24                	je     800dbb <vprintfmt+0x24b>
  800d97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9b:	78 b8                	js     800d55 <vprintfmt+0x1e5>
  800d9d:	ff 4d e0             	decl   -0x20(%ebp)
  800da0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da4:	79 af                	jns    800d55 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da6:	eb 13                	jmp    800dbb <vprintfmt+0x24b>
				putch(' ', putdat);
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	6a 20                	push   $0x20
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	ff d0                	call   *%eax
  800db5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db8:	ff 4d e4             	decl   -0x1c(%ebp)
  800dbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbf:	7f e7                	jg     800da8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc1:	e9 66 01 00 00       	jmp    800f2c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc6:	83 ec 08             	sub    $0x8,%esp
  800dc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800dcf:	50                   	push   %eax
  800dd0:	e8 3c fd ff ff       	call   800b11 <getint>
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de4:	85 d2                	test   %edx,%edx
  800de6:	79 23                	jns    800e0b <vprintfmt+0x29b>
				putch('-', putdat);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 0c             	pushl  0xc(%ebp)
  800dee:	6a 2d                	push   $0x2d
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	ff d0                	call   *%eax
  800df5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfe:	f7 d8                	neg    %eax
  800e00:	83 d2 00             	adc    $0x0,%edx
  800e03:	f7 da                	neg    %edx
  800e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e12:	e9 bc 00 00 00       	jmp    800ed3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e17:	83 ec 08             	sub    $0x8,%esp
  800e1a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800e20:	50                   	push   %eax
  800e21:	e8 84 fc ff ff       	call   800aaa <getuint>
  800e26:	83 c4 10             	add    $0x10,%esp
  800e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e36:	e9 98 00 00 00       	jmp    800ed3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3b:	83 ec 08             	sub    $0x8,%esp
  800e3e:	ff 75 0c             	pushl  0xc(%ebp)
  800e41:	6a 58                	push   $0x58
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	ff d0                	call   *%eax
  800e48:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4b:	83 ec 08             	sub    $0x8,%esp
  800e4e:	ff 75 0c             	pushl  0xc(%ebp)
  800e51:	6a 58                	push   $0x58
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	ff d0                	call   *%eax
  800e58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 0c             	pushl  0xc(%ebp)
  800e61:	6a 58                	push   $0x58
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	ff d0                	call   *%eax
  800e68:	83 c4 10             	add    $0x10,%esp
			break;
  800e6b:	e9 bc 00 00 00       	jmp    800f2c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	ff 75 0c             	pushl  0xc(%ebp)
  800e76:	6a 30                	push   $0x30
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	ff d0                	call   *%eax
  800e7d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e80:	83 ec 08             	sub    $0x8,%esp
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	6a 78                	push   $0x78
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	ff d0                	call   *%eax
  800e8d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e90:	8b 45 14             	mov    0x14(%ebp),%eax
  800e93:	83 c0 04             	add    $0x4,%eax
  800e96:	89 45 14             	mov    %eax,0x14(%ebp)
  800e99:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9c:	83 e8 04             	sub    $0x4,%eax
  800e9f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb2:	eb 1f                	jmp    800ed3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 e8             	pushl  -0x18(%ebp)
  800eba:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebd:	50                   	push   %eax
  800ebe:	e8 e7 fb ff ff       	call   800aaa <getuint>
  800ec3:	83 c4 10             	add    $0x10,%esp
  800ec6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eda:	83 ec 04             	sub    $0x4,%esp
  800edd:	52                   	push   %edx
  800ede:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee1:	50                   	push   %eax
  800ee2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	ff 75 08             	pushl  0x8(%ebp)
  800eee:	e8 00 fb ff ff       	call   8009f3 <printnum>
  800ef3:	83 c4 20             	add    $0x20,%esp
			break;
  800ef6:	eb 34                	jmp    800f2c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 0c             	pushl  0xc(%ebp)
  800efe:	53                   	push   %ebx
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			break;
  800f07:	eb 23                	jmp    800f2c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f09:	83 ec 08             	sub    $0x8,%esp
  800f0c:	ff 75 0c             	pushl  0xc(%ebp)
  800f0f:	6a 25                	push   $0x25
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	ff d0                	call   *%eax
  800f16:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f19:	ff 4d 10             	decl   0x10(%ebp)
  800f1c:	eb 03                	jmp    800f21 <vprintfmt+0x3b1>
  800f1e:	ff 4d 10             	decl   0x10(%ebp)
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	48                   	dec    %eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	3c 25                	cmp    $0x25,%al
  800f29:	75 f3                	jne    800f1e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2b:	90                   	nop
		}
	}
  800f2c:	e9 47 fc ff ff       	jmp    800b78 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f31:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3f:	8d 45 10             	lea    0x10(%ebp),%eax
  800f42:	83 c0 04             	add    $0x4,%eax
  800f45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f48:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4e:	50                   	push   %eax
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	ff 75 08             	pushl  0x8(%ebp)
  800f55:	e8 16 fc ff ff       	call   800b70 <vprintfmt>
  800f5a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5d:	90                   	nop
  800f5e:	c9                   	leave  
  800f5f:	c3                   	ret    

00800f60 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8b 40 08             	mov    0x8(%eax),%eax
  800f69:	8d 50 01             	lea    0x1(%eax),%edx
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8b 10                	mov    (%eax),%edx
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	8b 40 04             	mov    0x4(%eax),%eax
  800f7d:	39 c2                	cmp    %eax,%edx
  800f7f:	73 12                	jae    800f93 <sprintputch+0x33>
		*b->buf++ = ch;
  800f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f84:	8b 00                	mov    (%eax),%eax
  800f86:	8d 48 01             	lea    0x1(%eax),%ecx
  800f89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8c:	89 0a                	mov    %ecx,(%edx)
  800f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f91:	88 10                	mov    %dl,(%eax)
}
  800f93:	90                   	nop
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	01 d0                	add    %edx,%eax
  800fad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fbb:	74 06                	je     800fc3 <vsnprintf+0x2d>
  800fbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc1:	7f 07                	jg     800fca <vsnprintf+0x34>
		return -E_INVAL;
  800fc3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc8:	eb 20                	jmp    800fea <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fca:	ff 75 14             	pushl  0x14(%ebp)
  800fcd:	ff 75 10             	pushl  0x10(%ebp)
  800fd0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd3:	50                   	push   %eax
  800fd4:	68 60 0f 80 00       	push   $0x800f60
  800fd9:	e8 92 fb ff ff       	call   800b70 <vprintfmt>
  800fde:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fea:	c9                   	leave  
  800feb:	c3                   	ret    

00800fec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff5:	83 c0 04             	add    $0x4,%eax
  800ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	ff 75 f4             	pushl  -0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	ff 75 0c             	pushl  0xc(%ebp)
  801005:	ff 75 08             	pushl  0x8(%ebp)
  801008:	e8 89 ff ff ff       	call   800f96 <vsnprintf>
  80100d:	83 c4 10             	add    $0x10,%esp
  801010:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801013:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801025:	eb 06                	jmp    80102d <strlen+0x15>
		n++;
  801027:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80102a:	ff 45 08             	incl   0x8(%ebp)
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	84 c0                	test   %al,%al
  801034:	75 f1                	jne    801027 <strlen+0xf>
		n++;
	return n;
  801036:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801039:	c9                   	leave  
  80103a:	c3                   	ret    

0080103b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801048:	eb 09                	jmp    801053 <strnlen+0x18>
		n++;
  80104a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	ff 4d 0c             	decl   0xc(%ebp)
  801053:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801057:	74 09                	je     801062 <strnlen+0x27>
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	84 c0                	test   %al,%al
  801060:	75 e8                	jne    80104a <strnlen+0xf>
		n++;
	return n;
  801062:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801073:	90                   	nop
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8d 50 01             	lea    0x1(%eax),%edx
  80107a:	89 55 08             	mov    %edx,0x8(%ebp)
  80107d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801080:	8d 4a 01             	lea    0x1(%edx),%ecx
  801083:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801086:	8a 12                	mov    (%edx),%dl
  801088:	88 10                	mov    %dl,(%eax)
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	84 c0                	test   %al,%al
  80108e:	75 e4                	jne    801074 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801090:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a8:	eb 1f                	jmp    8010c9 <strncpy+0x34>
		*dst++ = *src;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8d 50 01             	lea    0x1(%eax),%edx
  8010b0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b6:	8a 12                	mov    (%edx),%dl
  8010b8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	84 c0                	test   %al,%al
  8010c1:	74 03                	je     8010c6 <strncpy+0x31>
			src++;
  8010c3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c6:	ff 45 fc             	incl   -0x4(%ebp)
  8010c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010cf:	72 d9                	jb     8010aa <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

008010d6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e6:	74 30                	je     801118 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e8:	eb 16                	jmp    801100 <strlcpy+0x2a>
			*dst++ = *src++;
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8d 50 01             	lea    0x1(%eax),%edx
  8010f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fc:	8a 12                	mov    (%edx),%dl
  8010fe:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801100:	ff 4d 10             	decl   0x10(%ebp)
  801103:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801107:	74 09                	je     801112 <strlcpy+0x3c>
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	84 c0                	test   %al,%al
  801110:	75 d8                	jne    8010ea <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111e:	29 c2                	sub    %eax,%edx
  801120:	89 d0                	mov    %edx,%eax
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801127:	eb 06                	jmp    80112f <strcmp+0xb>
		p++, q++;
  801129:	ff 45 08             	incl   0x8(%ebp)
  80112c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	84 c0                	test   %al,%al
  801136:	74 0e                	je     801146 <strcmp+0x22>
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 10                	mov    (%eax),%dl
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	38 c2                	cmp    %al,%dl
  801144:	74 e3                	je     801129 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	0f b6 d0             	movzbl %al,%edx
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	0f b6 c0             	movzbl %al,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
}
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115f:	eb 09                	jmp    80116a <strncmp+0xe>
		n--, p++, q++;
  801161:	ff 4d 10             	decl   0x10(%ebp)
  801164:	ff 45 08             	incl   0x8(%ebp)
  801167:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80116a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116e:	74 17                	je     801187 <strncmp+0x2b>
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	84 c0                	test   %al,%al
  801177:	74 0e                	je     801187 <strncmp+0x2b>
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 10                	mov    (%eax),%dl
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	38 c2                	cmp    %al,%dl
  801185:	74 da                	je     801161 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801187:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118b:	75 07                	jne    801194 <strncmp+0x38>
		return 0;
  80118d:	b8 00 00 00 00       	mov    $0x0,%eax
  801192:	eb 14                	jmp    8011a8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f b6 d0             	movzbl %al,%edx
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	0f b6 c0             	movzbl %al,%eax
  8011a4:	29 c2                	sub    %eax,%edx
  8011a6:	89 d0                	mov    %edx,%eax
}
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    

008011aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b6:	eb 12                	jmp    8011ca <strchr+0x20>
		if (*s == c)
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c0:	75 05                	jne    8011c7 <strchr+0x1d>
			return (char *) s;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	eb 11                	jmp    8011d8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c7:	ff 45 08             	incl   0x8(%ebp)
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	84 c0                	test   %al,%al
  8011d1:	75 e5                	jne    8011b8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e6:	eb 0d                	jmp    8011f5 <strfind+0x1b>
		if (*s == c)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011f0:	74 0e                	je     801200 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f2:	ff 45 08             	incl   0x8(%ebp)
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	84 c0                	test   %al,%al
  8011fc:	75 ea                	jne    8011e8 <strfind+0xe>
  8011fe:	eb 01                	jmp    801201 <strfind+0x27>
		if (*s == c)
			break;
  801200:	90                   	nop
	return (char *) s;
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801218:	eb 0e                	jmp    801228 <memset+0x22>
		*p++ = c;
  80121a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121d:	8d 50 01             	lea    0x1(%eax),%edx
  801220:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801223:	8b 55 0c             	mov    0xc(%ebp),%edx
  801226:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801228:	ff 4d f8             	decl   -0x8(%ebp)
  80122b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122f:	79 e9                	jns    80121a <memset+0x14>
		*p++ = c;

	return v;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801248:	eb 16                	jmp    801260 <memcpy+0x2a>
		*d++ = *s++;
  80124a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801253:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801256:	8d 4a 01             	lea    0x1(%edx),%ecx
  801259:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125c:	8a 12                	mov    (%edx),%dl
  80125e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	8d 50 ff             	lea    -0x1(%eax),%edx
  801266:	89 55 10             	mov    %edx,0x10(%ebp)
  801269:	85 c0                	test   %eax,%eax
  80126b:	75 dd                	jne    80124a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801287:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80128a:	73 50                	jae    8012dc <memmove+0x6a>
  80128c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128f:	8b 45 10             	mov    0x10(%ebp),%eax
  801292:	01 d0                	add    %edx,%eax
  801294:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801297:	76 43                	jbe    8012dc <memmove+0x6a>
		s += n;
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a5:	eb 10                	jmp    8012b7 <memmove+0x45>
			*--d = *--s;
  8012a7:	ff 4d f8             	decl   -0x8(%ebp)
  8012aa:	ff 4d fc             	decl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	8a 10                	mov    (%eax),%dl
  8012b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	75 e3                	jne    8012a7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c4:	eb 23                	jmp    8012e9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c9:	8d 50 01             	lea    0x1(%eax),%edx
  8012cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d8:	8a 12                	mov    (%edx),%dl
  8012da:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	75 dd                	jne    8012c6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801300:	eb 2a                	jmp    80132c <memcmp+0x3e>
		if (*s1 != *s2)
  801302:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801305:	8a 10                	mov    (%eax),%dl
  801307:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	38 c2                	cmp    %al,%dl
  80130e:	74 16                	je     801326 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	0f b6 d0             	movzbl %al,%edx
  801318:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	0f b6 c0             	movzbl %al,%eax
  801320:	29 c2                	sub    %eax,%edx
  801322:	89 d0                	mov    %edx,%eax
  801324:	eb 18                	jmp    80133e <memcmp+0x50>
		s1++, s2++;
  801326:	ff 45 fc             	incl   -0x4(%ebp)
  801329:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132c:	8b 45 10             	mov    0x10(%ebp),%eax
  80132f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801332:	89 55 10             	mov    %edx,0x10(%ebp)
  801335:	85 c0                	test   %eax,%eax
  801337:	75 c9                	jne    801302 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801346:	8b 55 08             	mov    0x8(%ebp),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801351:	eb 15                	jmp    801368 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f b6 d0             	movzbl %al,%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	0f b6 c0             	movzbl %al,%eax
  801361:	39 c2                	cmp    %eax,%edx
  801363:	74 0d                	je     801372 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801365:	ff 45 08             	incl   0x8(%ebp)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136e:	72 e3                	jb     801353 <memfind+0x13>
  801370:	eb 01                	jmp    801373 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801372:	90                   	nop
	return (void *) s;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801385:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138c:	eb 03                	jmp    801391 <strtol+0x19>
		s++;
  80138e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	3c 20                	cmp    $0x20,%al
  801398:	74 f4                	je     80138e <strtol+0x16>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	3c 09                	cmp    $0x9,%al
  8013a1:	74 eb                	je     80138e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 00                	mov    (%eax),%al
  8013a8:	3c 2b                	cmp    $0x2b,%al
  8013aa:	75 05                	jne    8013b1 <strtol+0x39>
		s++;
  8013ac:	ff 45 08             	incl   0x8(%ebp)
  8013af:	eb 13                	jmp    8013c4 <strtol+0x4c>
	else if (*s == '-')
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	3c 2d                	cmp    $0x2d,%al
  8013b8:	75 0a                	jne    8013c4 <strtol+0x4c>
		s++, neg = 1;
  8013ba:	ff 45 08             	incl   0x8(%ebp)
  8013bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c8:	74 06                	je     8013d0 <strtol+0x58>
  8013ca:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013ce:	75 20                	jne    8013f0 <strtol+0x78>
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	3c 30                	cmp    $0x30,%al
  8013d7:	75 17                	jne    8013f0 <strtol+0x78>
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	40                   	inc    %eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	3c 78                	cmp    $0x78,%al
  8013e1:	75 0d                	jne    8013f0 <strtol+0x78>
		s += 2, base = 16;
  8013e3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ee:	eb 28                	jmp    801418 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f4:	75 15                	jne    80140b <strtol+0x93>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	3c 30                	cmp    $0x30,%al
  8013fd:	75 0c                	jne    80140b <strtol+0x93>
		s++, base = 8;
  8013ff:	ff 45 08             	incl   0x8(%ebp)
  801402:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801409:	eb 0d                	jmp    801418 <strtol+0xa0>
	else if (base == 0)
  80140b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140f:	75 07                	jne    801418 <strtol+0xa0>
		base = 10;
  801411:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	3c 2f                	cmp    $0x2f,%al
  80141f:	7e 19                	jle    80143a <strtol+0xc2>
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 39                	cmp    $0x39,%al
  801428:	7f 10                	jg     80143a <strtol+0xc2>
			dig = *s - '0';
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	0f be c0             	movsbl %al,%eax
  801432:	83 e8 30             	sub    $0x30,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801438:	eb 42                	jmp    80147c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	3c 60                	cmp    $0x60,%al
  801441:	7e 19                	jle    80145c <strtol+0xe4>
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	3c 7a                	cmp    $0x7a,%al
  80144a:	7f 10                	jg     80145c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	0f be c0             	movsbl %al,%eax
  801454:	83 e8 57             	sub    $0x57,%eax
  801457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80145a:	eb 20                	jmp    80147c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 40                	cmp    $0x40,%al
  801463:	7e 39                	jle    80149e <strtol+0x126>
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	3c 5a                	cmp    $0x5a,%al
  80146c:	7f 30                	jg     80149e <strtol+0x126>
			dig = *s - 'A' + 10;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	0f be c0             	movsbl %al,%eax
  801476:	83 e8 37             	sub    $0x37,%eax
  801479:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801482:	7d 19                	jge    80149d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801484:	ff 45 08             	incl   0x8(%ebp)
  801487:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148e:	89 c2                	mov    %eax,%edx
  801490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801493:	01 d0                	add    %edx,%eax
  801495:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801498:	e9 7b ff ff ff       	jmp    801418 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a2:	74 08                	je     8014ac <strtol+0x134>
		*endptr = (char *) s;
  8014a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014aa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014b0:	74 07                	je     8014b9 <strtol+0x141>
  8014b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b5:	f7 d8                	neg    %eax
  8014b7:	eb 03                	jmp    8014bc <strtol+0x144>
  8014b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <ltostr>:

void
ltostr(long value, char *str)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d6:	79 13                	jns    8014eb <ltostr+0x2d>
	{
		neg = 1;
  8014d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f3:	99                   	cltd   
  8014f4:	f7 f9                	idiv   %ecx
  8014f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fc:	8d 50 01             	lea    0x1(%eax),%edx
  8014ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801502:	89 c2                	mov    %eax,%edx
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	01 d0                	add    %edx,%eax
  801509:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150c:	83 c2 30             	add    $0x30,%edx
  80150f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801511:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801514:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801519:	f7 e9                	imul   %ecx
  80151b:	c1 fa 02             	sar    $0x2,%edx
  80151e:	89 c8                	mov    %ecx,%eax
  801520:	c1 f8 1f             	sar    $0x1f,%eax
  801523:	29 c2                	sub    %eax,%edx
  801525:	89 d0                	mov    %edx,%eax
  801527:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80152a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801532:	f7 e9                	imul   %ecx
  801534:	c1 fa 02             	sar    $0x2,%edx
  801537:	89 c8                	mov    %ecx,%eax
  801539:	c1 f8 1f             	sar    $0x1f,%eax
  80153c:	29 c2                	sub    %eax,%edx
  80153e:	89 d0                	mov    %edx,%eax
  801540:	c1 e0 02             	shl    $0x2,%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	01 c0                	add    %eax,%eax
  801547:	29 c1                	sub    %eax,%ecx
  801549:	89 ca                	mov    %ecx,%edx
  80154b:	85 d2                	test   %edx,%edx
  80154d:	75 9c                	jne    8014eb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	48                   	dec    %eax
  80155a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801561:	74 3d                	je     8015a0 <ltostr+0xe2>
		start = 1 ;
  801563:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80156a:	eb 34                	jmp    8015a0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	8a 00                	mov    (%eax),%al
  801576:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 c2                	add    %eax,%edx
  801581:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801584:	8b 45 0c             	mov    0xc(%ebp),%eax
  801587:	01 c8                	add    %ecx,%eax
  801589:	8a 00                	mov    (%eax),%al
  80158b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801590:	8b 45 0c             	mov    0xc(%ebp),%eax
  801593:	01 c2                	add    %eax,%edx
  801595:	8a 45 eb             	mov    -0x15(%ebp),%al
  801598:	88 02                	mov    %al,(%edx)
		start++ ;
  80159a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a6:	7c c4                	jl     80156c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b3:	90                   	nop
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bc:	ff 75 08             	pushl  0x8(%ebp)
  8015bf:	e8 54 fa ff ff       	call   801018 <strlen>
  8015c4:	83 c4 04             	add    $0x4,%esp
  8015c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	e8 46 fa ff ff       	call   801018 <strlen>
  8015d2:	83 c4 04             	add    $0x4,%esp
  8015d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e6:	eb 17                	jmp    8015ff <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ee:	01 c2                	add    %eax,%edx
  8015f0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	01 c8                	add    %ecx,%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fc:	ff 45 fc             	incl   -0x4(%ebp)
  8015ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801602:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801605:	7c e1                	jl     8015e8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801607:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801615:	eb 1f                	jmp    801636 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801617:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161a:	8d 50 01             	lea    0x1(%eax),%edx
  80161d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801620:	89 c2                	mov    %eax,%edx
  801622:	8b 45 10             	mov    0x10(%ebp),%eax
  801625:	01 c2                	add    %eax,%edx
  801627:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80162a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162d:	01 c8                	add    %ecx,%eax
  80162f:	8a 00                	mov    (%eax),%al
  801631:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801633:	ff 45 f8             	incl   -0x8(%ebp)
  801636:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801639:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163c:	7c d9                	jl     801617 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	01 d0                	add    %edx,%eax
  801646:	c6 00 00             	movb   $0x0,(%eax)
}
  801649:	90                   	nop
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164f:	8b 45 14             	mov    0x14(%ebp),%eax
  801652:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801658:	8b 45 14             	mov    0x14(%ebp),%eax
  80165b:	8b 00                	mov    (%eax),%eax
  80165d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166f:	eb 0c                	jmp    80167d <strsplit+0x31>
			*string++ = 0;
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	8d 50 01             	lea    0x1(%eax),%edx
  801677:	89 55 08             	mov    %edx,0x8(%ebp)
  80167a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	8a 00                	mov    (%eax),%al
  801682:	84 c0                	test   %al,%al
  801684:	74 18                	je     80169e <strsplit+0x52>
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	0f be c0             	movsbl %al,%eax
  80168e:	50                   	push   %eax
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	e8 13 fb ff ff       	call   8011aa <strchr>
  801697:	83 c4 08             	add    $0x8,%esp
  80169a:	85 c0                	test   %eax,%eax
  80169c:	75 d3                	jne    801671 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	8a 00                	mov    (%eax),%al
  8016a3:	84 c0                	test   %al,%al
  8016a5:	74 5a                	je     801701 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016aa:	8b 00                	mov    (%eax),%eax
  8016ac:	83 f8 0f             	cmp    $0xf,%eax
  8016af:	75 07                	jne    8016b8 <strsplit+0x6c>
		{
			return 0;
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b6:	eb 66                	jmp    80171e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bb:	8b 00                	mov    (%eax),%eax
  8016bd:	8d 48 01             	lea    0x1(%eax),%ecx
  8016c0:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c3:	89 0a                	mov    %ecx,(%edx)
  8016c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cf:	01 c2                	add    %eax,%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d6:	eb 03                	jmp    8016db <strsplit+0x8f>
			string++;
  8016d8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 00                	mov    (%eax),%al
  8016e0:	84 c0                	test   %al,%al
  8016e2:	74 8b                	je     80166f <strsplit+0x23>
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8a 00                	mov    (%eax),%al
  8016e9:	0f be c0             	movsbl %al,%eax
  8016ec:	50                   	push   %eax
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	e8 b5 fa ff ff       	call   8011aa <strchr>
  8016f5:	83 c4 08             	add    $0x8,%esp
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	74 dc                	je     8016d8 <strsplit+0x8c>
			string++;
	}
  8016fc:	e9 6e ff ff ff       	jmp    80166f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801701:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801702:	8b 45 14             	mov    0x14(%ebp),%eax
  801705:	8b 00                	mov    (%eax),%eax
  801707:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170e:	8b 45 10             	mov    0x10(%ebp),%eax
  801711:	01 d0                	add    %edx,%eax
  801713:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801719:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	68 f0 2a 80 00       	push   $0x802af0
  80172e:	6a 0e                	push   $0xe
  801730:	68 2a 2b 80 00       	push   $0x802b2a
  801735:	e8 a8 ef ff ff       	call   8006e2 <_panic>

0080173a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801740:	a1 04 30 80 00       	mov    0x803004,%eax
  801745:	85 c0                	test   %eax,%eax
  801747:	74 0f                	je     801758 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801749:	e8 d2 ff ff ff       	call   801720 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80174e:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801755:	00 00 00 
	}
	if (size == 0) return NULL ;
  801758:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80175c:	75 07                	jne    801765 <malloc+0x2b>
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
  801763:	eb 14                	jmp    801779 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	68 38 2b 80 00       	push   $0x802b38
  80176d:	6a 2e                	push   $0x2e
  80176f:	68 2a 2b 80 00       	push   $0x802b2a
  801774:	e8 69 ef ff ff       	call   8006e2 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	68 60 2b 80 00       	push   $0x802b60
  801789:	6a 49                	push   $0x49
  80178b:	68 2a 2b 80 00       	push   $0x802b2a
  801790:	e8 4d ef ff ff       	call   8006e2 <_panic>

00801795 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 18             	sub    $0x18,%esp
  80179b:	8b 45 10             	mov    0x10(%ebp),%eax
  80179e:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	68 84 2b 80 00       	push   $0x802b84
  8017a9:	6a 57                	push   $0x57
  8017ab:	68 2a 2b 80 00       	push   $0x802b2a
  8017b0:	e8 2d ef ff ff       	call   8006e2 <_panic>

008017b5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	68 ac 2b 80 00       	push   $0x802bac
  8017c3:	6a 60                	push   $0x60
  8017c5:	68 2a 2b 80 00       	push   $0x802b2a
  8017ca:	e8 13 ef ff ff       	call   8006e2 <_panic>

008017cf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 d0 2b 80 00       	push   $0x802bd0
  8017dd:	6a 7c                	push   $0x7c
  8017df:	68 2a 2b 80 00       	push   $0x802b2a
  8017e4:	e8 f9 ee ff ff       	call   8006e2 <_panic>

008017e9 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	68 f8 2b 80 00       	push   $0x802bf8
  8017f7:	68 86 00 00 00       	push   $0x86
  8017fc:	68 2a 2b 80 00       	push   $0x802b2a
  801801:	e8 dc ee ff ff       	call   8006e2 <_panic>

00801806 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	68 1c 2c 80 00       	push   $0x802c1c
  801814:	68 91 00 00 00       	push   $0x91
  801819:	68 2a 2b 80 00       	push   $0x802b2a
  80181e:	e8 bf ee ff ff       	call   8006e2 <_panic>

00801823 <shrink>:

}
void shrink(uint32 newSize)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	68 1c 2c 80 00       	push   $0x802c1c
  801831:	68 96 00 00 00       	push   $0x96
  801836:	68 2a 2b 80 00       	push   $0x802b2a
  80183b:	e8 a2 ee ff ff       	call   8006e2 <_panic>

00801840 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	68 1c 2c 80 00       	push   $0x802c1c
  80184e:	68 9b 00 00 00       	push   $0x9b
  801853:	68 2a 2b 80 00       	push   $0x802b2a
  801858:	e8 85 ee ff ff       	call   8006e2 <_panic>

0080185d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	57                   	push   %edi
  801861:	56                   	push   %esi
  801862:	53                   	push   %ebx
  801863:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801872:	8b 7d 18             	mov    0x18(%ebp),%edi
  801875:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801878:	cd 30                	int    $0x30
  80187a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80187d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5f                   	pop    %edi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801894:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	52                   	push   %edx
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	50                   	push   %eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	e8 b2 ff ff ff       	call   80185d <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 01                	push   $0x1
  8018c0:	e8 98 ff ff ff       	call   80185d <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	6a 05                	push   $0x5
  8018dd:	e8 7b ff ff ff       	call   80185d <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
  8018fd:	51                   	push   %ecx
  8018fe:	52                   	push   %edx
  8018ff:	50                   	push   %eax
  801900:	6a 06                	push   $0x6
  801902:	e8 56 ff ff ff       	call   80185d <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190d:	5b                   	pop    %ebx
  80190e:	5e                   	pop    %esi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    

00801911 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801914:	8b 55 0c             	mov    0xc(%ebp),%edx
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 07                	push   $0x7
  801924:	e8 34 ff ff ff       	call   80185d <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	6a 08                	push   $0x8
  80193f:	e8 19 ff ff ff       	call   80185d <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 09                	push   $0x9
  801958:	e8 00 ff ff ff       	call   80185d <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 0a                	push   $0xa
  801971:	e8 e7 fe ff ff       	call   80185d <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 0b                	push   $0xb
  80198a:	e8 ce fe ff ff       	call   80185d <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	ff 75 08             	pushl  0x8(%ebp)
  8019a3:	6a 0f                	push   $0xf
  8019a5:	e8 b3 fe ff ff       	call   80185d <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
	return;
  8019ad:	90                   	nop
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	6a 10                	push   $0x10
  8019c1:	e8 97 fe ff ff       	call   80185d <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c9:	90                   	nop
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 10             	pushl  0x10(%ebp)
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	ff 75 08             	pushl  0x8(%ebp)
  8019dc:	6a 11                	push   $0x11
  8019de:	e8 7a fe ff ff       	call   80185d <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e6:	90                   	nop
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 0c                	push   $0xc
  8019f8:	e8 60 fe ff ff       	call   80185d <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	ff 75 08             	pushl  0x8(%ebp)
  801a10:	6a 0d                	push   $0xd
  801a12:	e8 46 fe ff ff       	call   80185d <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 0e                	push   $0xe
  801a2b:	e8 2d fe ff ff       	call   80185d <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	90                   	nop
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 13                	push   $0x13
  801a45:	e8 13 fe ff ff       	call   80185d <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	90                   	nop
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 14                	push   $0x14
  801a5f:	e8 f9 fd ff ff       	call   80185d <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	90                   	nop
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_cputc>:


void
sys_cputc(const char c)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a76:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	50                   	push   %eax
  801a83:	6a 15                	push   $0x15
  801a85:	e8 d3 fd ff ff       	call   80185d <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	90                   	nop
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 16                	push   $0x16
  801a9f:	e8 b9 fd ff ff       	call   80185d <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	90                   	nop
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	ff 75 0c             	pushl  0xc(%ebp)
  801ab9:	50                   	push   %eax
  801aba:	6a 17                	push   $0x17
  801abc:	e8 9c fd ff ff       	call   80185d <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	52                   	push   %edx
  801ad6:	50                   	push   %eax
  801ad7:	6a 1a                	push   $0x1a
  801ad9:	e8 7f fd ff ff       	call   80185d <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	52                   	push   %edx
  801af3:	50                   	push   %eax
  801af4:	6a 18                	push   $0x18
  801af6:	e8 62 fd ff ff       	call   80185d <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	52                   	push   %edx
  801b11:	50                   	push   %eax
  801b12:	6a 19                	push   $0x19
  801b14:	e8 44 fd ff ff       	call   80185d <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	90                   	nop
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b2b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b2e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	6a 00                	push   $0x0
  801b37:	51                   	push   %ecx
  801b38:	52                   	push   %edx
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	50                   	push   %eax
  801b3d:	6a 1b                	push   $0x1b
  801b3f:	e8 19 fd ff ff       	call   80185d <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 1c                	push   $0x1c
  801b5c:	e8 fc fc ff ff       	call   80185d <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	51                   	push   %ecx
  801b77:	52                   	push   %edx
  801b78:	50                   	push   %eax
  801b79:	6a 1d                	push   $0x1d
  801b7b:	e8 dd fc ff ff       	call   80185d <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 1e                	push   $0x1e
  801b98:	e8 c0 fc ff ff       	call   80185d <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 1f                	push   $0x1f
  801bb1:	e8 a7 fc ff ff       	call   80185d <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	ff 75 14             	pushl  0x14(%ebp)
  801bc6:	ff 75 10             	pushl  0x10(%ebp)
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	50                   	push   %eax
  801bcd:	6a 20                	push   $0x20
  801bcf:	e8 89 fc ff ff       	call   80185d <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	50                   	push   %eax
  801be8:	6a 21                	push   $0x21
  801bea:	e8 6e fc ff ff       	call   80185d <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	90                   	nop
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	50                   	push   %eax
  801c04:	6a 22                	push   $0x22
  801c06:	e8 52 fc ff ff       	call   80185d <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 02                	push   $0x2
  801c1f:	e8 39 fc ff ff       	call   80185d <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 03                	push   $0x3
  801c38:	e8 20 fc ff ff       	call   80185d <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 04                	push   $0x4
  801c51:	e8 07 fc ff ff       	call   80185d <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_exit_env>:


void sys_exit_env(void)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 23                	push   $0x23
  801c6a:	e8 ee fb ff ff       	call   80185d <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	90                   	nop
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c7b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c7e:	8d 50 04             	lea    0x4(%eax),%edx
  801c81:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	52                   	push   %edx
  801c8b:	50                   	push   %eax
  801c8c:	6a 24                	push   $0x24
  801c8e:	e8 ca fb ff ff       	call   80185d <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return result;
  801c96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c9f:	89 01                	mov    %eax,(%ecx)
  801ca1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	c9                   	leave  
  801ca8:	c2 04 00             	ret    $0x4

00801cab <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	ff 75 10             	pushl  0x10(%ebp)
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	ff 75 08             	pushl  0x8(%ebp)
  801cbb:	6a 12                	push   $0x12
  801cbd:	e8 9b fb ff ff       	call   80185d <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc5:	90                   	nop
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 25                	push   $0x25
  801cd7:	e8 81 fb ff ff       	call   80185d <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ced:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	50                   	push   %eax
  801cfa:	6a 26                	push   $0x26
  801cfc:	e8 5c fb ff ff       	call   80185d <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
	return ;
  801d04:	90                   	nop
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <rsttst>:
void rsttst()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 28                	push   $0x28
  801d16:	e8 42 fb ff ff       	call   80185d <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1e:	90                   	nop
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d2d:	8b 55 18             	mov    0x18(%ebp),%edx
  801d30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d34:	52                   	push   %edx
  801d35:	50                   	push   %eax
  801d36:	ff 75 10             	pushl  0x10(%ebp)
  801d39:	ff 75 0c             	pushl  0xc(%ebp)
  801d3c:	ff 75 08             	pushl  0x8(%ebp)
  801d3f:	6a 27                	push   $0x27
  801d41:	e8 17 fb ff ff       	call   80185d <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
	return ;
  801d49:	90                   	nop
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <chktst>:
void chktst(uint32 n)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	ff 75 08             	pushl  0x8(%ebp)
  801d5a:	6a 29                	push   $0x29
  801d5c:	e8 fc fa ff ff       	call   80185d <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
	return ;
  801d64:	90                   	nop
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <inctst>:

void inctst()
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 2a                	push   $0x2a
  801d76:	e8 e2 fa ff ff       	call   80185d <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7e:	90                   	nop
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <gettst>:
uint32 gettst()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 2b                	push   $0x2b
  801d90:	e8 c8 fa ff ff       	call   80185d <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 2c                	push   $0x2c
  801dac:	e8 ac fa ff ff       	call   80185d <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
  801db4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801db7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dbb:	75 07                	jne    801dc4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc2:	eb 05                	jmp    801dc9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 2c                	push   $0x2c
  801ddd:	e8 7b fa ff ff       	call   80185d <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
  801de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801de8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dec:	75 07                	jne    801df5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	eb 05                	jmp    801dfa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 2c                	push   $0x2c
  801e0e:	e8 4a fa ff ff       	call   80185d <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
  801e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e19:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e1d:	75 07                	jne    801e26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e24:	eb 05                	jmp    801e2b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 2c                	push   $0x2c
  801e3f:	e8 19 fa ff ff       	call   80185d <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
  801e47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e4a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e4e:	75 07                	jne    801e57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e50:	b8 01 00 00 00       	mov    $0x1,%eax
  801e55:	eb 05                	jmp    801e5c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 08             	pushl  0x8(%ebp)
  801e6c:	6a 2d                	push   $0x2d
  801e6e:	e8 ea f9 ff ff       	call   80185d <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
	return ;
  801e76:	90                   	nop
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e7d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e80:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	6a 00                	push   $0x0
  801e8b:	53                   	push   %ebx
  801e8c:	51                   	push   %ecx
  801e8d:	52                   	push   %edx
  801e8e:	50                   	push   %eax
  801e8f:	6a 2e                	push   $0x2e
  801e91:	e8 c7 f9 ff ff       	call   80185d <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	52                   	push   %edx
  801eae:	50                   	push   %eax
  801eaf:	6a 2f                	push   $0x2f
  801eb1:	e8 a7 f9 ff ff       	call   80185d <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    
  801ebb:	90                   	nop

00801ebc <__udivdi3>:
  801ebc:	55                   	push   %ebp
  801ebd:	57                   	push   %edi
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	83 ec 1c             	sub    $0x1c,%esp
  801ec3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ec7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ecb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ecf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ed3:	89 ca                	mov    %ecx,%edx
  801ed5:	89 f8                	mov    %edi,%eax
  801ed7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801edb:	85 f6                	test   %esi,%esi
  801edd:	75 2d                	jne    801f0c <__udivdi3+0x50>
  801edf:	39 cf                	cmp    %ecx,%edi
  801ee1:	77 65                	ja     801f48 <__udivdi3+0x8c>
  801ee3:	89 fd                	mov    %edi,%ebp
  801ee5:	85 ff                	test   %edi,%edi
  801ee7:	75 0b                	jne    801ef4 <__udivdi3+0x38>
  801ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  801eee:	31 d2                	xor    %edx,%edx
  801ef0:	f7 f7                	div    %edi
  801ef2:	89 c5                	mov    %eax,%ebp
  801ef4:	31 d2                	xor    %edx,%edx
  801ef6:	89 c8                	mov    %ecx,%eax
  801ef8:	f7 f5                	div    %ebp
  801efa:	89 c1                	mov    %eax,%ecx
  801efc:	89 d8                	mov    %ebx,%eax
  801efe:	f7 f5                	div    %ebp
  801f00:	89 cf                	mov    %ecx,%edi
  801f02:	89 fa                	mov    %edi,%edx
  801f04:	83 c4 1c             	add    $0x1c,%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5f                   	pop    %edi
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    
  801f0c:	39 ce                	cmp    %ecx,%esi
  801f0e:	77 28                	ja     801f38 <__udivdi3+0x7c>
  801f10:	0f bd fe             	bsr    %esi,%edi
  801f13:	83 f7 1f             	xor    $0x1f,%edi
  801f16:	75 40                	jne    801f58 <__udivdi3+0x9c>
  801f18:	39 ce                	cmp    %ecx,%esi
  801f1a:	72 0a                	jb     801f26 <__udivdi3+0x6a>
  801f1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801f20:	0f 87 9e 00 00 00    	ja     801fc4 <__udivdi3+0x108>
  801f26:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2b:	89 fa                	mov    %edi,%edx
  801f2d:	83 c4 1c             	add    $0x1c,%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5f                   	pop    %edi
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    
  801f35:	8d 76 00             	lea    0x0(%esi),%esi
  801f38:	31 ff                	xor    %edi,%edi
  801f3a:	31 c0                	xor    %eax,%eax
  801f3c:	89 fa                	mov    %edi,%edx
  801f3e:	83 c4 1c             	add    $0x1c,%esp
  801f41:	5b                   	pop    %ebx
  801f42:	5e                   	pop    %esi
  801f43:	5f                   	pop    %edi
  801f44:	5d                   	pop    %ebp
  801f45:	c3                   	ret    
  801f46:	66 90                	xchg   %ax,%ax
  801f48:	89 d8                	mov    %ebx,%eax
  801f4a:	f7 f7                	div    %edi
  801f4c:	31 ff                	xor    %edi,%edi
  801f4e:	89 fa                	mov    %edi,%edx
  801f50:	83 c4 1c             	add    $0x1c,%esp
  801f53:	5b                   	pop    %ebx
  801f54:	5e                   	pop    %esi
  801f55:	5f                   	pop    %edi
  801f56:	5d                   	pop    %ebp
  801f57:	c3                   	ret    
  801f58:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f5d:	89 eb                	mov    %ebp,%ebx
  801f5f:	29 fb                	sub    %edi,%ebx
  801f61:	89 f9                	mov    %edi,%ecx
  801f63:	d3 e6                	shl    %cl,%esi
  801f65:	89 c5                	mov    %eax,%ebp
  801f67:	88 d9                	mov    %bl,%cl
  801f69:	d3 ed                	shr    %cl,%ebp
  801f6b:	89 e9                	mov    %ebp,%ecx
  801f6d:	09 f1                	or     %esi,%ecx
  801f6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f73:	89 f9                	mov    %edi,%ecx
  801f75:	d3 e0                	shl    %cl,%eax
  801f77:	89 c5                	mov    %eax,%ebp
  801f79:	89 d6                	mov    %edx,%esi
  801f7b:	88 d9                	mov    %bl,%cl
  801f7d:	d3 ee                	shr    %cl,%esi
  801f7f:	89 f9                	mov    %edi,%ecx
  801f81:	d3 e2                	shl    %cl,%edx
  801f83:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f87:	88 d9                	mov    %bl,%cl
  801f89:	d3 e8                	shr    %cl,%eax
  801f8b:	09 c2                	or     %eax,%edx
  801f8d:	89 d0                	mov    %edx,%eax
  801f8f:	89 f2                	mov    %esi,%edx
  801f91:	f7 74 24 0c          	divl   0xc(%esp)
  801f95:	89 d6                	mov    %edx,%esi
  801f97:	89 c3                	mov    %eax,%ebx
  801f99:	f7 e5                	mul    %ebp
  801f9b:	39 d6                	cmp    %edx,%esi
  801f9d:	72 19                	jb     801fb8 <__udivdi3+0xfc>
  801f9f:	74 0b                	je     801fac <__udivdi3+0xf0>
  801fa1:	89 d8                	mov    %ebx,%eax
  801fa3:	31 ff                	xor    %edi,%edi
  801fa5:	e9 58 ff ff ff       	jmp    801f02 <__udivdi3+0x46>
  801faa:	66 90                	xchg   %ax,%ax
  801fac:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fb0:	89 f9                	mov    %edi,%ecx
  801fb2:	d3 e2                	shl    %cl,%edx
  801fb4:	39 c2                	cmp    %eax,%edx
  801fb6:	73 e9                	jae    801fa1 <__udivdi3+0xe5>
  801fb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fbb:	31 ff                	xor    %edi,%edi
  801fbd:	e9 40 ff ff ff       	jmp    801f02 <__udivdi3+0x46>
  801fc2:	66 90                	xchg   %ax,%ax
  801fc4:	31 c0                	xor    %eax,%eax
  801fc6:	e9 37 ff ff ff       	jmp    801f02 <__udivdi3+0x46>
  801fcb:	90                   	nop

00801fcc <__umoddi3>:
  801fcc:	55                   	push   %ebp
  801fcd:	57                   	push   %edi
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 1c             	sub    $0x1c,%esp
  801fd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fe3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fe7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801feb:	89 f3                	mov    %esi,%ebx
  801fed:	89 fa                	mov    %edi,%edx
  801fef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ff3:	89 34 24             	mov    %esi,(%esp)
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	75 1a                	jne    802014 <__umoddi3+0x48>
  801ffa:	39 f7                	cmp    %esi,%edi
  801ffc:	0f 86 a2 00 00 00    	jbe    8020a4 <__umoddi3+0xd8>
  802002:	89 c8                	mov    %ecx,%eax
  802004:	89 f2                	mov    %esi,%edx
  802006:	f7 f7                	div    %edi
  802008:	89 d0                	mov    %edx,%eax
  80200a:	31 d2                	xor    %edx,%edx
  80200c:	83 c4 1c             	add    $0x1c,%esp
  80200f:	5b                   	pop    %ebx
  802010:	5e                   	pop    %esi
  802011:	5f                   	pop    %edi
  802012:	5d                   	pop    %ebp
  802013:	c3                   	ret    
  802014:	39 f0                	cmp    %esi,%eax
  802016:	0f 87 ac 00 00 00    	ja     8020c8 <__umoddi3+0xfc>
  80201c:	0f bd e8             	bsr    %eax,%ebp
  80201f:	83 f5 1f             	xor    $0x1f,%ebp
  802022:	0f 84 ac 00 00 00    	je     8020d4 <__umoddi3+0x108>
  802028:	bf 20 00 00 00       	mov    $0x20,%edi
  80202d:	29 ef                	sub    %ebp,%edi
  80202f:	89 fe                	mov    %edi,%esi
  802031:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802035:	89 e9                	mov    %ebp,%ecx
  802037:	d3 e0                	shl    %cl,%eax
  802039:	89 d7                	mov    %edx,%edi
  80203b:	89 f1                	mov    %esi,%ecx
  80203d:	d3 ef                	shr    %cl,%edi
  80203f:	09 c7                	or     %eax,%edi
  802041:	89 e9                	mov    %ebp,%ecx
  802043:	d3 e2                	shl    %cl,%edx
  802045:	89 14 24             	mov    %edx,(%esp)
  802048:	89 d8                	mov    %ebx,%eax
  80204a:	d3 e0                	shl    %cl,%eax
  80204c:	89 c2                	mov    %eax,%edx
  80204e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802052:	d3 e0                	shl    %cl,%eax
  802054:	89 44 24 04          	mov    %eax,0x4(%esp)
  802058:	8b 44 24 08          	mov    0x8(%esp),%eax
  80205c:	89 f1                	mov    %esi,%ecx
  80205e:	d3 e8                	shr    %cl,%eax
  802060:	09 d0                	or     %edx,%eax
  802062:	d3 eb                	shr    %cl,%ebx
  802064:	89 da                	mov    %ebx,%edx
  802066:	f7 f7                	div    %edi
  802068:	89 d3                	mov    %edx,%ebx
  80206a:	f7 24 24             	mull   (%esp)
  80206d:	89 c6                	mov    %eax,%esi
  80206f:	89 d1                	mov    %edx,%ecx
  802071:	39 d3                	cmp    %edx,%ebx
  802073:	0f 82 87 00 00 00    	jb     802100 <__umoddi3+0x134>
  802079:	0f 84 91 00 00 00    	je     802110 <__umoddi3+0x144>
  80207f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802083:	29 f2                	sub    %esi,%edx
  802085:	19 cb                	sbb    %ecx,%ebx
  802087:	89 d8                	mov    %ebx,%eax
  802089:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80208d:	d3 e0                	shl    %cl,%eax
  80208f:	89 e9                	mov    %ebp,%ecx
  802091:	d3 ea                	shr    %cl,%edx
  802093:	09 d0                	or     %edx,%eax
  802095:	89 e9                	mov    %ebp,%ecx
  802097:	d3 eb                	shr    %cl,%ebx
  802099:	89 da                	mov    %ebx,%edx
  80209b:	83 c4 1c             	add    $0x1c,%esp
  80209e:	5b                   	pop    %ebx
  80209f:	5e                   	pop    %esi
  8020a0:	5f                   	pop    %edi
  8020a1:	5d                   	pop    %ebp
  8020a2:	c3                   	ret    
  8020a3:	90                   	nop
  8020a4:	89 fd                	mov    %edi,%ebp
  8020a6:	85 ff                	test   %edi,%edi
  8020a8:	75 0b                	jne    8020b5 <__umoddi3+0xe9>
  8020aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8020af:	31 d2                	xor    %edx,%edx
  8020b1:	f7 f7                	div    %edi
  8020b3:	89 c5                	mov    %eax,%ebp
  8020b5:	89 f0                	mov    %esi,%eax
  8020b7:	31 d2                	xor    %edx,%edx
  8020b9:	f7 f5                	div    %ebp
  8020bb:	89 c8                	mov    %ecx,%eax
  8020bd:	f7 f5                	div    %ebp
  8020bf:	89 d0                	mov    %edx,%eax
  8020c1:	e9 44 ff ff ff       	jmp    80200a <__umoddi3+0x3e>
  8020c6:	66 90                	xchg   %ax,%ax
  8020c8:	89 c8                	mov    %ecx,%eax
  8020ca:	89 f2                	mov    %esi,%edx
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    
  8020d4:	3b 04 24             	cmp    (%esp),%eax
  8020d7:	72 06                	jb     8020df <__umoddi3+0x113>
  8020d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020dd:	77 0f                	ja     8020ee <__umoddi3+0x122>
  8020df:	89 f2                	mov    %esi,%edx
  8020e1:	29 f9                	sub    %edi,%ecx
  8020e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020e7:	89 14 24             	mov    %edx,(%esp)
  8020ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020f2:	8b 14 24             	mov    (%esp),%edx
  8020f5:	83 c4 1c             	add    $0x1c,%esp
  8020f8:	5b                   	pop    %ebx
  8020f9:	5e                   	pop    %esi
  8020fa:	5f                   	pop    %edi
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    
  8020fd:	8d 76 00             	lea    0x0(%esi),%esi
  802100:	2b 04 24             	sub    (%esp),%eax
  802103:	19 fa                	sbb    %edi,%edx
  802105:	89 d1                	mov    %edx,%ecx
  802107:	89 c6                	mov    %eax,%esi
  802109:	e9 71 ff ff ff       	jmp    80207f <__umoddi3+0xb3>
  80210e:	66 90                	xchg   %ax,%ax
  802110:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802114:	72 ea                	jb     802100 <__umoddi3+0x134>
  802116:	89 d9                	mov    %ebx,%ecx
  802118:	e9 62 ff ff ff       	jmp    80207f <__umoddi3+0xb3>
