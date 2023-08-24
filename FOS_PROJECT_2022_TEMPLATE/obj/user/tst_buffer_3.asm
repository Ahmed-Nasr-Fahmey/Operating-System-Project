
obj/user/tst_buffer_3:     file format elf32-i386


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
  800031:	e8 82 02 00 00       	call   8002b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
//		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}
	int kilo = 1024;
  80003f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int Mega = 1024*1024;
  800046:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)

	{
		int freeFrames = sys_calculate_free_frames() ;
  80004d:	e8 1c 16 00 00       	call   80166e <sys_calculate_free_frames>
  800052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int origFreeFrames = freeFrames ;
  800055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800058:	89 45 e0             	mov    %eax,-0x20(%ebp)

		uint32 size = 10*Mega;
  80005b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	c1 e0 02             	shl    $0x2,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	01 c0                	add    %eax,%eax
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	ff 75 dc             	pushl  -0x24(%ebp)
  800070:	e8 ea 13 00 00       	call   80145f <malloc>
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80007b:	e8 ee 15 00 00       	call   80166e <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 ff 15 00 00       	call   801687 <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 60 1e 80 00       	push   $0x801e60
  80009c:	e8 1a 06 00 00       	call   8006bb <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp
		x[1]=-1;
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	40                   	inc    %eax
  8000a8:	c6 00 ff             	movb   $0xff,(%eax)

		x[1*Mega] = -1;
  8000ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	c6 00 ff             	movb   $0xff,(%eax)

		int i = x[2*Mega];
  8000b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	89 c2                	mov    %eax,%edx
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	8a 00                	mov    (%eax),%al
  8000c4:	0f b6 c0             	movzbl %al,%eax
  8000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		int j = x[3*Mega];
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	01 d2                	add    %edx,%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8a 00                	mov    (%eax),%al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		x[4*Mega] = -1;
  8000e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e5:	c1 e0 02             	shl    $0x2,%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega] = -1;
  8000f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000f5:	89 d0                	mov    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	89 c2                	mov    %eax,%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c6 00 ff             	movb   $0xff,(%eax)

		x[6*Mega] = -1;
  800106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800109:	89 d0                	mov    %edx,%eax
  80010b:	01 c0                	add    %eax,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	01 c0                	add    %eax,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 ff             	movb   $0xff,(%eax)

		x[7*Mega] = -1;
  80011b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80011e:	89 d0                	mov    %edx,%eax
  800120:	01 c0                	add    %eax,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	01 c0                	add    %eax,%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	c1 e0 03             	shl    $0x3,%eax
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013d:	01 d0                	add    %edx,%eax
  80013f:	c6 00 ff             	movb   $0xff,(%eax)

		x[9*Mega] = -1;
  800142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800145:	89 d0                	mov    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 d8             	pushl  -0x28(%ebp)
  80015c:	e8 3f 13 00 00       	call   8014a0 <free>
  800161:	83 c4 10             	add    $0x10,%esp

		int numOFEmptyLocInWS = 0;
  800164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80016b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800172:	eb 79                	jmp    8001ed <_main+0x1b5>
		{
			if (myEnv->__uptr_pws[i].empty)
  800174:	a1 20 30 80 00       	mov    0x803020,%eax
  800179:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80017f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800182:	89 d0                	mov    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	c1 e0 03             	shl    $0x3,%eax
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	8a 40 04             	mov    0x4(%eax),%al
  800190:	84 c0                	test   %al,%al
  800192:	74 05                	je     800199 <_main+0x161>
			{
				numOFEmptyLocInWS++;
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	eb 51                	jmp    8001ea <_main+0x1b2>
			}
			else
			{
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800199:	a1 20 30 80 00       	mov    0x803020,%eax
  80019e:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8001a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a7:	89 d0                	mov    %edx,%eax
  8001a9:	01 c0                	add    %eax,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	c1 e0 03             	shl    $0x3,%eax
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
  8001c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	79 21                	jns    8001ea <_main+0x1b2>
  8001c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001d4:	76 14                	jbe    8001ea <_main+0x1b2>
					panic("freeMem didn't remove its page(s) from the WS");
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 80 1e 80 00       	push   $0x801e80
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 ae 1e 80 00       	push   $0x801eae
  8001e5:	e8 1d 02 00 00       	call   800407 <_panic>
		x[9*Mega] = -1;

		free(x);

		int numOFEmptyLocInWS = 0;
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8001ea:	ff 45 f4             	incl   -0xc(%ebp)
  8001ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f2:	8b 50 74             	mov    0x74(%eax),%edx
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	0f 87 74 ff ff ff    	ja     800174 <_main+0x13c>
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
					panic("freeMem didn't remove its page(s) from the WS");
			}
		}
		int free_frames = sys_calculate_free_frames();
  800200:	e8 69 14 00 00       	call   80166e <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 7a 14 00 00       	call   801687 <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 72 14 00 00       	call   801687 <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 52 14 00 00       	call   80166e <sys_calculate_free_frames>
  80021c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	89 d1                	mov    %edx,%ecx
  800224:	29 c1                	sub    %eax,%ecx
  800226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	01 d0                	add    %edx,%eax
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	74 14                	je     800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 c4 1e 80 00       	push   $0x801ec4
  80023a:	6a 53                	push   $0x53
  80023c:	68 ae 1e 80 00       	push   $0x801eae
  800241:	e8 c1 01 00 00       	call   800407 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 18 1f 80 00       	push   $0x801f18
  80024e:	e8 68 04 00 00       	call   8006bb <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 74 1f 80 00       	push   $0x801f74
  80025e:	e8 58 04 00 00       	call   8006bb <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	c6 00 ff             	movb   $0xff,(%eax)

			x[1*Mega] = -1;
  80026d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c6 00 ff             	movb   $0xff,(%eax)

			int i = x[2*Mega];
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	01 c0                	add    %eax,%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800282:	01 d0                	add    %edx,%eax
  800284:	8a 00                	mov    (%eax),%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	89 45 bc             	mov    %eax,-0x44(%ebp)

			int j = x[3*Mega];
  80028c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028f:	89 c2                	mov    %eax,%edx
  800291:	01 d2                	add    %edx,%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8a 00                	mov    (%eax),%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 58 20 80 00       	push   $0x802058
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 ae 1e 80 00       	push   $0x801eae
  8002b3:	e8 4f 01 00 00       	call   800407 <_panic>

008002b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002be:	e8 8b 16 00 00       	call   80194e <sys_getenvindex>
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	01 c0                	add    %eax,%eax
  8002cd:	01 d0                	add    %edx,%eax
  8002cf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	c1 e0 02             	shl    $0x2,%eax
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8002e4:	01 c8                	add    %ecx,%eax
  8002e6:	c1 e0 02             	shl    $0x2,%eax
  8002e9:	01 d0                	add    %edx,%eax
  8002eb:	c1 e0 02             	shl    $0x2,%eax
  8002ee:	01 d0                	add    %edx,%eax
  8002f0:	c1 e0 03             	shl    $0x3,%eax
  8002f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f8:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800302:	8a 80 18 da 01 00    	mov    0x1da18(%eax),%al
  800308:	84 c0                	test   %al,%al
  80030a:	74 0f                	je     80031b <libmain+0x63>
		binaryname = myEnv->prog_name;
  80030c:	a1 20 30 80 00       	mov    0x803020,%eax
  800311:	05 18 da 01 00       	add    $0x1da18,%eax
  800316:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80031b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80031f:	7e 0a                	jle    80032b <libmain+0x73>
		binaryname = argv[0];
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	e8 ff fc ff ff       	call   800038 <_main>
  800339:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80033c:	e8 1a 14 00 00       	call   80175b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800341:	83 ec 0c             	sub    $0xc,%esp
  800344:	68 78 21 80 00       	push   $0x802178
  800349:	e8 6d 03 00 00       	call   8006bb <cprintf>
  80034e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800351:	a1 20 30 80 00       	mov    0x803020,%eax
  800356:	8b 90 00 da 01 00    	mov    0x1da00(%eax),%edx
  80035c:	a1 20 30 80 00       	mov    0x803020,%eax
  800361:	8b 80 f0 d9 01 00    	mov    0x1d9f0(%eax),%eax
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	52                   	push   %edx
  80036b:	50                   	push   %eax
  80036c:	68 a0 21 80 00       	push   $0x8021a0
  800371:	e8 45 03 00 00       	call   8006bb <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800379:	a1 20 30 80 00       	mov    0x803020,%eax
  80037e:	8b 88 10 da 01 00    	mov    0x1da10(%eax),%ecx
  800384:	a1 20 30 80 00       	mov    0x803020,%eax
  800389:	8b 90 0c da 01 00    	mov    0x1da0c(%eax),%edx
  80038f:	a1 20 30 80 00       	mov    0x803020,%eax
  800394:	8b 80 08 da 01 00    	mov    0x1da08(%eax),%eax
  80039a:	51                   	push   %ecx
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	68 c8 21 80 00       	push   $0x8021c8
  8003a2:	e8 14 03 00 00       	call   8006bb <cprintf>
  8003a7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8003af:	8b 80 60 da 01 00    	mov    0x1da60(%eax),%eax
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	50                   	push   %eax
  8003b9:	68 20 22 80 00       	push   $0x802220
  8003be:	e8 f8 02 00 00       	call   8006bb <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	68 78 21 80 00       	push   $0x802178
  8003ce:	e8 e8 02 00 00       	call   8006bb <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003d6:	e8 9a 13 00 00       	call   801775 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003db:	e8 19 00 00 00       	call   8003f9 <exit>
}
  8003e0:	90                   	nop
  8003e1:	c9                   	leave  
  8003e2:	c3                   	ret    

008003e3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	e8 27 15 00 00       	call   80191a <sys_destroy_env>
  8003f3:	83 c4 10             	add    $0x10,%esp
}
  8003f6:	90                   	nop
  8003f7:	c9                   	leave  
  8003f8:	c3                   	ret    

008003f9 <exit>:

void
exit(void)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ff:	e8 7c 15 00 00       	call   801980 <sys_exit_env>
}
  800404:	90                   	nop
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80040d:	8d 45 10             	lea    0x10(%ebp),%eax
  800410:	83 c0 04             	add    $0x4,%eax
  800413:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800416:	a1 58 a2 82 00       	mov    0x82a258,%eax
  80041b:	85 c0                	test   %eax,%eax
  80041d:	74 16                	je     800435 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80041f:	a1 58 a2 82 00       	mov    0x82a258,%eax
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	50                   	push   %eax
  800428:	68 34 22 80 00       	push   $0x802234
  80042d:	e8 89 02 00 00       	call   8006bb <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800435:	a1 00 30 80 00       	mov    0x803000,%eax
  80043a:	ff 75 0c             	pushl  0xc(%ebp)
  80043d:	ff 75 08             	pushl  0x8(%ebp)
  800440:	50                   	push   %eax
  800441:	68 39 22 80 00       	push   $0x802239
  800446:	e8 70 02 00 00       	call   8006bb <cprintf>
  80044b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80044e:	8b 45 10             	mov    0x10(%ebp),%eax
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 f4             	pushl  -0xc(%ebp)
  800457:	50                   	push   %eax
  800458:	e8 f3 01 00 00       	call   800650 <vcprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	6a 00                	push   $0x0
  800465:	68 55 22 80 00       	push   $0x802255
  80046a:	e8 e1 01 00 00       	call   800650 <vcprintf>
  80046f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800472:	e8 82 ff ff ff       	call   8003f9 <exit>

	// should not return here
	while (1) ;
  800477:	eb fe                	jmp    800477 <_panic+0x70>

00800479 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80047f:	a1 20 30 80 00       	mov    0x803020,%eax
  800484:	8b 50 74             	mov    0x74(%eax),%edx
  800487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048a:	39 c2                	cmp    %eax,%edx
  80048c:	74 14                	je     8004a2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	68 58 22 80 00       	push   $0x802258
  800496:	6a 26                	push   $0x26
  800498:	68 a4 22 80 00       	push   $0x8022a4
  80049d:	e8 65 ff ff ff       	call   800407 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004b0:	e9 c2 00 00 00       	jmp    800577 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	01 d0                	add    %edx,%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	85 c0                	test   %eax,%eax
  8004c8:	75 08                	jne    8004d2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004ca:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004cd:	e9 a2 00 00 00       	jmp    800574 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004e0:	eb 69                	jmp    80054b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e7:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  8004ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f0:	89 d0                	mov    %edx,%eax
  8004f2:	01 c0                	add    %eax,%eax
  8004f4:	01 d0                	add    %edx,%eax
  8004f6:	c1 e0 03             	shl    $0x3,%eax
  8004f9:	01 c8                	add    %ecx,%eax
  8004fb:	8a 40 04             	mov    0x4(%eax),%al
  8004fe:	84 c0                	test   %al,%al
  800500:	75 46                	jne    800548 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800502:	a1 20 30 80 00       	mov    0x803020,%eax
  800507:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80050d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800510:	89 d0                	mov    %edx,%eax
  800512:	01 c0                	add    %eax,%eax
  800514:	01 d0                	add    %edx,%eax
  800516:	c1 e0 03             	shl    $0x3,%eax
  800519:	01 c8                	add    %ecx,%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800520:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800523:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800528:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80052a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	01 c8                	add    %ecx,%eax
  800539:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	75 09                	jne    800548 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80053f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800546:	eb 12                	jmp    80055a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800548:	ff 45 e8             	incl   -0x18(%ebp)
  80054b:	a1 20 30 80 00       	mov    0x803020,%eax
  800550:	8b 50 74             	mov    0x74(%eax),%edx
  800553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800556:	39 c2                	cmp    %eax,%edx
  800558:	77 88                	ja     8004e2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80055a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80055e:	75 14                	jne    800574 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800560:	83 ec 04             	sub    $0x4,%esp
  800563:	68 b0 22 80 00       	push   $0x8022b0
  800568:	6a 3a                	push   $0x3a
  80056a:	68 a4 22 80 00       	push   $0x8022a4
  80056f:	e8 93 fe ff ff       	call   800407 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800574:	ff 45 f0             	incl   -0x10(%ebp)
  800577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80057d:	0f 8c 32 ff ff ff    	jl     8004b5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800583:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800591:	eb 26                	jmp    8005b9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800593:	a1 20 30 80 00       	mov    0x803020,%eax
  800598:	8b 88 58 da 01 00    	mov    0x1da58(%eax),%ecx
  80059e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	01 c0                	add    %eax,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	c1 e0 03             	shl    $0x3,%eax
  8005aa:	01 c8                	add    %ecx,%eax
  8005ac:	8a 40 04             	mov    0x4(%eax),%al
  8005af:	3c 01                	cmp    $0x1,%al
  8005b1:	75 03                	jne    8005b6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005b3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b6:	ff 45 e0             	incl   -0x20(%ebp)
  8005b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005be:	8b 50 74             	mov    0x74(%eax),%edx
  8005c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c4:	39 c2                	cmp    %eax,%edx
  8005c6:	77 cb                	ja     800593 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005cb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005ce:	74 14                	je     8005e4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 04 23 80 00       	push   $0x802304
  8005d8:	6a 44                	push   $0x44
  8005da:	68 a4 22 80 00       	push   $0x8022a4
  8005df:	e8 23 fe ff ff       	call   800407 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005e4:	90                   	nop
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	8d 48 01             	lea    0x1(%eax),%ecx
  8005f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f8:	89 0a                	mov    %ecx,(%edx)
  8005fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8005fd:	88 d1                	mov    %dl,%cl
  8005ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800602:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800610:	75 2c                	jne    80063e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800612:	a0 24 30 80 00       	mov    0x803024,%al
  800617:	0f b6 c0             	movzbl %al,%eax
  80061a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061d:	8b 12                	mov    (%edx),%edx
  80061f:	89 d1                	mov    %edx,%ecx
  800621:	8b 55 0c             	mov    0xc(%ebp),%edx
  800624:	83 c2 08             	add    $0x8,%edx
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	50                   	push   %eax
  80062b:	51                   	push   %ecx
  80062c:	52                   	push   %edx
  80062d:	e8 7b 0f 00 00       	call   8015ad <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800635:	8b 45 0c             	mov    0xc(%ebp),%eax
  800638:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80063e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800641:	8b 40 04             	mov    0x4(%eax),%eax
  800644:	8d 50 01             	lea    0x1(%eax),%edx
  800647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80064d:	90                   	nop
  80064e:	c9                   	leave  
  80064f:	c3                   	ret    

00800650 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800659:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800660:	00 00 00 
	b.cnt = 0;
  800663:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80066a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80066d:	ff 75 0c             	pushl  0xc(%ebp)
  800670:	ff 75 08             	pushl  0x8(%ebp)
  800673:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800679:	50                   	push   %eax
  80067a:	68 e7 05 80 00       	push   $0x8005e7
  80067f:	e8 11 02 00 00       	call   800895 <vprintfmt>
  800684:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800687:	a0 24 30 80 00       	mov    0x803024,%al
  80068c:	0f b6 c0             	movzbl %al,%eax
  80068f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	50                   	push   %eax
  800699:	52                   	push   %edx
  80069a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a0:	83 c0 08             	add    $0x8,%eax
  8006a3:	50                   	push   %eax
  8006a4:	e8 04 0f 00 00       	call   8015ad <sys_cputs>
  8006a9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006ac:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8006b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006b9:	c9                   	leave  
  8006ba:	c3                   	ret    

008006bb <cprintf>:

int cprintf(const char *fmt, ...) {
  8006bb:	55                   	push   %ebp
  8006bc:	89 e5                	mov    %esp,%ebp
  8006be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006c1:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8006c8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d7:	50                   	push   %eax
  8006d8:	e8 73 ff ff ff       	call   800650 <vcprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006ee:	e8 68 10 00 00       	call   80175b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800702:	50                   	push   %eax
  800703:	e8 48 ff ff ff       	call   800650 <vcprintf>
  800708:	83 c4 10             	add    $0x10,%esp
  80070b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80070e:	e8 62 10 00 00       	call   801775 <sys_enable_interrupt>
	return cnt;
  800713:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	53                   	push   %ebx
  80071c:	83 ec 14             	sub    $0x14,%esp
  80071f:	8b 45 10             	mov    0x10(%ebp),%eax
  800722:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072b:	8b 45 18             	mov    0x18(%ebp),%eax
  80072e:	ba 00 00 00 00       	mov    $0x0,%edx
  800733:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800736:	77 55                	ja     80078d <printnum+0x75>
  800738:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073b:	72 05                	jb     800742 <printnum+0x2a>
  80073d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800740:	77 4b                	ja     80078d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800742:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800745:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800748:	8b 45 18             	mov    0x18(%ebp),%eax
  80074b:	ba 00 00 00 00       	mov    $0x0,%edx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	ff 75 f4             	pushl  -0xc(%ebp)
  800755:	ff 75 f0             	pushl  -0x10(%ebp)
  800758:	e8 83 14 00 00       	call   801be0 <__udivdi3>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	83 ec 04             	sub    $0x4,%esp
  800763:	ff 75 20             	pushl  0x20(%ebp)
  800766:	53                   	push   %ebx
  800767:	ff 75 18             	pushl  0x18(%ebp)
  80076a:	52                   	push   %edx
  80076b:	50                   	push   %eax
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 08             	pushl  0x8(%ebp)
  800772:	e8 a1 ff ff ff       	call   800718 <printnum>
  800777:	83 c4 20             	add    $0x20,%esp
  80077a:	eb 1a                	jmp    800796 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	ff 75 0c             	pushl  0xc(%ebp)
  800782:	ff 75 20             	pushl  0x20(%ebp)
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	ff d0                	call   *%eax
  80078a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078d:	ff 4d 1c             	decl   0x1c(%ebp)
  800790:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800794:	7f e6                	jg     80077c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800796:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800799:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a4:	53                   	push   %ebx
  8007a5:	51                   	push   %ecx
  8007a6:	52                   	push   %edx
  8007a7:	50                   	push   %eax
  8007a8:	e8 43 15 00 00       	call   801cf0 <__umoddi3>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	05 74 25 80 00       	add    $0x802574,%eax
  8007b5:	8a 00                	mov    (%eax),%al
  8007b7:	0f be c0             	movsbl %al,%eax
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	50                   	push   %eax
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	ff d0                	call   *%eax
  8007c6:	83 c4 10             	add    $0x10,%esp
}
  8007c9:	90                   	nop
  8007ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d6:	7e 1c                	jle    8007f4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 08             	lea    0x8(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 08             	sub    $0x8,%eax
  8007ed:	8b 50 04             	mov    0x4(%eax),%edx
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	eb 40                	jmp    800834 <getuint+0x65>
	else if (lflag)
  8007f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f8:	74 1e                	je     800818 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	8d 50 04             	lea    0x4(%eax),%edx
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	89 10                	mov    %edx,(%eax)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	eb 1c                	jmp    800834 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	8d 50 04             	lea    0x4(%eax),%edx
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	89 10                	mov    %edx,(%eax)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800839:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80083d:	7e 1c                	jle    80085b <getint+0x25>
		return va_arg(*ap, long long);
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	8d 50 08             	lea    0x8(%eax),%edx
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	89 10                	mov    %edx,(%eax)
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	83 e8 08             	sub    $0x8,%eax
  800854:	8b 50 04             	mov    0x4(%eax),%edx
  800857:	8b 00                	mov    (%eax),%eax
  800859:	eb 38                	jmp    800893 <getint+0x5d>
	else if (lflag)
  80085b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80085f:	74 1a                	je     80087b <getint+0x45>
		return va_arg(*ap, long);
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	8d 50 04             	lea    0x4(%eax),%edx
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	89 10                	mov    %edx,(%eax)
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	83 e8 04             	sub    $0x4,%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	99                   	cltd   
  800879:	eb 18                	jmp    800893 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	8d 50 04             	lea    0x4(%eax),%edx
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	89 10                	mov    %edx,(%eax)
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	83 e8 04             	sub    $0x4,%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	99                   	cltd   
}
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	56                   	push   %esi
  800899:	53                   	push   %ebx
  80089a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089d:	eb 17                	jmp    8008b6 <vprintfmt+0x21>
			if (ch == '\0')
  80089f:	85 db                	test   %ebx,%ebx
  8008a1:	0f 84 af 03 00 00    	je     800c56 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	ff 75 0c             	pushl  0xc(%ebp)
  8008ad:	53                   	push   %ebx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	ff d0                	call   *%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b9:	8d 50 01             	lea    0x1(%eax),%edx
  8008bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f b6 d8             	movzbl %al,%ebx
  8008c4:	83 fb 25             	cmp    $0x25,%ebx
  8008c7:	75 d6                	jne    80089f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008cd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ec:	8d 50 01             	lea    0x1(%eax),%edx
  8008ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f2:	8a 00                	mov    (%eax),%al
  8008f4:	0f b6 d8             	movzbl %al,%ebx
  8008f7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008fa:	83 f8 55             	cmp    $0x55,%eax
  8008fd:	0f 87 2b 03 00 00    	ja     800c2e <vprintfmt+0x399>
  800903:	8b 04 85 98 25 80 00 	mov    0x802598(,%eax,4),%eax
  80090a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80090c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800910:	eb d7                	jmp    8008e9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800912:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800916:	eb d1                	jmp    8008e9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800918:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80091f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800922:	89 d0                	mov    %edx,%eax
  800924:	c1 e0 02             	shl    $0x2,%eax
  800927:	01 d0                	add    %edx,%eax
  800929:	01 c0                	add    %eax,%eax
  80092b:	01 d8                	add    %ebx,%eax
  80092d:	83 e8 30             	sub    $0x30,%eax
  800930:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800933:	8b 45 10             	mov    0x10(%ebp),%eax
  800936:	8a 00                	mov    (%eax),%al
  800938:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093b:	83 fb 2f             	cmp    $0x2f,%ebx
  80093e:	7e 3e                	jle    80097e <vprintfmt+0xe9>
  800940:	83 fb 39             	cmp    $0x39,%ebx
  800943:	7f 39                	jg     80097e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800945:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800948:	eb d5                	jmp    80091f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	83 c0 04             	add    $0x4,%eax
  800950:	89 45 14             	mov    %eax,0x14(%ebp)
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	83 e8 04             	sub    $0x4,%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80095e:	eb 1f                	jmp    80097f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800960:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800964:	79 83                	jns    8008e9 <vprintfmt+0x54>
				width = 0;
  800966:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80096d:	e9 77 ff ff ff       	jmp    8008e9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800972:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800979:	e9 6b ff ff ff       	jmp    8008e9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80097e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80097f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800983:	0f 89 60 ff ff ff    	jns    8008e9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800989:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80098f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800996:	e9 4e ff ff ff       	jmp    8008e9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80099e:	e9 46 ff ff ff       	jmp    8008e9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	83 c0 04             	add    $0x4,%eax
  8009a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8009af:	83 e8 04             	sub    $0x4,%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	50                   	push   %eax
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	ff d0                	call   *%eax
  8009c0:	83 c4 10             	add    $0x10,%esp
			break;
  8009c3:	e9 89 02 00 00       	jmp    800c51 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	83 c0 04             	add    $0x4,%eax
  8009ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	83 e8 04             	sub    $0x4,%eax
  8009d7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009d9:	85 db                	test   %ebx,%ebx
  8009db:	79 02                	jns    8009df <vprintfmt+0x14a>
				err = -err;
  8009dd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009df:	83 fb 64             	cmp    $0x64,%ebx
  8009e2:	7f 0b                	jg     8009ef <vprintfmt+0x15a>
  8009e4:	8b 34 9d e0 23 80 00 	mov    0x8023e0(,%ebx,4),%esi
  8009eb:	85 f6                	test   %esi,%esi
  8009ed:	75 19                	jne    800a08 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009ef:	53                   	push   %ebx
  8009f0:	68 85 25 80 00       	push   $0x802585
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	ff 75 08             	pushl  0x8(%ebp)
  8009fb:	e8 5e 02 00 00       	call   800c5e <printfmt>
  800a00:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a03:	e9 49 02 00 00       	jmp    800c51 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a08:	56                   	push   %esi
  800a09:	68 8e 25 80 00       	push   $0x80258e
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	ff 75 08             	pushl  0x8(%ebp)
  800a14:	e8 45 02 00 00       	call   800c5e <printfmt>
  800a19:	83 c4 10             	add    $0x10,%esp
			break;
  800a1c:	e9 30 02 00 00       	jmp    800c51 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	83 c0 04             	add    $0x4,%eax
  800a27:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	83 e8 04             	sub    $0x4,%eax
  800a30:	8b 30                	mov    (%eax),%esi
  800a32:	85 f6                	test   %esi,%esi
  800a34:	75 05                	jne    800a3b <vprintfmt+0x1a6>
				p = "(null)";
  800a36:	be 91 25 80 00       	mov    $0x802591,%esi
			if (width > 0 && padc != '-')
  800a3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3f:	7e 6d                	jle    800aae <vprintfmt+0x219>
  800a41:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a45:	74 67                	je     800aae <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	50                   	push   %eax
  800a4e:	56                   	push   %esi
  800a4f:	e8 0c 03 00 00       	call   800d60 <strnlen>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a5a:	eb 16                	jmp    800a72 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a5c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	ff 75 0c             	pushl  0xc(%ebp)
  800a66:	50                   	push   %eax
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a76:	7f e4                	jg     800a5c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a78:	eb 34                	jmp    800aae <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a7e:	74 1c                	je     800a9c <vprintfmt+0x207>
  800a80:	83 fb 1f             	cmp    $0x1f,%ebx
  800a83:	7e 05                	jle    800a8a <vprintfmt+0x1f5>
  800a85:	83 fb 7e             	cmp    $0x7e,%ebx
  800a88:	7e 12                	jle    800a9c <vprintfmt+0x207>
					putch('?', putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	6a 3f                	push   $0x3f
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	ff d0                	call   *%eax
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	eb 0f                	jmp    800aab <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	53                   	push   %ebx
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	ff d0                	call   *%eax
  800aa8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aab:	ff 4d e4             	decl   -0x1c(%ebp)
  800aae:	89 f0                	mov    %esi,%eax
  800ab0:	8d 70 01             	lea    0x1(%eax),%esi
  800ab3:	8a 00                	mov    (%eax),%al
  800ab5:	0f be d8             	movsbl %al,%ebx
  800ab8:	85 db                	test   %ebx,%ebx
  800aba:	74 24                	je     800ae0 <vprintfmt+0x24b>
  800abc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac0:	78 b8                	js     800a7a <vprintfmt+0x1e5>
  800ac2:	ff 4d e0             	decl   -0x20(%ebp)
  800ac5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac9:	79 af                	jns    800a7a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acb:	eb 13                	jmp    800ae0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	6a 20                	push   $0x20
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	ff d0                	call   *%eax
  800ada:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800add:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae4:	7f e7                	jg     800acd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae6:	e9 66 01 00 00       	jmp    800c51 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 e8             	pushl  -0x18(%ebp)
  800af1:	8d 45 14             	lea    0x14(%ebp),%eax
  800af4:	50                   	push   %eax
  800af5:	e8 3c fd ff ff       	call   800836 <getint>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b09:	85 d2                	test   %edx,%edx
  800b0b:	79 23                	jns    800b30 <vprintfmt+0x29b>
				putch('-', putdat);
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	6a 2d                	push   $0x2d
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	ff d0                	call   *%eax
  800b1a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b23:	f7 d8                	neg    %eax
  800b25:	83 d2 00             	adc    $0x0,%edx
  800b28:	f7 da                	neg    %edx
  800b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b30:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b37:	e9 bc 00 00 00       	jmp    800bf8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 84 fc ff ff       	call   8007cf <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b54:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5b:	e9 98 00 00 00       	jmp    800bf8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	6a 58                	push   $0x58
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	ff d0                	call   *%eax
  800b6d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 0c             	pushl  0xc(%ebp)
  800b76:	6a 58                	push   $0x58
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	ff d0                	call   *%eax
  800b7d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 58                	push   $0x58
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			break;
  800b90:	e9 bc 00 00 00       	jmp    800c51 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 30                	push   $0x30
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 78                	push   $0x78
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb8:	83 c0 04             	add    $0x4,%eax
  800bbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bd0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd7:	eb 1f                	jmp    800bf8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdf:	8d 45 14             	lea    0x14(%ebp),%eax
  800be2:	50                   	push   %eax
  800be3:	e8 e7 fb ff ff       	call   8007cf <getuint>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bff:	83 ec 04             	sub    $0x4,%esp
  800c02:	52                   	push   %edx
  800c03:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c06:	50                   	push   %eax
  800c07:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	ff 75 08             	pushl  0x8(%ebp)
  800c13:	e8 00 fb ff ff       	call   800718 <printnum>
  800c18:	83 c4 20             	add    $0x20,%esp
			break;
  800c1b:	eb 34                	jmp    800c51 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	53                   	push   %ebx
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	ff d0                	call   *%eax
  800c29:	83 c4 10             	add    $0x10,%esp
			break;
  800c2c:	eb 23                	jmp    800c51 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	6a 25                	push   $0x25
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	ff d0                	call   *%eax
  800c3b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c3e:	ff 4d 10             	decl   0x10(%ebp)
  800c41:	eb 03                	jmp    800c46 <vprintfmt+0x3b1>
  800c43:	ff 4d 10             	decl   0x10(%ebp)
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	48                   	dec    %eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	3c 25                	cmp    $0x25,%al
  800c4e:	75 f3                	jne    800c43 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c50:	90                   	nop
		}
	}
  800c51:	e9 47 fc ff ff       	jmp    80089d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c56:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    

00800c5e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c64:	8d 45 10             	lea    0x10(%ebp),%eax
  800c67:	83 c0 04             	add    $0x4,%eax
  800c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c70:	ff 75 f4             	pushl  -0xc(%ebp)
  800c73:	50                   	push   %eax
  800c74:	ff 75 0c             	pushl  0xc(%ebp)
  800c77:	ff 75 08             	pushl  0x8(%ebp)
  800c7a:	e8 16 fc ff ff       	call   800895 <vprintfmt>
  800c7f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c82:	90                   	nop
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	8b 40 08             	mov    0x8(%eax),%eax
  800c8e:	8d 50 01             	lea    0x1(%eax),%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	8b 10                	mov    (%eax),%edx
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	8b 40 04             	mov    0x4(%eax),%eax
  800ca2:	39 c2                	cmp    %eax,%edx
  800ca4:	73 12                	jae    800cb8 <sprintputch+0x33>
		*b->buf++ = ch;
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8b 00                	mov    (%eax),%eax
  800cab:	8d 48 01             	lea    0x1(%eax),%ecx
  800cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb1:	89 0a                	mov    %ecx,(%edx)
  800cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb6:	88 10                	mov    %dl,(%eax)
}
  800cb8:	90                   	nop
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ce0:	74 06                	je     800ce8 <vsnprintf+0x2d>
  800ce2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce6:	7f 07                	jg     800cef <vsnprintf+0x34>
		return -E_INVAL;
  800ce8:	b8 03 00 00 00       	mov    $0x3,%eax
  800ced:	eb 20                	jmp    800d0f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cef:	ff 75 14             	pushl  0x14(%ebp)
  800cf2:	ff 75 10             	pushl  0x10(%ebp)
  800cf5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cf8:	50                   	push   %eax
  800cf9:	68 85 0c 80 00       	push   $0x800c85
  800cfe:	e8 92 fb ff ff       	call   800895 <vprintfmt>
  800d03:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d09:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d0f:	c9                   	leave  
  800d10:	c3                   	ret    

00800d11 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d17:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1a:	83 c0 04             	add    $0x4,%eax
  800d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	ff 75 f4             	pushl  -0xc(%ebp)
  800d26:	50                   	push   %eax
  800d27:	ff 75 0c             	pushl  0xc(%ebp)
  800d2a:	ff 75 08             	pushl  0x8(%ebp)
  800d2d:	e8 89 ff ff ff       	call   800cbb <vsnprintf>
  800d32:	83 c4 10             	add    $0x10,%esp
  800d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d4a:	eb 06                	jmp    800d52 <strlen+0x15>
		n++;
  800d4c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4f:	ff 45 08             	incl   0x8(%ebp)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	84 c0                	test   %al,%al
  800d59:	75 f1                	jne    800d4c <strlen+0xf>
		n++;
	return n;
  800d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d6d:	eb 09                	jmp    800d78 <strnlen+0x18>
		n++;
  800d6f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	ff 4d 0c             	decl   0xc(%ebp)
  800d78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7c:	74 09                	je     800d87 <strnlen+0x27>
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	84 c0                	test   %al,%al
  800d85:	75 e8                	jne    800d6f <strnlen+0xf>
		n++;
	return n;
  800d87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d98:	90                   	nop
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8d 50 01             	lea    0x1(%eax),%edx
  800d9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dab:	8a 12                	mov    (%edx),%dl
  800dad:	88 10                	mov    %dl,(%eax)
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	84 c0                	test   %al,%al
  800db3:	75 e4                	jne    800d99 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcd:	eb 1f                	jmp    800dee <strncpy+0x34>
		*dst++ = *src;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8d 50 01             	lea    0x1(%eax),%edx
  800dd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddb:	8a 12                	mov    (%edx),%dl
  800ddd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	84 c0                	test   %al,%al
  800de6:	74 03                	je     800deb <strncpy+0x31>
			src++;
  800de8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800deb:	ff 45 fc             	incl   -0x4(%ebp)
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df4:	72 d9                	jb     800dcf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0b:	74 30                	je     800e3d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e0d:	eb 16                	jmp    800e25 <strlcpy+0x2a>
			*dst++ = *src++;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8d 50 01             	lea    0x1(%eax),%edx
  800e15:	89 55 08             	mov    %edx,0x8(%ebp)
  800e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e21:	8a 12                	mov    (%edx),%dl
  800e23:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e25:	ff 4d 10             	decl   0x10(%ebp)
  800e28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2c:	74 09                	je     800e37 <strlcpy+0x3c>
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 d8                	jne    800e0f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e4c:	eb 06                	jmp    800e54 <strcmp+0xb>
		p++, q++;
  800e4e:	ff 45 08             	incl   0x8(%ebp)
  800e51:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	84 c0                	test   %al,%al
  800e5b:	74 0e                	je     800e6b <strcmp+0x22>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 10                	mov    (%eax),%dl
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	38 c2                	cmp    %al,%dl
  800e69:	74 e3                	je     800e4e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	0f b6 d0             	movzbl %al,%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	0f b6 c0             	movzbl %al,%eax
  800e7b:	29 c2                	sub    %eax,%edx
  800e7d:	89 d0                	mov    %edx,%eax
}
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e84:	eb 09                	jmp    800e8f <strncmp+0xe>
		n--, p++, q++;
  800e86:	ff 4d 10             	decl   0x10(%ebp)
  800e89:	ff 45 08             	incl   0x8(%ebp)
  800e8c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e93:	74 17                	je     800eac <strncmp+0x2b>
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	74 0e                	je     800eac <strncmp+0x2b>
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8a 10                	mov    (%eax),%dl
  800ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	38 c2                	cmp    %al,%dl
  800eaa:	74 da                	je     800e86 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb0:	75 07                	jne    800eb9 <strncmp+0x38>
		return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb7:	eb 14                	jmp    800ecd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	0f b6 d0             	movzbl %al,%edx
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	0f b6 c0             	movzbl %al,%eax
  800ec9:	29 c2                	sub    %eax,%edx
  800ecb:	89 d0                	mov    %edx,%eax
}
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800edb:	eb 12                	jmp    800eef <strchr+0x20>
		if (*s == c)
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee5:	75 05                	jne    800eec <strchr+0x1d>
			return (char *) s;
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	eb 11                	jmp    800efd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eec:	ff 45 08             	incl   0x8(%ebp)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 e5                	jne    800edd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 04             	sub    $0x4,%esp
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f0b:	eb 0d                	jmp    800f1a <strfind+0x1b>
		if (*s == c)
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f15:	74 0e                	je     800f25 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f17:	ff 45 08             	incl   0x8(%ebp)
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	84 c0                	test   %al,%al
  800f21:	75 ea                	jne    800f0d <strfind+0xe>
  800f23:	eb 01                	jmp    800f26 <strfind+0x27>
		if (*s == c)
			break;
  800f25:	90                   	nop
	return (char *) s;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f3d:	eb 0e                	jmp    800f4d <memset+0x22>
		*p++ = c;
  800f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f42:	8d 50 01             	lea    0x1(%eax),%edx
  800f45:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f4d:	ff 4d f8             	decl   -0x8(%ebp)
  800f50:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f54:	79 e9                	jns    800f3f <memset+0x14>
		*p++ = c;

	return v;
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f59:	c9                   	leave  
  800f5a:	c3                   	ret    

00800f5b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f6d:	eb 16                	jmp    800f85 <memcpy+0x2a>
		*d++ = *s++;
  800f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f72:	8d 50 01             	lea    0x1(%eax),%edx
  800f75:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f81:	8a 12                	mov    (%edx),%dl
  800f83:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	75 dd                	jne    800f6f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800faf:	73 50                	jae    801001 <memmove+0x6a>
  800fb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	01 d0                	add    %edx,%eax
  800fb9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbc:	76 43                	jbe    801001 <memmove+0x6a>
		s += n;
  800fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fca:	eb 10                	jmp    800fdc <memmove+0x45>
			*--d = *--s;
  800fcc:	ff 4d f8             	decl   -0x8(%ebp)
  800fcf:	ff 4d fc             	decl   -0x4(%ebp)
  800fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd5:	8a 10                	mov    (%eax),%dl
  800fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fda:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	75 e3                	jne    800fcc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fe9:	eb 23                	jmp    80100e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800feb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fee:	8d 50 01             	lea    0x1(%eax),%edx
  800ff1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ffd:	8a 12                	mov    (%edx),%dl
  800fff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	8d 50 ff             	lea    -0x1(%eax),%edx
  801007:	89 55 10             	mov    %edx,0x10(%ebp)
  80100a:	85 c0                	test   %eax,%eax
  80100c:	75 dd                	jne    800feb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801011:	c9                   	leave  
  801012:	c3                   	ret    

00801013 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801025:	eb 2a                	jmp    801051 <memcmp+0x3e>
		if (*s1 != *s2)
  801027:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102a:	8a 10                	mov    (%eax),%dl
  80102c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	38 c2                	cmp    %al,%dl
  801033:	74 16                	je     80104b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	0f b6 d0             	movzbl %al,%edx
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	0f b6 c0             	movzbl %al,%eax
  801045:	29 c2                	sub    %eax,%edx
  801047:	89 d0                	mov    %edx,%eax
  801049:	eb 18                	jmp    801063 <memcmp+0x50>
		s1++, s2++;
  80104b:	ff 45 fc             	incl   -0x4(%ebp)
  80104e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	89 55 10             	mov    %edx,0x10(%ebp)
  80105a:	85 c0                	test   %eax,%eax
  80105c:	75 c9                	jne    801027 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	01 d0                	add    %edx,%eax
  801073:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801076:	eb 15                	jmp    80108d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	0f b6 d0             	movzbl %al,%edx
  801080:	8b 45 0c             	mov    0xc(%ebp),%eax
  801083:	0f b6 c0             	movzbl %al,%eax
  801086:	39 c2                	cmp    %eax,%edx
  801088:	74 0d                	je     801097 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108a:	ff 45 08             	incl   0x8(%ebp)
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801093:	72 e3                	jb     801078 <memfind+0x13>
  801095:	eb 01                	jmp    801098 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801097:	90                   	nop
	return (void *) s;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109b:	c9                   	leave  
  80109c:	c3                   	ret    

0080109d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b1:	eb 03                	jmp    8010b6 <strtol+0x19>
		s++;
  8010b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	3c 20                	cmp    $0x20,%al
  8010bd:	74 f4                	je     8010b3 <strtol+0x16>
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	3c 09                	cmp    $0x9,%al
  8010c6:	74 eb                	je     8010b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	3c 2b                	cmp    $0x2b,%al
  8010cf:	75 05                	jne    8010d6 <strtol+0x39>
		s++;
  8010d1:	ff 45 08             	incl   0x8(%ebp)
  8010d4:	eb 13                	jmp    8010e9 <strtol+0x4c>
	else if (*s == '-')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 2d                	cmp    $0x2d,%al
  8010dd:	75 0a                	jne    8010e9 <strtol+0x4c>
		s++, neg = 1;
  8010df:	ff 45 08             	incl   0x8(%ebp)
  8010e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ed:	74 06                	je     8010f5 <strtol+0x58>
  8010ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f3:	75 20                	jne    801115 <strtol+0x78>
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 30                	cmp    $0x30,%al
  8010fc:	75 17                	jne    801115 <strtol+0x78>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	40                   	inc    %eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	3c 78                	cmp    $0x78,%al
  801106:	75 0d                	jne    801115 <strtol+0x78>
		s += 2, base = 16;
  801108:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801113:	eb 28                	jmp    80113d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801115:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801119:	75 15                	jne    801130 <strtol+0x93>
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	3c 30                	cmp    $0x30,%al
  801122:	75 0c                	jne    801130 <strtol+0x93>
		s++, base = 8;
  801124:	ff 45 08             	incl   0x8(%ebp)
  801127:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112e:	eb 0d                	jmp    80113d <strtol+0xa0>
	else if (base == 0)
  801130:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801134:	75 07                	jne    80113d <strtol+0xa0>
		base = 10;
  801136:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	3c 2f                	cmp    $0x2f,%al
  801144:	7e 19                	jle    80115f <strtol+0xc2>
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	3c 39                	cmp    $0x39,%al
  80114d:	7f 10                	jg     80115f <strtol+0xc2>
			dig = *s - '0';
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	0f be c0             	movsbl %al,%eax
  801157:	83 e8 30             	sub    $0x30,%eax
  80115a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115d:	eb 42                	jmp    8011a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 60                	cmp    $0x60,%al
  801166:	7e 19                	jle    801181 <strtol+0xe4>
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 7a                	cmp    $0x7a,%al
  80116f:	7f 10                	jg     801181 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	0f be c0             	movsbl %al,%eax
  801179:	83 e8 57             	sub    $0x57,%eax
  80117c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117f:	eb 20                	jmp    8011a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 40                	cmp    $0x40,%al
  801188:	7e 39                	jle    8011c3 <strtol+0x126>
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 5a                	cmp    $0x5a,%al
  801191:	7f 30                	jg     8011c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f be c0             	movsbl %al,%eax
  80119b:	83 e8 37             	sub    $0x37,%eax
  80119e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a7:	7d 19                	jge    8011c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011a9:	ff 45 08             	incl   0x8(%ebp)
  8011ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b3:	89 c2                	mov    %eax,%edx
  8011b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b8:	01 d0                	add    %edx,%eax
  8011ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011bd:	e9 7b ff ff ff       	jmp    80113d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c7:	74 08                	je     8011d1 <strtol+0x134>
		*endptr = (char *) s;
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d5:	74 07                	je     8011de <strtol+0x141>
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011da:	f7 d8                	neg    %eax
  8011dc:	eb 03                	jmp    8011e1 <strtol+0x144>
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fb:	79 13                	jns    801210 <ltostr+0x2d>
	{
		neg = 1;
  8011fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801218:	99                   	cltd   
  801219:	f7 f9                	idiv   %ecx
  80121b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	01 d0                	add    %edx,%eax
  80122e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801231:	83 c2 30             	add    $0x30,%edx
  801234:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801236:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801239:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123e:	f7 e9                	imul   %ecx
  801240:	c1 fa 02             	sar    $0x2,%edx
  801243:	89 c8                	mov    %ecx,%eax
  801245:	c1 f8 1f             	sar    $0x1f,%eax
  801248:	29 c2                	sub    %eax,%edx
  80124a:	89 d0                	mov    %edx,%eax
  80124c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80124f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801252:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801257:	f7 e9                	imul   %ecx
  801259:	c1 fa 02             	sar    $0x2,%edx
  80125c:	89 c8                	mov    %ecx,%eax
  80125e:	c1 f8 1f             	sar    $0x1f,%eax
  801261:	29 c2                	sub    %eax,%edx
  801263:	89 d0                	mov    %edx,%eax
  801265:	c1 e0 02             	shl    $0x2,%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	01 c0                	add    %eax,%eax
  80126c:	29 c1                	sub    %eax,%ecx
  80126e:	89 ca                	mov    %ecx,%edx
  801270:	85 d2                	test   %edx,%edx
  801272:	75 9c                	jne    801210 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801274:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	48                   	dec    %eax
  80127f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801282:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801286:	74 3d                	je     8012c5 <ltostr+0xe2>
		start = 1 ;
  801288:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80128f:	eb 34                	jmp    8012c5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801294:	8b 45 0c             	mov    0xc(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	8a 00                	mov    (%eax),%al
  80129b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80129e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 c2                	add    %eax,%edx
  8012a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	01 c8                	add    %ecx,%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	01 c2                	add    %eax,%edx
  8012ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8012bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012cb:	7c c4                	jl     801291 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d3:	01 d0                	add    %edx,%eax
  8012d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012d8:	90                   	nop
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e1:	ff 75 08             	pushl  0x8(%ebp)
  8012e4:	e8 54 fa ff ff       	call   800d3d <strlen>
  8012e9:	83 c4 04             	add    $0x4,%esp
  8012ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	e8 46 fa ff ff       	call   800d3d <strlen>
  8012f7:	83 c4 04             	add    $0x4,%esp
  8012fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130b:	eb 17                	jmp    801324 <strcconcat+0x49>
		final[s] = str1[s] ;
  80130d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	01 c8                	add    %ecx,%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801321:	ff 45 fc             	incl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80132a:	7c e1                	jl     80130d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80132c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80133a:	eb 1f                	jmp    80135b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133f:	8d 50 01             	lea    0x1(%eax),%edx
  801342:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801345:	89 c2                	mov    %eax,%edx
  801347:	8b 45 10             	mov    0x10(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	01 c8                	add    %ecx,%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801358:	ff 45 f8             	incl   -0x8(%ebp)
  80135b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801361:	7c d9                	jl     80133c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801363:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801366:	8b 45 10             	mov    0x10(%ebp),%eax
  801369:	01 d0                	add    %edx,%eax
  80136b:	c6 00 00             	movb   $0x0,(%eax)
}
  80136e:	90                   	nop
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801374:	8b 45 14             	mov    0x14(%ebp),%eax
  801377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80137d:	8b 45 14             	mov    0x14(%ebp),%eax
  801380:	8b 00                	mov    (%eax),%eax
  801382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801394:	eb 0c                	jmp    8013a2 <strsplit+0x31>
			*string++ = 0;
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8d 50 01             	lea    0x1(%eax),%edx
  80139c:	89 55 08             	mov    %edx,0x8(%ebp)
  80139f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	84 c0                	test   %al,%al
  8013a9:	74 18                	je     8013c3 <strsplit+0x52>
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	0f be c0             	movsbl %al,%eax
  8013b3:	50                   	push   %eax
  8013b4:	ff 75 0c             	pushl  0xc(%ebp)
  8013b7:	e8 13 fb ff ff       	call   800ecf <strchr>
  8013bc:	83 c4 08             	add    $0x8,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 d3                	jne    801396 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	84 c0                	test   %al,%al
  8013ca:	74 5a                	je     801426 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cf:	8b 00                	mov    (%eax),%eax
  8013d1:	83 f8 0f             	cmp    $0xf,%eax
  8013d4:	75 07                	jne    8013dd <strsplit+0x6c>
		{
			return 0;
  8013d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013db:	eb 66                	jmp    801443 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e0:	8b 00                	mov    (%eax),%eax
  8013e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e5:	8b 55 14             	mov    0x14(%ebp),%edx
  8013e8:	89 0a                	mov    %ecx,(%edx)
  8013ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 c2                	add    %eax,%edx
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fb:	eb 03                	jmp    801400 <strsplit+0x8f>
			string++;
  8013fd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	74 8b                	je     801394 <strsplit+0x23>
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	0f be c0             	movsbl %al,%eax
  801411:	50                   	push   %eax
  801412:	ff 75 0c             	pushl  0xc(%ebp)
  801415:	e8 b5 fa ff ff       	call   800ecf <strchr>
  80141a:	83 c4 08             	add    $0x8,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	74 dc                	je     8013fd <strsplit+0x8c>
			string++;
	}
  801421:	e9 6e ff ff ff       	jmp    801394 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801426:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801427:	8b 45 14             	mov    0x14(%ebp),%eax
  80142a:	8b 00                	mov    (%eax),%eax
  80142c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801433:	8b 45 10             	mov    0x10(%ebp),%eax
  801436:	01 d0                	add    %edx,%eax
  801438:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80143e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  80144b:	83 ec 04             	sub    $0x4,%esp
  80144e:	68 f0 26 80 00       	push   $0x8026f0
  801453:	6a 0e                	push   $0xe
  801455:	68 2a 27 80 00       	push   $0x80272a
  80145a:	e8 a8 ef ff ff       	call   800407 <_panic>

0080145f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801465:	a1 04 30 80 00       	mov    0x803004,%eax
  80146a:	85 c0                	test   %eax,%eax
  80146c:	74 0f                	je     80147d <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80146e:	e8 d2 ff ff ff       	call   801445 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801473:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80147a:	00 00 00 
	}
	if (size == 0) return NULL ;
  80147d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801481:	75 07                	jne    80148a <malloc+0x2b>
  801483:	b8 00 00 00 00       	mov    $0x0,%eax
  801488:	eb 14                	jmp    80149e <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	68 38 27 80 00       	push   $0x802738
  801492:	6a 2e                	push   $0x2e
  801494:	68 2a 27 80 00       	push   $0x80272a
  801499:	e8 69 ef ff ff       	call   800407 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	68 60 27 80 00       	push   $0x802760
  8014ae:	6a 49                	push   $0x49
  8014b0:	68 2a 27 80 00       	push   $0x80272a
  8014b5:	e8 4d ef ff ff       	call   800407 <_panic>

008014ba <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 18             	sub    $0x18,%esp
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	68 84 27 80 00       	push   $0x802784
  8014ce:	6a 57                	push   $0x57
  8014d0:	68 2a 27 80 00       	push   $0x80272a
  8014d5:	e8 2d ef ff ff       	call   800407 <_panic>

008014da <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 ac 27 80 00       	push   $0x8027ac
  8014e8:	6a 60                	push   $0x60
  8014ea:	68 2a 27 80 00       	push   $0x80272a
  8014ef:	e8 13 ef ff ff       	call   800407 <_panic>

008014f4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014fa:	83 ec 04             	sub    $0x4,%esp
  8014fd:	68 d0 27 80 00       	push   $0x8027d0
  801502:	6a 7c                	push   $0x7c
  801504:	68 2a 27 80 00       	push   $0x80272a
  801509:	e8 f9 ee ff ff       	call   800407 <_panic>

0080150e <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	68 f8 27 80 00       	push   $0x8027f8
  80151c:	68 86 00 00 00       	push   $0x86
  801521:	68 2a 27 80 00       	push   $0x80272a
  801526:	e8 dc ee ff ff       	call   800407 <_panic>

0080152b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801531:	83 ec 04             	sub    $0x4,%esp
  801534:	68 1c 28 80 00       	push   $0x80281c
  801539:	68 91 00 00 00       	push   $0x91
  80153e:	68 2a 27 80 00       	push   $0x80272a
  801543:	e8 bf ee ff ff       	call   800407 <_panic>

00801548 <shrink>:

}
void shrink(uint32 newSize)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	68 1c 28 80 00       	push   $0x80281c
  801556:	68 96 00 00 00       	push   $0x96
  80155b:	68 2a 27 80 00       	push   $0x80272a
  801560:	e8 a2 ee ff ff       	call   800407 <_panic>

00801565 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	68 1c 28 80 00       	push   $0x80281c
  801573:	68 9b 00 00 00       	push   $0x9b
  801578:	68 2a 27 80 00       	push   $0x80272a
  80157d:	e8 85 ee ff ff       	call   800407 <_panic>

00801582 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	57                   	push   %edi
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801591:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801594:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801597:	8b 7d 18             	mov    0x18(%ebp),%edi
  80159a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80159d:	cd 30                	int    $0x30
  80159f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	5b                   	pop    %ebx
  8015a9:	5e                   	pop    %esi
  8015aa:	5f                   	pop    %edi
  8015ab:	5d                   	pop    %ebp
  8015ac:	c3                   	ret    

008015ad <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015b9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	52                   	push   %edx
  8015c5:	ff 75 0c             	pushl  0xc(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	6a 00                	push   $0x0
  8015cb:	e8 b2 ff ff ff       	call   801582 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 01                	push   $0x1
  8015e5:	e8 98 ff ff ff       	call   801582 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	52                   	push   %edx
  8015ff:	50                   	push   %eax
  801600:	6a 05                	push   $0x5
  801602:	e8 7b ff ff ff       	call   801582 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	56                   	push   %esi
  801610:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801611:	8b 75 18             	mov    0x18(%ebp),%esi
  801614:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801617:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80161a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	56                   	push   %esi
  801621:	53                   	push   %ebx
  801622:	51                   	push   %ecx
  801623:	52                   	push   %edx
  801624:	50                   	push   %eax
  801625:	6a 06                	push   $0x6
  801627:	e8 56 ff ff ff       	call   801582 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801632:	5b                   	pop    %ebx
  801633:	5e                   	pop    %esi
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	52                   	push   %edx
  801646:	50                   	push   %eax
  801647:	6a 07                	push   $0x7
  801649:	e8 34 ff ff ff       	call   801582 <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	ff 75 0c             	pushl  0xc(%ebp)
  80165f:	ff 75 08             	pushl  0x8(%ebp)
  801662:	6a 08                	push   $0x8
  801664:	e8 19 ff ff ff       	call   801582 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 09                	push   $0x9
  80167d:	e8 00 ff ff ff       	call   801582 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 0a                	push   $0xa
  801696:	e8 e7 fe ff ff       	call   801582 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 0b                	push   $0xb
  8016af:	e8 ce fe ff ff       	call   801582 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	ff 75 08             	pushl  0x8(%ebp)
  8016c8:	6a 0f                	push   $0xf
  8016ca:	e8 b3 fe ff ff       	call   801582 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
	return;
  8016d2:	90                   	nop
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	ff 75 08             	pushl  0x8(%ebp)
  8016e4:	6a 10                	push   $0x10
  8016e6:	e8 97 fe ff ff       	call   801582 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ee:	90                   	nop
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	ff 75 10             	pushl  0x10(%ebp)
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	6a 11                	push   $0x11
  801703:	e8 7a fe ff ff       	call   801582 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
	return ;
  80170b:	90                   	nop
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 0c                	push   $0xc
  80171d:	e8 60 fe ff ff       	call   801582 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	6a 0d                	push   $0xd
  801737:	e8 46 fe ff ff       	call   801582 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 0e                	push   $0xe
  801750:	e8 2d fe ff ff       	call   801582 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	90                   	nop
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 13                	push   $0x13
  80176a:	e8 13 fe ff ff       	call   801582 <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	90                   	nop
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 14                	push   $0x14
  801784:	e8 f9 fd ff ff       	call   801582 <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	90                   	nop
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_cputc>:


void
sys_cputc(const char c)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80179b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	50                   	push   %eax
  8017a8:	6a 15                	push   $0x15
  8017aa:	e8 d3 fd ff ff       	call   801582 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	90                   	nop
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 16                	push   $0x16
  8017c4:	e8 b9 fd ff ff       	call   801582 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	90                   	nop
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	50                   	push   %eax
  8017df:	6a 17                	push   $0x17
  8017e1:	e8 9c fd ff ff       	call   801582 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	52                   	push   %edx
  8017fb:	50                   	push   %eax
  8017fc:	6a 1a                	push   $0x1a
  8017fe:	e8 7f fd ff ff       	call   801582 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80180b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	52                   	push   %edx
  801818:	50                   	push   %eax
  801819:	6a 18                	push   $0x18
  80181b:	e8 62 fd ff ff       	call   801582 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	90                   	nop
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	52                   	push   %edx
  801836:	50                   	push   %eax
  801837:	6a 19                	push   $0x19
  801839:	e8 44 fd ff ff       	call   801582 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	90                   	nop
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	8b 45 10             	mov    0x10(%ebp),%eax
  80184d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801850:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801853:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	51                   	push   %ecx
  80185d:	52                   	push   %edx
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	50                   	push   %eax
  801862:	6a 1b                	push   $0x1b
  801864:	e8 19 fd ff ff       	call   801582 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	52                   	push   %edx
  80187e:	50                   	push   %eax
  80187f:	6a 1c                	push   $0x1c
  801881:	e8 fc fc ff ff       	call   801582 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80188e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	51                   	push   %ecx
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	6a 1d                	push   $0x1d
  8018a0:	e8 dd fc ff ff       	call   801582 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	6a 1e                	push   $0x1e
  8018bd:	e8 c0 fc ff ff       	call   801582 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 1f                	push   $0x1f
  8018d6:	e8 a7 fc ff ff       	call   801582 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 14             	pushl  0x14(%ebp)
  8018eb:	ff 75 10             	pushl  0x10(%ebp)
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	50                   	push   %eax
  8018f2:	6a 20                	push   $0x20
  8018f4:	e8 89 fc ff ff       	call   801582 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	50                   	push   %eax
  80190d:	6a 21                	push   $0x21
  80190f:	e8 6e fc ff ff       	call   801582 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	50                   	push   %eax
  801929:	6a 22                	push   $0x22
  80192b:	e8 52 fc ff ff       	call   801582 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 02                	push   $0x2
  801944:	e8 39 fc ff ff       	call   801582 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 03                	push   $0x3
  80195d:	e8 20 fc ff ff       	call   801582 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 04                	push   $0x4
  801976:	e8 07 fc ff ff       	call   801582 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_exit_env>:


void sys_exit_env(void)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 23                	push   $0x23
  80198f:	e8 ee fb ff ff       	call   801582 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a3:	8d 50 04             	lea    0x4(%eax),%edx
  8019a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	52                   	push   %edx
  8019b0:	50                   	push   %eax
  8019b1:	6a 24                	push   $0x24
  8019b3:	e8 ca fb ff ff       	call   801582 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
	return result;
  8019bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c4:	89 01                	mov    %eax,(%ecx)
  8019c6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	c9                   	leave  
  8019cd:	c2 04 00             	ret    $0x4

008019d0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 10             	pushl  0x10(%ebp)
  8019da:	ff 75 0c             	pushl  0xc(%ebp)
  8019dd:	ff 75 08             	pushl  0x8(%ebp)
  8019e0:	6a 12                	push   $0x12
  8019e2:	e8 9b fb ff ff       	call   801582 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ea:	90                   	nop
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_rcr2>:
uint32 sys_rcr2()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 25                	push   $0x25
  8019fc:	e8 81 fb ff ff       	call   801582 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a12:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	50                   	push   %eax
  801a1f:	6a 26                	push   $0x26
  801a21:	e8 5c fb ff ff       	call   801582 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return ;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <rsttst>:
void rsttst()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 28                	push   $0x28
  801a3b:	e8 42 fb ff ff       	call   801582 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
	return ;
  801a43:	90                   	nop
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a52:	8b 55 18             	mov    0x18(%ebp),%edx
  801a55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	ff 75 10             	pushl  0x10(%ebp)
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	ff 75 08             	pushl  0x8(%ebp)
  801a64:	6a 27                	push   $0x27
  801a66:	e8 17 fb ff ff       	call   801582 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6e:	90                   	nop
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <chktst>:
void chktst(uint32 n)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	6a 29                	push   $0x29
  801a81:	e8 fc fa ff ff       	call   801582 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
	return ;
  801a89:	90                   	nop
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <inctst>:

void inctst()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 2a                	push   $0x2a
  801a9b:	e8 e2 fa ff ff       	call   801582 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa3:	90                   	nop
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <gettst>:
uint32 gettst()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 2b                	push   $0x2b
  801ab5:	e8 c8 fa ff ff       	call   801582 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 2c                	push   $0x2c
  801ad1:	e8 ac fa ff ff       	call   801582 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
  801ad9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801adc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ae0:	75 07                	jne    801ae9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ae2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae7:	eb 05                	jmp    801aee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 2c                	push   $0x2c
  801b02:	e8 7b fa ff ff       	call   801582 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
  801b0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b0d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b11:	75 07                	jne    801b1a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b13:	b8 01 00 00 00       	mov    $0x1,%eax
  801b18:	eb 05                	jmp    801b1f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 2c                	push   $0x2c
  801b33:	e8 4a fa ff ff       	call   801582 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
  801b3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b3e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b42:	75 07                	jne    801b4b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b44:	b8 01 00 00 00       	mov    $0x1,%eax
  801b49:	eb 05                	jmp    801b50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 2c                	push   $0x2c
  801b64:	e8 19 fa ff ff       	call   801582 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
  801b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b6f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b73:	75 07                	jne    801b7c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b75:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7a:	eb 05                	jmp    801b81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	ff 75 08             	pushl  0x8(%ebp)
  801b91:	6a 2d                	push   $0x2d
  801b93:	e8 ea f9 ff ff       	call   801582 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9b:	90                   	nop
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ba2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	53                   	push   %ebx
  801bb1:	51                   	push   %ecx
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	6a 2e                	push   $0x2e
  801bb6:	e8 c7 f9 ff ff       	call   801582 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 2f                	push   $0x2f
  801bd6:	e8 a7 f9 ff ff       	call   801582 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <__udivdi3>:
  801be0:	55                   	push   %ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 1c             	sub    $0x1c,%esp
  801be7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801beb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bf3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bf7:	89 ca                	mov    %ecx,%edx
  801bf9:	89 f8                	mov    %edi,%eax
  801bfb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bff:	85 f6                	test   %esi,%esi
  801c01:	75 2d                	jne    801c30 <__udivdi3+0x50>
  801c03:	39 cf                	cmp    %ecx,%edi
  801c05:	77 65                	ja     801c6c <__udivdi3+0x8c>
  801c07:	89 fd                	mov    %edi,%ebp
  801c09:	85 ff                	test   %edi,%edi
  801c0b:	75 0b                	jne    801c18 <__udivdi3+0x38>
  801c0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c12:	31 d2                	xor    %edx,%edx
  801c14:	f7 f7                	div    %edi
  801c16:	89 c5                	mov    %eax,%ebp
  801c18:	31 d2                	xor    %edx,%edx
  801c1a:	89 c8                	mov    %ecx,%eax
  801c1c:	f7 f5                	div    %ebp
  801c1e:	89 c1                	mov    %eax,%ecx
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	f7 f5                	div    %ebp
  801c24:	89 cf                	mov    %ecx,%edi
  801c26:	89 fa                	mov    %edi,%edx
  801c28:	83 c4 1c             	add    $0x1c,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    
  801c30:	39 ce                	cmp    %ecx,%esi
  801c32:	77 28                	ja     801c5c <__udivdi3+0x7c>
  801c34:	0f bd fe             	bsr    %esi,%edi
  801c37:	83 f7 1f             	xor    $0x1f,%edi
  801c3a:	75 40                	jne    801c7c <__udivdi3+0x9c>
  801c3c:	39 ce                	cmp    %ecx,%esi
  801c3e:	72 0a                	jb     801c4a <__udivdi3+0x6a>
  801c40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c44:	0f 87 9e 00 00 00    	ja     801ce8 <__udivdi3+0x108>
  801c4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4f:	89 fa                	mov    %edi,%edx
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    
  801c59:	8d 76 00             	lea    0x0(%esi),%esi
  801c5c:	31 ff                	xor    %edi,%edi
  801c5e:	31 c0                	xor    %eax,%eax
  801c60:	89 fa                	mov    %edi,%edx
  801c62:	83 c4 1c             	add    $0x1c,%esp
  801c65:	5b                   	pop    %ebx
  801c66:	5e                   	pop    %esi
  801c67:	5f                   	pop    %edi
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	89 d8                	mov    %ebx,%eax
  801c6e:	f7 f7                	div    %edi
  801c70:	31 ff                	xor    %edi,%edi
  801c72:	89 fa                	mov    %edi,%edx
  801c74:	83 c4 1c             	add    $0x1c,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5f                   	pop    %edi
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    
  801c7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c81:	89 eb                	mov    %ebp,%ebx
  801c83:	29 fb                	sub    %edi,%ebx
  801c85:	89 f9                	mov    %edi,%ecx
  801c87:	d3 e6                	shl    %cl,%esi
  801c89:	89 c5                	mov    %eax,%ebp
  801c8b:	88 d9                	mov    %bl,%cl
  801c8d:	d3 ed                	shr    %cl,%ebp
  801c8f:	89 e9                	mov    %ebp,%ecx
  801c91:	09 f1                	or     %esi,%ecx
  801c93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c97:	89 f9                	mov    %edi,%ecx
  801c99:	d3 e0                	shl    %cl,%eax
  801c9b:	89 c5                	mov    %eax,%ebp
  801c9d:	89 d6                	mov    %edx,%esi
  801c9f:	88 d9                	mov    %bl,%cl
  801ca1:	d3 ee                	shr    %cl,%esi
  801ca3:	89 f9                	mov    %edi,%ecx
  801ca5:	d3 e2                	shl    %cl,%edx
  801ca7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cab:	88 d9                	mov    %bl,%cl
  801cad:	d3 e8                	shr    %cl,%eax
  801caf:	09 c2                	or     %eax,%edx
  801cb1:	89 d0                	mov    %edx,%eax
  801cb3:	89 f2                	mov    %esi,%edx
  801cb5:	f7 74 24 0c          	divl   0xc(%esp)
  801cb9:	89 d6                	mov    %edx,%esi
  801cbb:	89 c3                	mov    %eax,%ebx
  801cbd:	f7 e5                	mul    %ebp
  801cbf:	39 d6                	cmp    %edx,%esi
  801cc1:	72 19                	jb     801cdc <__udivdi3+0xfc>
  801cc3:	74 0b                	je     801cd0 <__udivdi3+0xf0>
  801cc5:	89 d8                	mov    %ebx,%eax
  801cc7:	31 ff                	xor    %edi,%edi
  801cc9:	e9 58 ff ff ff       	jmp    801c26 <__udivdi3+0x46>
  801cce:	66 90                	xchg   %ax,%ax
  801cd0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cd4:	89 f9                	mov    %edi,%ecx
  801cd6:	d3 e2                	shl    %cl,%edx
  801cd8:	39 c2                	cmp    %eax,%edx
  801cda:	73 e9                	jae    801cc5 <__udivdi3+0xe5>
  801cdc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cdf:	31 ff                	xor    %edi,%edi
  801ce1:	e9 40 ff ff ff       	jmp    801c26 <__udivdi3+0x46>
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	31 c0                	xor    %eax,%eax
  801cea:	e9 37 ff ff ff       	jmp    801c26 <__udivdi3+0x46>
  801cef:	90                   	nop

00801cf0 <__umoddi3>:
  801cf0:	55                   	push   %ebp
  801cf1:	57                   	push   %edi
  801cf2:	56                   	push   %esi
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 1c             	sub    $0x1c,%esp
  801cf7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cfb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d0f:	89 f3                	mov    %esi,%ebx
  801d11:	89 fa                	mov    %edi,%edx
  801d13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d17:	89 34 24             	mov    %esi,(%esp)
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	75 1a                	jne    801d38 <__umoddi3+0x48>
  801d1e:	39 f7                	cmp    %esi,%edi
  801d20:	0f 86 a2 00 00 00    	jbe    801dc8 <__umoddi3+0xd8>
  801d26:	89 c8                	mov    %ecx,%eax
  801d28:	89 f2                	mov    %esi,%edx
  801d2a:	f7 f7                	div    %edi
  801d2c:	89 d0                	mov    %edx,%eax
  801d2e:	31 d2                	xor    %edx,%edx
  801d30:	83 c4 1c             	add    $0x1c,%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
  801d38:	39 f0                	cmp    %esi,%eax
  801d3a:	0f 87 ac 00 00 00    	ja     801dec <__umoddi3+0xfc>
  801d40:	0f bd e8             	bsr    %eax,%ebp
  801d43:	83 f5 1f             	xor    $0x1f,%ebp
  801d46:	0f 84 ac 00 00 00    	je     801df8 <__umoddi3+0x108>
  801d4c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d51:	29 ef                	sub    %ebp,%edi
  801d53:	89 fe                	mov    %edi,%esi
  801d55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d59:	89 e9                	mov    %ebp,%ecx
  801d5b:	d3 e0                	shl    %cl,%eax
  801d5d:	89 d7                	mov    %edx,%edi
  801d5f:	89 f1                	mov    %esi,%ecx
  801d61:	d3 ef                	shr    %cl,%edi
  801d63:	09 c7                	or     %eax,%edi
  801d65:	89 e9                	mov    %ebp,%ecx
  801d67:	d3 e2                	shl    %cl,%edx
  801d69:	89 14 24             	mov    %edx,(%esp)
  801d6c:	89 d8                	mov    %ebx,%eax
  801d6e:	d3 e0                	shl    %cl,%eax
  801d70:	89 c2                	mov    %eax,%edx
  801d72:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d76:	d3 e0                	shl    %cl,%eax
  801d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d80:	89 f1                	mov    %esi,%ecx
  801d82:	d3 e8                	shr    %cl,%eax
  801d84:	09 d0                	or     %edx,%eax
  801d86:	d3 eb                	shr    %cl,%ebx
  801d88:	89 da                	mov    %ebx,%edx
  801d8a:	f7 f7                	div    %edi
  801d8c:	89 d3                	mov    %edx,%ebx
  801d8e:	f7 24 24             	mull   (%esp)
  801d91:	89 c6                	mov    %eax,%esi
  801d93:	89 d1                	mov    %edx,%ecx
  801d95:	39 d3                	cmp    %edx,%ebx
  801d97:	0f 82 87 00 00 00    	jb     801e24 <__umoddi3+0x134>
  801d9d:	0f 84 91 00 00 00    	je     801e34 <__umoddi3+0x144>
  801da3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801da7:	29 f2                	sub    %esi,%edx
  801da9:	19 cb                	sbb    %ecx,%ebx
  801dab:	89 d8                	mov    %ebx,%eax
  801dad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801db1:	d3 e0                	shl    %cl,%eax
  801db3:	89 e9                	mov    %ebp,%ecx
  801db5:	d3 ea                	shr    %cl,%edx
  801db7:	09 d0                	or     %edx,%eax
  801db9:	89 e9                	mov    %ebp,%ecx
  801dbb:	d3 eb                	shr    %cl,%ebx
  801dbd:	89 da                	mov    %ebx,%edx
  801dbf:	83 c4 1c             	add    $0x1c,%esp
  801dc2:	5b                   	pop    %ebx
  801dc3:	5e                   	pop    %esi
  801dc4:	5f                   	pop    %edi
  801dc5:	5d                   	pop    %ebp
  801dc6:	c3                   	ret    
  801dc7:	90                   	nop
  801dc8:	89 fd                	mov    %edi,%ebp
  801dca:	85 ff                	test   %edi,%edi
  801dcc:	75 0b                	jne    801dd9 <__umoddi3+0xe9>
  801dce:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd3:	31 d2                	xor    %edx,%edx
  801dd5:	f7 f7                	div    %edi
  801dd7:	89 c5                	mov    %eax,%ebp
  801dd9:	89 f0                	mov    %esi,%eax
  801ddb:	31 d2                	xor    %edx,%edx
  801ddd:	f7 f5                	div    %ebp
  801ddf:	89 c8                	mov    %ecx,%eax
  801de1:	f7 f5                	div    %ebp
  801de3:	89 d0                	mov    %edx,%eax
  801de5:	e9 44 ff ff ff       	jmp    801d2e <__umoddi3+0x3e>
  801dea:	66 90                	xchg   %ax,%ax
  801dec:	89 c8                	mov    %ecx,%eax
  801dee:	89 f2                	mov    %esi,%edx
  801df0:	83 c4 1c             	add    $0x1c,%esp
  801df3:	5b                   	pop    %ebx
  801df4:	5e                   	pop    %esi
  801df5:	5f                   	pop    %edi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    
  801df8:	3b 04 24             	cmp    (%esp),%eax
  801dfb:	72 06                	jb     801e03 <__umoddi3+0x113>
  801dfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e01:	77 0f                	ja     801e12 <__umoddi3+0x122>
  801e03:	89 f2                	mov    %esi,%edx
  801e05:	29 f9                	sub    %edi,%ecx
  801e07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e0b:	89 14 24             	mov    %edx,(%esp)
  801e0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e12:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e16:	8b 14 24             	mov    (%esp),%edx
  801e19:	83 c4 1c             	add    $0x1c,%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5e                   	pop    %esi
  801e1e:	5f                   	pop    %edi
  801e1f:	5d                   	pop    %ebp
  801e20:	c3                   	ret    
  801e21:	8d 76 00             	lea    0x0(%esi),%esi
  801e24:	2b 04 24             	sub    (%esp),%eax
  801e27:	19 fa                	sbb    %edi,%edx
  801e29:	89 d1                	mov    %edx,%ecx
  801e2b:	89 c6                	mov    %eax,%esi
  801e2d:	e9 71 ff ff ff       	jmp    801da3 <__umoddi3+0xb3>
  801e32:	66 90                	xchg   %ax,%ax
  801e34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e38:	72 ea                	jb     801e24 <__umoddi3+0x134>
  801e3a:	89 d9                	mov    %ebx,%ecx
  801e3c:	e9 62 ff ff ff       	jmp    801da3 <__umoddi3+0xb3>
